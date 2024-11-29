import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportdivers/Provider/constantsProvider.dart';
import 'dart:convert';

import 'package:sportdivers/models/tournamentModel.dart';

class TournamentProvider extends ChangeNotifier {
  List<Tournament> _tournaments = [];
  bool _isLoading = true;
  String? _error;

  List<Tournament> get tournaments => _tournaments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTournaments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    final url = '${Constants.baseUrl}/tournaments';
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

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> tournamentJson = json.decode(response.body);

        // Convert JSON to Tournament objects
        _tournaments = tournamentJson
            .map((tournament) => Tournament.fromJson(tournament))
            .toList();

        _isLoading = false;
      } else {
        // Handle error
        _error = 'Failed to load tournaments. Status code: ${response.statusCode}';
        _isLoading = false;
      }
    } catch (e) {
      // Handle network or parsing errors
      _error = 'Error fetching tournaments: $e';
      _isLoading = false;
    }

    notifyListeners();
  }
}