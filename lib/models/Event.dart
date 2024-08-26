import 'package:flutter/material.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String image;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.image,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['titre'],
      description: json['description'],
      startDate: DateTime.parse(json['start']),
      endDate: DateTime.parse(json['end']),
      image: json['image'],
    );
  }
}
