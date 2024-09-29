import 'package:flutter/material.dart';
import 'package:sportdivers/Menu/MenuPage.dart';
import 'package:sportdivers/Provider/ProfileProvider/profileProvider.dart';
import 'package:sportdivers/screens/dashboard/StatDashboardAdhrt.dart';
import 'package:sportdivers/screens/dashboard/StatDashboardCoach.dart';
import 'package:sportdivers/screens/messages/MessagesList.dart';
import 'package:sportdivers/screens/profile/ProfileScreen.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/AuthProvider/auth_provider.dart';
import 'package:sportdivers/screens/Tutorials/tutorials.dart';
import 'package:sportdivers/screens/auth/reset_password/resetPasswordWebView.dart';
import 'package:sportdivers/screens/report/ReportSheet1.dart';
import 'package:sportdivers/screens/report/fetchTicket.dart';
import 'package:sportdivers/screens/training/timetable.dart';
import 'package:sportdivers/screens/auth/login_screen.dart';

class AppDrawer extends StatefulWidget {
  final String role;

  const AppDrawer({Key? key, required this.role}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final userData = profileProvider.userData?['userData'];
        return Drawer(
          child: Column(
            children: [
              _buildHeader(context, userData),
              Expanded(
                child: _buildDrawerItems(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic>? userData) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight * 0.20,
      decoration: BoxDecoration(
        color: Colors.blue[900],
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SportDivers',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenHeight * 0.035,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Row(
                children: [
                  CircleAvatar(
                    radius: screenHeight * 0.045,
                    backgroundImage: userData != null && userData['profilePicture'] != null
                        ? NetworkImage(userData['profilePicture'])
                        : null,
                    backgroundColor: Colors.white,
                    child: userData != null && userData['profilePicture'] != null
                        ? null
                        : Icon(Icons.person, size: screenHeight * 0.05, color: Colors.blue[900]),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData?['firstName'] ?? 'User Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight * 0.024,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData?['email'] ?? 'user@example.com',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: screenHeight * 0.018,
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
      ),
    );
  }

  Widget _buildDrawerItems(BuildContext context,) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildDrawerItem(context, 'Menu principal', Icons.home, HomePage.id),
        _buildDrawerItem(context, 'Profil', Icons.account_box_rounded, ProfileScreen1.id),
        _buildDrawerItem(context, 'Calendrier', Icons.calendar_month_outlined, TrainingScheduleScreen.id),
        _buildDrawerItem(context, 'Mes tickets', Icons.history, TicketsScreen.id),
        _buildDrawerItem(context, 'Messages', Icons.mark_unread_chat_alt_outlined, MessagesList.id),
        _buildDrawerItem(context, 'Video', Icons.video_camera_back_outlined, VideoApp.id),
        _buildDrawerItem(context, 'Assistance', Icons.report_problem_outlined, ReportPage.id),
        _buildDrawerItem(context, 'Changer mot de passe', Icons.password, ResetPasswordScreen.id),
        //_buildDrawerItem(context, 'Dashboard', Icons.poll, StatDashboardAdhrt.id),
        _buildDrawerItem(
            context,
            'Dashboard',
            Icons.poll,
            widget.role == 'TEACHER' ? StatDashboardCoach.id : StatDashboardAdhrt.id
        ),
        // _buildDrawerItem(context, 'Classement', Icons.leaderboard, '/standings'),
        // _buildDrawerItem(context, 'Fantasy Leagues', Icons.emoji_events, '/fantasy'),
        const Divider(),
        // _buildDrawerItem(context, 'Paramètres', Icons.settings, '/settings'),
        _buildDrawerItem(context, 'Déconnexion', Icons.exit_to_app, '/logout', isLogout: true),
      ],
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, IconData icon, String route, {bool isLogout = false}) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Icon(icon, color: Colors.blue[900], size: screenHeight * 0.032),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: screenHeight * 0.022,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (isLogout) {
          _logout(context);
        } else if (route == ProfileScreen1.id) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen1(),
            ),
          );
        } else {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  void _logout(BuildContext context) async {
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.logoutUser();
    Navigator.pushReplacementNamed(context, LoginScreen.id);
  }
}
