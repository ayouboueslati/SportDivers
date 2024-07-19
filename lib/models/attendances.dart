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
}
