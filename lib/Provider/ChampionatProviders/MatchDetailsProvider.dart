import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportdivers/Provider/constantsProvider.dart';
import 'dart:convert';
import 'package:sportdivers/models/MatchDetailsModel.dart';

class MatchDetailsProvider extends ChangeNotifier {
  Match? _match;
  bool _isLoading = false;
  String? _error;

  Match? get match => _match;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMatchDetails(String matchId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/tournaments/matches/$matchId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _match = Match.fromJson(responseData);
        _isLoading = false;
        notifyListeners();
      } else {
        _error = 'Failed to load match details. Status code: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = 'An error occurred: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
}