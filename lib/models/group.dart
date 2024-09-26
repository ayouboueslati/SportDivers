import 'package:sportdivers/models/category.dart';
import 'package:sportdivers/models/studentProfile.dart';

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

  // Default constructor for cases with missing or invalid data
  factory Group.empty() {
    return Group(
      id: '',
      designation: '',
      category: Category.empty(), // Ensure Category has a default constructor
      students: [],
    );
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? '',
      designation: json['designation'] ?? '',
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : Category.empty(), // Handle null values
      students: (json['students'] as List<dynamic>?)
              ?.map((data) => StudentProfile.fromJson(data))
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation': designation,
      'category': category.toJson(),
      'students': students.map((student) => student.toJson()).toList(),
    };
  }
}
