class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String? profilePicture;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'profilePicture': profilePicture,
    };
  }

  String get fullName => '$firstName $lastName';
  String get initials => firstName.isNotEmpty ? firstName[0] : '';
}
