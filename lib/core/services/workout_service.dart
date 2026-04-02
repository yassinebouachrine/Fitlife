import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class WorkoutService {
  final ApiClient _api = ApiClient.instance;

  Future<Map<String, dynamic>> getMyWorkouts() async {
    try {
      final response = await _api.get(ApiEndpoints.workouts);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getWorkout(int id) async {
    try {
      final response = await _api.get('${ApiEndpoints.workouts}/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createWorkout({
    required String name,
    String? description,
    int? estimatedDurationMin,
    List<Map<String, dynamic>>? exercises,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.workouts,
        data: {
          'name': name,
          if (description != null) 'description': description,
          if (estimatedDurationMin != null) 'estimated_duration_min': estimatedDurationMin,
          if (exercises != null) 'exercises': exercises,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> deleteWorkout(int id) async {
    try {
      final response = await _api.delete('${ApiEndpoints.workouts}/$id');
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