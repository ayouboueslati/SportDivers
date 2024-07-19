import 'package:footballproject/models/session.dart';

class Field {
  String id;
  String designation;
  List<Session> sessions;

  Field({
    required this.id,
    required this.designation,
    required this.sessions,
  });
}
