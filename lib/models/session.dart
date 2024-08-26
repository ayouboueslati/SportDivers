import 'dart:math';

import 'package:footballproject/models/attendances.dart';
import 'package:footballproject/models/sessionTypes.dart';
import 'package:footballproject/models/teacherHourCost.dart';
import 'package:footballproject/models/teacherPayment.dart';
import 'package:footballproject/models/teacherProfile.dart';
import 'package:footballproject/models/field.dart';
import 'package:footballproject/models/schedule.dart';
import 'package:footballproject/models/weekday.dart';
import 'package:footballproject/models/group.dart';
import 'package:footballproject/models/user.dart';
import 'package:footballproject/models/gender.dart';

class Session {
  String id;
  String? designation;
  Weekday weekday;
  String startTime;
  String endTime;
  Schedule schedule;
  TeacherProfile teacher;
  Field? field;
  final Sessiontypes type;
  List<Attendance> attendances;
  // List<TeacherpaymentMethod> teacherPayments;

  Session({
    required this.id,
    this.designation,
    required this.weekday,
    required this.startTime,
    required this.endTime,
    required this.schedule,
    required this.teacher,
    this.field,
    required this.type,
    required this.attendances,
    // required this.teacherPayments,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    Weekday weekday = Weekday.MONDAY; // Default value
    List<Attendance> attendances = [];

    Sessiontypes type = Sessiontypes.FRIENDLY_GAME; // Default value
    if (json.containsKey('type') && json['type'] != null) {
      type = Sessiontypes.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => Sessiontypes.FRIENDLY_GAME,
      );
    }

    // Parsing the weekday
    if (json.containsKey('weekday') && json['weekday'] != null) {
      weekday = Weekday.values.firstWhere(
        (e) => e.toString().split('.').last == json['weekday'],
        orElse: () => Weekday.MONDAY,
      );
    }

    // Parsing attendances
    final attendancesData = json['attendances'] as List<dynamic>? ?? [];
    attendances = attendancesData
        .map((data) => Attendance.fromJson(data as Map<String, dynamic>))
        .toList();

    // Parsing schedule
    Schedule schedule = json['schedule'] != null
        ? Schedule.fromJson(json['schedule'])
        : Schedule(
            id: '',
            designation: '',
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            group: Group.fromJson(json),
          );

    // Parsing teacher
    TeacherProfile teacher = json['teacher'] != null
        ? TeacherProfile.fromJson(json['teacher'])
        : TeacherProfile(
            id: '',
            user: User.empty(),
            firstName: '',
            lastName: '',
            birthdate: DateTime.now(),
            gender: Gender.male,
            diploma: '',
            diplomaPhoto: null,
            cin: '',
            cinPhoto: null,
            jobContract: null,
            paymentMethod: TeacherpaymentMethod.salary,
            salary: 0.0,
            groups: [],
            categories: [],
            sessions: [],
            hourCosts: [],
            payments: [],
          );

    // Parsing field
    Field? field = json['field'] != null ? Field.fromJson(json['field']) : null;

    return Session(
      id: json['id'] ?? '',
      designation: json['designation'] as String?,
      weekday: weekday,
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      schedule: schedule,
      teacher: teacher,
      field: field,
      type: type,
      attendances: attendances,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation': designation,
      'weekday': weekday.toString().split('.').last,
      'startTime': startTime,
      'endTime': endTime,
      'schedule': schedule.toJson(),
      'teacher': teacher.toJson(),
      'field': field?.toJson(),
      'type': type.toString().split('.').last,
      'attendances':
          attendances.map((attendance) => attendance.toJson()).toList(),
    };
  }
}
