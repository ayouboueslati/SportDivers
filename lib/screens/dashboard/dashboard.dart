import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:footballproject/screens/Service/PlayerStatisticsService.dart';
import 'package:footballproject/models/PlayerStatistics.dart';
import 'package:footballproject/screens/dashboard/CoachDashboardScreen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedView = 'Last Game';
  PlayerStatistics? playerStats;

  @override
  void initState() {
    super.initState();
    _updateStatistics();
  }

  void _updateStatistics() {
    setState(() {
      if (selectedView == 'Last Game') {
        playerStats = PlayerStatisticsService.getLastGameStatistics();
      } else if (selectedView == 'Seasonal') {
        playerStats = PlayerStatisticsService.getSeasonStatistics();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var isLargeScreen = screenSize.width > 600;

    return Scaffold(
      body: playerStats == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Statistics View:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<String>(
                        value: selectedView,
                        items: <String>['Last Game', 'Seasonal']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedView = newValue!;
                            _updateStatistics();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ratings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildLineChart(playerStats!.rating),
                  const SizedBox(height: 30),
                  const Text(
                    'Goals',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildBarChart(playerStats!.goals),
                  const SizedBox(height: 30),
                  const Text(
                    'Assists',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildPieChart(playerStats!.assists),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildLineChart(double rating) {
    List<FlSpot> lineChartData = List.generate(8, (index) {
      return FlSpot(index.toDouble(), rating * (index + 1) / 8);
    });

    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: lineChartData,
              isCurved: true,
              barWidth: 4,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(double goals) {
    List<BarChartGroupData> barChartData = List.generate(8, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: goals * (index + 1) / 8,
          ),
        ],
      );
    });

    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          barGroups: barChartData,
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(width: 1),
              left: BorderSide(width: 1),
            ),
          ),
          alignment: BarChartAlignment.spaceAround,
        ),
      ),
    );
  }

  Widget _buildPieChart(List<PieChartSectionData> assists) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: PieChart(
        PieChartData(
          sections: assists,
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          centerSpaceRadius: 40,
          sectionsSpace: 0,
        ),
      ),
    );
  }
}
