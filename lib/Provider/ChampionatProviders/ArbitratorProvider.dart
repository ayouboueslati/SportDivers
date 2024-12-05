import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportdivers/Provider/constantsProvider.dart';

class MatchActionProvider with ChangeNotifier {
  final String matchId;
  bool _isLoading = false;
  String? _errorMessage;

  MatchActionProvider({required this.matchId}) {

  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> addMatchAction({
    required String type,
    required int minute,
    required String targetTeam,
    required String target,
  }) async {
    debugPrint("MatchActionProvider initialized for matchId: $matchId");
    debugPrint("addMatchAction called with type: $type, minute: $minute, targetTeam: $targetTeam, target: $target");

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      debugPrint("Token retrieved: $token");

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/tournaments/matches/$matchId/actions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'type': type,
          'minute': minute,
          'targetTeam': targetTeam,
          'target': target,
        }),
      );

      debugPrint("Response status code: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      _isLoading = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Match action added successfully.");
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to add match action: ${response.body}';
        debugPrint(_errorMessage!);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error adding match action: $e';
      debugPrint(_errorMessage!);
      notifyListeners();
      return false;
    }
  }
}
