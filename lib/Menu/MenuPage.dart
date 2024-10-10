import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/AuthProvider/auth_provider.dart';
import 'package:sportdivers/Provider/EventProvider/eventProvider.dart';
import 'package:sportdivers/Provider/ProfileProvider/profileProvider.dart';
import 'package:sportdivers/components/AppDrawer.dart';
import 'package:sportdivers/components/BtmNavBar.dart';
import 'package:sportdivers/models/event.dart';
import 'package:sportdivers/screens/Survey/PollsPage.dart';
import 'package:sportdivers/screens/Tutorials/tutorials.dart';
import 'package:sportdivers/screens/auth/login_screen.dart';
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
  //late final List<Widget> _widgetOptions;

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
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                    const Text("Bienvenue Chez SportDivers",
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
                GestureDetector(
                  onTap: () => _showProfileMenu(context),
                  child: CircleAvatar(
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
                ),
              ],
            ),
            SizedBox(height: height / 36),
            const Text(
              "Menu",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            _buildTaskGrid(height, width),
            SizedBox(height: height / 26),
           const Row(
              children: [
                const Text("Événements à venir",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                //const Spacer(),
                // Text("Voir tout",
                //     style: TextStyle(fontSize: 12, color: Colors.blue[900])),
              ],
            ),
            // SizedBox(height: height / 36),
            _buildEventList(height, width),
          ],
        ),
      ),
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
        } else if (eventProvider.events.isEmpty) {
          return Center(child: Text("Aucun événement à venir"));
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
    return GestureDetector(
      onTap: () => _showEventDetails(context, event),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                'https://sportdivers.tn/storage/${event.image}',
                height: height / 4,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: height / 4,
                  color: Colors.grey[300],
                  child: Icon(Icons.error, color: Colors.red, size: 50),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.titre,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16, color: Colors.blue[900]),
                      SizedBox(width: 6),
                      Text(
                        event.formattedDateRange,
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 60,
                    child: Html(
                      data: event.shortDescription,
                      style: {
                        "body": Style(
                          fontSize: FontSize(14),
                          color: Colors.grey[600],
                          maxLines: 3,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (event.limit != null)
                        Text(
                          "Limite: ${event.limit} participants",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold),
                        ),
                      Text(
                        "Inscrits: ${event.rented}",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventDetails(BuildContext context, Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  event.titre,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Image.network(
                  'https://sportdivers.tn/storage/${event.image}',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue[900]),
                    SizedBox(width: 8),
                    Text(
                      event.formattedDateRange,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "Description",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Html(
                  data: event.description,
                  style: {
                    "body": Style(fontSize: FontSize(14)),
                  },
                ),
                if (event.limit != null) ...[
                  SizedBox(height: 16),
                  Text(
                    "Limite de participants: ${event.limit}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
                // SizedBox(height: 24),
                // ElevatedButton(
                //   onPressed: () {
                //     // TODO: Implement event registration logic
                //     Navigator.pop(context);
                //   },
                //   child: Text("S'inscrire à l'événement"),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.blue[900],
                //     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 110, 15, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      color: Colors.white70,
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(
              Icons.person_outline_rounded,
              color: Colors.blue[900],
            ),
            title: Text(
              'Profil',
              style: TextStyle(color: Colors.blue[900]),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, ProfileScreen1.id);
            },
          ),
        ),
        // PopupMenuItem(
        //   child: ListTile(
        //     leading: Icon(Icons.settings),
        //     title: Text('Settings'),
        //     onTap: () {
        //       Navigator.pop(context);
        //       // Add navigation to Settings screen here
        //     },
        //   ),
        // ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.blue[900],
            ),
            title: Text(
              'Déconnexion',
              style: TextStyle(color: Colors.blue[900]),
            ),
            onTap: () {
              _logout(context);
            },
          ),
        ),
      ],
    );
  }

  void _logout(BuildContext context) async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.logoutUser();
    Navigator.pushReplacementNamed(context, LoginScreen.id);
  }
}
