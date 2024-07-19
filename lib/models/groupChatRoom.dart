import 'package:footballproject/models/group.dart';
import 'package:footballproject/models/message_model.dart';
import 'package:footballproject/models/user.dart';

class Groupchatroom {
  String id;
  DateTime createdAt;
  Group group;
  List<Message> messages;
  List<User> participants;

  Groupchatroom({
    required this.id,
    required this.createdAt,
    required this.group,
    required this.messages,
    required this.participants,
  });
}
