import 'package:footballproject/models/category.dart';
import 'package:footballproject/models/group.dart';
import 'package:footballproject/models/user.dart';

class Tutorial {
  String id;
  String designation;
  DateTime date;
  String link;
  DateTime createdAt;
  DateTime? updatedAt;
  bool? isRemoved;
  List<Group> groups;
  List<Category> categories;
  List<User> users;

  Tutorial({
    required this.id,
    required this.designation,
    required this.date,
    required this.link,
    required this.createdAt,
    this.updatedAt,
    this.isRemoved,
    required this.groups,
    required this.categories,
    required this.users,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    return Tutorial(
      id: json['id'],
      designation: json['designation'],
      date: DateTime.parse(json['date']),
      link: json['link'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isRemoved: json['isRemoved'],
      groups:
          (json['groups'] as List).map((data) => Group.fromJson(data)).toList(),
      categories: (json['categories'] as List)
          .map((data) => Category.fromJson(data))
          .toList(),
      users:
          (json['users'] as List).map((data) => User.fromJson(data)).toList(),
    );
  }
}
