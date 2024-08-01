import 'package:footballproject/models/user.dart';

class AdminProfile {
  String id;
  User user;
  int userPk;
  String firstName;
  String lastName;
  String? profilePicture;

  AdminProfile({
    required this.id,
    required this.user,
    required this.userPk,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
  });

  factory AdminProfile.fromJson(Map<String, dynamic> json) {
    return AdminProfile(
      id: json['id'],
      user: User.fromJson(json['user']),
      userPk: json['userPk'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePicture: json['profilePicture'],
    );
  }
}
