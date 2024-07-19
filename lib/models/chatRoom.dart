import 'package:footballproject/models/message_model.dart';
import 'package:footballproject/models/user.dart';

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
}
