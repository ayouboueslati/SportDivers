import 'package:flutter/material.dart';
import 'package:footballproject/components/AppDrawer.dart';
import 'package:footballproject/screens/Survey/PollsPage.dart';
import 'package:footballproject/screens/Tutorials/tutorials.dart';
import 'package:footballproject/screens/dashboard/CoachDashboardScreen.dart';
import 'package:footballproject/screens/dashboard/dashboard.dart';
import 'package:footballproject/screens/messages/friend_list.dart';
import 'package:footballproject/screens/profile/profile.dart';
import 'package:footballproject/screens/report/ReportSheet1.dart';
import 'package:footballproject/screens/report/report_sheet.dart';
import 'package:footballproject/screens/training/timetable.dart';

import '../models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.role, this.userData})
      : super(key: key);

  static const String id = 'home_page';

  final String role;
  final Map<String, dynamic>? userData;

  @override
  _HomePageState createState() => _HomePageState();
}

// Event model class
class Event {
  final String title;
  final String date;
  final String imagePath;

  Event({required this.title, required this.date, required this.imagePath});
}

List<Event> events = [
  Event(title: 'Football Match', date: 'Aug 15, 2024', imagePath: 'assets/images/black-widow.jpg'),
  Event(title: 'Basketball Championship', date: 'Aug 16, 2024', imagePath: 'assets/images/football_logo.jpg'),
  Event(title: 'Tennis Tournament', date: 'Aug 17, 2024', imagePath: 'assets/images/hulk.jpg'),
  Event(title: 'Marathon Run', date: 'Aug 18, 2024', imagePath: 'assets/images/scarlet-witch.jpg'),
];

class _HomePageState extends State<HomePage> {

  late final User chatUser;

  late final List<Widget> _widgetOptions;
  @override
  void initState() {
    super.initState();
    chatUser = User(
      id: int.tryParse(widget.userData?['id']?.toString() ?? '0') ?? 0,
      name: widget.userData?['name'] ?? 'John Doe',
      imageUrl: widget.userData?['imageUrl'] ?? 'assets/images/user1.png',
      isOnline: widget.userData?['isOnline'] ?? true,
    );

    _widgetOptions = <Widget>[
      ProfileScreen(userData: widget.userData),
      TrainingScheduleScreen(),
      const FriendScreen(),
      widget.role == 'TEACHER' ? CoachDashboardScreen() : DashboardScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 65,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue[900],
          elevation: 12,
          shadowColor: Colors.blue.withOpacity(0.4),
          title: const Text(
            'SportDivers',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSportCard(context, 'Calendar', Icons.calendar_month_outlined, TrainingScheduleScreen.id),
                  _buildSportCard(context, 'Chat', Icons.mark_unread_chat_alt_outlined, FriendScreen.id),
                  _buildSportCard(context, 'Video', Icons.video_camera_back_outlined, VideoApp.id),
                  _buildSportCard(context, 'Assistance', Icons.report_problem_outlined, ReportPage.id),
                ],
              ),
              SizedBox(
                height: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Upcoming Events',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return _buildEventCard(
                            title: events[index].title,
                            date: events[index].date,
                            imagePath: events[index].imagePath,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Card(
                margin: const EdgeInsets.all(16),
                elevation: 15,
                shadowColor: Colors.blue.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'More Features',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureButton(context, 'Player Stats', Icons.area_chart, CoachDashboardScreen.id),
                      _buildFeatureButton(context, 'Standings', Icons.poll_outlined, PollSurveyPage.id),
                      _buildFeatureButton(context, 'Fantasy Leagues', Icons.emoji_events, '/fantasy'),
                    ],
                  ),
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }

  Widget _buildSportCard(BuildContext context, String title, IconData icon, String route) {
    return Card(
      elevation: 15,
      shadowColor: Colors.blue.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Icon(
                icon,
                size: 150,
                color: Colors.blue[100]!.withOpacity(0.3),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: Colors.blue[900]),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildEventCard({required String title, required String date, required String imagePath}) {
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0,5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              imagePath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[900]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}
