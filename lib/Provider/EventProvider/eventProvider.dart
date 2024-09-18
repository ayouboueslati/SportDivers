// lib/providers/event_provider.dart
import 'package:flutter/foundation.dart';
import 'package:footballproject/models/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;
  String _error = '';

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchEvents() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://sportdivers.tn/api/events'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          final eventsList = jsonData['data']['data'] as List;
          _events = eventsList.map((eventJson) => Event.fromJson(eventJson)).toList();
        } else {
          _error = 'Failed to load events';
        }
      } else {
        _error = 'Server error';
      }
    } catch (e) {
      _error = 'Network error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}