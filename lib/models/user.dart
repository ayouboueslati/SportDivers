import 'package:footballproject/models/accountType.dart';
import 'package:footballproject/models/adminProfile.dart';
import 'package:footballproject/models/chatRoom.dart';
import 'package:footballproject/models/message.dart';
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: '', // Do not fetch password
      accountType: AccountType.values.firstWhere(
          (e) => e.toString() == 'AccountType.${json['accountType']}'),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      deactivationDate: json['deactivationDate'] != null
          ? DateTime.parse(json['deactivationDate'])
          : null,
      deactivationReason: json['deactivationReason'],
      deactivationComment: json['deactivationComment'],
      adminProfile: json['adminProfile'] != null
          ? AdminProfile.fromJson(json['adminProfile'])
          : null,
      studentProfile: json['studentProfile'] != null
          ? StudentProfile.fromJson(json['studentProfile'])
          : null,
      teacherProfile: json['teacherProfile'] != null
          ? TeacherProfile.fromJson(json['teacherProfile'])
          : null,
      staffProfile: json['staffProfile'] != null
          ? StaffProfile.fromJson(json['staffProfile'])
          : null,
      chatRoomsFirst: (json['chatRoomsFirst'] as List)
          .map((data) => Chatroom.fromJson(data))
          .toList(),
      chatRoomsSecond: (json['chatRoomsSecond'] as List)
          .map((data) => Chatroom.fromJson(data))
          .toList(),
      tutorials: (json['tutorials'] as List)
          .map((data) => Tutorial.fromJson(data))
          .toList(),
      sentMessages: (json['sentMessages'] as List)
          .map((data) => Message.fromJson(data))
          .toList(),
      seenMessages: (json['seenMessages'] as List)
          .map((data) => Message.fromJson(data))
          .toList(),
    );
  }
}
