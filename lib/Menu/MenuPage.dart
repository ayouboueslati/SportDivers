import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:footballproject/Provider/EventProvider/eventProvider.dart';
import 'package:footballproject/Provider/ProfileProvider/profileProvider.dart';
import 'package:footballproject/components/AppDrawer.dart';
import 'package:footballproject/models/event.dart';
import 'package:footballproject/screens/Payment/PaymentScreen.dart';
import 'package:footballproject/screens/Survey/PollsPage.dart';
import 'package:footballproject/screens/Tutorials/tutorials.dart';
import 'package:footballproject/screens/dashboard/CoachDashboardScreen.dart';
import 'package:footballproject/screens/messages/MessagesList.dart';
import 'package:footballproject/screens/messages/friend_list.dart';
import 'package:footballproject/screens/profile/profile.dart';
import 'package:footballproject/screens/report/ReportSheet1.dart';
import 'package:footballproject/screens/training/TimeTableCoach.dart';
import 'package:footballproject/screens/training/timetable.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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

    // Initialize Firebase Messaging when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Notification: ${message.notification!.title}');
      }
    });
    // Request permission for notifications on iOS
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      sound: true,
    ).then((settings) {
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else {
        print('User declined or has not accepted permission');
      }
    });
    // Fetch the FCM token
    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM Token: $token");  // Print the token for debugging
      // You can now send this token to your backend to associate with the user
      // or store it for later use
      // For example, send the token to your server:
      // sendTokenToServer(token);
    });
    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Notification: ${message.notification!.title}');
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).fetchEvents();
    });
    _widgetOptions = <Widget>[
      TrainingScheduleScreen(),
      TrainingScheduleScreenCoach(),
      MessagesList(role: widget.role),
    ];

    // Fetch events once the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).fetchEvents();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserData();
    });
  }

  void _fetchUserData() async {
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final token = authProvider.token;

    if (token != null) {
      await profileProvider.fetchUserData(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue[900],
          elevation: 14,
          shadowColor: Colors.blue.withOpacity(0.5),
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
                  _buildSportCardWithRoleBasedRoute(
                    context,
                    'Calendrier',
                    Icons.calendar_today_outlined,
                    TrainingScheduleScreen.id,
                    TrainingScheduleScreenCoach.id,
                  ),
                  _buildSportCard(
                    context,
                    'Messages',
                    Icons.message_outlined,
                    MessagesList.id,
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
                    Icons.support_agent_outlined,
                    ReportPage.id,
                  ),
                  if (widget.role != 'TEACHER') ...[
                    _buildSportCard(
                      context,
                      'Sondages',
                      Icons.poll_outlined,
                      PollSurveyPage.id,
                    ),
                    _buildSportCard(
                      context,
                      'paiements',
                      Icons.payment_outlined,
                      PaymentScreen.id,
                    ),
                  ],
                ],
              ),
              Consumer<EventProvider>(
                builder: (context, eventProvider, child) {
                  if (eventProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (eventProvider.error.isNotEmpty) {
                    return Center(child: Text(eventProvider.error));
                  } else {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                'Événements à venir',
                                style: TextStyle(
                                  fontSize:
                                      constraints.maxWidth < 600 ? 18 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: constraints.maxWidth < 650 ? 260 : 300,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: eventProvider.events.length,
                                itemBuilder: (context, index) {
                                  return _buildEventCard(
                                      context, eventProvider.events[index]);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
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
              // top: -20,
              // right: -20,
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
  Widget _buildSportCardWithRoleBasedRoute(
      BuildContext context,
      String title,
      IconData icon,
      String studentRoute,
      String teacherRoute,
      ) {
    return Card(
      elevation: 15,
      shadowColor: Colors.blue.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: () {
          String route = widget.role == 'TEACHER' ? teacherRoute : studentRoute;
          Navigator.pushNamed(context, route);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              // top: -20,
              // right: -20,
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

  Widget _buildEventCard(BuildContext context, Event event) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        double cardWidth = maxWidth < 700 ? maxWidth * 0.8 : 250.0;
        double imageHeight = cardWidth * 0.6;

        return GestureDetector(
          onTap: () => _showEventDialog(context, event),
          child: Container(
            width: cardWidth,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white, // Make sure the card is white
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3), // Subtle shadow for depth
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 3), // Slightly raise the card
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    'https://sportdivers.tn/storage/${event.image}',
                    height: imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: imageHeight,
                        color: Colors.grey[300],
                        child: const Center(child: Text('Image non disponible')),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.titre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: maxWidth < 600 ? 14 : 16,
                          color: Colors.black87, // Darker text for contrast
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatDate(event.start)} - ${_formatDate(event.end)}',
                        style: TextStyle(
                          color: Colors.grey[600], // Light grey for secondary text
                          fontSize: maxWidth < 600 ? 12 : 14,
                        ),
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



  void _showEventDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://sportdivers.tn/storage/${event.image}',
                      height:  230,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Center(child: Text('Image non disponible')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    event.titre,
                    style:  TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(Icons.calendar_today, 'Début: ${_formatDateTime(event.start)}'),
                  const SizedBox(height: 5),
                  _buildInfoRow(Icons.calendar_today, 'Fin: ${_formatDateTime(event.end)}'),
                  const SizedBox(height: 15),
                   Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    event.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: const Text('Fermer',style: TextStyle(color: Colors.white),),
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[900], size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat(' d/M/y  HH:mm').format(dateTime);
  }
}
