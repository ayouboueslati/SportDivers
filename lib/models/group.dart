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
}
