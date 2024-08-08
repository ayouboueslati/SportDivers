import 'package:flutter/material.dart';
import 'package:footballproject/Provider/constantsProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/tutorial.dart';

class VideoProvider with ChangeNotifier {
  List<Tutorial> _videos = [];
  List<Tutorial> get videos => _videos;

  Future<void> fetchVideos() async {
    const String url =
        "${Constants.baseUrl}/tutorials"; // Replace with your actual base URL
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(response.body);
        print('Decoded response: $decodedResponse');

        if (decodedResponse is List) {
          _videos =
              decodedResponse.map((data) => Tutorial.fromJson(data)).toList();
          print('Mapped videos: $_videos');
          notifyListeners();
        } else {
          throw Exception('Unexpected response format. Expected a list.');
        }
      } else {
        throw Exception(
            'Failed to load videos. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching and initializing videos: $e');
      throw Exception("Error fetching videos: $e");
    }
  }
}
