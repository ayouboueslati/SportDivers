import 'package:flutter/material.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:footballproject/models/studentProfile.dart';
import 'package:footballproject/models/teacherProfile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constantsProvider.dart';

class TicketsProvider extends ChangeNotifier {
  List<dynamic> _tickets = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<dynamic> get tickets => _tickets;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  AuthenticationProvider? _authProvider;

  TicketsProvider(this._authProvider);

  set authProvider(AuthenticationProvider authProvider) {
    _authProvider = authProvider;
    notifyListeners();
  }

  Future<void> submitReport({
    required String reason,
    required String comment,
    required String target,
    required String person,
  }) async {
    final url = Uri.parse('${Constants.baseUrl}/tickets');
    final token = _authProvider?.token;

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'reason': reason,
          'comment': comment,
          'target': target,
          'person': person,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to submit report: ${response.statusCode}');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<StudentProfile>> fetchStudents() async {
    final url = Uri.parse('${Constants.baseUrl}/users/students');
    final token = _authProvider?.token;

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Fetched Students Data: $data'); // Updated log message

        return data.map((json) => StudentProfile.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch students: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching students: $error');
      throw error;
    }
  }

  Future<List<TeacherProfile>> fetchTeachers() async {
    final url = Uri.parse('${Constants.baseUrl}/users/teachers');
    final token = _authProvider?.token;

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Fetched Teachers Data: $data'); // Updated log message
        return data.map((json) => TeacherProfile.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch teachers: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching teachers: $error');
      throw error;
    }
  }

  Future<void> fetchTickets() async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = 'User not authenticated';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/tickets'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_authProvider!.token}',
        },
      );

      if (response.statusCode == 200) {
        _tickets = jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);
        _errorMessage = responseBody['message'] ?? 'Failed to fetch tickets';
      }
    } catch (e) {
      _errorMessage = 'Error occurred while fetching tickets: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
