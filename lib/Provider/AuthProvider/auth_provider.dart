import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import '../constantsProvider.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _resMessage = '';
  bool _isAuthenticated = false;
  String _accountType = '';
  String? _token;
  Map<String, dynamic>? _userData;

  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  bool get isAuthenticated => _isAuthenticated;
  String get accountType => _accountType;
  String? get token => _token;
  Map<String, dynamic>? get userData => _userData;

  AuthenticationProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
    bool rememberMe = false,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['accessToken'];
        _userData = data['userData']; // Extract userData
        _accountType = data['userData']['accountType'] ??
            ''; // Ensure accountType is present
        _isAuthenticated = true;
        _resMessage = 'Login successful';

        await _saveToken(_token!);

        if (rememberMe) {
          await _saveUserCredentials(email, password);
        } else {
          await _clearUserCredentials();
        }
      } else {
        _isAuthenticated = false;
        _resMessage = 'Please try again';
      }
    } catch (e) {
      _isAuthenticated = false;
      _resMessage = 'Error occurred';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveUserCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<void> _clearUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
  }

  Future<Map<String, String?>> loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    return {'email': email, 'password': password};
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await _clearUserCredentials();
    _isAuthenticated = false;
    _token = null;
    notifyListeners();
  }

  Future<String> requestPasswordReset({required String email}) async {
    // Construct the URL with query parameters
    final Uri url =
        Uri.parse('${Constants.baseUrl}/auth/request-password-reset')
            .replace(queryParameters: {'email': email});

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return 'Password reset link sent successfully.';
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception(
            'Failed to request password reset: ${responseBody['message']}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error occurred while requesting password reset: $e');
    }
  }
}
