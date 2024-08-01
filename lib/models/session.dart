import 'package:footballproject/models/attendances.dart';
import 'package:footballproject/models/teacherPayment.dart';
import 'package:footballproject/models/teacherProfile.dart';
import 'package:footballproject/models/field.dart';
import 'package:footballproject/models/schedule.dart';
import 'package:footballproject/models/weekday.dart';

class Session {
  String id;
  String? designation;
  Weekday weekday;
  String startTime;
  String endTime;
  Schedule schedule;
  TeacherProfile teacher;
  Field? field;
  List<Attendance> attendances;
  List<TeacherpaymentMethod> teacherPayments;

  Session({
    required this.id,
    this.designation,
    required this.weekday,
    required this.startTime,
    required this.endTime,
    required this.schedule,
    required this.teacher,
    this.field,
    required this.attendances,
    required this.teacherPayments,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      designation: json['designation'],
      weekday: Weekday.values
          .firstWhere((e) => e.toString() == 'Weekday.${json['weekday']}'),
      startTime: json['startTime'],
      endTime: json['endTime'],
      schedule: Schedule.fromJson(json['schedule']),
      teacher: TeacherProfile.fromJson(json['teacher']),
      field: json['field'] != null ? Field.fromJson(json['field']) : null,
      attendances: (json['attendances'] as List)
          .map((data) => Attendance.fromJson(data))
          .toList(),
      teacherPayments: (json['teacherPayments'] as List)
          .map((data) => TeacherpaymentMethod.values.firstWhere(
              (e) => e.toString() == 'TeacherpaymentMethod.${data}'))
          .toList(),
    );
  }
}
