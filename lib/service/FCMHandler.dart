import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Function? _onNewPoll;

  Future<void> init({Function? onNewPoll}) async {
    _onNewPoll = onNewPoll;

    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // Initialize local notifications
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
     // const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
       // iOS: initializationSettingsIOS,
      );
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

      // Handle incoming messages when the app is in the foreground
      FirebaseMessaging.onMessage.listen(_handleMessage);

      // Handle notification opening app from background state
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _handleMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      _showNotification(message);
    }

    // If the message is about a new poll, call the callback
    if (message.data['type'] == 'new_poll') {
      _onNewPoll?.call();
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'new_polls_channel',
      'New Polls',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title ?? 'New Poll',
      message.notification?.body ?? 'A new poll is available!',
      platformChannelSpecifics,
      payload: 'new_poll',
    );
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}