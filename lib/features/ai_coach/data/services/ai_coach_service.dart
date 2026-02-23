import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// AI Coach Service — connects to our custom AI Engine
class AICoachService {
  // AI Engine Configuration from .env
  static String get _authKey => dotenv.get('AI_API_KEY', fallback: '');
  static String get _engineModel =>
      dotenv.get('AI_MODEL', fallback: 'gemini-1.5-flash');
  static String get _endpoint =>
      'https://generativelanguage.googleapis.com/v1beta/models/$_engineModel:generateContent?key=$_authKey';

  /// System prompt that defines the AI coach persona
  static const String _systemPrompt = '''
You are NEXUS — an elite AI fitness coach built on cutting-edge sports science 
and performance psychology. Your character traits:

🧠 EXPERTISE: Sports science, biomechanics, nutrition, recovery, mindset coaching
💪 STYLE: Scientific but motivating. Evidence-based, never toxic or unrealistic.
🎯 GOAL: Help users achieve peak physical performance safely and sustainably.

YOUR RULES:
- Always respond in valid JSON matching the ResponseSchema below
- Use the user's fitness history to give personalized advice
- Balance science with motivation — you're a coach AND a mentor
- Never recommend dangerous practices or unrealistic expectations
- Factor in recovery, sleep, nutrition holistically
- Adapt your coaching style to the user's experience level

RESPONSE SCHEMA (always return this JSON structure):
{
  "message": "Your main coach response (conversational, motivating)",
  "weekly_plan": [
    {"day": "Monday", "focus": "...", "exercises": [...]}
  ],
  "nutrition_advice": "Specific macro/meal guidance",
  "motivation_message": "A powerful, personalized motivational quote",
  "recovery_tips": "Sleep, mobility, stress management advice",
  "adjustments": "Any program adjustments based on user feedback",
  "metrics_to_track": ["..."],
  "danger_flags": []
}

If a weekly plan is not requested, return empty arrays for those fields.
Always include `message`, `motivation_message`.
''';

  final List<Map<String, dynamic>> _coachHistory = [];

  /// Sends a message into the AI engine and returns the structured response
  Future<AICoachResponse> sendMessage({
    required String userMessage,
    required UserFitnessContext context,
  }) async {
    // Add user context to the message
    final contextualMessage = '''
USER CONTEXT:
- Goal: ${context.goal}
- Experience: ${context.experienceLevel}
- Weight: ${context.weightKg}kg, Height: ${context.heightCm}cm
- Weekly workouts: ${context.workoutsPerWeek}
- Recent streak: ${context.streakDays} days
- Available equipment: ${context.equipment.join(', ')}
- Injuries: ${context.injuries.isEmpty ? 'None' : context.injuries.join(', ')}

USER MESSAGE: $userMessage
''';

    _coachHistory.add({
      'role': 'user',
      'parts': [
        {'text': contextualMessage}
      ],
    });

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': _coachHistory,
          'systemInstruction': {
            'parts': [
              {'text': _systemPrompt}
            ]
          },
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 2000,
            'responseMimeType': 'application/json',
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final contentText =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        final parsed = jsonDecode(contentText) as Map<String, dynamic>;

        // Add assistant response to history
        _coachHistory.add({
          'role': 'model',
          'parts': [
            {'text': contentText}
          ],
        });

        return AICoachResponse.fromJson(parsed);
      } else {
        throw Exception('AI Engine Error: ${response.statusCode}');
      }
    } catch (e) {
      // Return a fallback response if engineering fails
      return AICoachResponse.fallback(userMessage);
    }
  }

  void clearHistory() => _coachHistory.clear();
}

/// User fitness context for personalized coaching
class UserFitnessContext {
  final String goal;
  final String experienceLevel;
  final double weightKg;
  final int heightCm;
  final int workoutsPerWeek;
  final int streakDays;
  final List<String> equipment;
  final List<String> injuries;

  const UserFitnessContext({
    required this.goal,
    required this.experienceLevel,
    required this.weightKg,
    required this.heightCm,
    this.workoutsPerWeek = 4,
    this.streakDays = 0,
    this.equipment = const ['Barbell', 'Dumbbells', 'Cables', 'Machines'],
    this.injuries = const [],
  });
}

/// Structured response from the AI coach
class AICoachResponse {
  final String message;
  final List<DayPlan> weeklyPlan;
  final String nutritionAdvice;
  final String motivationMessage;
  final String recoveryTips;
  final String adjustments;
  final List<String> metricsToTrack;
  final List<String> dangerFlags;

  const AICoachResponse({
    required this.message,
    this.weeklyPlan = const [],
    this.nutritionAdvice = '',
    this.motivationMessage = '',
    this.recoveryTips = '',
    this.adjustments = '',
    this.metricsToTrack = const [],
    this.dangerFlags = const [],
  });

  factory AICoachResponse.fromJson(Map<String, dynamic> json) {
    return AICoachResponse(
      message: json['message'] as String? ?? '',
      weeklyPlan: (json['weekly_plan'] as List<dynamic>? ?? [])
          .map((e) => DayPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      nutritionAdvice: json['nutrition_advice'] as String? ?? '',
      motivationMessage: json['motivation_message'] as String? ?? '',
      recoveryTips: json['recovery_tips'] as String? ?? '',
      adjustments: json['adjustments'] as String? ?? '',
      metricsToTrack: List<String>.from(json['metrics_to_track'] ?? []),
      dangerFlags: List<String>.from(json['danger_flags'] ?? []),
    );
  }

  factory AICoachResponse.fallback(String userMessage) {
    return const AICoachResponse(
      message:
          "I'm currently in offline mode. Your dedication is inspiring! Keep pushing — your consistency is building an unstoppable foundation. Connect to the internet to get your personalized AI coaching session.",
      motivationMessage:
          '"The iron never lies to you. You can walk outside and it\'s raining, you don\'t want to work out, but you pick up the iron and it will always give you what you deserve." — Henry Rollins',
    );
  }
}

class DayPlan {
  final String day;
  final String focus;
  final List<String> exercises;

  const DayPlan({
    required this.day,
    required this.focus,
    this.exercises = const [],
  });

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    return DayPlan(
      day: json['day'] as String? ?? '',
      focus: json['focus'] as String? ?? '',
      exercises: List<String>.from(json['exercises'] ?? []),
    );
  }
}
