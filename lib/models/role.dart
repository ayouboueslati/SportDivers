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
}
