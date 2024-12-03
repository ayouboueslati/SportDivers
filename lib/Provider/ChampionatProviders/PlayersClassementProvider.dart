import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportdivers/Provider/constantsProvider.dart';
import 'package:sportdivers/models/PlayersClassementModel.dart';



class PlayerRankingProvider with ChangeNotifier {

  List<PlayerRanking> _topScorers = [];
  List<PlayerRanking> _redCards = [];
  List<PlayerRanking> _yellowCards = [];

  List<PlayerRanking> get topScorers => _topScorers;
  List<PlayerRanking> get redCards => _redCards;
  List<PlayerRanking> get yellowCards => _yellowCards;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<List<PlayerRanking>> _fetchRankings(String endpoint) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((item) => PlayerRanking.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load rankings');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<void> fetchPlayerRankings(String tournamentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _topScorers = await _fetchRankings('${Constants.baseUrl}/tournaments/$tournamentId/players-ranking');
      _redCards = await _fetchRankings('${Constants.baseUrl}/tournaments/$tournamentId/players-red-cards');
      _yellowCards = await _fetchRankings('${Constants.baseUrl}/tournaments/$tournamentId/players-yellow-cards');
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}