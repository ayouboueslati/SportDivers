import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sportdivers/Provider/constantsProvider.dart';
import 'package:sportdivers/models/ChatModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoomsProvider with ChangeNotifier {
  List<ChatRoom> _chatRooms = [];
  List<GroupChatRoom> _groupChatRooms = [];
  bool _isLoading = false;


  List<ChatRoom> get chatRooms => _chatRooms;
  List<GroupChatRoom> get groupChatRooms => _groupChatRooms;
  bool get isLoading => _isLoading;


  Future<void> fetchChatRooms() async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('${Constants.baseUrl}/chats/rooms');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        _chatRooms = (data['chatRooms'] as List<dynamic>?)
            ?.map((item) => ChatRoom.fromJson(item as Map<String, dynamic>))
            .toList() ?? [];

        _groupChatRooms = (data['groupChatRooms'] as List<dynamic>?)
            ?.map((item) => GroupChatRoom.fromJson(item as Map<String, dynamic>))
            .toList() ?? [];

        print('Parsed ${_chatRooms.length} chat rooms');
        print('Parsed ${_groupChatRooms.length} group chat rooms');

        // Debug: Print last message of each group chat room
        _groupChatRooms.forEach((room) {
          print('Group ${room.group.designation} last message: ${room.lastMessage?.text}');
        });
      } else {
        throw Exception('Failed to load chat rooms');
      }
    } catch (error) {
      print('Error fetching chat rooms: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<ChatRoom> _parseChatRooms(dynamic data) {
    if (data == null) {
      return [];
    }
    return (data as List<dynamic>)
        .map((item) => ChatRoom.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  List<GroupChatRoom> _parseGroupChatRooms(dynamic data) {
    if (data == null) {
      return [];
    }
    return (data as List<dynamic>)
        .map((item) => GroupChatRoom.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> markMessagesAsSeen(String roomId, bool isGroup) async {
    final url = Uri.parse('${Constants.baseUrl}/chats/mark-seen');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'roomId': roomId,
          'isGroup': isGroup,
        }),
      );

      if (response.statusCode == 200) {
        // Update the local state
        if (isGroup) {
          int index = _groupChatRooms.indexWhere((room) => room.id == roomId);
          if (index != -1) {
            _groupChatRooms[index] = GroupChatRoom(
              id: _groupChatRooms[index].id,
              group: _groupChatRooms[index].group,
              lastMessage: _groupChatRooms[index].lastMessage,
              unseenMsgs: 0,
            );
          }
        } else {
          int index = _chatRooms.indexWhere((room) => room.id == roomId);
          if (index != -1) {
            _chatRooms[index] = ChatRoom(
              id: _chatRooms[index].id,
              firstUser: _chatRooms[index].firstUser,
              secondUser: _chatRooms[index].secondUser,
              lastMessage: _chatRooms[index].lastMessage,
              unseenMsgs: 0,
            );
          }
        }
        notifyListeners();
      } else {
        throw Exception('Failed to mark messages as seen');
      }
    } catch (error) {
      print('Error marking messages as seen: $error');
    }
  }
}
