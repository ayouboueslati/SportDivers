import 'package:footballproject/models/teacherProfile.dart';

class TeacherHourCost {
  String id;
  double cost;
  TeacherProfile teacher;
  int teacherPk;

  TeacherHourCost({
    required this.id,
    required this.cost,
    required this.teacher,
    required this.teacherPk,
  });
}
