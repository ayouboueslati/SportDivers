import 'package:flutter/material.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:footballproject/screens/Tutorials/tutorials.dart';
import 'package:footballproject/screens/auth/reset_password/resetPasswordWebView.dart';
import 'package:footballproject/screens/messages/friend_list.dart';
import 'package:footballproject/screens/report/ReportSheet1.dart';
import 'package:footballproject/screens/report/fetchTicket.dart';
import 'package:footballproject/screens/training/timetable.dart';
import 'package:provider/provider.dart';
import 'package:footballproject/screens/profile/profile.dart';
import 'package:footballproject/screens/auth/login_screen.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final user = authProvider.userData;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarRadius = screenHeight * 0.05;

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
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundImage:
                          user != null && user['profilePicture'] != null
                              ? NetworkImage(user['profilePicture'])
                              : null,
                      backgroundColor: Colors.white,
                      child: user != null && user['profilePicture'] != null
                          ? null
                          : Icon(
                              Icons.person,
                              size: avatarRadius * 1.4,
                              color: Colors.blue[900],
                            ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authProvider.userData?['firstName'] ?? 'User Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            authProvider.userData?['email'] ??
                                'user@example.com',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: screenHeight * 0.014,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildDrawerItem(context, 'Home', Icons.home, '/'),
          _buildDrawerItem(
              context, 'Profile', Icons.account_box_rounded, ProfileScreen.id),
          _buildDrawerItem(context, 'Calendrier', Icons.calendar_month_outlined,
              TrainingScheduleScreen.id),
          _buildDrawerItem(
              context, 'Mes tickets', Icons.support_agent, TicketsScreen.id),
          _buildDrawerItem(context, 'Messages',
              Icons.mark_unread_chat_alt_outlined, FriendScreen.id),
          _buildDrawerItem(
              context, 'Video', Icons.video_camera_back_outlined, VideoApp.id),
          _buildDrawerItem(context, 'Assistance', Icons.report_problem_outlined,
              ReportPage.id),
          _buildDrawerItem(context, 'Changer mot de passe', Icons.password,
              ResetPasswordScreen.id),
          const Divider(),
          _buildDrawerItem(
              context, 'Statistiques', Icons.poll, '/player-stats'),
          _buildDrawerItem(
              context, 'Classement', Icons.leaderboard, '/standings'),
          _buildDrawerItem(
              context, 'Fantasy Leagues', Icons.emoji_events, '/fantasy'),
          const Divider(),
          _buildDrawerItem(context, 'Paramètres', Icons.settings, '/settings'),
          _buildDrawerItem(context, 'Déconnexion', Icons.exit_to_app, '/logout',
              isLogout: true),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, String title, IconData icon, String route,
      {bool isLogout = false}) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ListTile(
      leading: Icon(icon, color: Colors.blue[900], size: screenHeight * 0.03),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: screenHeight * 0.022,
        ),
      ),
      onTap: () {
        Navigator.pop(context);

        if (isLogout) {
          _logout(context);
        } else if (route == ProfileScreen.id) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                userData:
                    Provider.of<AuthenticationProvider>(context, listen: false)
                        .userData,
              ),
            ),
          );
          print("Navigating to ProfileScreen");
        } else {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  void _logout(BuildContext context) async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.logoutUser();
    Navigator.pushReplacementNamed(context, LoginScreen.id);
  }
}
