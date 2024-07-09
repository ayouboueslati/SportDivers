import 'package:fl_chart/fl_chart.dart';

class PlayerStatistics {
  double rating;
  double goals;
  List<PieChartSectionData> assists;

  PlayerStatistics({
    required this.rating,
    required this.goals,
    required this.assists,
  });
}
