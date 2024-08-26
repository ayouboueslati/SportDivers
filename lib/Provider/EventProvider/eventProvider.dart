import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:footballproject/models/Event.dart';
import 'package:http/http.dart' as http;

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners(); // Notify listeners about the loading state change

    final url = 'https://sports.becker-brand.store/api/events';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        print(response.statusCode);
        print('Response data: ${response.body}');

        if (responseData.containsKey('data') &&
            responseData['data'].containsKey('data')) {
          final List<dynamic> eventList = responseData['data']['data'];
          _events = eventList.map((data) => Event.fromJson(data)).toList();
          notifyListeners();
        } else {
          throw Exception(
              'Expected key "data" or nested "data" not found in the response');
        }
      } else {
        throw Exception('Failed to load events');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
