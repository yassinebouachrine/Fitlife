import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class ProgramService {
  final ApiClient _api = ApiClient.instance;

  Future<Map<String, dynamic>> getPrograms({String? category, String? difficulty}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null && category != 'All') queryParams['category'] = category;
      if (difficulty != null) queryParams['difficulty'] = difficulty;

      final response = await _api.get(ApiEndpoints.programs, queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getProgram(int id) async {
    try {
      final response = await _api.get('${ApiEndpoints.programs}/$id');
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