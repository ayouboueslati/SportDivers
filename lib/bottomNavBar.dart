import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:footballproject/screens/Tutorials/tutorials.dart';
import 'package:footballproject/screens/dashboard/CoachDashboardScreen.dart';
import 'package:footballproject/screens/dashboard/dashboard.dart';
import 'package:footballproject/screens/profile/profile.dart';
import 'package:footballproject/screens/training/timetable.dart';
import 'package:footballproject/screens/messages/friend_list.dart';
import 'package:footballproject/screens/report/report_sheet.dart';
import 'package:footballproject/models/user_model.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({Key? key, required this.role, this.userData})
      : super(key: key);

  static const String id = 'bottom_navbar';

  final String role;
  final Map<String, dynamic>? userData;

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _bottomNavIndex = 0;

  late final User chatUser;

  final List<IconData> iconList = [
    Icons.person,
    Icons.calendar_today,
    Icons.chat,
    Icons.dashboard,
  ];

  final List<String> titles = [
    'Profile',
    'Training Schedule',
    'Friends',
    'Dashboard',
  ];

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
      const TrainingScheduleScreen(),
      const FriendScreen(),
      widget.role == 'TEACHER' ? CoachDashboardScreen() : DashboardScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  void _navigateToTutorialScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VideoApp()),
    );
  }

  void _showReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: ReportSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_bottomNavIndex]),
      ),
      body: Stack(
        children: [
          _widgetOptions.elementAt(_bottomNavIndex),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _showReportSheet(context);
              },
              child: const Icon(Icons.report_problem),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToTutorialScreen(context);
        },
        child: const Icon(Icons.video_collection_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: _onItemTapped,
      ),
    );
  }
}
