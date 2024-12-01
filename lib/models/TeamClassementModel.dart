class TeamRanking {
  final String id;
  final String type;
  final String designation;
  final String photo;
  final int points;
  final int goals;
  final int victories;
  final int defeats;
  final int nulls;
  final int receivedGoals;
  final int goalsDifference;

  TeamRanking({
    required this.id,
    required this.type,
    required this.designation,
    required this.photo,
    required this.points,
    required this.goals,
    required this.victories,
    required this.defeats,
    required this.nulls,
    required this.receivedGoals,
    required this.goalsDifference,
  });

  factory TeamRanking.fromJson(Map<String, dynamic> json) {
    return TeamRanking(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      designation: json['designation'] ?? '',
      photo: json['photo'] ?? '',
      points: json['points'] ?? 0,
      goals: json['goals'] ?? 0,
      victories: json['victories'] ?? 0,
      defeats: json['defeats'] ?? 0,
      nulls: json['nulls'] ?? 0,
      receivedGoals: json['receivedGoals'] ?? 0,
      goalsDifference: json['goalsDifference'] ?? 0,
    );
  }
}