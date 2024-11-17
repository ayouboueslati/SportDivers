import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportdivers/Provider/constantsProvider.dart';
import 'dart:convert';
import 'package:sportdivers/models/tournamentModel.dart';

class MatchListProvider extends ChangeNotifier {
  List<MatchPhase> _phases = [];
  bool _isLoading = false;
  String? _error;

  List<MatchPhase> get phases => _phases;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMatches(String tournamentId) async {

      _isLoading = true;
      notifyListeners();
      final url = '${Constants.baseUrl}//tournaments/matches/$tournamentId';
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
        final data = jsonDecode(response.body) as List<dynamic>;
        final matches = data.map((item) => Match.fromJson(item)).toList();

        // Group matches by date
        Map<DateTime, List<Match>> groupedMatches = {};
        for (var match in matches) {
          final date = DateTime(match.date.year, match.date.month, match.date.day);
          if (!groupedMatches.containsKey(date)) {
            groupedMatches[date] = [];
          }
          groupedMatches[date]?.add(match);
        }

        // Create MatchPhase objects
        _phases = groupedMatches.entries.map((entry) {
          return MatchPhase(
            date: entry.key,
            matches: entry.value,
          );
        }).toList();

        _error = null;
      } else {
        _error = 'Failed to fetch matches: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class MatchPhase {
  final DateTime date;
  final List<Match> matches;

  MatchPhase({
    required this.date,
    required this.matches,
  });
}