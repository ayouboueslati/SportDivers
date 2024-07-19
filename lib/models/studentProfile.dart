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
}
