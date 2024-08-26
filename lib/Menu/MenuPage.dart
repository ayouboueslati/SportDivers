import 'package:flutter/material.dart';
import 'package:footballproject/Provider/EventProvider/eventProvider.dart';
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
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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

    // Fetch events once the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

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
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
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
                  _buildSportCard(
                    context,
                    'Calendrier',
                    Icons.calendar_today_outlined,
                    TrainingScheduleScreen.id,
                  ),
                  _buildSportCard(
                    context,
                    'Messages',
                    Icons.message_outlined,
                    FriendScreen.id,
                  ),
                  _buildSportCard(
                    context,
                    'Vidéo',
                    Icons.video_library_outlined,
                    VideoApp.id,
                  ),
                  _buildSportCard(
                    context,
                    'Assistance',
                    Icons.help_outline,
                    ReportPage.id,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        'Événements à venir',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                    Expanded(
                      child: eventProvider.isLoading
                          ? _buildShimmer()
                          : eventProvider.events.isEmpty
                              ? const Center(
                                  child: Text('Aucun événement trouvé'),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: eventProvider.events.length,
                                  itemBuilder: (context, index) {
                                    final event = eventProvider.events[index];
                                    return _buildEventCard(
                                      title: event.title,
                                      startDate: event.startDate,
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                margin: const EdgeInsets.all(16),
                elevation: 15,
                shadowColor: Colors.blue.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildFeatureButton(
                      context,
                      'Statistiques des joueurs',
                      Icons.pie_chart_outline,
                      DashboardScreen.id,
                    ),
                    _buildFeatureButton(
                      context,
                      'Quiz',
                      Icons.poll_outlined,
                      PollSurveyPage.id,
                    ),
                    _buildFeatureButton(
                      context,
                      'Fantasy Leagues',
                      Icons.star_outline,
                      '/fantasy',
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

  Widget _buildShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5, // Number of shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
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
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 70,
                        height: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSportCard(
      BuildContext context, String title, IconData icon, String route) {
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

  Widget _buildEventCard({
    required String title,
    required DateTime startDate,
  }) {
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
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  '${startDate.day}/${startDate.month}/${startDate.year}',
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

  Widget _buildFeatureButton(
      BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: Icon(icon, color: Colors.blue[900]),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}
