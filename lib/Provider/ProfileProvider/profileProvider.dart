import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constantsProvider.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  Map<String, dynamic>? _userData;

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get userData => _userData;

  Future<void> fetchUserData(String token) async {
    _isLoading = true;
    notifyListeners();

    String url = "${Constants.baseUrl}/auth/check-token";

    print("Fetching user data from: $url");
    print("Using token: $token");

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      print('Response status: ${req.statusCode}');
      print('Response body: ${req.body}');

      if (req.statusCode == 200) {
        _userData = json.decode(req.body);
        print("User data fetched successfully: $_userData");
      } else {
        _userData = null;
        print("Failed to fetch user data. Status code: ${req.statusCode}");
      }
    } on SocketException catch (_) {
      _userData = null;
      print("SocketException: Failed to connect to the server.");
    } catch (e) {
      _userData = null;
      print("Exception: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
