import 'package:footballproject/models/chargetype.dart';
import 'package:footballproject/models/group.dart';
import 'package:footballproject/models/paymentType.dart';
import 'package:footballproject/models/user.dart';

class Payment {
  String id;
  DateTime date;
  double amount;
  String description;
  ChargeType chargeType;
  Group? group;
  User user;
  Paymenttype paymentType;

  Payment({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.chargeType,
    this.group,
    required this.user,
    required this.paymentType,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      date: DateTime.parse(json['date']),
      amount: json['amount'].toDouble(),
      description: json['description'],
      chargeType: ChargeType.values.firstWhere(
          (e) => e.toString() == 'ChargeType.' + json['chargeType']),
      group: json['group'] != null ? Group.fromJson(json['group']) : null,
      user: User.fromJson(json['user']),
      paymentType: Paymenttype.values.firstWhere(
          (e) => e.toString() == 'Paymenttype.' + json['paymentType']),
    );
  }
}
