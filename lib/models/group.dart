import 'package:footballproject/models/category.dart';
import 'package:footballproject/models/studentProfile.dart';

class Group {
  String id;
  String designation;
  Category category;
  List<StudentProfile> students;

  Group({
    required this.id,
    required this.designation,
    required this.category,
    required this.students,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? '',
      designation: json['designation'] ?? '',
      category: Category.fromJson(json['category'] ?? {}),
      students: (json['students'] as List<dynamic>?)
              ?.map((data) => StudentProfile.fromJson(data))
              .toList() ??
          [],
    );
  }
}
