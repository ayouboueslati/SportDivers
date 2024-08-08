import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:footballproject/models/ticket.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../constantsProvider.dart';

class TicketProvider with ChangeNotifier {
  final String _baseUrl = '${Constants.baseUrl}/tickets';
  List<Ticket> _tickets = [];
  List<String> _userIds = []; // To store user IDs

  List<Ticket> get tickets => _tickets;
  List<String> get userIds => _userIds;

  Future<void> fetchTickets(BuildContext context) async {
    try {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final token = authProvider.token;

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _tickets = data.map((item) => Ticket.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load tickets');
      }
    } catch (error) {
      throw Exception('Failed to load tickets: $error');
    }
  }

  Future<void> fetchUserIds(BuildContext context) async {
    try {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final token = authProvider.token;
      final url =
          '${Constants.baseUrl}/users'; // Replace with your actual endpoint

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _userIds = data
            .map((item) => item['id'].toString())
            .toList(); // Adjust according to your response structure
        notifyListeners();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      throw Exception('Failed to load users: $error');
    }
  }

  Future<void> createTicket(
    BuildContext context,
    String reason,
    String comment,
    String target,
  ) async {
    try {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final token = authProvider.token;
      final url = Uri.parse(_baseUrl);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'reason': reason,
          'comment': comment,
          'target': target,
        }),
      );

      if (response.statusCode == 201) {
        final newTicket = Ticket.fromJson(json.decode(response.body));
        _tickets.add(newTicket);
        notifyListeners();
      } else {
        throw Exception('Failed to create ticket: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to create ticket: $error');
    }
  }
}
