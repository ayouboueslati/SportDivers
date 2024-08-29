import 'package:flutter/material.dart';
import 'package:footballproject/Provider/ChatProvider/ChatRoomsProvider.dart';
import 'package:footballproject/Provider/ChatProvider/FindMessagesProvider.dart';
import 'package:footballproject/Provider/ChatProvider/SendMsgProvider.dart';
import 'package:footballproject/Provider/ChatProvider/usersChat.dart';
import 'package:footballproject/Provider/PollsProvider/PollsProvider.dart';
import 'package:footballproject/Provider/UserProvider/userProvider.dart';
import 'package:footballproject/models/session.dart';
import 'package:footballproject/screens/Payment/PaymentScreen.dart';
import 'package:footballproject/screens/Service/SocketService.dart';
import 'package:footballproject/screens/auth/reset_password/PasswordResetSuccess.dart';
import 'package:footballproject/screens/messages/MessagesList.dart';
import 'package:footballproject/screens/training/rateSession.dart';
import 'package:provider/provider.dart';
import 'package:footballproject/Menu/MenuPage.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:footballproject/Provider/EventProvider/eventProvider.dart';
import 'package:footballproject/Provider/ProfileProvider/profileProvider.dart';
import 'package:footballproject/Provider/ReportPorivder/ticketProvider.dart';
import 'package:footballproject/Provider/TrainingSchedule/trainingScheduleProvider.dart';
import 'package:footballproject/screens/Survey/PollsPage.dart';
import 'package:footballproject/screens/auth/login_screen.dart';
import 'package:footballproject/screens/auth/reset_password/forgotpassword.dart';
import 'package:footballproject/screens/auth/reset_password/resetPasswordWebView.dart';
import 'package:footballproject/screens/dashboard/dashboard.dart';
import 'package:footballproject/screens/messages/friend_list.dart';
import 'package:footballproject/screens/dashboard/CoachDashboardScreen.dart';
import 'package:footballproject/screens/Tutorials/tutorials.dart';
import 'package:footballproject/screens/profile/CardPicture.dart';
import 'package:footballproject/screens/profile/profile.dart';
import 'package:footballproject/screens/rating/RatingCoachPage.dart';
import 'package:footballproject/screens/rating/ratingPage.dart';
import 'package:footballproject/screens/report/ReportSheet1.dart';
import 'package:footballproject/screens/report/fetchTicket.dart';
import 'package:footballproject/screens/training/timetable.dart';
import 'package:footballproject/bottomNavBar.dart';
import 'package:footballproject/Provider/VideosProvider/videoProvider.dart';

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
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProxyProvider<AuthenticationProvider, TicketsProvider>(
          create: (_) => TicketsProvider(null), // Initially null
          update: (context, authProvider, previousTicketsProvider) =>
              TicketsProvider(authProvider)..fetchTickets(),
        ),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => usersChatProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => MessagesProvider()),
        ChangeNotifierProvider(create: (_) => ChatRoomsProvider()),
        ChangeNotifierProvider(create: (_) => PollProvider()),

        // Add other providers if needed
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
            routes: {
              LoginScreen.id: (context) => LoginScreen(onLoginPressed: () {
                    Navigator.pushReplacementNamed(context, HomePage.id);
                  }),
              ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
              FriendScreen.id: (context) => const FriendScreen(),
              CoachDashboardScreen.id: (context) => CoachDashboardScreen(),
              VideoApp.id: (context) => VideoApp(),
              TrainingScheduleScreen.id: (context) => TrainingScheduleScreen(),
              ProfileScreen.id: (context) => ProfileScreen(),
              ReportPage.id: (context) => ReportPage(),
              PollSurveyPage.id: (context) => PollSurveyPage(),
              RatingPage.id: (context) => RatingPage(),
              TicketsScreen.id: (context) => TicketsScreen(),
              RatingCoachPage.id: (context) => RatingCoachPage(),
              DashboardScreen.id: (context) => DashboardScreen(),
              MessagesList.id: (context) =>  MessagesList(),
              PaymentScreen.id: (context) =>  PaymentScreen(),
              PasswordResetSuccessScreen.id: (context) =>
                  PasswordResetSuccessScreen(),
              ResetPasswordScreen.id: (context) =>
                  ResetPasswordScreen(token: authProvider.token ?? ''),
              HomePage.id: (context) =>
                  HomePage(role: authProvider.accountType),
              // RateSessionDialog.id: (context) {
              //   final session =
              //       ModalRoute.of(context)!.settings.arguments as Session;
              //   return RateSessionDialog(session: session, sessionDate:sel,);
              // },
            },
            onGenerateRoute: (settings) {
              if (settings.name == HomePage.id) {
                final role = authProvider.accountType;
                return MaterialPageRoute(
                  builder: (context) {
                    return HomePage(role: role);
                  },
                );
              }
              // Return a default route or error screen
              return null;
            },
          );
        },
      ),
    );
  }
}
