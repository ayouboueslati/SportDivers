class Tournament {
  final String id;
  final String title;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final double fees;
  final List<Group> groups;
  final List<Group> externalGroups;

  Tournament({
    required this.id,
    required this.title,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.fees,
    required this.groups,
    required this.externalGroups,
  });

  // Method to parse JSON data
  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : DateTime.now(),
      fees: (json['fees'] as num?)?.toDouble() ?? 0.0,
      groups: json['groups'] != null
          ? (json['groups'] as List)
          .map((group) => Group.fromJson(group))
          .toList()
          : [],
      externalGroups: json['externalGroups'] != null
          ? (json['externalGroups'] as List)
          .map((group) => Group.fromJson(group))
          .toList()
          : [],
    );
  }

  // Getters for formatted data
  String get formattedStartDate =>
      '${startDate.day} ${_getMonthName(startDate.month)} ${startDate.year}';

  String get formattedEndDate =>
      '${endDate.day} ${_getMonthName(endDate.month)} ${endDate.year}';

  String _getMonthName(int month) {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return months[month - 1];
  }
}

class Group {
  final String id;
  final String designation;

  Group({
    required this.id,
    required this.designation,
  });

  // Method to parse JSON data
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? '',
      designation: json['designation'] ?? '',
    );
  }
}

class Match {
  final String id;
  final DateTime date;
  final String firstTeamType;
  final String secondTeamType;
  final Team firstTeam;
  final Team secondTeam;
  final Field field;

  Match({
    required this.id,
    required this.date,
    required this.firstTeamType,
    required this.secondTeamType,
    required this.firstTeam,
    required this.secondTeam,
    required this.field,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      date: DateTime.parse(json['date']),
      firstTeamType: json['firstTeamType'],
      secondTeamType: json['secondTeamType'],
      firstTeam: Team.fromJson(json['firstTeam']),
      secondTeam: Team.fromJson(json['secondTeam']),
      field: Field.fromJson(json['field']),
    );
  }
}

// Team Model
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
      photo: json['photo'] ?? '', // Use an empty string if 'photo' is not present
    );
  }
}


// Category Model
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

// Field Model
class Field {
  final String id;
  final String designation;

  Field({
    required this.id,
    required this.designation,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      designation: json['designation'],
    );
  }
}

class MatchPhase {
  final String id;
  final DateTime date;
  final List<Match> matches;

  MatchPhase({
    required this.id,
    required this.date,
    required this.matches,
  });

  factory MatchPhase.fromJson(Map<String, dynamic> json) {
    return MatchPhase(
      id: json['id'],
      date: DateTime.parse(json['date']),
      matches: (json['matches'] as List)
          .map((match) => Match.fromJson(match))
          .toList(),
    );
  }
}
