import 'package:flutter/material.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constantsProvider.dart';

class TicketsProvider extends ChangeNotifier {
  List<dynamic> _tickets = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<dynamic> get tickets => _tickets;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  AuthenticationProvider? _authProvider;

  TicketsProvider(this._authProvider);

  set authProvider(AuthenticationProvider authProvider) {
    _authProvider = authProvider;
    notifyListeners();
  }

  Future<void> fetchTickets() async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = 'User not authenticated';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/tickets'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_authProvider!.token}',
        },
      );

      if (response.statusCode == 200) {
        _tickets = jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);
        _errorMessage = responseBody['message'] ?? 'Failed to fetch tickets';
      }
    } catch (e) {
      _errorMessage = 'Error occurred while fetching tickets: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}


  // bool _isLoading = false;
  // String _resMessage = '';
  // List<dynamic> _coaches = [];
  // List<dynamic> _teammates = [];

  // bool get isLoading => _isLoading;
  // String get resMessage => _resMessage;
  // List<dynamic> get coaches => _coaches;
  // List<dynamic> get teammates => _teammates;

  // Future<void> fetchCoaches({required BuildContext context}) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     final token =
  //         Provider.of<AuthenticationProvider>(context, listen: false).token;
  //     final response = await http.get(
  //       Uri.parse('${Constants.baseUrl}/users/teachers'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );

  //     print('Raw response body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(response.body);

  //       // Clear previous coaches list before adding new ones
  //       _coaches.clear();

  //       // Map and check for null values
  //       _coaches = data
  //           .map((item) {
  //             // Add debug print to check each item
  //             print('Parsing item: $item');
  //             try {
  //               return TeacherProfile.fromJson(item as Map<String, dynamic>);
  //             } catch (e) {
  //               print('Error parsing item: $e');
  //               return null; // or handle error
  //             }
  //           })
  //           .where((item) => item != null)
  //           .toList();

  //       print('Parsed coaches: $_coaches');
  //     } else {
  //       final responseBody = jsonDecode(response.body);
  //       _resMessage = 'Failed to fetch coaches: ${responseBody['message']}';
  //     }
  //   } catch (e) {
  //     _resMessage = 'Error occurred while fetching coaches';
  //     print('Error fetching coaches: $e');
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  // }

  // Future<void> fetchTeammates({required BuildContext context}) async {
  //   print('**************');

  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     final token =
  //         Provider.of<AuthenticationProvider>(context, listen: false).token;
  //     final response = await http.get(
  //       Uri.parse('${Constants.baseUrl}/users/students'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //     print('Raw response body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(response.body);
  //       print('Fetched teammates data: $data');

  //       // Adjust parsing according to your model if necessary
  //       _teammates = data.map((item) {
  //         // Perform similar checks as in fetchCoaches if using complex models
  //         return item; // Replace with actual parsing if applicable
  //       }).toList();

  //       print('Parsed teammates: $_teammates');
  //     } else {
  //       final responseBody = jsonDecode(response.body);
  //       _resMessage = 'Failed to fetch teammates: ${responseBody['message']}';
  //       print('Failed to fetch teammates: $_resMessage');
  //     }
  //   } catch (e) {
  //     _resMessage = 'Error occurred while fetching teammates';
  //     print('Error fetching teammates: $e');
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  // }

  // Future<void> submitReport({
  //   required String reason,
  //   required String comment,
  //   required String targetType,
  //   required String targetId,
  //   required BuildContext context,
  // }) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     final token = Provider.of<AuthenticationProvider>(context, listen: false)
  //         .token; // Get token from AuthenticationProvider
  //     final response = await http.post(
  //       Uri.parse('${Constants.baseUrl}/tickets'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({
  //         'reason': reason,
  //         'comment': comment,
  //         'targetType': targetType,
  //         'targetId': targetId,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       _resMessage = 'Report submitted successfully';
  //     } else {
  //       final responseBody = jsonDecode(response.body);
  //       _resMessage = 'Failed to submit report: ${responseBody['message']}';
  //     }
  //   } catch (e) {
  //     _resMessage = 'Error occurred while submitting report';
  //     print('Error submitting report: $e');
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  // }

