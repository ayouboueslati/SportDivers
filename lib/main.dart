import 'package:flutter/material.dart';
import 'package:sportdivers/Provider/ChatProvider/ChatRoomsProvider.dart';
import 'package:sportdivers/Provider/ChatProvider/FindMessagesProvider.dart';
import 'package:sportdivers/Provider/ChatProvider/SendMsgProvider.dart';
import 'package:sportdivers/Provider/ChatProvider/usersChat.dart';
import 'package:sportdivers/Provider/DashboardProvider/DashboardCoachProvider.dart';
import 'package:sportdivers/Provider/DashboardProvider/DashboardProvider.dart';
import 'package:sportdivers/Provider/PollsProvider/PollsProvider.dart';
import 'package:sportdivers/Provider/ProfileProvider/EditProfileProvider.dart';
import 'package:sportdivers/Provider/TrainingSchedule/CoachDashboardProvider.dart';
import 'package:sportdivers/Provider/UserProvider/userProvider.dart';
import 'package:sportdivers/components/Loader.dart';
import 'package:sportdivers/screens/Championnat/MatchsList.dart';
import 'package:sportdivers/screens/Payment/PaymentScreen.dart';
import 'package:sportdivers/screens/Service/SocketService.dart';
import 'package:sportdivers/screens/auth/reset_password/PasswordResetSuccess.dart';
import 'package:sportdivers/screens/dashboard/StatDashboardAdhrt.dart';
import 'package:sportdivers/screens/dashboard/StatDashboardCoach.dart';
import 'package:sportdivers/screens/messages/MessagesList.dart';
import 'package:sportdivers/screens/profile/ModifyProfile.dart';
import 'package:sportdivers/screens/profile/ProfileScreen.dart';
import 'package:sportdivers/screens/training/TimeTableCoach.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Menu/MenuPage.dart';
import 'package:sportdivers/Provider/AuthProvider/auth_provider.dart';
import 'package:sportdivers/Provider/EventProvider/eventProvider.dart';
import 'package:sportdivers/Provider/ProfileProvider/profileProvider.dart';
import 'package:sportdivers/Provider/ReportPorivder/ticketProvider.dart';
import 'package:sportdivers/Provider/TrainingSchedule/trainingScheduleProvider.dart';
import 'package:sportdivers/screens/Survey/PollsPage.dart';
import 'package:sportdivers/screens/auth/login_screen.dart';
import 'package:sportdivers/screens/auth/reset_password/forgotpassword.dart';
import 'package:sportdivers/screens/auth/reset_password/resetPasswordWebView.dart';
import 'package:sportdivers/screens/Tutorials/tutorials.dart';
import 'package:sportdivers/screens/rating/RatingCoachPage.dart';
import 'package:sportdivers/screens/rating/ratingPage.dart';
import 'package:sportdivers/screens/report/ReportSheet1.dart';
import 'package:sportdivers/screens/report/fetchTicket.dart';
import 'package:sportdivers/screens/training/timetable.dart';
import 'package:sportdivers/Provider/VideosProvider/videoProvider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sportdivers/service/FCMHandler.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  print('------------------------------------------------------');
  print(await FirebaseMessaging.instance.getToken());
  print('------------------------------------------------------');
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
        ChangeNotifierProvider(create: (_) => EditProfileProvider()),
        ChangeNotifierProvider(create: (_) => ApiProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => DashboardCoachProvider()),
        ChangeNotifierProvider(create: (_) => PollProvider()),
        Provider<FCMHandler>(
          create: (context) {
            final fcmHandler = FCMHandler();
            fcmHandler.init(onNewPoll: () {
              // This callback will be called when a new poll notification is received
              Provider.of<PollProvider>(context, listen: false).fetchPollData();
            });
            return fcmHandler;
          },
        ),
      ],
      child: Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {

          // // Get the FCM token when the user logs in
          // if (authProvider.isAuthenticated) {
          //   Provider.of<FCMHandler>(context, listen: false).getToken().then((token) {
          //     // Send this token to your server
          //     authProvider.updateFCMToken(token);
          //   });
          // }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SprotDivers',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),

            locale: Locale('fr', 'FR'),
            // Set French locale
            supportedLocales: [
              Locale('en', 'US'), // Add other locales if needed
              Locale('fr', 'FR'),
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            home: CustomLoaderPage(),

            //tests
          //  home: MatchListPage(),
            //initialRoute: LoginScreen.id,
            routes: {
              LoginScreen.id: (context) => LoginScreen(onLoginPressed: () {
                    Navigator.pushReplacementNamed(context, HomePage.id);
                  }),
              ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
              //FriendScreen.id: (context) => const FriendScreen(),
              //CoachDashboardScreen.id: (context) => CoachDashboardScreen(),
              VideoApp.id: (context) => VideoApp(),
              TrainingScheduleScreen.id: (context) => TrainingScheduleScreen(),
              TrainingScheduleScreenCoach.id: (context) =>
                  TrainingScheduleScreenCoach(),
              //ProfileScreen.id: (context) => ProfileScreen(),
              ProfileScreen1.id: (context) => ProfileScreen1(),
              ReportPage.id: (context) => ReportPage(),
              PollSurveyPage.id: (context) => PollSurveyPage(),
              RatingPage.id: (context) => RatingPage(),
              TicketsScreen.id: (context) => TicketsScreen(),
              RatingCoachPage.id: (context) => RatingCoachPage(),
              MessagesList.id: (context) =>
                  MessagesList(role: authProvider.accountType),
              PaymentScreen.id: (context) => PaymentScreen(),
              EditProfileScreen.id: (context) => EditProfileScreen(),
              PasswordResetSuccessScreen.id: (context) =>
                  PasswordResetSuccessScreen(),
              StatDashboardAdhrt.id: (context) => StatDashboardAdhrt(),
              StatDashboardCoach.id: (context) => StatDashboardCoach(),
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message here
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}
