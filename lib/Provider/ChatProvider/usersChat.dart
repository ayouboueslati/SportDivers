import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:footballproject/models/ChatModel.dart';
import 'package:footballproject/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constantsProvider.dart';

class usersChatProvider with ChangeNotifier {
  List<User> _users = [];
  List<Group> _groups = [];
  List<ChatRoom> _chatRooms = [];
  List<GroupChatRoom> _groupChatRooms = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<User> get users => _users;

  List<Group> get groups => _groups;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  void updateUsers(List<User> users) {
    _users = users;
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/chats/contacts'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        List<User> allUsers = [];
        List<Group> allGroups = [];
        List<ChatRoom> allChatRooms = [];
        List<GroupChatRoom> allGroupChatRooms = [];

        // Parse students
        data['students'].forEach((id, studentData) {
          allUsers.add(User.fromJson({
            ...studentData,
            'type': 'student',
          }));
        });

        // Parse teachers
        data['teachers'].forEach((id, teacherData) {
          allUsers.add(User.fromJson({
            ...teacherData,
            'type': 'teacher',
          }));
        });

        // Parse groups
        data['groups'].forEach((id, groupData) {
          allGroups.add(Group.fromJson({
            ...groupData,
            'id': id,
          }));
        });

        // Parse chat rooms
        if (data['chatRooms'] != null) {
          data['chatRooms'].forEach((roomData) {
            allChatRooms.add(ChatRoom.fromJson(roomData));
          });
          print('Parsed ${allChatRooms.length} chat rooms'); // Debugging
        } else {
          print('No chatRooms data in API response'); // Debugging
        }

        // Parse group chat rooms
        if (data['groupChatRooms'] != null) {
          data['groupChatRooms'].forEach((roomData) {
            allGroupChatRooms.add(GroupChatRoom.fromJson(roomData));
          });
        }

        _users = allUsers;
        _groups = allGroups;
        _chatRooms = allChatRooms;
        _groupChatRooms = allGroupChatRooms;

        print('Total users: ${_users.length}'); // Debugging
        print('Total chat rooms: ${_chatRooms.length}'); // Debugging

        _errorMessage = '';
      } else {
        _errorMessage = 'Failed to load users: ${response.statusCode}';
        print(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Error fetching users: ${e.toString()}';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  User? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  ChatRoom? getChatRoomForUser(User user) {
    try {
      ChatRoom? room = _chatRooms.firstWhere((room) =>
          room.firstUser.id == user.id || room.secondUser.id == user.id);
      print('Found chat room for user ${user.id}: ${room.id}'); // Debugging
      return room;
    } catch (e) {
      print('No chat room found for user ${user.id}'); // Debugging
      return null;
    }
  }

  GroupChatRoom? getGroupChatRoomForGroup(Group group) {
    try {
      return _groupChatRooms.firstWhere((room) => room.group.id == group.id);
    } catch (e) {
      return null;
    }
  }

  void debugPrintUsers() {
    print('Total users in provider: ${_users.length}');
    for (var user in _users) {
      print(
          'User ID: ${user.id}, Name: ${user.firstName} ${user.lastName}, Picture: ${user.picture}');
    }
  }
}
