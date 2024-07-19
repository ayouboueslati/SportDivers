import 'package:flutter/material.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:footballproject/screens/Tutorials/tutorials.dart';
import 'package:footballproject/bottomNavBar.dart';
import 'package:footballproject/screens/auth/login_screen.dart';
import 'package:footballproject/screens/auth/otp/forgotpassword.dart';
import 'package:footballproject/screens/dashboard/CoachDashboardScreen.dart';
import 'package:footballproject/screens/messages/friend_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      ],
      child: MaterialApp(
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
          VideoApp.id: (context) => VideoApp(),
          //VideoListScreen.id: (context) => VideoListScreen(),
        },
      ),
    );
  }
}
