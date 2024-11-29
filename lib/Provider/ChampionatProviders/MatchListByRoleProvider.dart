import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportdivers/Provider/constantsProvider.dart';
import 'package:sportdivers/models/MatchListByRoleModel.dart';
import 'dart:convert';

class MatchListProviderByRole extends ChangeNotifier {
  List<MatchByRole> _matches = [];
  bool _isLoading = false;
  String? _error;

  List<MatchByRole> get matches => _matches;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMatchesByRole(String tournamentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final url = '${Constants.baseUrl}/tournaments/matches?tournamentId=$tournamentId';
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
        _matches = data.map((match) => MatchByRole.fromJson(match)).toList();
        _matches.sort((a, b) => a.date.compareTo(b.date));
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