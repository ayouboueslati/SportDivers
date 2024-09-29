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
        _userData = data['userData'];
        _accountType = data['userData']['accountType'] ?? '';
        _isAuthenticated = true;
        _resMessage = 'Login successful';

        // print('Login successful');
        // print('Token: $_token');
        // print('User Data: $_userData');
        // print('Account Type: $_accountType');

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
    await _clearUserCredentials();
    _isAuthenticated = false;
    _token = null;
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




  Future<void> updateFCMToken(String? token) async {
    if (token != null && _token != null) {
      try {
        final response = await http.post(
          Uri.parse('${Constants.baseUrl}/users/update-fcm-token'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
          },
          body: json.encode({'fcm_token': token}),
        );

        if (response.statusCode == 200) {
          print('FCM token updated successfully on server');
        } else {
          print('Failed to update FCM token on server: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Error updating FCM token: $e');
      }
    } else {
      print('Cannot update FCM token: token is null or user is not authenticated');
    }
  }

}
