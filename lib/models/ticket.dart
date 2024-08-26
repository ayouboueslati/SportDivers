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
      createdAt: DateTime.parse(json['createdAt']), // Parse the date correctly
      reason: json['reason'] ?? '',
      comment: json['comment'] ?? '',
      isAdminTarget: json['isAdminTarget'] ?? false,
      target: User.fromJson(json['target']), // Deserialize the user object
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt':
          createdAt.toIso8601String(), // Ensure date is in ISO 8601 format
      'reason': reason,
      'comment': comment,
      'isAdminTarget': isAdminTarget,
      'target': target.toJson(), // Serialize the user object
    };
  }
}
