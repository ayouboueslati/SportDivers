import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportdivers/Provider/constantsProvider.dart';
import 'package:sportdivers/models/TeamClassementModel.dart';
import 'dart:convert';


class TournamentRankingProvider with ChangeNotifier {
  List<TeamRanking> _rankings = [];
  bool _isLoading = false;
  String? _error;

  List<TeamRanking> get rankings => _rankings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTournamentRankings(String tournamentId) async {
    _isLoading = true;
    _error = null;
    _rankings.clear();
    notifyListeners();

    final url ='${Constants.baseUrl}/tournaments/$tournamentId/ranking';
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
        final List<dynamic> jsonResponse = json.decode(response.body);
        // Convert JSON to TeamRanking objects
        _rankings = jsonResponse
            .map((rankingJson) => TeamRanking.fromJson(rankingJson))
            .toList();
        // Sort rankings by points in descending order
        _rankings.sort((a, b) => b.points.compareTo(a.points));
      } else {
        // Handle error response
        _error = 'Failed to load rankings. Status code: ${response.statusCode}';
      }
    } catch (e) {
      // Handle any exceptions
      _error = 'An error occurred while fetching rankings: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}