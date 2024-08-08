// lib/models/ticket_model.dart

class Ticket {
  final String id;
  final String reason;
  final String comment;
  final String target;

  Ticket({
    required this.id,
    required this.reason,
    required this.comment,
    required this.target,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] ?? '', // Adjust based on your actual response
      reason: json['reason'],
      comment: json['comment'],
      target: json['target'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reason': reason,
      'comment': comment,
      'target': target,
    };
  }
}
