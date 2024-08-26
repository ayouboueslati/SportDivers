import 'package:footballproject/models/group.dart';

class Category {
  String id;
  String designation;

  Category({
    required this.id,
    required this.designation,
  });

  // Default constructor for empty or default instances
  Category.empty()
      : id = '',
        designation = '';

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      designation: json['designation'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation': designation,
    };
  }
}
