import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:footballproject/screens/dashboard/dashboard.dart';
import 'package:footballproject/screens/messages/chat_screen.dart';
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
      TrainingScheduleScreen(),
      //ChatScreen(user: chatUser),
      FriendScreen(),
      DashboardScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
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
          // andle FAB action
        },
        child: const Icon(Icons.add),
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
