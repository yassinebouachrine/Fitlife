// Calculate level and title based on XP
function getLevelInfo(xp) {
  const levels = [
    { level: 1, title: 'Beginner', minXp: 0, maxXp: 500 },
    { level: 2, title: 'Novice', minXp: 500, maxXp: 1000 },
    { level: 3, title: 'Apprentice', minXp: 1000, maxXp: 1700 },
    { level: 4, title: 'Trainee', minXp: 1700, maxXp: 2500 },
    { level: 5, title: 'Regular', minXp: 2500, maxXp: 3500 },
    { level: 6, title: 'Committed', minXp: 3500, maxXp: 4700 },
    { level: 7, title: 'Dedicated', minXp: 4700, maxXp: 6000 },
    { level: 8, title: 'Warrior', minXp: 6000, maxXp: 7500 },
    { level: 9, title: 'Veteran', minXp: 7500, maxXp: 9200 },
    { level: 10, title: 'Champion', minXp: 9200, maxXp: 11000 },
    { level: 11, title: 'Master', minXp: 11000, maxXp: 13000 },
    { level: 12, title: 'Elite Warrior', minXp: 13000, maxXp: 15500 },
    { level: 13, title: 'Legend', minXp: 15500, maxXp: 18500 },
    { level: 14, title: 'Mythic', minXp: 18500, maxXp: 22000 },
    { level: 15, title: 'Immortal', minXp: 22000, maxXp: 30000 },
  ];

  for (let i = levels.length - 1; i >= 0; i--) {
    if (xp >= levels[i].minXp) {
      return {
        level: levels[i].level,
        title: levels[i].title,
        currentXp: xp,
        maxXp: levels[i].maxXp,
        xpToNext: levels[i].maxXp - xp,
      };
    }
  }
  return levels[0];
}

// Calculate XP earned from a workout
function calculateWorkoutXP(durationMin, exerciseCount, difficulty) {
  let base = durationMin * 2;
  base += exerciseCount * 10;

  const multiplier = difficulty === 'Advanced' ? 1.5 : difficulty === 'Intermediate' ? 1.2 : 1.0;
  return Math.round(base * multiplier);
}

// Calculate calories burned (rough estimate)
function calculateCalories(durationMin, weightKg, intensity) {
  const met = intensity === 'Advanced' ? 8 : intensity === 'Intermediate' ? 6 : 4;
  return Math.round((met * 3.5 * (weightKg || 70) / 200) * durationMin);
}

// Calculate streak
function calculateStreak(lastWorkoutDate, currentStreak) {
  if (!lastWorkoutDate) return 1;

  const last = new Date(lastWorkoutDate);
  const today = new Date();
  last.setHours(0, 0, 0, 0);
  today.setHours(0, 0, 0, 0);

  const diffDays = Math.floor((today - last) / (1000 * 60 * 60 * 24));

  if (diffDays === 0) return currentStreak; // Same day
  if (diffDays === 1) return currentStreak + 1; // Consecutive
  return 1; // Streak broken
}

module.exports = { getLevelInfo, calculateWorkoutXP, calculateCalories, calculateStreak };