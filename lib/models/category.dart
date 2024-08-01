class Category {
  String id;
  String designation;

  Category({
    required this.id,
    required this.designation,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      designation: json['designation'],
    );
  }
}
