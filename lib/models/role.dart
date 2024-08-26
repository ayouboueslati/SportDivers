import 'package:footballproject/models/staffProfile.dart';

class Role {
  String id;
  String designation;
  String description;
  List<StaffProfile> staff;

  Role({
    required this.id,
    required this.designation,
    required this.description,
    required this.staff,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      designation: json['designation'],
      description: json['description'],
      staff: (json['staff'] as List)
          .map((data) => StaffProfile.fromJson(data))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation': designation,
      'description': description,
      'staff': staff.map((staffMember) => staffMember.toJson()).toList(),
    };
  }
}
