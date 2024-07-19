import 'package:footballproject/models/attendances.dart';
import 'package:footballproject/models/field.dart';
import 'package:footballproject/models/schedule.dart';
import 'package:footballproject/models/teacherPayment.dart';
import 'package:footballproject/models/teacherProfile.dart';
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
}
