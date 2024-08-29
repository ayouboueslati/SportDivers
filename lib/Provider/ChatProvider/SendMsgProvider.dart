import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import '../constantsProvider.dart';

class ChatProvider with ChangeNotifier {
  Future<Map<String, dynamic>> sendMessage({
    required String text,
    required String type,
    required String targetType,
    required String target,
    String? chatRoom,
    File? file,
  }) async {
    String? chatRoomId;
    try {
      chatRoomId = await getChatRoomId(targetType, target);
    } catch (e) {
      throw Exception('Failed to get chat room: $e');
    }

    var url = Uri.parse('${Constants.baseUrl}/chats');
    debugPrint('Sending request to URL: $url');
    var request = http.MultipartRequest('POST', url);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token not found');
      throw Exception('Token not found');
    }
    // Add authorization header
    request.headers['Authorization'] = 'Bearer $token';
    if (chatRoomId != null) {
      request.fields['chatRoom'] = chatRoomId;
    }
    // Add form fields
    request.fields['text'] = text;
    request.fields['type'] = type;
    request.fields['targetType'] = targetType;
    request.fields['target'] = target;

    debugPrint('Added Authorization header: Bearer $token');

    debugPrint(
        'Request fields: text=$text, type=$type, targetType=$targetType, target=$target');

    if (chatRoom != null) {
      request.fields['chatRoom'] = chatRoom;
      debugPrint('Added chatRoom field: $chatRoom');
    }

    // Add file if present
    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      debugPrint('Added file: ${file.path}');
    }

    try {
      debugPrint('Sending request...');
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('Received response with status code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var result = json.decode(response.body);
        debugPrint('Response body: ${response.body}');
        notifyListeners(); // Notify listeners of the new message
        return result;
      } else {
        debugPrint(
            'Failed to send message. Status code: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        throw Exception(
            'Failed to send message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
      throw Exception('Error sending message: $e');
    }
  }

  Future<String?> getChatRoomId(String targetType, String target) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found');
    }

    var url = Uri.parse('${Constants.baseUrl}/chats/rooms');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);

      if (targetType.toUpperCase() == 'GROUP') {
        // Search in groupChatRooms
        for (var room in responseData['groupChatRooms']) {
          if (room['group']['id'] == target) {
            return room['id'];
          }
        }
      } else {
        // Search in chatRooms (assuming these are for one-on-one chats)
        for (var room in responseData['chatRooms']) {
          if (room['firstUser']['id'] == target ||
              room['secondUser']['id'] == target) {
            return room['id'];
          }
        }
      }
      // If we reach here, no matching room was found
      return null;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception(
          'Failed to fetch chat rooms. Status code: ${response.statusCode}');
    }
  }
}
