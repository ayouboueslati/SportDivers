import 'package:flutter/foundation.dart';
import 'package:footballproject/Provider/constantsProvider.dart';
import 'package:footballproject/models/payment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PaymentProvider with ChangeNotifier {
  List<Payment> _payments = [];
  bool _isLoading = false;
  String _error = '';

  List<Payment> get payments => _payments;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchPayments() async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    final url = '${Constants.baseUrl}/payments';

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
        final List<dynamic> paymentJson = json.decode(response.body);
        _payments = paymentJson.map((json) => Payment.fromJson(json)).toList();
      } else {
        _error = 'Failed to load payments';
      }
    } catch (e) {
      _error = 'An error occurred: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> makePayment(String paymentId) async {
    try {
      // Simulating API call
      await Future.delayed(Duration(seconds: 2));
      final paymentIndex = _payments.indexWhere((payment) => payment.id == paymentId);
      if (paymentIndex != -1) {
        _payments[paymentIndex].paid = true;
        _payments[paymentIndex].paidAt = DateTime.now();
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to make payment: $e';
      notifyListeners();
    }
  }
}