class DashboardStats {
  final int presenceCount;
  final int absenceCount;
  final Map<String, double> absenceRatio;
  final List<MonthlyGrade> averageGradesPerMonth;

  DashboardStats({
    required this.presenceCount,
    required this.absenceCount,
    required this.absenceRatio,
    required this.averageGradesPerMonth,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      presenceCount: json['presenceCount'] ?? 0,
      absenceCount: json['absenceCount'] ?? 0,
      absenceRatio: (json['absenceRation'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, (value as num).toDouble()),
      ) ?? {},
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