class Match {
  final String id;
  final DateTime date;
  final Field field;
  final Team firstTeam;
  final Team secondTeam;
  final Arbiter? arbiter;
  final List<MatchAction> actions;

  Match({
    required this.id,
    required this.date,
    required this.field,
    required this.firstTeam,
    required this.secondTeam,
    this.arbiter,
    this.actions = const [],
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      date: DateTime.parse(json['date']),
      field: Field.fromJson(json['field']),
      firstTeam: Team.fromJson(json['firstTeam']),
      secondTeam: Team.fromJson(json['secondTeam']),
      arbiter: json['arbiter'] != null ? Arbiter.fromJson(json['arbiter']) : null,
      actions: json['actions'] != null
          ? (json['actions'] as List)
          .map((actionJson) => MatchAction.fromJson(actionJson))
          .toList()
          : [],
    );
  }
}

class MatchAction {
  final String id;
  final String type;
  final int minute;
  final String? targetType;
  final String? target;
  final String? targetTeam;

  MatchAction({
    required this.id,
    required this.type,
    required this.minute,
    this.targetType,
    this.target,
    this.targetTeam,
  });

  factory MatchAction.fromJson(Map<String, dynamic> json) {
    return MatchAction(
      id: json['id'],
      type: json['type'],
      minute: json['minute'],
      targetType: json['targetType'],
      target: json['target'],
      targetTeam: json['targetTeam'],
    );
  }

  String get actionName {
    switch (type) {
      case 'GOAL':
        return 'But';
      case 'YELLOW_CARD':
        return 'Carton Jaune';
      case 'RED_CARD':
        return 'Carton Rouge';
      default:
        return type;
    }
  }
}

class Field {
  final String id;
  final String designation;

  Field({required this.id, required this.designation});

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      designation: json['designation'],
    );
  }
}

class Team {
  final String id;
  final String designation;
  final String? photo;
  final List<Player>? players;

  Team({
    required this.id,
    required this.designation,
    this.photo,
    this.players,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      designation: json['designation'],
      photo: json['photo'],
      players: json['players'] != null
          ? (json['players'] as List)
          .map((playerJson) => Player.fromJson(playerJson))
          .toList()
          : null,
    );
  }
}

class Player {
  final String id;
  final String firstName;
  final String lastName;
  final String? profilePicture;

  Player({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePicture: json['profilePicture'],
    );
  }

  String get fullName => '$firstName $lastName';
}

class Arbiter {
  final String id;
  final String firstName;
  final String lastName;
  final String? profilePicture;

  Arbiter({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
  });

  factory Arbiter.fromJson(Map<String, dynamic> json) {
    return Arbiter(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePicture: json['profilePicture'],
    );
  }

  String get fullName => '$firstName $lastName';
}