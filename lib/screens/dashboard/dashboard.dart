import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:footballproject/Menu/MenuPage.dart';

class DashboardScreen extends StatelessWidget {
  static String id = 'dashboard_screen';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xff4B4B87),
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                HomePage.id,
                (Route<dynamic> route) => false,
              );
            },
          ),
          title: Text(
            "STATS",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xff4B4B87),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color(0xff4B4B87).withOpacity(.2),
                ),
                child: TabBar(
                  unselectedLabelColor: Color(0xff4B4B87),
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xff4B4B87)),
                  tabs: [
                    Tab(text: "Day"),
                    Tab(text: "Week"),
                    Tab(text: "Month"),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    _buildStatCard(
                      context,
                      title: "Rate",
                      value: '56%',
                      icon: Icons.stacked_bar_chart_sharp,
                      color: Color(0xff2AC3FF),
                      chart: _buildRatingsChart(),
                    ),
                    _buildStatCard(
                      context,
                      title: "Goals",
                      value: '12',
                      icon: Icons.sports_soccer,
                      color: Color(0xffFF6968),
                      chart: _buildGoalsChart(),
                    ),
                    _buildStatCard(
                      context,
                      title: "Assists",
                      value: '7',
                      icon: Icons.group,
                      color: Color(0xff7A54FF),
                      chart: _buildAssistsChart(),
                    ),
                    _buildStatCard(
                      context,
                      title: "Absences",
                      value: '2',
                      icon: Icons.close,
                      color: Color(0xffFF8F61),
                      chart: _buildAbsenceChart(),
                    ),
                    _buildStatCard(
                      context,
                      title: "Payment",
                      value: '150 TND',
                      icon: Icons.attach_money_rounded,
                      color: Color(0xff2AC3FF),
                      chart: _buildPaymentChart(),
                    ),
                    _buildStatCard(
                      context,
                      title: "Reports",
                      value: '3',
                      icon: Icons.warning,
                      color: Color(0xff96DA45),
                      chart: _buildReportsChart(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Widget chart,
  }) {
    return InkWell(
      onTap: () => _showStatDialog(context, title, chart),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 30),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStatDialog(BuildContext context, String title, Widget chart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            height: 250,
            width: 300,
            child: chart,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Build the Ratings Chart (Pie Chart example)
  Widget _buildRatingsChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: Colors.orange,
            value: 85,
            title: '85%',
            radius: 40,
            titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: Colors.grey[300],
            value: 15,
            title: '',
            radius: 40,
          ),
        ],
      ),
    );
  }

  // Placeholder methods for other charts
  Widget _buildGoalsChart() {
    return Container(); // Replace with actual chart
  }

  Widget _buildAssistsChart() {
    return Container(); // Replace with actual chart
  }

  Widget _buildPaymentChart() {
    return Container(); // Replace with actual chart
  }

  Widget _buildReportsChart() {
    return Container(); // Replace with actual chart
  }

  Widget _buildAbsenceChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: 2, // Absences
                color: Colors.red,
              ),
              BarChartRodData(
                toY: 8, // Presences
                color: Colors.green,
              ),
            ],
          ),
        ],
        titlesData: FlTitlesData(
          show: false,
        ),
        gridData: FlGridData(
          show: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
      ),
    );
  }
}
