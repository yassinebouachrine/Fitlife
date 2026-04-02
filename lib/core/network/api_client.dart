import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static ApiClient? _instance;
  late Dio _dio;

  // Singleton
  static ApiClient get instance {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  ApiClient._internal() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:3000';

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Intercepteur pour ajouter le token JWT automatiquement
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('➡️ ${options.method} ${options.uri}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ ${response.statusCode} ${response.requestOptions.uri}');
          handler.next(response);
        },
        onError: (error, handler) {
          print('❌ ${error.response?.statusCode} ${error.requestOptions.uri}');
          print('   Message: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // ==================== MÉTHODES HTTP ====================

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  Future<Response> patch(String path, {dynamic data}) {
    return _dio.patch(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) {
    return _dio.delete(path, data: data);
  }

  // ==================== TOKEN MANAGEMENT ====================

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}