const db = require('../config/database');

// Simple AI coach (can be replaced with real AI API later)
exports.chat = async (req, res) => {
  try {
    const { message } = req.body;

    // Get user context
    const [users] = await db.query('SELECT * FROM users WHERE id = ?', [req.userId]);
    const user = users[0];

    // Get recent workout data
    const [recentWorkouts] = await db.query(
      `SELECT workout_name, duration_min, xp_earned, completed_at 
       FROM workout_history WHERE user_id = ? ORDER BY completed_at DESC LIMIT 5`,
      [req.userId]
    );

    // Generate response based on context
    const response = generateResponse(message, user, recentWorkouts);

    // Save conversation
    await db.query(
      'INSERT INTO ai_conversations (user_id, message, response) VALUES (?, ?, ?)',
      [req.userId, message, response]
    );

    res.json({
      success: true,
      data: { message: response },
    });
  } catch (err) {
    console.error('AI chat error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Get chat history
exports.getChatHistory = async (req, res) => {
  try {
    const [conversations] = await db.query(
      'SELECT message, response, created_at FROM ai_conversations WHERE user_id = ? ORDER BY created_at DESC LIMIT 50',
      [req.userId]
    );

    res.json({ success: true, data: conversations });
  } catch (err) {
    console.error('Chat history error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Clear chat
exports.clearChat = async (req, res) => {
  try {
    await db.query('DELETE FROM ai_conversations WHERE user_id = ?', [req.userId]);
    res.json({ success: true, message: 'Chat cleared' });
  } catch (err) {
    console.error('Clear chat error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Simple response generator
function generateResponse(message, user, recentWorkouts) {
  const msg = message.toLowerCase();
  const name = user.full_name.split(' ')[0];

  if (msg.includes('plan') || msg.includes('weekly') || msg.includes('schedule')) {
    return `Here's a suggested weekly plan for you, ${name}:

Monday: Upper Body (Chest + Shoulders) - 45 min
Tuesday: Lower Body (Squats + Lunges) - 50 min
Wednesday: Rest or Light Cardio - 20 min
Thursday: Back + Biceps - 45 min
Friday: Legs + Core - 50 min
Saturday: Full Body HIIT - 30 min
Sunday: Rest and Recovery

Based on your ${user.fitness_level} level and ${user.goal} goal, I recommend focusing on progressive overload. Want me to create a detailed workout for any of these days?`;
  }

  if (msg.includes('nutrition') || msg.includes('diet') || msg.includes('eat') || msg.includes('food')) {
    const calories = user.goal === 'Lose Weight' ? 'a 300-500 calorie deficit' :
                     user.goal === 'Build Muscle' ? 'a 200-300 calorie surplus' : 'maintenance calories';
    return `For your goal of "${user.goal}", I recommend ${calories}.

Key nutrition tips:
- Protein: Aim for ${Math.round((user.weight || 70) * 1.8)}g daily (1.8g per kg)
- Stay hydrated: Drink at least 2.5L of water daily
- Eat whole foods: Lean meats, vegetables, complex carbs
- Pre-workout: Light carbs 1-2 hours before training
- Post-workout: Protein + carbs within 30 min after

Would you like a more specific meal plan?`;
  }

  if (msg.includes('progress') || msg.includes('stats') || msg.includes('track')) {
    const workoutCount = recentWorkouts.length;
    return `Here's your recent progress, ${name}:

Total workouts: ${user.total_workouts}
Current streak: ${user.streak} days
Total XP: ${user.xp}
Calories burned: ${user.total_calories_burned}

${workoutCount > 0 ? `Last workout: ${recentWorkouts[0].workout_name} (${recentWorkouts[0].duration_min} min)` : 'No recent workouts logged.'}

${user.streak >= 7 ? 'Amazing streak! Keep it going!' : user.streak >= 3 ? 'Good consistency! Try to maintain your streak.' : 'Try to workout more regularly to build a streak!'}`;
  }

  if (msg.includes('form') || msg.includes('technique') || msg.includes('how to')) {
    return `Great question about form! Here are some general tips:

1. Always warm up for 5-10 minutes before lifting
2. Focus on controlled movements, not speed
3. Keep your core engaged during all exercises
4. Breathe out during the effort phase
5. Full range of motion is more important than heavy weight
6. If you feel pain (not soreness), stop immediately

Which specific exercise would you like form tips for? I can give detailed guidance for squats, deadlifts, bench press, and more.`;
  }

  if (msg.includes('motivation') || msg.includes('motivate') || msg.includes('tired')) {
    return `${name}, remember why you started! Here's some motivation:

"The only bad workout is the one that didn't happen."

You've already completed ${user.total_workouts} workouts. That's incredible! Every session is building a stronger version of you.

Tips to stay motivated:
- Set small, achievable weekly goals
- Track your progress (you're already doing this!)
- Find a workout buddy
- Mix up your routine to avoid boredom
- Celebrate small wins

You're at Level ${user.level} - keep pushing to level up!`;
  }

  // Default response
  return `Hey ${name}! I'm your Lifevora AI Coach. I can help you with:

- Workout plans and scheduling
- Nutrition and diet advice
- Exercise form and technique
- Progress tracking and analysis
- Motivation and tips

Your current stats: Level ${user.level}, ${user.total_workouts} workouts, ${user.streak} day streak.

What would you like to work on today?`;
}