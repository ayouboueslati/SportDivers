import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sportdivers/Provider/AuthProvider/auth_provider.dart';
import 'package:sportdivers/Provider/constantsProvider.dart';
import 'package:sportdivers/models/session.dart';
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

        print('Number of sessions fetched: ${_sessions.length}');

      } catch (e) {
        print('Error parsing response: $e');
        throw Exception('Error parsing sessions data');
      }
    } else {
      throw Exception(
          'Failed to load sessions. Status code: ${response.statusCode}');
    }
  }

  Future<void> submitRating({
    required double rating,
    required String comment,
    required String sessionId,
    required DateTime sessionDate,
    required BuildContext context,
  }) async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final token = authProvider.token;

    if (token != null) {
      const url = '${Constants.baseUrl}/ratings';

      // Print URL and token for debugging
      print('Submitting rating to URL: $url');
      print('Authorization Token: $token');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'value': rating,
          'text': comment,
          'date':
              sessionDate.toIso8601String(), // Correctly use the session date
          'targetType': 'COACH',
          'session': sessionId,
        }),
      );

      // Print request details
      print('Request URL: ${response.request?.url}');
      print('Request Headers: ${response.request?.headers}');
      print('Request Body: ${response.request}');

      // Print response details
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        print('Rating submitted successfully');
      } else {
        _handleSubmitError(context, response); // Call your error handler
        print('Failed to submit rating');
      }
    } else {
      print('Token is null');
      throw Exception('Token is null');
    }
  }

  void _handleSubmitError(BuildContext context, http.Response response) {
    print('Failed to submit rating. Status code: ${response.statusCode}');
    String errorMessage = 'Failed to submit rating.';

    switch (response.statusCode) {
      case 400:
        errorMessage = 'Invalid rating data. Please check your input.';
        break;
      case 401:
        errorMessage = 'Unauthorized. Please log in again.';
        break;
      case 500:
        errorMessage = 'Server error. Please try again later.';
        break;
      default:
        errorMessage = 'An unknown error occurred. Please try again.';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}
