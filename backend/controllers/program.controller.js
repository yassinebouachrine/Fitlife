const db = require('../config/database');

// Get all programs
exports.getPrograms = async (req, res) => {
  try {
    const { category, difficulty } = req.query;

    let query = `SELECT p.*, COUNT(pe.id) as exercise_count 
                 FROM programs p 
                 LEFT JOIN program_exercises pe ON p.id = pe.program_id 
                 WHERE p.is_active = TRUE`;
    const params = [];

    if (category && category !== 'All') {
      query += ' AND p.category = ?';
      params.push(category);
    }
    if (difficulty) {
      query += ' AND p.difficulty = ?';
      params.push(difficulty);
    }

    query += ' GROUP BY p.id ORDER BY p.xp_reward DESC';

    const [programs] = await db.query(query, params);

    res.json({ success: true, data: programs });
  } catch (err) {
    console.error('Get programs error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Get program detail
exports.getProgram = async (req, res) => {
  try {
    const [programs] = await db.query('SELECT * FROM programs WHERE id = ?', [req.params.id]);
    if (programs.length === 0) {
      return res.status(404).json({ success: false, message: 'Program not found' });
    }

    const [exercises] = await db.query(
      `SELECT pe.*, e.name, e.description, e.muscle_group, e.category, e.equipment, e.difficulty 
       FROM program_exercises pe 
       JOIN exercises e ON pe.exercise_id = e.id 
       WHERE pe.program_id = ? 
       ORDER BY pe.order_index`,
      [req.params.id]
    );

    res.json({
      success: true,
      data: { ...programs[0], exercises },
    });
  } catch (err) {
    console.error('Get program error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};