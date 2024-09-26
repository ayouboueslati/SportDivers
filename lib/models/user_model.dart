import 'package:sportdivers/models/ChatModel.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String? picture;
  final String type;
  final String? groupId;
  final Message? lastMessage;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.picture,
    required this.type,
    this.groupId,
    this.lastMessage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      picture: json['picture'] as String?,
      type: json['type'] as String? ?? '',
      groupId: json['groupId'] as String?,
      lastMessage: json['lastMessage'] != null ? Message.fromJson(json['lastMessage'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'picture': picture,
      'type': type,
      'groupId': groupId,
      'lastMessage': lastMessage?.toJson(),
    };
  }
}
