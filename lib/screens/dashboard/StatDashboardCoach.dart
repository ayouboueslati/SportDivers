import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:sportdivers/Provider/DashboardProvider/DashboardCoachProvider.dart';
import 'package:sportdivers/models/DashboardCoachModel.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

class StatDashboardCoach extends StatefulWidget {
  static String id = 'Stat_Dashboard_Coach';

  const StatDashboardCoach({Key? key}) : super(key: key);

  @override
  _StatDashboardCoachState createState() => _StatDashboardCoachState();
}

class _StatDashboardCoachState extends State<StatDashboardCoach> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 30)),
    end: DateTime.now(),
  );

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: _dateRange,
      locale:const Locale('fr', 'FR'),
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

      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      String startDate = formatter.format(_dateRange.start);
      String endDate = formatter.format(_dateRange.end);

      Provider.of<DashboardCoachProvider>(context, listen: false)
          .fetchDashboardStats(startDate: startDate, endDate: endDate);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      String startDate = formatter.format(_dateRange.start);
      String endDate = formatter.format(_dateRange.end);

      Provider.of<DashboardCoachProvider>(context, listen: false)
          .fetchDashboardStats(startDate: startDate, endDate: endDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text(
      //     'Dashboard',
      //     style: hsSemiBold.copyWith(fontSize: 18),
      //   ),
      //   backgroundColor: DailozColor.white,
      //   elevation: 0,
      //   leading: Padding(
      //     padding: const EdgeInsets.all(10),
      //     child: InkWell(
      //       splashColor: DailozColor.transparent,
      //       highlightColor: DailozColor.transparent,
      //       onTap: () => Navigator.pop(context),
      //       child: Container(
      //         height: height / 20,
      //         width: height / 20,
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(5),
      //           color: DailozColor.white,
      //           boxShadow: [
      //             BoxShadow(
      //               color: DailozColor.grey.withOpacity(0.3),
      //               blurRadius: 5,
      //             )
      //           ],
      //         ),
      //         child: Padding(
      //           padding: EdgeInsets.only(left: width / 56),
      //           child: Icon(
      //             Icons.arrow_back_ios,
      //             size: 18,
      //             color: DailozColor.black,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: Consumer<DashboardCoachProvider>(
        builder: (context, dashboardProvider, child) {
          if (dashboardProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (dashboardProvider.error.isNotEmpty) {
            return Center(child: Text('Error: ${dashboardProvider.error}'));
          } else if (dashboardProvider.stats != null) {
            final stats = dashboardProvider.stats!;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width/36, vertical: height/36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25,),
                    _buildDateRangePicker(),
                    SizedBox(height: height/36),
                    _buildPriorityCard(stats),
                    SizedBox(height: height/36),
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
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: DailozColor.bggray,
      ),
      child: InkWell(
        onTap: () => _selectDateRange(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtrer par date',
              style: hsSemiBold.copyWith(fontSize: 18, color: DailozColor.black),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatter.format(_dateRange.start),
                  style: hsRegular.copyWith(fontSize: 16, color: DailozColor.textblue),
                ),
                Icon(Icons.arrow_forward, color: DailozColor.textblue),
                Text(
                  formatter.format(_dateRange.end),
                  style: hsRegular.copyWith(fontSize: 16, color: DailozColor.textblue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityCard(DashboardStats stats) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: DailozColor.bggray,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPriorityItem('Groupes', stats.groupsCount, DailozColor.lightred),
              _buildPriorityItem('Séances', stats.sessionsCount, DailozColor.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityItem(String title, int count, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.2),
          child: Text(
            count.toString(),
            style: hsSemiBold.copyWith(fontSize: 24, color: color),
          ),
        ),
        SizedBox(height: 8),
        Text(title, style: hsRegular.copyWith(fontSize: 14, color: DailozColor.textgray)),
      ],
    );
  }

  Widget _buildAverageGradesCard(List<MonthlyGrade> grades) {
    // Sort the grades by date to ensure they're in chronological order
    grades.sort((a, b) => a.month.compareTo(b.month));

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: DailozColor.bggray,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Moyenne note par mois',
            style: hsSemiBold.copyWith(fontSize: 18, color: DailozColor.black),
          ),
          SizedBox(height: 20),
          Container(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: hsRegular.copyWith(fontSize: 12, color: DailozColor.textgray),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < grades.length) {
                          final parts = grades[value.toInt()].month.split('-');
                          if (parts.length == 2) {
                            final year = int.parse(parts[0]);
                            final month = int.parse(parts[1]);
                            final date = DateTime(year, month);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('MMM').format(date),
                                style: hsRegular.copyWith(fontSize: 14, color: DailozColor.textgray),
                              ),
                            );
                          }
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: grades.length.toDouble() - 1,
                minY: 0,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: grades.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.value);
                    }).toList(),
                    isCurved: true,
                    color: DailozColor.textblue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: DailozColor.textblue.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}