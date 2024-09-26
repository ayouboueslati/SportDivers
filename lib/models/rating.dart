import 'package:sportdivers/models/ratingTargetType.dart';
import 'package:sportdivers/models/session.dart';
import 'package:sportdivers/models/user.dart';

class Rating {
  String id;
  int value;
  String text;
  DateTime createdAt;
  DateTime sessionDate;
  RatingTargetType targetType;
  User user;
  Session session;

  Rating({
    required this.id,
    required this.value,
    required this.text,
    required this.createdAt,
    required this.sessionDate,
    required this.targetType,
    required this.user,
    required this.session,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'] ?? '',
      value: json['value'] ?? 0,
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      sessionDate:
          DateTime.parse(json['date']), // Assuming "date" is sessionDate
      targetType: RatingTargetType.values.firstWhere(
        (e) => e.toString().split('.').last == json['targetType'],
        orElse: () => RatingTargetType.Coach,
      ),
      user: User.fromJson(json['user']),
      session: Session.fromJson(json['session']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'date': sessionDate.toIso8601String(),
      'targetType': targetType.toString().split('.').last,
      'user': user.toJson(),
      'session': session.toJson(),
    };
  }
}
