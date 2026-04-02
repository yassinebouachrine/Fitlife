import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class AiService {
  final ApiClient _api = ApiClient.instance;

  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      final response = await _api.post(
        ApiEndpoints.aiChat,
        data: {'message': message},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getChatHistory() async {
    try {
      final response = await _api.get(ApiEndpoints.aiHistory);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> clearChat() async {
    try {
      await _api.delete(ApiEndpoints.aiClear);
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