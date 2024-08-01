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

  factory TeacherHourCost.fromJson(Map<String, dynamic> json) {
    return TeacherHourCost(
      id: json['id'],
      cost: json['cost'],
      teacher: TeacherProfile.fromJson(json['teacher']),
      teacherPk: json['teacherPk'],
    );
  }
}
