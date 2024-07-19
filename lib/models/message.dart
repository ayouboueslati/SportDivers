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
    required this.updatedAt,
    required this.isRemoved,
    required this.sender,
    required this.recipient,
  });
}
