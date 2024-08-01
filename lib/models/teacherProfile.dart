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

  factory TeacherProfile.fromJson(Map<String, dynamic> json) {
    return TeacherProfile(
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
      paymentMethod:
          TeacherpaymentMethodExtension.fromString(json['paymentMethod']),
      salary: json['salary'].toDouble(),
      groups:
          (json['groups'] as List).map((item) => Group.fromJson(item)).toList(),
      categories: (json['categories'] as List)
          .map((item) => Category.fromJson(item))
          .toList(),
      sessions: (json['sessions'] as List)
          .map((item) => Session.fromJson(item))
          .toList(),
      hourCosts: (json['hourCosts'] as List)
          .map((item) => TeacherHourCost.fromJson(item))
          .toList(),
      payments: (json['payments'] as List)
          .map((item) =>
              TeacherpaymentMethodExtension.fromString(item as String))
          .toList(),
    );
  }
}
