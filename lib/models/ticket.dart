// lib/models/ticket_model.dart

import 'package:footballproject/models/user.dart';

class Ticket {
  final String id;
  final DateTime createdAt;
  final String reason;
  final String comment;
  final bool isAdminTarget;
  final User target;

  Ticket({
    required this.id,
    required this.createdAt,
    required this.reason,
    required this.comment,
    required this.isAdminTarget,
    required this.target,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] ?? '',
      createdAt: json['createdAt'], // Adjust based on your actual response
      reason: json['reason'],
      comment: json['comment'],
      isAdminTarget: json['isAdminTarget'],
      target: json['target'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'reason': reason,
      'comment': comment,
      'isAdminTarget': isAdminTarget,
      'target': target,
    };
  }
}
