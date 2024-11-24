import 'package:dio/dio.dart';

import '../models/login_response.dart';
import 'dio_client.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(DioClient dioClient) : _dio = dioClient.dio;

  /// Perform login
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login', // Replace with your backend login endpoint
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);

        if (loginResponse.userType != 'vendor') {
          throw Exception(
              'You are not allowed to login in this app, please use download and use the ${loginResponse.userType} app!');
        }
        await AuthService().saveAuthData(loginResponse);
        await AuthService().setLoggedIn(true);

        return loginResponse; // Contains accessToken, vendorData, etc.
      } else {
        print('Failed to login: ${response.data}');
        throw Exception('Failed to login: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error: ${e.response?.data['message'] ?? e.message}');
        throw Exception("${e.response?.data['message'] ?? e.message}");
      } else {
        print('Unexpected error: ${e.message}');
        throw Exception('Unexpected error: ${e.message}');
      }
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/signup', // Replace with your backend endpoint
        data: {
          "name": name.trim(),
          "email": email.trim(),
          "phone": phone.trim(),
          "password": password,
        },
      );

      if (response.statusCode != 201) {
        throw Exception(response.data['message'] ?? 'Signup failed');
      }
    } catch (e) {
      throw Exception('An error occurred during signup: $e');
    }
  }
}
