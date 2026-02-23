import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Result returned after analysing a food image with Gemini Vision
class FoodRecognitionResult {
  final String dishName;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatsG;
  final List<String> ingredients;
  final String portionEstimate;
  final bool isSuccessful;
  final String? errorMessage;

  const FoodRecognitionResult({
    required this.dishName,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    this.ingredients = const [],
    this.portionEstimate = '~1 serving',
    this.isSuccessful = true,
    this.errorMessage,
  });

  /// Fallback result when analysis fails
  factory FoodRecognitionResult.error(String message) {
    return FoodRecognitionResult(
      dishName: 'Unknown Dish',
      calories: 0,
      proteinG: 0,
      carbsG: 0,
      fatsG: 0,
      isSuccessful: false,
      errorMessage: message,
    );
  }

  /// Parse from Gemini Vision JSON response
  factory FoodRecognitionResult.fromJson(Map<String, dynamic> json) {
    return FoodRecognitionResult(
      dishName: (json['dish'] as String?) ?? 'Unknown Dish',
      calories: (json['calories'] as num?)?.round() ?? 0,
      proteinG: (json['protein_g'] as num?)?.toDouble() ?? 0,
      carbsG: (json['carbs_g'] as num?)?.toDouble() ?? 0,
      fatsG: (json['fats_g'] as num?)?.toDouble() ?? 0,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      portionEstimate: (json['portion'] as String?) ?? '~1 serving',
    );
  }
}

/// Food recognition service powered by Gemini Vision API
///
/// Uses the same API key as the AI Coach — no extra setup needed.
/// Sends a base64-encoded image to Gemini Flash Vision and parses
/// structured nutritional JSON from the response.
class FoodRecognitionService {
  static String get _apiKey => dotenv.get('AI_API_KEY', fallback: '');
  static String get _model =>
      dotenv.get('AI_MODEL', fallback: 'gemini-1.5-flash');
  static String get _endpoint =>
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_apiKey';

  static const String _foodPrompt = '''
You are a professional nutritionist and food recognition AI.
Analyze the food in this image and respond ONLY with a valid JSON object — no markdown, no explanation.

JSON schema:
{
  "dish": "Name of the dish or food item",
  "calories": 450,
  "protein_g": 35.5,
  "carbs_g": 40.2,
  "fats_g": 12.1,
  "ingredients": ["chicken breast", "rice", "broccoli"],
  "portion": "~350g, 1 plate"
}

Rules:
- Identify the main dish name accurately
- Estimate calories and macros based on visible portion size
- List up to 6 key visible ingredients
- If multiple foods are visible, sum total nutritional values
- If the image is NOT food, return: {"dish":"Not Food","calories":0,"protein_g":0,"carbs_g":0,"fats_g":0,"ingredients":[],"portion":"N/A"}
''';

  /// Analyse [imageFile] and return structured nutritional information.
  ///
  /// [imageFile] should be a valid local File from image_picker.
  Future<FoodRecognitionResult> analyzeFood(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Determine MIME type from extension
      final ext = imageFile.path.split('.').last.toLowerCase();
      final mimeType = ext == 'png'
          ? 'image/png'
          : ext == 'webp'
              ? 'image/webp'
              : 'image/jpeg';

      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'inlineData': {
                  'mimeType': mimeType,
                  'data': base64Image,
                }
              },
              {'text': _foodPrompt},
            ]
          }
        ],
        'generationConfig': {
          'temperature':
              0.1, // Low temp for consistent, accurate nutritional data
          'maxOutputTokens': 512,
          'responseMimeType': 'application/json',
        },
      });

      final response = await http
          .post(
            Uri.parse(_endpoint),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text']
            as String?;

        if (text == null || text.isEmpty) {
          return FoodRecognitionResult.error('No response from vision model.');
        }

        final parsed = jsonDecode(text) as Map<String, dynamic>;
        return FoodRecognitionResult.fromJson(parsed);
      } else {
        final err = jsonDecode(response.body);
        final msg = err['error']?['message'] ?? 'HTTP ${response.statusCode}';
        return FoodRecognitionResult.error(msg);
      }
    } on FormatException {
      return FoodRecognitionResult.error(
          'Could not parse nutritional data. Try a clearer photo.');
    } catch (e) {
      return FoodRecognitionResult.error(
          'Analysis failed. Check your internet connection.');
    }
  }
}
