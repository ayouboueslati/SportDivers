import 'package:flutter/material.dart';
import 'package:footballproject/Provider/DashboardProvider/DashboardProvider.dart';
import 'package:footballproject/models/DashboardModel.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class StatDashboardAdhrt extends StatefulWidget {
  static String id = 'dashboard_screen';

  const StatDashboardAdhrt({Key? key}) : super(key: key);

  @override
  _StatDashboardAdhrtState createState() => _StatDashboardAdhrtState();
}

class _StatDashboardAdhrtState extends State<StatDashboardAdhrt> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 7)),
    end: DateTime.now(),
  );

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: _dateRange,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue[900],
            colorScheme: ColorScheme.light(primary: Colors.blue[900]!),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _dateRange) {
      setState(() {
        _dateRange = picked;
      });

      // Format dates as per your requirement (yyyy-MM-dd)
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      String startDate = formatter.format(_dateRange.start);
      String endDate = formatter.format(_dateRange.end);

      // Call the provider with the new date range
      Provider.of<DashboardProvider>(context, listen: false)
          .fetchDashboardStats(startDate: startDate, endDate: endDate);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Format initial dates
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      String startDate = formatter.format(_dateRange.start);
      String endDate = formatter.format(_dateRange.end);

      Provider.of<DashboardProvider>(context, listen: false)
          .fetchDashboardStats(startDate: startDate, endDate: endDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        shadowColor: Colors.grey.withOpacity(0.3),
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, dashboardProvider, child) {
          if (dashboardProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (dashboardProvider.error.isNotEmpty) {
            return Center(child: Text('Error: ${dashboardProvider.error}'));
          } else if (dashboardProvider.stats != null) {
            final stats = dashboardProvider.stats!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDateRangePicker(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSmallCard(
                              'Présence',
                              '${stats.presenceCount}',
                              Icons.check_circle_outline,
                              Colors.green[600]!),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSmallCard(
                              'Absence',
                              '${stats.absenceCount}',
                              Icons.cancel_outlined,
                              Colors.red[600]!),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildAbsenceRatioCard(stats.absenceRatio),
                    const SizedBox(height: 16),
                    _buildAverageGradesCard(stats.averageGradesPerMonth),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildDateRangePicker() {
    final DateFormat formatter = DateFormat('MMM d, yyyy');
    return Card(
      elevation: 15,
      shadowColor: Colors.blue.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: () => _selectDateRange(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtrer par date',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  Icon(Icons.date_range, color: Colors.blue[900]),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Du',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      Text(
                        formatter.format(_dateRange.start),
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward, color: Colors.blue[900]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Au',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      Text(
                        formatter.format(_dateRange.end),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900]),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Appuyez pour modifier la plage de dates',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallCard(
      String title, String number, IconData icon, Color color) {
    return Card(
      elevation: 15,
      shadowColor: Colors.blue.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 16, color: color)),
            const SizedBox(height: 4),
            Text(number,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildAbsenceRatioCard(Map<String, double> absenceRatio) {
    return Card(
      elevation: 15,
      shadowColor: Colors.blue.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Taux D\'absence',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900])),
            const SizedBox(height: 16),
            ...absenceRatio.entries
                .map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blue[900])),
                          Text('${(entry.value * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900])),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAverageGradesCard(List<MonthlyGrade> grades) {
    return Card(
      elevation: 15,
      shadowColor: Colors.blue.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Moyenne Des Notes Par Mois',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900])),
            const SizedBox(height: 20),
            Container(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      //tooltipBgColor: Colors.blueAccent,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${grades[group.x].month}\n${rod.toY.toStringAsFixed(2)}',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          // Custom parsing for "YYYY-MM" format
                          final parts = grades[value.toInt()].month.split('-');
                          if (parts.length == 2) {
                            final year = int.parse(parts[0]);
                            final month = int.parse(parts[1]);
                            final date = DateTime(year, month);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('MMM').format(date),
                                style: const TextStyle(
                                  color: Color(0xff7589a2),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }
                          return const Text(''); // Fallback if parsing fails
                        },
                        reservedSize: 40,
                      ),
                      // axisNameWidget: Text('Mois', style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                                color: Color(0xff7589a2),
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                      // axisNameWidget: Text('Note Moyenne', style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    horizontalInterval: 2,
                    drawVerticalLine: false,
                  ),
                  barGroups: grades
                      .asMap()
                      .entries
                      .map((entry) => BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value.value,
                                color: Colors.lightBlueAccent,
                                width: 22,
                                borderRadius: BorderRadius.circular(4),
                              )
                            ],
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
