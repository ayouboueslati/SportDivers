import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportdivers/models/tutorial.dart';

class Videoservice {
  final String baseUrl;

  Videoservice({required this.baseUrl});

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Tutorial>> fetchVideos() async {
    try {
      String? authToken = await _getToken();
      if (authToken == null) {
        throw Exception('No auth token found');
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      print('Base URL: $baseUrl');

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        if (body.isEmpty) {
          throw Exception('Empty response body');
        }
        return body.map((dynamic item) => Tutorial.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load videos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching videos: $e');
      throw Exception('Failed to load videos');
    }
  }
}
