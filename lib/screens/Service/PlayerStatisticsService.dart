import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:footballproject/models/PlayerStatistics.dart';

class PlayerStatisticsService {
  static PlayerStatistics getLastGameStatistics() {
    // Example hardcoded data for the last game
    return PlayerStatistics(
      rating: 7.5,
      goals: 2,
      assists: [
        PieChartSectionData(value: 30, color: Colors.orange),
        PieChartSectionData(value: 40, color: Colors.green),
        PieChartSectionData(value: 20, color: Colors.blue),
        PieChartSectionData(value: 10, color: Colors.purple),
      ],
    );
  }

  static PlayerStatistics getSeasonStatistics() {
    // Example hardcoded data for the season
    return PlayerStatistics(
      rating: 8.5,
      goals: 15,
      assists: [
        PieChartSectionData(value: 25, color: Colors.orange),
        PieChartSectionData(value: 35, color: Colors.green),
        PieChartSectionData(value: 20, color: Colors.blue),
        PieChartSectionData(value: 20, color: Colors.purple),
      ],
    );
  }
}
