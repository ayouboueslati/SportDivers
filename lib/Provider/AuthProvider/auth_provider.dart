import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthenticationProvider extends ChangeNotifier {
  final String requestBaseUrl =
      // Replace with your base URL
      'https://example.com/api';

  bool _isLoading = false;
  String _resMessage = '';
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  bool get isAuthenticated => _isAuthenticated;

  // Login
  Future<void> loginUser({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Replace with your base URL
    String url = "$requestBaseUrl/login";

    final body = {
      "email": email,
      "password": password,
    };

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode(body),
      );
      if (req.statusCode == 200 || req.statusCode == 201) {
        _isAuthenticated = true;
        _resMessage = "Login successful!";
      } else {
        final res = json.decode(req.body);
        _isAuthenticated = false;
        _resMessage = res["message"] ?? "Login failed";
      }
    } on SocketException catch (_) {
      _isAuthenticated = false;
      _resMessage = "Internet connection is not available";
    } catch (e) {
      _isAuthenticated = false;
      _resMessage = "Please try again";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset Password
  Future<void> resetPassword(BuildContext context,
      {required String email}) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please enter an email address and click on "Reset password"'),
          duration: Duration(milliseconds: 4000),
        ),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    // Replace with your base URL
    String url =
        "$requestBaseUrl/reset-password"; // Replace with your reset password endpoint

    final body = {
      "email": email,
    };

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode(body),
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        _resMessage = "Reset instructions sent to $email";
      } else {
        final res = json.decode(req.body);
        _resMessage = res["message"] ?? "Failed to send reset instructions";
      }
    } on SocketException catch (_) {
      _resMessage = "Internet connection is not available";
    } catch (e) {
      _resMessage = "Failed to send reset instructions. Please try again.";
    } finally {
      _isLoading = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_resMessage),
          duration: const Duration(milliseconds: 3000),
        ),
      );
    }
  }
}
