import 'package:flutter/material.dart';
import 'package:footballproject/screens/dashboard/CoachDashboardScreen.dart';
import 'package:footballproject/screens/dashboard/dashboard.dart';
import 'package:footballproject/screens/messages/friend_list.dart';
import 'package:footballproject/screens/profile/profile.dart';
import 'package:footballproject/screens/training/timetable.dart';

import '../models/user_model.dart';

class AppDrawer extends StatefulWidget {

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[900],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SportDivers',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'user@example.com',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildDrawerItem(context, 'Home', Icons.home, '/'),
          _buildDrawerItem(
              context, 'Profile', Icons.account_box_rounded, ProfileScreen.id),
          _buildDrawerItem(
              context, 'Calendar', Icons.calendar_month_outlined, '/Calendar'),
          _buildDrawerItem(
              context, 'Chat', Icons.mark_unread_chat_alt_outlined, '/Chat'),
          _buildDrawerItem(
              context, 'Video', Icons.video_camera_back_outlined, '/Video'),
          _buildDrawerItem(context, 'Assistance', Icons.report_problem_outlined,
              '/Assistance'),
          Divider(),
          _buildDrawerItem(
              context, 'Player Stats', Icons.poll, '/player-stats'),
          _buildDrawerItem(
              context, 'Standings', Icons.leaderboard, '/standings'),
          _buildDrawerItem(
              context, 'Fantasy Leagues', Icons.emoji_events, '/fantasy'),
          Divider(),
          _buildDrawerItem(context, 'Settings', Icons.settings, '/settings'),
          _buildDrawerItem(context, 'Logout', Icons.exit_to_app, '/logout'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[900]),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        if (route != '/') {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
