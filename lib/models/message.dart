import 'package:footballproject/models/user.dart';

class Message {
  String id;
  String content;
  DateTime createdAt;
  DateTime? updatedAt;
  bool? isRemoved;
  User sender;
  User recipient;

  Message({
    required this.id,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.isRemoved,
    required this.sender,
    required this.recipient,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isRemoved: json['isRemoved'],
      sender: User.fromJson(json['sender']),
      recipient: User.fromJson(json['recipient']),
    );
  }
}
