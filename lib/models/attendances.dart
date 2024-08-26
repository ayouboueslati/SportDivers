import 'package:footballproject/models/user.dart';

class Attendance {
  String id;
  DateTime date;
  User student;
  bool present;
  int grade1;
  int grade2;
  int grade3;
  int grade4;

  Attendance({
    required this.id,
    required this.date,
    required this.student,
    required this.present,
    required this.grade1,
    required this.grade2,
    required this.grade3,
    required this.grade4,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      student: json['student'] != null
          ? User.fromJson(json['student'])
          : User.empty(),
      present: json['present'] ?? false,
      grade1: json['grade1'] ?? 0,
      grade2: json['grade2'] ?? 0,
      grade3: json['grade3'] ?? 0,
      grade4: json['grade4'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'student': student.toJson(),
      'present': present,
      'grade1': grade1,
      'grade2': grade2,
      'grade3': grade3,
      'grade4': grade4,
    };
  }
}
