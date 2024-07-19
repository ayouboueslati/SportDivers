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
}
