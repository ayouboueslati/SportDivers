import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/AuthProvider/auth_provider.dart';
import 'package:sportdivers/Provider/EventProvider/eventProvider.dart';
import 'package:sportdivers/Provider/ProfileProvider/profileProvider.dart';
import 'package:sportdivers/components/AppDrawer.dart';
import 'package:sportdivers/components/BtmNavBar.dart';
import 'package:sportdivers/models/event.dart';
import 'package:sportdivers/screens/Survey/PollsPage.dart';
import 'package:sportdivers/screens/Tutorials/tutorials.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_icons.dart';
import 'package:sportdivers/screens/dashboard/StatDashboardAdhrt.dart';
import 'package:sportdivers/screens/dashboard/StatDashboardCoach.dart';
import 'package:sportdivers/screens/messages/MessagesList.dart';
import 'package:sportdivers/screens/Payment/PaymentScreen.dart';
import 'package:sportdivers/screens/profile/ProfileScreen.dart';
import 'package:sportdivers/screens/report/ReportSheet1.dart';
import 'package:sportdivers/screens/report/fetchTicket.dart';
import 'package:sportdivers/screens/training/TimeTableCoach.dart';
import 'package:sportdivers/screens/training/timetable.dart';
import 'package:intl/intl.dart';

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
  late final List<Widget> _widgetOptions;

  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _selectedIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).fetchEvents();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserData();
    });
  }

  void _fetchUserData() async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final token = authProvider.token;

    if (token != null) {
      await profileProvider.fetchUserData(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: Builder(
      //     builder: (BuildContext context) {
      //       return IconButton(
      //         icon: const Icon(Icons.menu, color: Colors.black),
      //         onPressed: () {
      //           Scaffold.of(context).openDrawer();
      //         },
      //       );
      //     },
      //   ),
      //   actions: [
      //     Padding(
      //       padding: EdgeInsets.only(right: width / 36),
      //       child: CircleAvatar(
      //         radius: height / 32,
      //         backgroundImage: widget.userData != null &&
      //                 widget.userData?['profilePicture'] != null
      //             ? NetworkImage(widget.userData?['profilePicture'])
      //             : null,
      //         backgroundColor: Colors.transparent,
      //         child: widget.userData != null &&
      //                 widget.userData?['profilePicture'] != null
      //             ? null
      //             : Container(
      //                 decoration: BoxDecoration(
      //                   shape: BoxShape.circle,
      //                   gradient: LinearGradient(
      //                     begin: Alignment.topLeft,
      //                     end: Alignment.bottomRight,
      //                     colors: [Colors.blue[300]!, Colors.blue[900]!],
      //                   ),
      //                 ),
      //                 child: Icon(
      //                   Icons.person,
      //                   size: height * 0.035,
      //                   color: Colors.white,
      //                 ),
      //               ),
      //       ),
      //     )
      //   ],
      // ),
      // drawer: AppDrawer(role: widget.role),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: [
          _buildHomePage(height, width),
          widget.role == 'TEACHER'
              ? StatDashboardCoach()
              : StatDashboardAdhrt(),
          widget.role == 'TEACHER'
              ? TrainingScheduleScreenCoach()
              : TrainingScheduleScreen(),
          MessagesList(role: widget.role),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  Widget _buildHomePage(double height, double width) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height / 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Salut, ${widget.userData?['firstName'] ?? 'User'}",
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                    Text("Bienvenue Chez SportDivers",
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
                CircleAvatar(
                  radius: height / 32,
                  backgroundImage: widget.userData != null &&
                          widget.userData?['profilePicture'] != null
                      ? NetworkImage(widget.userData?['profilePicture'])
                      : null,
                  backgroundColor: Colors.transparent,
                  child: widget.userData != null &&
                          widget.userData?['profilePicture'] != null
                      ? null
                      : Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.blue[300]!, Colors.blue[900]!],
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            size: height * 0.035,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
            SizedBox(height: height / 36),
            Text("Menu",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            //SizedBox(height: height / 150),
            _buildTaskGrid(height, width),
            SizedBox(height: height / 26),
            Row(
              children: [
                Text("Événements à venir",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Spacer(),
                Text("Voir tout",
                    style: TextStyle(fontSize: 12, color: Colors.blue[900])),
              ],
            ),
            SizedBox(height: height / 36),
            _buildEventList(height, width),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomTabBar(double height, double width) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: width / 30, vertical: height / 36),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)]),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DailozSvgimage.task,
                height: height / 30,
                width: width / 30,
              ),
              activeIcon: SvgPicture.asset(
                DailozSvgimage.taskfill,
                height: height / 30,
                width: width / 30,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(DailozSvgimage.graphic,
                  height: height / 32, width: width / 32),
              activeIcon: SvgPicture.asset(
                DailozSvgimage.graphicfill,
                height: height / 34,
                width: width / 34,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DailozSvgimage.folder,
                height: height / 32,
                width: width / 32,
              ),
              activeIcon: SvgPicture.asset(
                DailozSvgimage.folderfill,
                height: height / 32,
                width: width / 32,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DailozSvgimage.home,
                height: height / 30,
                width: width / 30,
              ),
              activeIcon: SvgPicture.asset(
                DailozSvgimage.homefill,
                height: height / 35,
                width: width / 35,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildTaskGrid(double height, double width) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      crossAxisSpacing: width / 36,
      mainAxisSpacing: height / 56,
      children: [
        // _buildTaskCard(
        //     'Calendrier',
        //     "assets/images/icons/chat.png",
        //     Colors.blue[100]!,
        //     TrainingScheduleScreen.id,
        //     TrainingScheduleScreenCoach.id),
        // _buildTaskCard('Messages', "assets/images/icons/chat.png",
        //     Colors.purple[100]!, MessagesList.id, MessagesList.id),
        _buildTaskCard('Video', "assets/images/icons/film.png",
            Colors.blue[100]!, VideoApp.id, VideoApp.id),
        _buildTaskCard('Assistance', "assets/images/icons/caution.png",
            Colors.orange[100]!, ReportPage.id, ReportPage.id),
        if (widget.role != 'TEACHER') ...[
          _buildTaskCard('Sondages', "assets/images/icons/phone.png",
              Colors.red[100]!, PollSurveyPage.id, PollSurveyPage.id),
          _buildTaskCard('Paiements', "assets/images/icons/payment.png",
              Colors.teal[100]!, PaymentScreen.id, PaymentScreen.id),
        ],
        _buildTaskCard('Profil', "assets/images/icons/employee.png",
            Colors.green[100]!, ProfileScreen1.id, ProfileScreen1.id),
        _buildTaskCard('Tickets', "assets/images/icons/byod.png",
            Colors.purple[100]!, TicketsScreen.id, TicketsScreen.id),
      ],
    );
  }

  Widget _buildTaskCard(String title, String image, Color color,
      String studentRoute, String teacherRoute) {
    return InkWell(
      onTap: () {
        String route = widget.role == 'TEACHER' ? teacherRoute : studentRoute;
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 60,
                width: 60,
              ),
              //  Icon(icon, size: 40, color: Colors.blue[900]),
              SizedBox(height: 16),
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900])),
              Text("Appuyez pour voir",
                  style: TextStyle(fontSize: 12, color: Colors.blue[900])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventList(double height, double width) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        if (eventProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (eventProvider.error.isNotEmpty) {
          return Center(child: Text(eventProvider.error));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: eventProvider.events.length,
            itemBuilder: (context, index) {
              return _buildEventCard(
                  context, eventProvider.events[index], height, width);
            },
          );
        }
      },
    );
  }

  Widget _buildEventCard(
      BuildContext context, Event event, double height, double width) {
    return Container(
      margin: EdgeInsets.only(bottom: height / 46),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey[100],
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 66),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(event.titre,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Spacer(),
                Icon(Icons.more_vert, color: Colors.grey),
              ],
            ),
            SizedBox(height: height / 200),
            Text("${_formatDate(event.start)} - ${_formatDate(event.end)}",
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(height: height / 66),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width / 36, vertical: height / 120),
                    child: Text("Événement",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('MMM d, y').format(date);
  }
}
