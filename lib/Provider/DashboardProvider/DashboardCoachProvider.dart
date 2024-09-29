import 'package:flutter/foundation.dart';
import 'package:sportdivers/Provider/constantsProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sportdivers/models/DashboardCoachModel.dart';

class DashboardCoachProvider with ChangeNotifier {
  DashboardStats? _stats;
  bool _isLoading = false;
  String _error = '';

  DashboardStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchDashboardStats({String? startDate, String? endDate})  async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    var url = '${Constants.baseUrl}/stats';

    // Add query parameters if dates are provided
    if (startDate != null && endDate != null) {
      url += '?startDate=$startDate&endDate=$endDate';
    }
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

      print('HTTP response status: ${response.statusCode}');
      print('HTTP response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _stats = DashboardStats.fromJson(jsonData);
        _error = ''; // Clear any previous errors
      } else {
        _error = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      print('Exception caught: $e');
      _error = 'Network error: $e';
      _stats = null; // Ensure stats is null if there's an error
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    print('Loading state: $_isLoading');
    print('Error state: $_error');
    print('Stats: $_stats');
  }
}