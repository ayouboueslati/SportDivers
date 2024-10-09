import 'package:flutter/material.dart';
import 'package:sportdivers/Menu/MenuPage.dart';
import 'package:sportdivers/Provider/ProfileProvider/profileProvider.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
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
  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final userData = profileProvider.userData?['userData'];
        return Drawer(
          child: Container(
            color: DailozColor.bggray,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, userData),
                  _buildDrawerItems(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic>? userData) {
    return Container(
      height: height * 0.25,
      decoration: BoxDecoration(
        color: DailozColor.appcolor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(width / 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SportDivers',
                style: TextStyle(
                  color: DailozColor.white,
                  fontSize: height * 0.035,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  CircleAvatar(
                    radius: height * 0.05,
                    backgroundImage:
                    userData != null && userData['profilePicture'] != null
                        ? NetworkImage(userData['profilePicture'])
                        : null,
                    backgroundColor: DailozColor.white,
                    child:
                    userData != null && userData['profilePicture'] != null
                        ? null
                        : Icon(Icons.person,
                        size: height * 0.05,
                        color: DailozColor.appcolor),
                  ),
                  SizedBox(width: width * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData?['firstName'] ?? 'User Name',
                          style: TextStyle(
                            color: DailozColor.white,
                            fontSize: height * 0.024,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: height * 0.005),
                        Text(
                          userData?['email'] ?? 'user@example.com',
                          style: TextStyle(
                            color: DailozColor.white.withOpacity(0.8),
                            fontSize: height * 0.018,
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

  Widget _buildDrawerItems(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Menu",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: height * 0.024,
              color: DailozColor.black,
            ),
          ),
          SizedBox(height: height / 36),
          _buildDrawerItem(context, 'Menu principal', Icons.home, HomePage.id, DailozColor.lightblue),
          _buildDrawerItem(context, 'Profil', Icons.account_box_rounded, ProfileScreen1.id, DailozColor.lightgreen),
          _buildDrawerItem(context, 'Calendrier', Icons.calendar_month_outlined, TrainingScheduleScreen.id, DailozColor.purple),
          _buildDrawerItem(context, 'Mes tickets', Icons.history, TicketsScreen.id, DailozColor.lightred),
          _buildDrawerItem(context, 'Messages', Icons.mark_unread_chat_alt_outlined, MessagesList.id, DailozColor.lightblue),
          _buildDrawerItem(context, 'Video', Icons.video_camera_back_outlined, VideoApp.id, DailozColor.lightgreen),
          _buildDrawerItem(context, 'Assistance', Icons.report_problem_outlined, ReportPage.id, DailozColor.purple),
          _buildDrawerItem(
            context,
            'Dashboard',
            Icons.poll,
            widget.role == 'TEACHER' ? StatDashboardCoach.id : StatDashboardAdhrt.id,
            DailozColor.lightred,
          ),
          _buildDrawerItem(context, 'Changer mot de passe', Icons.password, ResetPasswordScreen.id, DailozColor.lightblue),
          SizedBox(height: height / 36),
          _buildDrawerItem(context, 'Déconnexion', Icons.exit_to_app, '/logout', DailozColor.lightred, isLogout: true),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, IconData icon, String route, Color color, {bool isLogout = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: height / 46),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color,
      ),
      child: ListTile(
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
        leading: Icon(icon, color: DailozColor.black, size: height * 0.032),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: height * 0.022,
            color: DailozColor.black,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: height * 0.02, color: DailozColor.black),
      ),
    );
  }

  void _logout(BuildContext context) async {
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.logoutUser();
    Navigator.pushReplacementNamed(context, LoginScreen.id);
  }
}