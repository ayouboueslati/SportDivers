import 'package:footballproject/models/attendances.dart';
import 'package:footballproject/models/rating.dart';
import 'package:footballproject/models/sessionTypes.dart';
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
  List<Rating> ratings;

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
    required this.ratings,
  });

  double get averageRating {
    if (ratings.isEmpty) return 0.0;
    double totalRating = ratings.fold(0.0, (sum, rating) => sum + rating.value);
    return totalRating / ratings.length;
  }

  String get sessionDate {
    try {
      final dateTime = DateTime.parse(startTime);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      print('Error parsing startTime: $e');
      return '';
    }
  }

  bool isWithinRange(DateTime date, DateTime startDate, DateTime endDate) {
    return date.isAfter(startDate) && date.isBefore(endDate);
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    Weekday weekday = Weekday.MONDAY; // Default value
    List<Attendance> attendances = [];
    Sessiontypes type = Sessiontypes.MATCH_AMICAL; // Default value

    if (json.containsKey('type') && json['type'] != null) {
      type = Sessiontypes.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => Sessiontypes.MATCH_AMICAL,
      );
    }

    if (json.containsKey('weekday') && json['weekday'] != null) {
      weekday = Weekday.values.firstWhere(
        (e) => e.toString().split('.').last == json['weekday'],
        orElse: () => Weekday.MONDAY,
      );
    }

    final attendancesData = json['attendances'] as List<dynamic>? ?? [];
    attendances = attendancesData
        .map((data) => Attendance.fromJson(data as Map<String, dynamic>))
        .toList();

    final ratingsData = json['ratings'] as List<dynamic>? ?? [];
    List<Rating> ratings = ratingsData
        .map((data) => Rating.fromJson(data as Map<String, dynamic>))
        .toList();

    Schedule schedule = json['schedule'] != null
        ? Schedule.fromJson(json['schedule'])
        : Schedule(
            id: '',
            designation: '',
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            group: Group.fromJson(json),
          );

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
      ratings: ratings,
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
      'ratings': ratings.map((rating) => rating.toJson().toString()),
    };
  }
}
