// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//   static final NotificationService _notificationService = NotificationService._internal();
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   factory NotificationService() {
//     return _notificationService;
//   }
//
//   NotificationService._internal();
//
//   Future<void> initNotification() async {
//     // Android Initialization
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('app_icon');
//
//     // iOS Initialization (if needed)
//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onSelectNotification: selectNotification,
//     );
//   }
//
//   Future<void> showNotification(int id, String title, String body) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       channelDescription: 'your_channel_description',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );
//
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );
//
//     await flutterLocalNotificationsPlugin.show(
//       id,
//       title,
//       body,
//       platformChannelSpecifics,
//     );
//   }
//
//   Future selectNotification(String payload) async {
//     // Handle notification tapped logic here
//     if (payload != null) {
//       print('notification payload: $payload');
//     }
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'notification_service.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     // Initialize notifications
//     NotificationService().initNotification();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Notification Template'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () {
//               // Show a notification
//               NotificationService().showNotification(0, 'Hello, Flutter!', 'This is a notification template.');
//             },
//             child: Text('Show Notification'),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
