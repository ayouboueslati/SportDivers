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
      } else {
        _userData = null;
      }
    } on SocketException catch (_) {
      _userData = null;
    } catch (e) {
      _userData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
