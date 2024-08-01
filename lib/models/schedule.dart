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

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      designation: json['designation'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      group: Group.fromJson(json['group']),
      sessions: (json['sessions'] as List)
          .map((data) => Session.fromJson(data))
          .toList(),
    );
  }
}
