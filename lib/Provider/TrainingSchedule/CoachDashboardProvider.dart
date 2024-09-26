import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sportdivers/Provider/constantsProvider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  Future<void> _initToken() async {
    if (_token == null) {
      print('Initializing token...');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      print('Token retrieved: $_token');

      if (_token == null) {
        print('Error: Token not found');
        throw Exception('Token not found');
      }
    } else {
      print('Token already initialized: $_token');
    }
  }

  Future<List<dynamic>> getStudents() async {
    await _initToken();
    final url = Uri.parse('${Constants.baseUrl}/users/students');
    print('Fetching students from: $url');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $_token',
      });

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error: Failed to load students, status code: ${response.statusCode}');
        throw Exception('Failed to load students');
      }
    } catch (e) {
      print('Error fetching students: $e');
      rethrow;
    }
  }

  Future<void> setAttendance(String sessionId, Map<String, dynamic> attendanceData) async {
    await _initToken();
    final url = Uri.parse('${Constants.baseUrl}/sessions/$sessionId/set-attendance');
    print('Setting attendance for session: $sessionId');
    print('Attendance data: $attendanceData');
    print('Sending request to: $url');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode(attendanceData),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        print('Error: Failed to set attendance, status code: ${response.statusCode}');
        print('Error response: ${response.body}');
        throw Exception('Failed to set attendance: ${response.body}');
      } else {
        print('Attendance successfully set for session: $sessionId');
      }
    } catch (e) {
      print('Error setting attendance: $e');
      rethrow;
    }
  }
}
