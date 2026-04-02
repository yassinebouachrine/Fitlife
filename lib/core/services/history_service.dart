import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class HistoryService {
  final ApiClient _api = ApiClient.instance;

  Future<Map<String, dynamic>> getHistory({int limit = 20, int offset = 0}) async {
    try {
      final response = await _api.get(
        ApiEndpoints.history,
        queryParameters: {'limit': limit, 'offset': offset},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getHistoryDetail(int id) async {
    try {
      final response = await _api.get('${ApiEndpoints.history}/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> logWorkout({
    required String workoutName,
    required int durationMin,
    String workoutType = 'custom',
    int? programId,
    int? workoutId,
    int exercisesCompleted = 0,
    List<Map<String, dynamic>>? exerciseDetails,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.history,
        data: {
          'workout_name': workoutName,
          'duration_min': durationMin,
          'workout_type': workoutType,
          if (programId != null) 'program_id': programId,
          if (workoutId != null) 'workout_id': workoutId,
          'exercises_completed': exercisesCompleted,
          if (exerciseDetails != null) 'exercise_details': exerciseDetails,
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