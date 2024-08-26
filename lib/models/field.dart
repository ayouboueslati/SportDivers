import 'package:footballproject/models/session.dart';

class Field {
  String id;
  String designation;
  List<Session>? sessions;

  Field({
    required this.id,
    required this.designation,
    required this.sessions,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      designation: json['designation'],
      sessions: json['sessions'] != null
          ? (json['sessions'] as List)
              .map((data) => Session.fromJson(data))
              .toList()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation': designation,
      'sessions': sessions?.map((session) => session.toJson()).toList(),
    };
  }
}
