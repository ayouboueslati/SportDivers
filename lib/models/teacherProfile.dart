import 'package:footballproject/models/category.dart';
import 'package:footballproject/models/gender.dart';
import 'package:footballproject/models/group.dart';
import 'package:footballproject/models/session.dart';
import 'package:footballproject/models/teacherHourCost.dart';
import 'package:footballproject/models/teacherPayment.dart';
import 'package:footballproject/models/user.dart';

class TeacherProfile {
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
  TeacherpaymentMethod paymentMethod;
  double salary;
  List<Group> groups;
  List<Category> categories;
  List<Session> sessions;
  List<TeacherHourCost> hourCosts;
  List<TeacherpaymentMethod> payments;

  TeacherProfile({
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
    required this.paymentMethod,
    required this.salary,
    required this.groups,
    required this.categories,
    required this.sessions,
    required this.hourCosts,
    required this.payments,
  });
}
