import 'package:footballproject/models/group.dart';
import 'package:footballproject/models/user.dart';

class Attendance {
  String id;
  DateTime date;
  Group group;
  int groupPk;
  User user;
  int userPk;

  Attendance({
    required this.id,
    required this.date,
    required this.group,
    required this.groupPk,
    required this.user,
    required this.userPk,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      date: DateTime.parse(json['date']),
      group: Group.fromJson(json['group']),
      groupPk: json['groupPk'],
      user: User.fromJson(json['user']),
      userPk: json['userPk'],
    );
  }
}
