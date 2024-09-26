import 'package:sportdivers/models/group.dart';
import 'package:sportdivers/models/session.dart';

import 'package:sportdivers/models/group.dart';

class Schedule {
  String id;
  String designation;
  DateTime startDate;
  DateTime endDate;
  Group group;

  Schedule({
    required this.id,
    required this.designation,
    required this.startDate,
    required this.endDate,
    required this.group,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] ?? '',
      designation: json['designation'] ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : DateTime.now(),
      group:
          json['group'] != null ? Group.fromJson(json['group']) : Group.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation': designation,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'group': group.toJson(),
    };
  }
}
