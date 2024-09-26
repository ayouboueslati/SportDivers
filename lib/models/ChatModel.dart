import 'package:sportdivers/models/studentProfile.dart';
import 'package:sportdivers/models/teacherProfile.dart';
import 'package:sportdivers/models/user_model.dart';

class GroupChatRoom {
  final String id;
  final Group group;
  final Message? lastMessage;
  final int unseenMsgs;

  GroupChatRoom({
    required this.id,
    required this.group,
    this.lastMessage,
    required this.unseenMsgs,
  });

  factory GroupChatRoom.fromJson(Map<String, dynamic> json) {
    return GroupChatRoom(
      id: json['id'] as String? ?? '',
      group: Group.fromJson(json['group'] as Map<String, dynamic>),
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      unseenMsgs: json['unseenMsgs'] as int? ?? 0,
    );
  }
}

class Message {
  final String id;
  final String text;
  final String? fileName;
  final String type;
  final DateTime timestamp;
  final Sender sender;
  final List<String> seenBy;

  Message({
    required this.id,
    required this.text,
    this.fileName,
    required this.type,
    required this.timestamp,
    required this.sender,
    required this.seenBy,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      fileName: json['fileName'] as String?,
      type: json['type'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      sender: Sender.fromJson(json['sender'] as Map<String, dynamic>? ?? {}),
      seenBy: (json['seenBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'fileName': fileName,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'sender': sender.toJson(),
      'seenBy': seenBy,
    };
  }
}

class Sender {
  final String id;

  Sender({required this.id});

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(id: json['id'] as String? ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class ChatRoom {
  final String id;
  final User firstUser;
  final User secondUser;
  final Message lastMessage;
  final int unseenMsgs;

  ChatRoom({
    required this.id,
    required this.firstUser,
    required this.secondUser,
    required this.lastMessage,
    required this.unseenMsgs,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'] as String? ?? '',
      firstUser: User.fromJson(json['firstUser'] as Map<String, dynamic>? ?? {}),
      secondUser:
      User.fromJson(json['secondUser'] as Map<String, dynamic>? ?? {}),
      lastMessage:
      Message.fromJson(json['lastMessage'] as Map<String, dynamic>? ?? {}),
      unseenMsgs: json['unseenMsgs'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstUser': firstUser.toJson(),
      'secondUser': secondUser.toJson(),
      'lastMessage': lastMessage.toJson(),
      'unseenMsgs': unseenMsgs,
    };
  }
}


class Group {
  final String id;
  final String designation;
  final Category category;
  final List<StudentProfile> students;
  final List<TeacherProfile> teachers;
  final Message? lastMessage;
  final String? photo;

  Group({
    required this.id,
    required this.designation,
    required this.category,
    required this.students,
    required this.teachers,
    this.lastMessage,
    this.photo,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? '',
      // Default to empty string if null
      designation: json['designation'] ?? '',
      // Default to empty string if null
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : Category(id: '', designation: ''),
      students: (json['students'] as List<dynamic>?)
              ?.map((data) =>
                  StudentProfile.fromJson(data as Map<String, dynamic>))
              .toList() ??
          [],
      teachers: (json['teachers'] as List<dynamic>?)
              ?.map((data) =>
                  TeacherProfile.fromJson(data as Map<String, dynamic>))
              .toList() ??
          [],
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      photo: json['photo'] as String?,
    );
  }
}

class Category {
  final String id;
  final String designation;

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

class Student {
  final String id;
  final String profilePicture;
  final String firstName;
  final String lastName;
  final User user;

  Student({
    required this.id,
    required this.profilePicture,
    required this.firstName,
    required this.lastName,
    required this.user,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      profilePicture: json['profilePicture'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      user: User.fromJson(json['user']),
    );
  }
}

class Teacher {
  final String id;
  final String? profilePicture;
  final String firstName;
  final String lastName;
  final User user;

  Teacher({
    required this.id,
    this.profilePicture,
    required this.firstName,
    required this.lastName,
    required this.user,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      profilePicture: json['profilePicture'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      user: User.fromJson(json['user']),
    );
  }
}

class ChatData {
  final List<Group> groups;
  final List<User> students;

  ChatData({
    required this.groups,
    required this.students,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    var groupsJson = (json['groups'] as Map).values.toList();
    var studentsJson = (json['students'] as Map).values.toList();

    return ChatData(
      groups: groupsJson.map((e) => Group.fromJson(e)).toList(),
      students: studentsJson.map((e) => User.fromJson(e)).toList(),
    );
  }
}
