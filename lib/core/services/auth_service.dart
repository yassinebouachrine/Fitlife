import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class AuthService {
  final ApiClient _api = ApiClient.instance;

  // ==================== CONNEXION ====================
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;

      // Sauvegarder le token
      if (data['data'] != null && data['data']['token'] != null) {
        await ApiClient.saveToken(data['data']['token']);
      }

      return data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== INSCRIPTION ====================
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    double? weight,
    double? height,
    String? goal,
    String? fitnessLevel,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.register,
        data: {
          'full_name': fullName,
          'email': email,
          'password': password,
          if (weight != null) 'weight': weight,
          if (height != null) 'height': height,
          if (goal != null) 'goal': goal,
          if (fitnessLevel != null) 'fitness_level': fitnessLevel,
        },
      );

      final data = response.data;

      // Sauvegarder le token
      if (data['data'] != null && data['data']['token'] != null) {
        await ApiClient.saveToken(data['data']['token']);
      }

      return data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== PROFIL ====================
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _api.get(ApiEndpoints.profile);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== DÉCONNEXION ====================
  Future<void> logout() async {
    await ApiClient.removeToken();
  }

  // ==================== VÉRIFIER CONNEXION ====================
  Future<bool> isAuthenticated() async {
    return await ApiClient.hasToken();
  }

  // ==================== TEST SANTÉ SERVEUR ====================
  Future<bool> healthCheck() async {
    try {
      final response = await _api.get(ApiEndpoints.health);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ==================== GESTION D'ERREURS ====================
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Check your connection.';

      case DioExceptionType.connectionError:
        return 'Cannot connect to server. Make sure the server is running and you are on the same WiFi network.';

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        String? message;

        if (data is Map<String, dynamic>) {
          message = data['message'] as String?;
        }

        switch (statusCode) {
          case 400:
            return message ?? 'Invalid data.';
          case 401:
            return message ?? 'Invalid email or password.';
          case 403:
            return message ?? 'Access denied.';
          case 404:
            return message ?? 'Not found.';
          case 409:
            return message ?? 'Email already in use.';
          case 422:
            // Validation errors
            if (data is Map && data['errors'] != null) {
              final errors = data['errors'] as List;
              return errors.map((e) => e['msg']).join('\n');
            }
            return message ?? 'Validation error.';
          case 500:
            return message ?? 'Server error.';
          default:
            return message ?? 'Unexpected error ($statusCode).';
        }

      default:
        return 'A network error occurred.';
    }
  }
}