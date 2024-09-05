import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:footballproject/Provider/constantsProvider.dart';
import 'package:footballproject/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _error = '';

  bool get isLoading => _isLoading;
  String get error => _error;

  Future<User?> updateUserProfile(Map<String, dynamic> updatedData) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    final url = "${Constants.baseUrl}/users/profile";
    print('Updating user profile with URL: $url');
    print('Updated data: $updatedData');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      print('Token: $token');

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode(updatedData),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return User.fromJson(json.decode(response.body));
      } else {
        _error = 'Failed to update user profile. Status code: ${response.statusCode}';
        print('Error: $_error');
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = 'An error occurred: $e';
      print('Error: $_error');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}