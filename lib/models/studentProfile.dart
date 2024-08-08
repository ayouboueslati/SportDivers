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
      user: User.fromJson(json['user'] ?? {}),
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'],
      birthdate: DateTime.parse(json['birthdate'] ?? DateTime.now().toString()),
      address: json['address'],
      gender: json['gender'] != null
          ? Gender.values.firstWhere(
              (e) => e.toString().split('.').last == json['gender'],
              orElse: () => Gender.male, // Default value
            )
          : Gender.male, // Default value
      inscriptionDate:
          DateTime.parse(json['inscriptionDate'] ?? DateTime.now().toString()),
      profilePicture: json['profilePicture'],
      gradebook: json['gradebook'],
      birthCertificate: json['birthCertificate'],
      observation: json['observation'],
      average: (json['average'] as num?)?.toDouble(),
      discountType: json['discountType'] != null
          ? StudentdiscountType.values.firstWhere(
              (e) => e.toString().split('.').last == json['discountType'],
              orElse: () => StudentdiscountType.none, // Default value
            )
          : StudentdiscountType.none, // Default value
      discount: (json['discount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] != null
          ? StudentpaymentMethod.values.firstWhere(
              (e) => e.toString().split('.').last == json['paymentMethod'],
              orElse: () => StudentpaymentMethod.perMonth, // Default value
            )
          : StudentpaymentMethod.perMonth, // Default value
      hasAccess: json['hasAccess'] ?? false,
      group: json['group'] != null ? Group.fromJson(json['group']) : null,
      attendances: (json['attendances'] as List<dynamic>?)
              ?.map((data) => Attendance.fromJson(data))
              .toList() ??
          [],
      payments: (json['payments'] as List<dynamic>?)
              ?.map((data) => PaymenttypeExtension.fromString(data as String))
              .toList() ??
          [],
    );
  }
}
