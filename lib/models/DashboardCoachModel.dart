class DashboardStats {
  final int groupsCount;
  final int sessionsCount;
  final List<MonthlyGrade> averageGradesPerMonth;

  DashboardStats({
    required this.groupsCount,
    required this.sessionsCount,
    required this.averageGradesPerMonth,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      groupsCount: json['groupsCount'] ?? 0,
      sessionsCount: json['sessionsCount'] ?? 0,
      averageGradesPerMonth: (json['averageGradesPerMonth'] as List?)
          ?.map((e) => MonthlyGrade.fromJson(e))
          .toList() ?? [],
    );
  }
}

class MonthlyGrade {
  final String month;
  final double value;

  MonthlyGrade({required this.month, required this.value});

  factory MonthlyGrade.fromJson(Map<String, dynamic> json) {
    return MonthlyGrade(
      month: json['month'] ?? '',
      value: (json['value'] as num).toDouble(),
    );
  }
}