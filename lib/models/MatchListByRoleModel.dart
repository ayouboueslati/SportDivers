class MatchByRole {
  final String id;
  final DateTime date;
  final String firstTeamType;
  final String secondTeamType;
  final TournamentPhase tournamentPhase;
  final Field field;
  final String? arbiter;
  final Team firstTeam;
  final Team secondTeam;
  final List<String>? coachTeams;

  MatchByRole({
    required this.id,
    required this.date,
    required this.firstTeamType,
    required this.secondTeamType,
    required this.tournamentPhase,
    required this.field,
    this.arbiter,
    required this.firstTeam,
    required this.secondTeam,
    required this.coachTeams,
  });

  factory MatchByRole.fromJson(Map<String, dynamic> json) {
    return MatchByRole(
      id: json['id'],
      date: DateTime.parse(json['date']),
      firstTeamType: json['firstTeamType'],
      secondTeamType: json['secondTeamType'],
      tournamentPhase: TournamentPhase.fromJson(json['tournamentPhase']),
      field: Field.fromJson(json['field']),
      arbiter: json['arbiter'],
      firstTeam: Team.fromJson(json['firstTeam']),
      secondTeam: Team.fromJson(json['secondTeam']),
      coachTeams: json['coachTeams'] != null
          ? List<String>.from(json['coachTeams'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'firstTeamType': firstTeamType,
      'secondTeamType': secondTeamType,
      'tournamentPhase': tournamentPhase.toJson(),
      'field': field.toJson(),
      'arbiter': arbiter,
      'firstTeam': firstTeam.toJson(),
      'secondTeam': secondTeam.toJson(),
      if (coachTeams != null) 'coachTeams': coachTeams,
    };
  }
}

class TournamentPhase {
  final String id;
  final DateTime date;

  TournamentPhase({required this.id, required this.date});

  factory TournamentPhase.fromJson(Map<String, dynamic> json) {
    return TournamentPhase(
      id: json['id'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation': designation,
    };
  }
}

class Team {
  final String id;
  final String designation;
  final Category category;
  final String photo;

  Team({
    required this.id,
    required this.designation,
    required this.category,
    required this.photo,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      designation: json['designation'],
      category: Category.fromJson(json['category']),
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation': designation,
      'category': category.toJson(),
      'photo': photo,
    };
  }
}

class Category {
  final String id;
  final String designation;

  Category({required this.id, required this.designation});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      designation: json['designation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation': designation,
    };
  }
}
