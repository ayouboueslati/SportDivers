import 'package:flutter/foundation.dart';
import 'package:sportdivers/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  // Set the current user and save to persistent storage
  Future<void> setCurrentUser(User user) async {
    _currentUser = user;


    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUser', json.encode({
      'id': user.id,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'picture': user.picture,
      'type': user.type,
      'groupId': user.groupId,
    }));

    notifyListeners();
  }

  // Load the current user from persistent storage
  Future<void> loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('currentUser');
    if (userJson != null) {
      final userData = json.decode(userJson);
      _currentUser = User.fromJson(userData);
      notifyListeners();
    }
  }

  // Clear the current user (for logout)
  Future<void> clearCurrentUser() async {
    _currentUser = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
  }
}