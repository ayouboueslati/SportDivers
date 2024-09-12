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
    print("AuthProvider set: ${_authProvider?.token}");
    notifyListeners();
  }

  Future<Map<String, dynamic>?> submitReport({
    required String reason,
    required String comment,
    required String target,
    String? person, // 'person' is optional
  }) async {
    print(
        "Submitting report: reason=$reason, comment=$comment, target=$target, person=$person");

    final url = Uri.parse('${Constants.baseUrl}/tickets');
    final token = _authProvider?.token;

    if (token == null) {
      _errorMessage = 'User not authenticated';
      print(_errorMessage);
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
        if (target != 'ADMIN' && person != null) 'target':person ,
      };

      print("Request body: $requestBody");

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
        print("Response Body: $responseBody");
        _errorMessage = 'Report submitted successfully'; // Success message
        return responseBody; // Return response data
      } else {
        final responseBody = json.decode(response.body);
        print("Error Response: $responseBody");
        _errorMessage = responseBody['message'] ??
            'Failed to submit report'; // Error message
        return null;
      }
    } catch (error) {
      _errorMessage =
          'Error occurred while submitting report: $error'; // Exception message
      print(_errorMessage);
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserList(String userType) async {
    print("Fetching user list for: $userType");

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    String apiUrl;

    if (userType == 'Student') {
      apiUrl = '${Constants.baseUrl}/users/students';
    } else if (userType == 'Coach') {
      apiUrl = '${Constants.baseUrl}/users/teachers';
    } else {
      print("Invalid userType: $userType");
      _isLoading = false;
      notifyListeners();
      return;
    }

    final token = _authProvider?.token;

    if (token == null) {
      _errorMessage = 'User not authenticated';
      print(_errorMessage);
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      print("Fetching from API: $apiUrl");

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print("Fetched user data: $data");

        _userList = data.map((user) {
          return {
           'id': user['id'],
            'name':
                '${user['profile']['firstName']} ${user['profile']['lastName']}',
            'profilePicture': user['profile']['profilePicture'] ?? '',
          };
        }).toList();

        print("Mapped UserList: $_userList");
      } else {
        final responseBody = json.decode(response.body);
        print("Error Response: $responseBody");
        _errorMessage = responseBody['message'] ?? 'Failed to load users';
      }
    } catch (e) {
      _errorMessage = 'Error occurred while fetching users: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTickets() async {
    print("Fetching tickets");

    final url = Uri.parse('${Constants.baseUrl}/tickets');
    final token = _authProvider?.token;

    if (token == null) {
      _errorMessage = 'User not authenticated';
      print(_errorMessage);
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      print("Fetching from API: $url");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        _tickets = json.decode(response.body);
        print("Fetched tickets: $_tickets");
      } else {
        final responseBody = json.decode(response.body);
        print("Error Response: $responseBody");
        _errorMessage = responseBody['message'] ?? 'Failed to fetch tickets';
      }
    } catch (e) {
      _errorMessage = 'Error occurred while fetching tickets: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
