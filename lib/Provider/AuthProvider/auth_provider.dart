import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sportdivers/Provider/UserProvider/userProvider.dart';
import 'package:sportdivers/models/user_model.dart';
import 'package:sportdivers/screens/Service/SocketService.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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
    loadAuthState();
    //_loadToken();
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

  //stay connected
  Future<void> loadAuthState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _accountType = prefs.getString('accountType') ?? '';
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      _userData = json.decode(userDataString);
    }
    notifyListeners();
  }

  Future<void> _saveAuthState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token ?? '');
    await prefs.setBool('isAuthenticated', _isAuthenticated);
    await prefs.setString('accountType', _accountType);
    if (_userData != null) {
      await prefs.setString('userData', json.encode(_userData));
    }
  }

  Future<bool> _verifyToken() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/auth/check-token'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _userData = data['userData'];
        _accountType = data['userData']['accountType'] ?? '';
        await _saveAuthState();
        return true;
      } else {
        await logoutUser();
        return false;
      }
    } catch (e) {
      print('Error verifying token: $e');
      await logoutUser();
      return false;
    }
  }

  Future<bool> isUserLoggedIn() async {
    await loadAuthState();
    if (_isAuthenticated && _token != null) {
      return await _verifyToken();
    }
    return false;
  }

  //*************

  Future<void> resetPassword({
    required String oldPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // print('Attempting to reset password...');
      // print('Using token: $_token');

      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/users/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'oldPassword': oldPassword,
          'password': newPassword,
        }),
      );

      // print('Response Status Code: ${response.statusCode}');
      // print('Response Headers: ${response.headers}');
      // print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        _resMessage = 'Password changed successfully';
        await logoutUser();
      } else {
        final responseBody = jsonDecode(response.body);
        _resMessage = responseBody['message'] ?? 'Failed to change password';
      }
    } catch (e) {
      // print('Exception: $e');
      _resMessage = 'Error occurred while changing password';
    }

    _isLoading = false;
    notifyListeners();
  }

  void resetMessage() {
    _resMessage = '';
    notifyListeners();
  }

  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
    bool rememberMe = false,
  }) async {
    _isLoading = true;
    notifyListeners();
    late SocketService _socketService;
    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'token': deviceToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['accessToken'];
        _userData = data['userData'];
        _accountType = data['userData']['accountType'] ?? '';
        _isAuthenticated = true;
        _resMessage = 'Login successful';

        // Save the authentication state
        await _saveAuthState();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs?.setBool("isLoggedIn", true);

        //socket
        _socketService = Provider.of<SocketService>(context, listen: false);
        _socketService.connect(_token!);

        await _saveToken(_token!);
        // Create a User object
        User user = User(
          id: userData?['id'] ?? '',
          firstName: userData?['firstName'] ?? '',
          lastName: userData?['lastName'] ?? '',
          picture: userData?['picture'],
          type: userData?['type'] ?? '',
          groupId: userData?['groupId'],
        );

        print('Created User object: $user');

        // Set the current user
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.setCurrentUser(user);

        print('Current user set in UserProvider');

        // Verify that the user was set correctly
        final currentUser = userProvider.currentUser;
        print('Current user after setting: $currentUser');

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
    await prefs.remove('isAuthenticated');
    await prefs.remove('accountType');
    await prefs.remove('userData');
    await prefs.remove('isLoggedIn');
    await _clearUserCredentials();
    _isAuthenticated = false;
    _token = null;
    _userData = null;
    _accountType = '';

    notifyListeners();
  }

  Future<String> requestPasswordReset({required String email}) async {
    final encodedEmail = base64Encode(utf8.encode(email));

    final Uri url = Uri.parse(
        '${Constants.baseUrl}/auth/request-password-reset?email=$encodedEmail');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return 'Password reset link sent successfully.';
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception(
            'Failed to request password reset: ${responseBody['message']}');
      }
    } catch (e) {
      throw Exception('Error occurred while requesting password reset: $e');
    }
  }
}
