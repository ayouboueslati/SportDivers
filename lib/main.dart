import 'package:flutter/material.dart';
import 'package:footballproject/bottomNavBar.dart';
import 'package:footballproject/screens/auth/login_screen.dart';
import 'package:footballproject/screens/auth/otp/forgotpassword.dart';
import 'package:footballproject/screens/dashboard/CoachDashboardScreen.dart';
import 'package:footballproject/screens/messages/friend_list.dart';
import 'package:appcenter_sdk_flutter/appcenter_sdk_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppCenter.start(secret: '5d6d517a-f682-404f-aefe-c22577cb8db6');
  FlutterError.onError = (final details) async {
    await AppCenterCrashes.trackException(
      message: details.exception.toString(),
      type: details.exception.runtimeType,
      stackTrace: details.stack,
    );
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Football Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(onLoginPressed: () {
              Navigator.pushReplacementNamed(context, Bottomnavbar.id);
            }),
        ForgotPasswordScreen.id: (context) => const ForgotPasswordScreen(),
        FriendScreen.id: (context) => const FriendScreen(),
        Bottomnavbar.id: (context) => const Bottomnavbar(),
        CoachDashboardScreen.id: (context) => CoachDashboardScreen(),
      },
    );
  }
}
