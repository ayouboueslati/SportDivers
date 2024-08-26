import 'dart:convert';

class Tutorial {
  final String id;
  final String name;
  final String description;
  final String fileName;
  final String createdAt;
  final List<dynamic> categories; // Adjust according to actual data structure
  final List<dynamic> groups; // Adjust according to actual data structure
  final Map<String, dynamic> createdBy;
  final String fileUrl;

  Tutorial({
    required this.id,
    required this.name,
    required this.description,
    required this.fileName,
    required this.createdAt,
    required this.categories,
    required this.groups,
    required this.createdBy,
    required this.fileUrl,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    return Tutorial(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      fileName: json['fileName'],
      createdAt: json['createdAt'],
      categories: json['categories'],
      groups: json['groups'],
      createdBy: json['createdBy'],
      fileUrl: json['fileUrl'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'fileName': fileName,
      'createdAt': createdAt,
      'categories': categories,
      'groups': groups,
      'createdBy': createdBy,
      'fileUrl': fileUrl,
    };
  }
}
