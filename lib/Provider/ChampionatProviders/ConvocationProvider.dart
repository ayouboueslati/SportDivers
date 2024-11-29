import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportdivers/Provider/constantsProvider.dart';
import 'dart:convert';
import 'package:sportdivers/models/ConvocationStudModel.dart';

class ConvocationProvider with ChangeNotifier {
  List<Student> _students = [];
  List<String> _selectedStudentIds = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Student> get students => _students;
  List<String> get selectedStudentIds => _selectedStudentIds;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchGroupStudents(String groupId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    print('Fetching students for groupId: $groupId');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/groups/$groupId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Response data decoded: $responseData');

        _students = (responseData['students'] as List)
            .map((studentData) => Student.fromJson(studentData))
            .toList();

        print('Students list updated: $_students');
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load students';
        print('Error loading students: $response.body');
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'An error occurred: ${e.toString()}';
      print('Exception during fetchGroupStudents: ${e.toString()}');
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleStudentSelection(String studentId) {
    print('Toggling selection for studentId: $studentId');
    if (_selectedStudentIds.contains(studentId)) {
      _selectedStudentIds.remove(studentId);
      print('Student removed: $studentId');
    } else {
      _selectedStudentIds.add(studentId);
      print('Student added: $studentId');
    }
    print('Current selectedStudentIds: $_selectedStudentIds');
    notifyListeners();
  }

  void clearSelectedStudents() {
    print('Clearing selected students');
    _selectedStudentIds.clear();
    notifyListeners();
  }

  Future<bool> submitConvocation({
    required String matchId,
    required String teamId,
  }) async {
    print('Submitting convocation with matchId: $matchId, teamId: $teamId');
    if (_selectedStudentIds.isEmpty) {
      print('No students selected for submission');
      return false;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/tournaments/matches/$matchId/set-players'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "team": teamId,
          "players": _selectedStudentIds,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Convocation submitted successfully');
        clearSelectedStudents();
        return true;
      } else {
        print('Failed to submit convocation. Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception during submitConvocation: ${e.toString()}');
      return false;
    }
  }
}
