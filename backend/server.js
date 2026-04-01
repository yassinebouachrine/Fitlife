const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const sqlite3 = require('sqlite3').verbose();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const fs = require('fs');
require('dotenv').config();

const PORT = process.env.PORT || 4000;
const JWT_SECRET = process.env.JWT_SECRET || 'dev-secret';

const DB_DIR = __dirname + '/data';
const DB_PATH = DB_DIR + '/database.sqlite3';
if (!fs.existsSync(DB_DIR)) fs.mkdirSync(DB_DIR, { recursive: true });

const db = new sqlite3.Database(DB_PATH, (err) => {
  if (err) console.error('Failed to open DB', err);
  else console.log('Connected to SQLite DB at', DB_PATH);
});

db.serialize(() => {
  db.run(`CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    email TEXT UNIQUE,
    displayName TEXT,
    passwordHash TEXT,
    avatarUrl TEXT,
    xp INTEGER,
    level INTEGER,
    streakDays INTEGER,
    goal TEXT,
    experienceLevel TEXT,
    weightKg REAL,
    heightCm INTEGER,
    workoutsCompleted INTEGER,
    equipment TEXT,
    injuries TEXT,
    subscription TEXT,
    createdAt TEXT,
    lastWorkoutAt TEXT
  )`);
});

function getUserByEmail(email) {
  return new Promise((resolve, reject) => {
    db.get('SELECT * FROM users WHERE email = ?', [email], (err, row) => {
      if (err) return reject(err);
      resolve(row);
    });
  });
}

function getUserById(id) {
  return new Promise((resolve, reject) => {
    db.get('SELECT * FROM users WHERE id = ?', [id], (err, row) => {
      if (err) return reject(err);
      resolve(row);
    });
  });
}

function insertUser(u) {
  return new Promise((resolve, reject) => {
    const stmt = db.prepare(`INSERT INTO users (
      id, email, displayName, passwordHash, avatarUrl, xp, level, streakDays, goal,
      experienceLevel, weightKg, heightCm, workoutsCompleted, equipment, injuries,
      subscription, createdAt, lastWorkoutAt
    ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`);
    stmt.run(
      u.id,
      u.email,
      u.displayName,
      u.passwordHash,
      u.avatarUrl || null,
      u.xp || 0,
      u.level || 1,
      u.streakDays || 0,
      u.goal || 'buildMuscle',
      u.experienceLevel || 'beginner',
      u.weightKg || 70,
      u.heightCm || 175,
      u.workoutsCompleted || 0,
      u.equipment || '[]',
      u.injuries || '[]',
      u.subscription || 'free',
      u.createdAt || new Date().toISOString(),
      u.lastWorkoutAt || null,
      function (err) {
        if (err) return reject(err);
        resolve(true);
      }
    );
    stmt.finalize();
  });
}

function rowToUser(row) {
  if (!row) return null;
  return {
    id: row.id,
    email: row.email,
    displayName: row.displayName,
    avatarUrl: row.avatarUrl,
    xp: row.xp || 0,
    level: row.level || 1,
    streakDays: row.streakDays || 0,
    goal: row.goal,
    experienceLevel: row.experienceLevel,
    weightKg: row.weightKg,
    heightCm: row.heightCm,
    workoutsCompleted: row.workoutsCompleted || 0,
    equipment: row.equipment ? JSON.parse(row.equipment) : [],
    injuries: row.injuries ? JSON.parse(row.injuries) : [],
    subscription: row.subscription || 'free',
    createdAt: row.createdAt,
    lastWorkoutAt: row.lastWorkoutAt,
  };
}

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.get('/', (req, res) => res.json({ status: 'ok' }));

app.post('/api/auth/register', async (req, res) => {
  const { email, password, displayName } = req.body || {};
  if (!email || !password || !displayName) {
    return res.status(400).json({ error: 'Missing required fields' });
  }
  try {
    const existing = await getUserByEmail(email);
    if (existing) return res.status(400).json({ error: 'Email already in use' });
    const id = uuidv4();
    const passwordHash = await bcrypt.hash(password, 10);
    const now = new Date().toISOString();
    const userRow = {
      id,
      email,
      displayName,
      passwordHash,
      avatarUrl: null,
      xp: 0,
      level: 1,
      streakDays: 0,
      goal: 'buildMuscle',
      experienceLevel: 'beginner',
      weightKg: 70,
      heightCm: 175,
      workoutsCompleted: 0,
      equipment: JSON.stringify([]),
      injuries: JSON.stringify([]),
      subscription: 'free',
      createdAt: now,
      lastWorkoutAt: null,
    };
    await insertUser(userRow);
    const token = jwt.sign({ sub: id, email }, JWT_SECRET, { expiresIn: '7d' });
    return res.json({ token, user: rowToUser(userRow) });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: 'Server error' });
  }
});

app.post('/api/auth/login', async (req, res) => {
  const { email, password } = req.body || {};
  if (!email || !password) {
    return res.status(400).json({ error: 'Missing email or password' });
  }
  try {
    const user = await getUserByEmail(email);
    if (!user) return res.status(401).json({ error: 'Invalid credentials' });
    const match = await bcrypt.compare(password, user.passwordHash || '');
    if (!match) return res.status(401).json({ error: 'Invalid credentials' });
    const token = jwt.sign({ sub: user.id, email: user.email }, JWT_SECRET, { expiresIn: '7d' });
    return res.json({ token, user: rowToUser(user) });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: 'Server error' });
  }
});

app.get('/api/auth/me', async (req, res) => {
  const auth = req.headers.authorization;
  if (!auth || !auth.startsWith('Bearer ')) return res.status(401).json({ error: 'Not authenticated' });
  const token = auth.split(' ')[1];
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    const userId = decoded.sub || decoded.id;
    const user = await getUserById(userId);
    if (!user) return res.status(404).json({ error: 'User not found' });
    return res.json({ user: rowToUser(user) });
  } catch (e) {
    console.error(e);
    return res.status(401).json({ error: 'Invalid token' });
  }
});

app.listen(PORT, () => {
  console.log(`Auth server running on port ${PORT}`);
});
