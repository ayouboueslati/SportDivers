import 'package:footballproject/models/accountType.dart';
import 'package:footballproject/models/adminProfile.dart';
import 'package:footballproject/models/chatRoom.dart';
import 'package:footballproject/models/message_model.dart';
import 'package:footballproject/models/staffProfile.dart';
import 'package:footballproject/models/studentProfile.dart';
import 'package:footballproject/models/teacherProfile.dart';
import 'package:footballproject/models/tutorial.dart';

class User {
  String id;
  String? email;
  String password;
  AccountType accountType;
  bool isActive;
  DateTime? deactivationDate;
  String? deactivationReason;
  String? deactivationComment;
  DateTime createdAt;
  AdminProfile? adminProfile;
  StudentProfile? studentProfile;
  TeacherProfile? teacherProfile;
  StaffProfile? staffProfile;
  List<Chatroom> chatRoomsFirst;
  List<Chatroom> chatRoomsSecond;
  List<Tutorial> tutorials;
  List<Message> sentMessages;
  List<Message> seenMessages;

  User({
    required this.id,
    this.email,
    required this.password,
    required this.accountType,
    required this.isActive,
    this.deactivationDate,
    this.deactivationReason,
    this.deactivationComment,
    required this.createdAt,
    this.adminProfile,
    this.studentProfile,
    this.teacherProfile,
    this.staffProfile,
    required this.chatRoomsFirst,
    required this.chatRoomsSecond,
    required this.tutorials,
    required this.sentMessages,
    required this.seenMessages,
  });
}
