const db = require('../config/database');

// Get user workouts
exports.getMyWorkouts = async (req, res) => {
  try {
    const [workouts] = await db.query(
      `SELECT w.*, COUNT(we.id) as exercise_count 
       FROM workouts w 
       LEFT JOIN workout_exercises we ON w.id = we.workout_id 
       WHERE w.user_id = ? 
       GROUP BY w.id 
       ORDER BY w.updated_at DESC`,
      [req.userId]
    );

    res.json({ success: true, data: workouts });
  } catch (err) {
    console.error('Get workouts error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Get workout detail
exports.getWorkout = async (req, res) => {
  try {
    const [workouts] = await db.query(
      'SELECT * FROM workouts WHERE id = ? AND user_id = ?',
      [req.params.id, req.userId]
    );

    if (workouts.length === 0) {
      return res.status(404).json({ success: false, message: 'Workout not found' });
    }

    const [exercises] = await db.query(
      `SELECT we.*, e.name, e.muscle_group, e.category, e.equipment 
       FROM workout_exercises we 
       JOIN exercises e ON we.exercise_id = e.id 
       WHERE we.workout_id = ? 
       ORDER BY we.order_index`,
      [req.params.id]
    );

    res.json({
      success: true,
      data: { ...workouts[0], exercises },
    });
  } catch (err) {
    console.error('Get workout error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Create workout
exports.createWorkout = async (req, res) => {
  try {
    const { name, description, estimated_duration_min, exercises } = req.body;

    const [result] = await db.query(
      `INSERT INTO workouts (user_id, name, description, estimated_duration_min) 
       VALUES (?, ?, ?, ?)`,
      [req.userId, name, description || '', estimated_duration_min || 30]
    );

    const workoutId = result.insertId;

    // Add exercises
    if (exercises && exercises.length > 0) {
      const values = exercises.map((ex, i) => [
        workoutId, ex.exercise_id, ex.sets || 3, ex.reps || '10',
        ex.weight_kg || null, ex.rest_seconds || 60, i + 1,
      ]);

      await db.query(
        `INSERT INTO workout_exercises (workout_id, exercise_id, sets, reps, weight_kg, rest_seconds, order_index) 
         VALUES ?`,
        [values]
      );
    }

    const [workout] = await db.query('SELECT * FROM workouts WHERE id = ?', [workoutId]);
    const [workoutExercises] = await db.query(
      `SELECT we.*, e.name, e.muscle_group 
       FROM workout_exercises we 
       JOIN exercises e ON we.exercise_id = e.id 
       WHERE we.workout_id = ? ORDER BY we.order_index`,
      [workoutId]
    );

    res.status(201).json({
      success: true,
      message: 'Workout created',
      data: { ...workout[0], exercises: workoutExercises },
    });
  } catch (err) {
    console.error('Create workout error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Update workout
exports.updateWorkout = async (req, res) => {
  try {
    const { name, description, estimated_duration_min, exercises } = req.body;

    // Check ownership
    const [existing] = await db.query(
      'SELECT id FROM workouts WHERE id = ? AND user_id = ?',
      [req.params.id, req.userId]
    );
    if (existing.length === 0) {
      return res.status(404).json({ success: false, message: 'Workout not found' });
    }

    await db.query(
      `UPDATE workouts SET name = COALESCE(?, name), description = COALESCE(?, description),
       estimated_duration_min = COALESCE(?, estimated_duration_min) WHERE id = ?`,
      [name, description, estimated_duration_min, req.params.id]
    );

    // Update exercises if provided
    if (exercises) {
      await db.query('DELETE FROM workout_exercises WHERE workout_id = ?', [req.params.id]);

      if (exercises.length > 0) {
        const values = exercises.map((ex, i) => [
          req.params.id, ex.exercise_id, ex.sets || 3, ex.reps || '10',
          ex.weight_kg || null, ex.rest_seconds || 60, i + 1,
        ]);

        await db.query(
          `INSERT INTO workout_exercises (workout_id, exercise_id, sets, reps, weight_kg, rest_seconds, order_index) VALUES ?`,
          [values]
        );
      }
    }

    res.json({ success: true, message: 'Workout updated' });
  } catch (err) {
    console.error('Update workout error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Delete workout
exports.deleteWorkout = async (req, res) => {
  try {
    const [result] = await db.query(
      'DELETE FROM workouts WHERE id = ? AND user_id = ?',
      [req.params.id, req.userId]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: 'Workout not found' });
    }

    res.json({ success: true, message: 'Workout deleted' });
  } catch (err) {
    console.error('Delete workout error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};