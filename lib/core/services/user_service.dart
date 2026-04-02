import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class UserService {
  final ApiClient _api = ApiClient.instance;

  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await _api.get(ApiEndpoints.dashboard);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _api.get(ApiEndpoints.profile);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    double? weight,
    double? height,
    int? age,
    String? goal,
    String? fitnessLevel,
  }) async {
    try {
      final response = await _api.put(
        ApiEndpoints.updateProfile,
        data: {
          if (fullName != null) 'full_name': fullName,
          if (weight != null) 'weight': weight,
          if (height != null) 'height': height,
          if (age != null) 'age': age,
          if (goal != null) 'goal': goal,
          if (fitnessLevel != null) 'fitness_level': fitnessLevel,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionError) {
      return 'Cannot connect to server.';
    }
    if (e.type == DioExceptionType.badResponse) {
      return e.response?.data?['message'] ?? 'Server error.';
    }
    return 'Network error.';
  }
}