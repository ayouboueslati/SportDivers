import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sportdivers/Provider/ChampionatProviders/ArbitratorProvider.dart';
import 'package:sportdivers/Provider/ChampionatProviders/ConvocationProvider.dart';
import 'package:sportdivers/Provider/ChampionatProviders/MatchDetailsProvider.dart';
import 'package:sportdivers/Provider/ChampionatProviders/MatchListByRoleProvider.dart';
import 'package:sportdivers/Provider/ChampionatProviders/MatchListProvider.dart';
import 'package:sportdivers/Provider/ChampionatProviders/PlayersClassementProvider.dart';
import 'package:sportdivers/Provider/ChampionatProviders/TeamsClassementProvider.dart';
import 'package:sportdivers/Provider/ChampionatProviders/TournamentProvider.dart';
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
import 'package:sportdivers/models/tournamentModel.dart';
import 'package:sportdivers/screens/Championnat/MatchsByRole/ArbitrageMatch.dart';
import 'package:sportdivers/screens/Championnat/TeamsClassementPage.dart';
import 'package:sportdivers/screens/Championnat/MatchsByRole/ConvocationPage.dart';
import 'package:sportdivers/screens/Championnat/MatchDetails.dart';
import 'package:sportdivers/screens/Championnat/MatchsByRole/MatchListByRole.dart';
import 'package:sportdivers/screens/Championnat/MatchsList.dart';
import 'package:sportdivers/screens/Championnat/TournamentsPage.dart';
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
import 'package:sportdivers/service/NotificationService.dart';
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

  // Initialize NotificationService
  await NotificationService().init();

  initializeDateFormatting('fr_FR', null).then((_) => runApp(MyApp()));
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
        ChangeNotifierProvider(create: (_) => TournamentProvider()),
        ChangeNotifierProvider(create: (_) => MatchListProvider()),
        ChangeNotifierProvider(create: (_) => MatchListProviderByRole()),
        ChangeNotifierProvider(create: (_) => ConvocationProvider()),
        ChangeNotifierProvider(create: (_) => TournamentRankingProvider()),
        ChangeNotifierProvider(create: (_) => PlayerRankingProvider()),
        ChangeNotifierProvider(create: (_) => MatchDetailsProvider()),
        // ChangeNotifierProvider(create: (_) => MatchActionProvider()),
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

            // home:  ArbitratorMatchPage(),
            // home: MatchListPage(),
            //home:ClassementPage(),
            // home:ArbitratorMatchPage(),

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
              TournamentScreen.id: (context) => TournamentScreen(),
            //  TeamsClassementPage.id: (context) => TeamsClassementPage(),
              //  MatchDetailsPage.id: (context) => MatchDetailsPage(match: ,),
              MatchListPage.id: (context) {
                final tournament =
                    ModalRoute.of(context)!.settings.arguments as Tournament;
                return MatchListPage(tournament: tournament);
              },
              MatchListByRolePage.id: (context) {
                final tournament =
                    ModalRoute.of(context)!.settings.arguments as Tournament;
                return MatchListByRolePage(tournament: tournament);
              },
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
