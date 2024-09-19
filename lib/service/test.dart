import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:footballproject/Menu/MenuPage.dart';

class StatDashboardAdhrt extends StatefulWidget {
  static String id = 'dashboard_screen';

  const StatDashboardAdhrt({Key? key}) : super(key: key);

  @override
  _StatDashboardAdhrtState createState() => _StatDashboardAdhrtState();
}

class _StatDashboardAdhrtState extends State<StatDashboardAdhrt> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          shadowColor: Colors.grey.withOpacity(0.3),
          elevation: 5,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
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
                    _buildBIGStatCard(
                      context,
                      title: "Assists",
                      value: '7',
                      icon: Icons.group,
                      color: Color(0xff7A54FF),
                      chart: _buildAssistsChart(),
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
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
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

  Widget _buildBIGStatCard(
      BuildContext context, {
        required String title,
        required String value,
        required IconData icon,
        required Color color,
        required Widget chart,
      }) {
    return InkWell(
      onTap: () => _showStatDialog(context, title, chart),
      child: SizedBox(
        width: 300,
        height: 300,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 30),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
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
