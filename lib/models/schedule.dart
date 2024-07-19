import 'package:footballproject/models/group.dart';
import 'package:footballproject/models/session.dart';

class Schedule {
  String id;
  String designation;
  String? description;
  DateTime startDate;
  DateTime endDate;
  Group group;
  List<Session> sessions;

  Schedule({
    required this.id,
    required this.designation,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.group,
    required this.sessions,
  });
}
