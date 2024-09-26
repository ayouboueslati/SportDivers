import 'package:sportdivers/models/accountType.dart';
import 'package:sportdivers/models/adminProfile.dart';
import 'package:sportdivers/models/staffProfile.dart';
import 'package:sportdivers/models/studentProfile.dart';
import 'package:sportdivers/models/teacherProfile.dart';
import 'package:sportdivers/models/tutorial.dart';
import 'package:sportdivers/models/ChatModel.dart';

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
  List<ChatRoom> chatRoomsFirst;
  List<ChatRoom> chatRoomsSecond;
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

  // Empty constructor
  User.empty()
      : id = '',
        email = null,
        password = '',
        accountType = AccountType.admin, // Default value
        isActive = false,
        deactivationDate = null,
        deactivationReason = null,
        deactivationComment = null,
        createdAt = DateTime.now(),
        adminProfile = null,
        studentProfile = null,
        teacherProfile = null,
        staffProfile = null,
        chatRoomsFirst = [],
        chatRoomsSecond = [],
        tutorials = [],
        sentMessages = [],
        seenMessages = [];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'],
      password: '',
      accountType: json['accountType'] != null
          ? AccountTypeExtension.fromString(json['accountType'])
          : AccountType.admin,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
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
      chatRoomsFirst: (json['chatRoomsFirst'] as List<dynamic>?)
              ?.map((data) => ChatRoom.fromJson(data))
              .toList() ??
          [],
      chatRoomsSecond: (json['chatRoomsSecond'] as List<dynamic>?)
              ?.map((data) => ChatRoom.fromJson(data))
              .toList() ??
          [],
      tutorials: (json['tutorials'] as List<dynamic>?)
              ?.map((data) => Tutorial.fromJson(data))
              .toList() ??
          [],
      sentMessages: (json['sentMessages'] as List<dynamic>?)
              ?.map((data) => Message.fromJson(data))
              .toList() ??
          [],
      seenMessages: (json['seenMessages'] as List<dynamic>?)
              ?.map((data) => Message.fromJson(data))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'accountType': accountType.toString().split('.').last,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'deactivationDate': deactivationDate?.toIso8601String(),
      'deactivationReason': deactivationReason,
      'deactivationComment': deactivationComment,
      'adminProfile': adminProfile?.toJson(),
      'studentProfile': studentProfile?.toJson(),
      'teacherProfile': teacherProfile?.toJson(),
      'staffProfile': staffProfile?.toJson(),
      'chatRoomsFirst':
          chatRoomsFirst.map((chatRoom) => chatRoom.toJson()).toList(),
      'chatRoomsSecond':
          chatRoomsSecond.map((chatRoom) => chatRoom.toJson()).toList(),
      'tutorials': tutorials.map((tutorial) => tutorial.toJson()).toList(),
      'sentMessages': sentMessages.map((message) => message.toJson()).toList(),
      'seenMessages': seenMessages.map((message) => message.toJson()).toList(),
    };
  }
}
