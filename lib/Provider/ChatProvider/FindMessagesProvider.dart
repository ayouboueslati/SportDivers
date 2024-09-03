import 'package:flutter/material.dart';
import 'package:footballproject/Provider/constantsProvider.dart';
import 'package:footballproject/models/ChatModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MessagesProvider with ChangeNotifier {
  List<Message> _messages = [];
  List<Message> get messages => _messages;

  void addMessage(Message message) {
    _messages.add(message);
    print('Added new message: ${message.text}');
    notifyListeners();
  }

  Future<void> fetchPrivateMessages(String chatRoomId) async {
    final url = '${Constants.baseUrl}/chats/rooms/$chatRoomId/messages';
    print('Fetching private messages for chatRoomId: $chatRoomId');

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

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _messages = data.map((json) {
          try {
            return Message.fromJson(json);
          } catch (e) {
            print('Error parsing message: $e');
            return null;
          }
        }).whereType<Message>().toList();

        print('Messages list updated: $_messages');
        notifyListeners();
      } else if (response.statusCode == 404) {
        print('Chat room or messages not found for chatRoomId: $chatRoomId');
        _messages = [];
        notifyListeners();
      } else {
        print('Failed to load messages with status code: ${response.statusCode}');
        throw Exception('Failed to load messages: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Error fetching messages for chatRoomId $chatRoomId: $error');
      throw error;
    }
  }

  Future<void> fetchGroupMessages(String groupChatId) async {
    final url = '${Constants.baseUrl}/chats/group-rooms/$groupChatId/messages';
    print('Fetching group messages for groupChatId: $groupChatId');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }
      print('Requesting messages for groupChatId: $groupChatId');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Using token: $token');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        print('Decoded data: $data');

        _messages = data.map((json) {
          try {
            print('Parsing message: $json');
            return Message.fromJson(json);
          } catch (e) {
            print('Error parsing message: $e');
            return null;
          }
        }).whereType<Message>().toList();

        print('Messages list updated: $_messages');
        notifyListeners();
      } else if (response.statusCode == 404) {
        print('Group chat or messages not found for groupChatId: $groupChatId');
        print('Please verify that the group chat exists and you have permission to access it.');
        _messages = []; // Set to empty list
        notifyListeners();
      } else {
        print('Failed to load messages with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load messages: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Error fetching messages for groupChatId $groupChatId: $error');
      print('Request URL: $url');
      throw error;
    }
  }
}