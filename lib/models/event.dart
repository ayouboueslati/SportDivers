import 'package:intl/intl.dart';

class Event {
  final int id;
  final String titre;
  final String description;
  final String image;
  final DateTime start;
  final DateTime end;
  final int? limit;
  final int rented;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.titre,
    required this.description,
    required this.image,
    required this.start,
    required this.end,
    this.limit,
    required this.rented,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      image: json['image'],
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      limit: json['limit'],
      rented: json['rented'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'image': image,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'limit': limit,
      'rented': rented,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get formattedDateRange {
    final DateFormat formatter = DateFormat('d MMMM yyyy', 'fr_FR');
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }

  String get shortDescription {
    String plainText = description.replaceAll(RegExp(r'<[^>]*>'), '');
    return plainText.length > 100 ? '${plainText.substring(0, 100)}...' : plainText;
  }
}