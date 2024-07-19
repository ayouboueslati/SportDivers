import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:footballproject/screens/Tutorials/tutorials.dart';
import 'package:footballproject/screens/dashboard/dashboard.dart';
import 'package:footballproject/screens/profile/profile.dart';
import 'package:footballproject/screens/training/timetable.dart';
import 'package:footballproject/screens/messages/friend_list.dart';
import 'package:footballproject/models/user_model.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({Key? key}) : super(key: key);

  static const String id = 'bottom_navbar'; // Ensure the id is correctly set

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _bottomNavIndex = 0;

  // Sample user for ChatScreen, replace with actual user data
  final User chatUser = User(
    id: 1,
    name: 'John Doe',
    imageUrl: 'assets/images/user1.png',
    isOnline: true,
  );

  final List<IconData> iconList = [
    Icons.person,
    Icons.calendar_today,
    Icons.group,
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
    _widgetOptions = <Widget>[
      ProfileScreen(),
      const TrainingScheduleScreen(),
      //ChatScreen(user: chatUser),
      const FriendScreen(),
      DashboardScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_bottomNavIndex]),
      ),
      body: _widgetOptions.elementAt(_bottomNavIndex),
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
