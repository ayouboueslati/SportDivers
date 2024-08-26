import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:footballproject/Provider/constantsProvider.dart';
import 'package:footballproject/models/session.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SessionProvider with ChangeNotifier {
  List<Session> _sessions = [];

  List<Session> get sessions => _sessions;

  // Function to fetch sessions
  Future<void> fetchSessions(String token) async {
    final url = '${Constants.baseUrl}/sessions';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        List<dynamic> jsonResponse = json.decode(response.body);
        _sessions = jsonResponse.map((json) => Session.fromJson(json)).toList();
        notifyListeners();
      } catch (e) {
        print('Error parsing response: $e');
        throw Exception('Error parsing sessions data');
      }
    } else {
      throw Exception(
          'Failed to load sessions. Status code: ${response.statusCode}');
    }
  }
}
