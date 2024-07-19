import 'package:footballproject/models/gender.dart';
import 'package:footballproject/models/role.dart';
import 'package:footballproject/models/user.dart';

class StaffProfile {
  String id;
  User user;
  String firstName;
  String lastName;
  String? phone;
  DateTime birthdate;
  String? address;
  Gender gender;
  String? profilePicture;
  String diploma;
  String? diplomaPhoto;
  String cin;
  String? cinPhoto;
  String? jobContract;
  double salary;
  List<Role> roles;

  StaffProfile({
    required this.id,
    required this.user,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.birthdate,
    this.address,
    required this.gender,
    this.profilePicture,
    required this.diploma,
    this.diplomaPhoto,
    required this.cin,
    this.cinPhoto,
    this.jobContract,
    required this.salary,
    required this.roles,
  });
}
