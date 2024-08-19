import 'package:flutter/material.dart';
import 'package:footballproject/Menu/MenuPage.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:footballproject/Provider/ProfileProvider/profileProvider.dart';
import 'package:footballproject/Provider/ReportPorivder/ticketProvider.dart';
import 'package:footballproject/Provider/TrainingSchedule/trainingSchedule.dart';
import 'package:footballproject/screens/Survey/PollsPage.dart';
import 'package:footballproject/screens/auth/login_screen.dart';
import 'package:footballproject/screens/auth/reset_password/forgotpassword.dart';
import 'package:footballproject/screens/messages/friend_list.dart';
import 'package:footballproject/screens/dashboard/CoachDashboardScreen.dart';
import 'package:footballproject/screens/Tutorials/tutorials.dart';
import 'package:footballproject/screens/profile/CardPicture.dart';
import 'package:footballproject/screens/profile/profile.dart';
import 'package:footballproject/screens/rating/RatingCoachPage.dart';
import 'package:footballproject/screens/rating/ratingPage.dart';
import 'package:footballproject/screens/report/ReportSheet1.dart';
import 'package:footballproject/screens/training/timetable.dart';
import 'package:provider/provider.dart';
import 'package:footballproject/bottomNavBar.dart';
import 'Provider/VideosProvider/videoProvider.dart';

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
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => TrainingScheduleProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
      ],
      child: Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Football Project',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
           initialRoute: LoginScreen.id,
            //home: ReportPage(),
             //home: PollSurveyPage(),
            //home: RatingPage(),

            routes: {
              LoginScreen.id: (context) => LoginScreen(onLoginPressed: () {
                    Navigator.pushReplacementNamed(context, HomePage.id);
                  }),
              ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
              FriendScreen.id: (context) => const FriendScreen(),
              CoachDashboardScreen.id: (context) => CoachDashboardScreen(),
              VideoApp.id: (context) => VideoApp(),
              TrainingScheduleScreen.id: (context) => TrainingScheduleScreen(),
              ProfileScreen.id: (context) =>  ProfileScreen(),
              ReportPage.id: (context) =>  ReportPage(),
              PollSurveyPage.id: (context) =>  PollSurveyPage(),
              RatingPage.id: (context) =>  RatingPage(),
              RatingCoachPage.id: (context) =>  RatingCoachPage(),
              // Add other routes if needed
            },
            onGenerateRoute: (settings) {
              // Handle dynamic routing based on user role
              if (settings.name == HomePage.id) {
                final role = authProvider
                    .accountType; // Assuming accountType is the role
                return MaterialPageRoute(
                  builder: (context) {
                    return HomePage(role: role);
                  },
                );
              }
              return null; // Return null if no matching route
            },
            // onGenerateRoute: (settings) {
            //   // Handle dynamic routing based on user role
            //   if (settings.name == Bottomnavbar.id) {
            //     final role = authProvider
            //         .accountType; // Assuming accountType is the role
            //     return MaterialPageRoute(
            //       builder: (context) {
            //         return Bottomnavbar(role: role);
            //       },
            //     );
            //   }
            //   return null; // Return null if no matching route
            // },
          );
        },
      ),
    );
  }
}
