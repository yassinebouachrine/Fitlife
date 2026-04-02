require('dotenv').config();
const express = require('express');
const cors = require('cors');
const db = require('./config/database');

const authRoutes = require('./routes/auth.routes');
const userRoutes = require('./routes/user.routes');
const workoutRoutes = require('./routes/workout.routes');
const programRoutes = require('./routes/program.routes');
const exerciseRoutes = require('./routes/exercise.routes');
const historyRoutes = require('./routes/history.routes');
const aiRoutes = require('./routes/ai.routes');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Test DB connection
db.getConnection()
  .then(conn => {
    console.log('MySQL connected successfully');
    conn.release();
  })
  .catch(err => {
    console.error('MySQL connection error:', err.message);
  });

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/user', userRoutes);
app.use('/api/workouts', workoutRoutes);
app.use('/api/programs', programRoutes);
app.use('/api/exercises', exerciseRoutes);
app.use('/api/history', historyRoutes);
app.use('/api/ai', aiRoutes);

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', app: 'Lifevora API', version: '2.0.0' });
});

// Error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ success: false, message: 'Internal server error' });
});

// ✅ MODIFICATION : écouter sur '0.0.0.0' pour accepter les connexions externes
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Lifevora API running on http://0.0.0.0:${PORT}`);
  console.log(`Accessible depuis le réseau local sur le port ${PORT}`);
});