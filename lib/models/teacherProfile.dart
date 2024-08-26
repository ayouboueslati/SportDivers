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
      id: json['id'] as String? ?? '',
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : User.empty(), // Provide default if needed
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      phone: json['phone'] as String?,
      birthdate: DateTime.tryParse(json['birthdate'] as String? ?? '') ??
          DateTime.now(),
      address: json['address'] as String?,
      gender: json['gender'] != null
          ? Gender.values.firstWhere(
              (e) => e.toString().split('.').last == json['gender'] as String,
              orElse: () => Gender.male)
          : Gender.male,
      profilePicture: json['profilePicture'] as String?,
      diploma: json['diploma'] as String? ?? '',
      diplomaPhoto: json['diplomaPhoto'] as String?,
      cin: json['cin'] as String? ?? '',
      cinPhoto: json['cinPhoto'] as String?,
      jobContract: json['jobContract'] as String?,
      paymentMethod: json['paymentMethod'] != null
          ? TeacherpaymentMethodExtension.fromString(
              json['paymentMethod'] as String)
          : TeacherpaymentMethod.salary,
      salary: (json['salary'] as num?)?.toDouble() ?? 0.0,
      groups: (json['groups'] as List<dynamic>? ?? [])
          .map((item) => Group.fromJson(item as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
      sessions: (json['sessions'] as List<dynamic>? ?? [])
          .map((item) => Session.fromJson(item as Map<String, dynamic>))
          .toList(),
      hourCosts: (json['hourCosts'] as List<dynamic>? ?? [])
          .map((item) => TeacherHourCost.fromJson(item as Map<String, dynamic>))
          .toList(),
      payments: (json['payments'] as List<dynamic>? ?? [])
          .map((item) =>
              TeacherpaymentMethodExtension.fromString(item as String))
          .toList(),
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
      'paymentMethod': paymentMethod.toString().split('.').last,
      'salary': salary,
      'groups': groups.map((group) => group.toJson()).toList(),
      'categories': categories.map((category) => category.toJson()).toList(),
      'sessions': sessions.map((session) => session.toJson()).toList(),
      'hourCosts': hourCosts.map((hourCost) => hourCost.toJson()).toList(),
      'payments': payments
          .map((payment) => payment.toString())
          .toList(), // Adjust if payments are not strings
    };
  }
}
