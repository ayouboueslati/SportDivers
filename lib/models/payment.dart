import 'package:intl/intl.dart';

class Payment {
  final String id;
  final double amount;
  final DateTime date;
  final String? type;
  final DateTime? depositDate;
  bool paid;
  DateTime? paidAt;

  Payment({
    required this.id,
    required this.amount,
    required this.date,
    this.type,
    this.depositDate,
    required this.paid,
    this.paidAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      type: json['type'],
      depositDate: json['depositDate'] != null ? DateTime.parse(json['depositDate']) : null,
      paid: json['paid'],
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
    );
  }

  String get formattedDate => DateFormat('d MMM yyyy').format(date);
  String get formattedTime => DateFormat('HH:mm').format(date);
  String? get formattedDepositDate => depositDate != null ? DateFormat('d MMM yyyy').format(depositDate!) : null;
  String? get formattedPaidAt => paidAt != null ? DateFormat('d MMM yyyy à HH:mm').format(paidAt!) : null;
}