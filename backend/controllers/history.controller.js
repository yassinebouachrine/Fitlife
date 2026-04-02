const db = require('../config/database');
const { calculateWorkoutXP, calculateCalories, calculateStreak, getLevelInfo } = require('../utils/helpers');

// Get workout history
exports.getHistory = async (req, res) => {
  try {
    const { limit = 20, offset = 0 } = req.query;

    const [history] = await db.query(
      `SELECT * FROM workout_history 
       WHERE user_id = ? 
       ORDER BY completed_at DESC 
       LIMIT ? OFFSET ?`,
      [req.userId, parseInt(limit), parseInt(offset)]
    );

    // Get totals
    const [totals] = await db.query(
      `SELECT 
         COUNT(*) as total_sessions,
         COALESCE(SUM(duration_min), 0) as total_minutes,
         COALESCE(SUM(xp_earned), 0) as total_xp,
         COALESCE(SUM(calories_burned), 0) as total_calories
       FROM workout_history WHERE user_id = ?`,
      [req.userId]
    );

    res.json({
      success: true,
      data: { history, totals: totals[0] },
    });
  } catch (err) {
    console.error('Get history error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Log completed workout
exports.logWorkout = async (req, res) => {
  try {
    const {
      workout_name, workout_type = 'custom', program_id, workout_id,
      duration_min, exercises_completed = 0, exercise_details = [],
    } = req.body;

    // Get user data
    const [users] = await db.query('SELECT * FROM users WHERE id = ?', [req.userId]);
    const user = users[0];

    // Calculate XP and calories
    const xpEarned = calculateWorkoutXP(duration_min, exercises_completed, user.fitness_level);
    const caloriesBurned = calculateCalories(duration_min, user.weight, user.fitness_level);

    // Calculate volume
    let totalVolume = 0;
    exercise_details.forEach(ex => {
      if (ex.weight_used_kg && ex.sets_completed) {
        const reps = parseInt(ex.reps_completed) || 10;
        totalVolume += ex.weight_used_kg * ex.sets_completed * reps;
      }
    });

    // Insert history
    const [result] = await db.query(
      `INSERT INTO workout_history 
       (user_id, workout_name, workout_type, program_id, workout_id, duration_min, 
        calories_burned, xp_earned, total_volume_kg, exercises_completed) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [req.userId, workout_name, workout_type, program_id || null, workout_id || null,
       duration_min, caloriesBurned, xpEarned, totalVolume, exercises_completed]
    );

    const historyId = result.insertId;

    // Insert exercise details
    if (exercise_details.length > 0) {
      const values = exercise_details.map(ex => [
        historyId, ex.exercise_name, ex.sets_completed || 0,
        ex.reps_completed || '', ex.weight_used_kg || null,
      ]);

      await db.query(
        `INSERT INTO history_exercises (history_id, exercise_name, sets_completed, reps_completed, weight_used_kg) VALUES ?`,
        [values]
      );
    }

    // Update user stats
    const newStreak = calculateStreak(user.last_workout_date, user.streak);
    const newXp = user.xp + xpEarned;
    const newLevelInfo = getLevelInfo(newXp);

    await db.query(
      `UPDATE users SET 
       xp = ?, level = ?, title = ?, max_xp = ?,
       total_workouts = total_workouts + 1,
       streak = ?, best_streak = GREATEST(best_streak, ?),
       last_workout_date = CURDATE(),
       total_calories_burned = total_calories_burned + ?,
       total_workout_minutes = total_workout_minutes + ?
       WHERE id = ?`,
      [newXp, newLevelInfo.level, newLevelInfo.title, newLevelInfo.maxXp,
       newStreak, newStreak, caloriesBurned, duration_min, req.userId]
    );

    // Update daily activity
    await db.query(
      `INSERT INTO daily_activity (user_id, activity_date, workouts_done, minutes_trained, calories_burned)
       VALUES (?, CURDATE(), 1, ?, ?)
       ON DUPLICATE KEY UPDATE 
       workouts_done = workouts_done + 1,
       minutes_trained = minutes_trained + VALUES(minutes_trained),
       calories_burned = calories_burned + VALUES(calories_burned)`,
      [req.userId, duration_min, caloriesBurned]
    );

    // Check achievements
    await checkAchievements(req.userId, newXp, user.total_workouts + 1, newStreak, user.total_calories_burned + caloriesBurned);

    res.status(201).json({
      success: true,
      message: 'Workout logged successfully',
      data: {
        history_id: historyId,
        xp_earned: xpEarned,
        calories_burned: caloriesBurned,
        new_xp: newXp,
        new_level: newLevelInfo.level,
        new_title: newLevelInfo.title,
        streak: newStreak,
      },
    });
  } catch (err) {
    console.error('Log workout error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Check and award achievements
async function checkAchievements(userId, xp, workouts, streak, calories) {
  try {
    const [achievements] = await db.query('SELECT * FROM achievements');
    const [earned] = await db.query(
      'SELECT achievement_id FROM user_achievements WHERE user_id = ?',
      [userId]
    );

    const earnedIds = earned.map(e => e.achievement_id);

    for (const ach of achievements) {
      if (earnedIds.includes(ach.id)) continue;

      let qualified = false;
      switch (ach.requirement_type) {
        case 'workouts': qualified = workouts >= ach.requirement_value; break;
        case 'streak': qualified = streak >= ach.requirement_value; break;
        case 'xp': qualified = xp >= ach.requirement_value; break;
        case 'calories': qualified = calories >= ach.requirement_value; break;
      }

      if (qualified) {
        await db.query(
          'INSERT IGNORE INTO user_achievements (user_id, achievement_id) VALUES (?, ?)',
          [userId, ach.id]
        );
        // Add achievement XP
        await db.query('UPDATE users SET xp = xp + ? WHERE id = ?', [ach.xp_reward, userId]);
      }
    }
  } catch (err) {
    console.error('Achievement check error:', err);
  }
}

// Get history detail
exports.getHistoryDetail = async (req, res) => {
  try {
    const [history] = await db.query(
      'SELECT * FROM workout_history WHERE id = ? AND user_id = ?',
      [req.params.id, req.userId]
    );

    if (history.length === 0) {
      return res.status(404).json({ success: false, message: 'Not found' });
    }

    const [exercises] = await db.query(
      'SELECT * FROM history_exercises WHERE history_id = ?',
      [req.params.id]
    );

    res.json({
      success: true,
      data: { ...history[0], exercises },
    });
  } catch (err) {
    console.error('History detail error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};