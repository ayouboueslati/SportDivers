import 'package:flutter/material.dart';
import 'package:footballproject/models/session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrainingScheduleProvider with ChangeNotifier {
  List<Session> _sessions = [];

  List<Session> get sessions => _sessions;

  Future<void> fetchTrainingSchedule(String baseUrl, String token) async {
    final url = Uri.parse('$baseUrl/sessions');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> sessionData = json.decode(response.body);
        _sessions = sessionData.map((data) => Session.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load training schedule');
      }
    } catch (error) {
      throw Exception('Failed to load training schedule: $error');
    }
  }
}
