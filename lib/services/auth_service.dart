import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_response.dart';

class AuthService {
  static const _isLoggedInKey = 'is_logged_in';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  Future<void> saveAuthData(LoginResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();

    // Serialize the login response to JSON
    final jsonString = jsonEncode(loginResponse.toJson());

    // Save the JSON string to SharedPreferences
    await prefs.setString('authData', jsonString);
  }

  /// Retrieve login response from SharedPreferences
  Future<LoginResponse?> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the JSON string
    final jsonString = prefs.getString('authData');

    if (jsonString != null) {
      // Deserialize the JSON string back to LoginResponse
      return LoginResponse.fromJson(jsonDecode(jsonString));
    }

    return null;
  }

  /// Clear login response data from SharedPreferences
  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authData');
  }
}
