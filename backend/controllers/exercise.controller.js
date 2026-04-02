const db = require('../config/database');

// Get all exercises
exports.getExercises = async (req, res) => {
  try {
    const { category, muscle_group, difficulty, search } = req.query;

    let query = 'SELECT * FROM exercises WHERE 1=1';
    const params = [];

    if (category && category !== 'All') {
      query += ' AND category = ?';
      params.push(category);
    }
    if (muscle_group) {
      query += ' AND muscle_group = ?';
      params.push(muscle_group);
    }
    if (difficulty) {
      query += ' AND difficulty = ?';
      params.push(difficulty);
    }
    if (search) {
      query += ' AND name LIKE ?';
      params.push(`%${search}%`);
    }

    query += ' ORDER BY name';

    const [exercises] = await db.query(query, params);
    res.json({ success: true, data: exercises });
  } catch (err) {
    console.error('Get exercises error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Get single exercise
exports.getExercise = async (req, res) => {
  try {
    const [exercises] = await db.query('SELECT * FROM exercises WHERE id = ?', [req.params.id]);
    if (exercises.length === 0) {
      return res.status(404).json({ success: false, message: 'Exercise not found' });
    }
    res.json({ success: true, data: exercises[0] });
  } catch (err) {
    console.error('Get exercise error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};