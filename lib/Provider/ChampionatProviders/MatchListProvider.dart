import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportdivers/Provider/constantsProvider.dart';
import 'package:sportdivers/models/tournamentModel.dart';
import 'dart:convert';


class MatchListProvider extends ChangeNotifier {
  List<MatchPhase> _phases = [];
  bool _isLoading = false;
  String? _error;

  List<MatchPhase> get phases => _phases;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMatches(String tournamentId) async {

      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = '${Constants.baseUrl}/tournaments/$tournamentId/phases';
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
        final List<dynamic> data = json.decode(response.body);
        _phases = data.map((phase) => MatchPhase.fromJson(phase)).toList();
        _phases.sort((a, b) => a.date.compareTo(b.date));
      } else {
        _error = 'Failed to load matches';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}