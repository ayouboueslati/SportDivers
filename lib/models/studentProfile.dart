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
      id: json['id'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : User.empty(),
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'],
      birthdate: DateTime.tryParse(json['birthdate'] ?? '') ?? DateTime.now(),
      address: json['address'],
      gender: json['gender'] != null
          ? Gender.values.firstWhere(
              (e) => e.toString().split('.').last == json['gender'],
              orElse: () => Gender.male,
            )
          : Gender.male,
      inscriptionDate:
          DateTime.tryParse(json['inscriptionDate'] ?? '') ?? DateTime.now(),
      profilePicture: json['profilePicture'],
      gradebook: json['gradebook'],
      birthCertificate: json['birthCertificate'],
      observation: json['observation'],
      average: (json['average'] as num?)?.toDouble(),
      discountType: json['discountType'] != null
          ? StudentdiscountType.values.firstWhere(
              (e) => e.toString().split('.').last == json['discountType'],
              orElse: () => StudentdiscountType.none,
            )
          : StudentdiscountType.none,
      discount: (json['discount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] != null
          ? StudentpaymentMethod.values.firstWhere(
              (e) => e.toString().split('.').last == json['paymentMethod'],
              orElse: () => StudentpaymentMethod.perMonth,
            )
          : StudentpaymentMethod.perMonth,
      hasAccess: json['hasAccess'] ?? false,
      group: json['group'] != null ? Group.fromJson(json['group']) : null,
      attendances: (json['attendances'] as List<dynamic>?)
              ?.map((data) => Attendance.fromJson(data as Map<String, dynamic>))
              .toList() ??
          [],
      payments: (json['payments'] as List<dynamic>?)
              ?.map((data) => PaymenttypeExtension.fromString(data as String))
              .toList() ??
          [],
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
      'inscriptionDate': inscriptionDate.toIso8601String(),
      'profilePicture': profilePicture,
      'gradebook': gradebook,
      'birthCertificate': birthCertificate,
      'observation': observation,
      'average': average,
      'discountType': discountType.toString().split('.').last,
      'discount': discount,
      'paymentMethod': paymentMethod.toString().split('.').last,
      'hasAccess': hasAccess,
      'group': group?.toJson(),
      'attendances':
          attendances.map((attendance) => attendance.toJson()).toList(),
      'payments': payments.map((payment) => payment.toJson()).toList(),
    };
  }
}
