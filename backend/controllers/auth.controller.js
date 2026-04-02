const db = require('../config/database');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { getLevelInfo } = require('../utils/helpers');

// Register
exports.register = async (req, res) => {
  try {
    const { full_name, email, password, weight, height, goal, fitness_level } = req.body;

    // Check if user exists
    const [existing] = await db.query('SELECT id FROM users WHERE email = ?', [email]);
    if (existing.length > 0) {
      return res.status(400).json({ success: false, message: 'Email already registered' });
    }

    // Hash password
    const salt = await bcrypt.genSalt(12);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create user
    const [result] = await db.query(
      `INSERT INTO users (full_name, email, password, weight, height, goal, fitness_level) 
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [full_name, email, hashedPassword, weight || null, height || null, goal || 'Stay Fit', fitness_level || 'Beginner']
    );

    const userId = result.insertId;

    // Generate token
    const token = jwt.sign({ id: userId }, process.env.JWT_SECRET, {
      expiresIn: process.env.JWT_EXPIRES_IN || '30d',
    });

    // Get user data
    const [users] = await db.query('SELECT * FROM users WHERE id = ?', [userId]);
    const user = users[0];
    const levelInfo = getLevelInfo(user.xp);

    res.status(201).json({
      success: true,
      message: 'Account created successfully',
      data: {
        token,
        user: {
          id: user.id,
          full_name: user.full_name,
          email: user.email,
          avatar_url: user.avatar_url,
          level: levelInfo.level,
          title: levelInfo.title,
          xp: levelInfo.currentXp,
          max_xp: levelInfo.maxXp,
          total_workouts: user.total_workouts,
          streak: user.streak,
          weight: user.weight,
          height: user.height,
          goal: user.goal,
          fitness_level: user.fitness_level,
          total_calories_burned: user.total_calories_burned,
        },
      },
    });
  } catch (err) {
    console.error('Register error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Login
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find user
    const [users] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
    if (users.length === 0) {
      return res.status(401).json({ success: false, message: 'Invalid email or password' });
    }

    const user = users[0];

    // Check password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Invalid email or password' });
    }

    // Generate token
    const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, {
      expiresIn: process.env.JWT_EXPIRES_IN || '30d',
    });

    const levelInfo = getLevelInfo(user.xp);

    res.json({
      success: true,
      message: 'Login successful',
      data: {
        token,
        user: {
          id: user.id,
          full_name: user.full_name,
          email: user.email,
          avatar_url: user.avatar_url,
          level: levelInfo.level,
          title: levelInfo.title,
          xp: levelInfo.currentXp,
          max_xp: levelInfo.maxXp,
          total_workouts: user.total_workouts,
          streak: user.streak,
          weight: user.weight,
          height: user.height,
          goal: user.goal,
          fitness_level: user.fitness_level,
          total_calories_burned: user.total_calories_burned,
          total_workout_minutes: user.total_workout_minutes,
        },
      },
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};