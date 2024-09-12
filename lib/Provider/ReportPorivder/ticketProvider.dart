import 'package:flutter/material.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constantsProvider.dart';

class TicketsProvider extends ChangeNotifier {
  List<dynamic> _tickets = [];
  List<Map<String, dynamic>> _userList = [];

  bool _isLoading = false;
  String _errorMessage = '';
  String? _selectedTarget;
  String? _selectedPerson;

  List<dynamic> get tickets => _tickets;

  List<Map<String, dynamic>> get userList => _userList;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  String? get selectedTarget => _selectedTarget;

  String? get selectedPerson => _selectedPerson;

  AuthenticationProvider? _authProvider;

  TicketsProvider(this._authProvider);

  set authProvider(AuthenticationProvider authProvider) {
    _authProvider = authProvider;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> submitReport({
    required String reason,
    required String comment,
    required String target,
    String? person, // 'person' is optional
  }) async {
    final url = Uri.parse('${Constants.baseUrl}/tickets');
    final token = _authProvider?.token;

    if (token == null) {
      _errorMessage = 'User not authenticated';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _errorMessage = ''; // Clear any previous error message
    notifyListeners();

    try {
      // Construct request body
      final Map<String, dynamic> requestBody = {
        'reason': reason,
        'comment': comment,
        'target': target,

        if (target != 'ADMIN' && person != null) 'person': person,
      };

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        print(responseBody);
        _errorMessage = 'Report submitted successfully'; // Success message
        return responseBody; // Return response data
      } else {
        final responseBody = json.decode(response.body);
        print(responseBody);
        _errorMessage = responseBody['message'] ??
            'Failed to submit report'; // Error message
        return null;
      }
    } catch (error) {
      _errorMessage =
          'Error occurred while submitting report: $error'; // Exception message
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserList(String userType) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    String apiUrl;

    if (userType == 'Student') {
      apiUrl = '${Constants.baseUrl}/users/students';
    } else if (userType == 'Coach') {
      apiUrl = '${Constants.baseUrl}/users/teachers';
    } else {
      _isLoading = false;
      notifyListeners();
      return;
    }

    final token = _authProvider?.token;

    if (token == null) {
      _errorMessage = 'User not authenticated';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _userList = data.map((user) {
          return {
            'name': '${user['profile']['firstName']} ${user['profile']['lastName']}',
            'profilePicture': user['profile']['profilePicture'] ?? '',
          };
        }).toList();
      } else {
        final responseBody = json.decode(response.body);
        _errorMessage = responseBody['message'] ?? 'Failed to load users';
      }
    } catch (e) {
      _errorMessage = 'Error occurred while fetching users: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTickets() async {
    final url = Uri.parse('${Constants.baseUrl}/tickets');
    final token = _authProvider?.token;

    if (token == null) {
      _errorMessage = 'User not authenticated';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _tickets = json.decode(response.body);
      } else {
        final responseBody = json.decode(response.body);
        _errorMessage = responseBody['message'] ?? 'Failed to fetch tickets';
      }
    } catch (e) {
      _errorMessage = 'Error occurred while fetching tickets: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
