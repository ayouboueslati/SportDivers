import 'package:sportdivers/models/gender.dart';
import 'package:sportdivers/models/role.dart';
import 'package:sportdivers/models/user.dart';

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

  factory StaffProfile.fromJson(Map<String, dynamic> json) {
    return StaffProfile(
      id: json['id'],
      user: User.fromJson(json['user']),
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      birthdate: DateTime.parse(json['birthdate']),
      address: json['address'],
      gender: Gender.values
          .firstWhere((e) => e.toString() == 'Gender.${json['gender']}'),
      profilePicture: json['profilePicture'],
      diploma: json['diploma'],
      diplomaPhoto: json['diplomaPhoto'],
      cin: json['cin'],
      cinPhoto: json['cinPhoto'],
      jobContract: json['jobContract'],
      salary: json['salary'],
      roles:
          (json['roles'] as List).map((data) => Role.fromJson(data)).toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'birthdate': birthdate.toIso8601String(),
      'address': address,
      'gender': gender.toString().split('.').last,
      'profilePicture': profilePicture,
      'diploma': diploma,
      'diplomaPhoto': diplomaPhoto,
      'cin': cin,
      'cinPhoto': cinPhoto,
      'jobContract': jobContract,
      'salary': salary,
      'roles': roles.map((role) => role.toJson()).toList(),
    };
  }
}
