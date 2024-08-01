import 'package:footballproject/models/user.dart';
import 'message.dart';

class Chatroom {
  String id;
  DateTime createdAt;
  List<Message> messages;
  List<User> participants;

  Chatroom({
    required this.id,
    required this.createdAt,
    required this.messages,
    required this.participants,
  });

  factory Chatroom.fromJson(Map<String, dynamic> json) {
    return Chatroom(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      messages: (json['messages'] as List)
          .map((data) => Message.fromJson(data))
          .toList(),
      participants: (json['participants'] as List)
          .map((data) => User.fromJson(data))
          .toList(),
    );
  }
}
