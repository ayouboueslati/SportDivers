class PlayerRanking {
  final String playerType;
  final int count;
  final String id;
  final String? profilePicture;
  final String fullname;
  final GroupInfo group;

  PlayerRanking({
    required this.playerType,
    required this.count,
    required this.id,
    this.profilePicture,
    required this.fullname,
    required this.group,
  });

  factory PlayerRanking.fromJson(Map<String, dynamic> json) {
    return PlayerRanking(
      playerType: json['playerType'] ?? '',
      count: json['count'] ?? 0,
      id: json['id'] ?? '',
      profilePicture: json['profilePicture'],
      fullname: json['fullname'] ?? '',
      group: GroupInfo.fromJson(json['group'] ?? {}),
    );
  }
}

class GroupInfo {
  final String id;
  final String designation;
  final String? photo;

  GroupInfo({
    required this.id,
    required this.designation,
    this.photo,
  });

  factory GroupInfo.fromJson(Map<String, dynamic> json) {
    return GroupInfo(
      id: json['id'] ?? '',
      designation: json['designation'] ?? '',
      photo: json['photo'],
    );
  }
}