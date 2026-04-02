const db = require('../config/database');
const { getLevelInfo } = require('../utils/helpers');

// Get profile
exports.getProfile = async (req, res) => {
  try {
    const [users] = await db.query('SELECT * FROM users WHERE id = ?', [req.userId]);
    if (users.length === 0) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    const user = users[0];
    const levelInfo = getLevelInfo(user.xp);

    // Get achievements
    const [achievements] = await db.query(
      `SELECT a.name, a.description, a.icon, ua.earned_at 
       FROM user_achievements ua 
       JOIN achievements a ON ua.achievement_id = a.id 
       WHERE ua.user_id = ?`,
      [req.userId]
    );

    // Get weekly activity
    const [weeklyActivity] = await db.query(
      `SELECT activity_date, workouts_done, minutes_trained, calories_burned 
       FROM daily_activity 
       WHERE user_id = ? AND activity_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
       ORDER BY activity_date`,
      [req.userId]
    );

    // Weekly totals
    const [weeklyTotals] = await db.query(
      `SELECT 
         COALESCE(SUM(workouts_done), 0) as total_workouts,
         COALESCE(SUM(minutes_trained), 0) as total_minutes,
         COALESCE(SUM(calories_burned), 0) as total_calories
       FROM daily_activity 
       WHERE user_id = ? AND activity_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)`,
      [req.userId]
    );

    res.json({
      success: true,
      data: {
        user: {
          id: user.id,
          full_name: user.full_name,
          email: user.email,
          avatar_url: user.avatar_url,
          level: levelInfo.level,
          title: levelInfo.title,
          xp: levelInfo.currentXp,
          max_xp: levelInfo.maxXp,
          xp_to_next: levelInfo.xpToNext,
          total_workouts: user.total_workouts,
          streak: user.streak,
          best_streak: user.best_streak,
          weight: user.weight,
          height: user.height,
          age: user.age,
          goal: user.goal,
          fitness_level: user.fitness_level,
          total_calories_burned: user.total_calories_burned,
          total_workout_minutes: user.total_workout_minutes,
        },
        achievements,
        weekly_activity: weeklyActivity,
        weekly_totals: weeklyTotals[0],
      },
    });
  } catch (err) {
    console.error('Get profile error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Update profile
exports.updateProfile = async (req, res) => {
  try {
    const { full_name, weight, height, age, goal, fitness_level } = req.body;

    await db.query(
      `UPDATE users SET full_name = COALESCE(?, full_name), weight = COALESCE(?, weight),
       height = COALESCE(?, height), age = COALESCE(?, age), goal = COALESCE(?, goal),
       fitness_level = COALESCE(?, fitness_level) WHERE id = ?`,
      [full_name, weight, height, age, goal, fitness_level, req.userId]
    );

    const [users] = await db.query('SELECT * FROM users WHERE id = ?', [req.userId]);
    const user = users[0];
    const levelInfo = getLevelInfo(user.xp);

    res.json({
      success: true,
      message: 'Profile updated',
      data: {
        id: user.id,
        full_name: user.full_name,
        weight: user.weight,
        height: user.height,
        age: user.age,
        goal: user.goal,
        fitness_level: user.fitness_level,
        level: levelInfo.level,
        title: levelInfo.title,
      },
    });
  } catch (err) {
    console.error('Update profile error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Get dashboard / home data
exports.getDashboard = async (req, res) => {
  try {
    const [users] = await db.query('SELECT * FROM users WHERE id = ?', [req.userId]);
    if (users.length === 0) return res.status(404).json({ success: false, message: 'User not found' });

    const user = users[0];
    const levelInfo = getLevelInfo(user.xp);

    // Today's program (latest uncompleted or suggested)
    const [todayPrograms] = await db.query(
      `SELECT p.id, p.name, p.session_duration_min, p.difficulty, p.xp_reward,
              p.category, COUNT(pe.id) as exercise_count
       FROM programs p
       LEFT JOIN program_exercises pe ON p.id = pe.program_id
       WHERE p.is_active = TRUE
       GROUP BY p.id
       ORDER BY RAND()
       LIMIT 2`
    );

    // Recent history
    const [recentHistory] = await db.query(
      `SELECT workout_name, duration_min, xp_earned, completed_at 
       FROM workout_history WHERE user_id = ? ORDER BY completed_at DESC LIMIT 3`,
      [req.userId]
    );

    // Weekly activity
    const [weekDays] = await db.query(
      `SELECT activity_date, workouts_done 
       FROM daily_activity 
       WHERE user_id = ? AND activity_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
       ORDER BY activity_date`,
      [req.userId]
    );

    // Weekly stats
    const [weekStats] = await db.query(
      `SELECT 
         COALESCE(SUM(workouts_done), 0) as workouts,
         COALESCE(SUM(minutes_trained), 0) as minutes,
         COALESCE(SUM(calories_burned), 0) as calories
       FROM daily_activity 
       WHERE user_id = ? AND activity_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)`,
      [req.userId]
    );

    // XP gained this week
    const [weekXp] = await db.query(
      `SELECT COALESCE(SUM(xp_earned), 0) as xp_this_week 
       FROM workout_history 
       WHERE user_id = ? AND completed_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)`,
      [req.userId]
    );

    res.json({
      success: true,
      data: {
        user: {
          full_name: user.full_name,
          avatar_url: user.avatar_url,
          level: levelInfo.level,
          title: levelInfo.title,
          xp: levelInfo.currentXp,
          max_xp: levelInfo.maxXp,
          xp_to_next: levelInfo.xpToNext,
          xp_this_week: weekXp[0].xp_this_week,
          total_workouts: user.total_workouts,
          streak: user.streak,
          weight: user.weight,
          total_calories_burned: user.total_calories_burned,
        },
        today_programs: todayPrograms,
        recent_history: recentHistory,
        weekly_days: weekDays,
        weekly_stats: weekStats[0],
      },
    });
  } catch (err) {
    console.error('Dashboard error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};