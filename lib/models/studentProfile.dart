import 'package:footballproject/models/attendances.dart';
import 'package:footballproject/models/gender.dart';
import 'package:footballproject/models/group.dart';
import 'package:footballproject/models/paymentType.dart';
import 'package:footballproject/models/studentDiscount.dart';
import 'package:footballproject/models/studentPayment.dart';
import 'package:footballproject/models/user.dart';

class StudentProfile {
  String id;
  User user;
  String firstName;
  String lastName;
  String? phone;
  DateTime birthdate;
  String? address;
  Gender gender;
  DateTime inscriptionDate;
  String? profilePicture;
  String? gradebook;
  String? birthCertificate;
  String? observation;
  double? average;
  StudentdiscountType discountType;
  double discount;
  StudentpaymentMethod paymentMethod;
  bool hasAccess;
  Group? group;
  List<Attendance> attendances;
  List<Paymenttype> payments;

  StudentProfile({
    required this.id,
    required this.user,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.birthdate,
    this.address,
    required this.gender,
    required this.inscriptionDate,
    this.profilePicture,
    this.gradebook,
    this.birthCertificate,
    this.observation,
    this.average,
    required this.discountType,
    required this.discount,
    required this.paymentMethod,
    required this.hasAccess,
    this.group,
    required this.attendances,
    required this.payments,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'],
      user: User.fromJson(json['user']),
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      birthdate: DateTime.parse(json['birthdate']),
      address: json['address'],
      gender: Gender.values
          .firstWhere((e) => e.toString() == 'Gender.${json['gender']}'),
      inscriptionDate: DateTime.parse(json['inscriptionDate']),
      profilePicture: json['profilePicture'],
      gradebook: json['gradebook'],
      birthCertificate: json['birthCertificate'],
      observation: json['observation'],
      average: json['average']?.toDouble(),
      discountType: StudentdiscountType.values.firstWhere(
          (e) => e.toString() == 'StudentdiscountType.${json['discountType']}'),
      discount: json['discount'].toDouble(),
      paymentMethod: StudentpaymentMethod.values.firstWhere((e) =>
          e.toString() == 'StudentpaymentMethod.${json['paymentMethod']}'),
      hasAccess: json['hasAccess'],
      group: json['group'] != null ? Group.fromJson(json['group']) : null,
      attendances: (json['attendances'] as List)
          .map((data) => Attendance.fromJson(data))
          .toList(),
      payments: (json['payments'] as List)
          .map((data) => PaymenttypeExtension.fromString(data as String))
          .toList(),
    );
  }
}
