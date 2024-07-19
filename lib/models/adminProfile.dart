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
}
