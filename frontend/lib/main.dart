import 'dart:developer';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:bbb/components/streak_calendar.dart';
import 'package:bbb/firebase_options.dart';
import 'package:bbb/pages/ChallengeView/joined_challeng_page.dart';
import 'package:bbb/pages/CollectionView/collection_detail_page.dart';
import 'package:bbb/pages/NewMonthView/2_new_month_overview.dart';
import 'package:bbb/pages/NewMonthView/3_new_today_page.dart';
import 'package:bbb/pages/NewMonthView/4_new_excerise_page.dart';
import 'package:bbb/pages/NewMonthView/new_day_completed_page.dart';
import 'package:bbb/pages/Notification/notifications_page.dart';
import 'package:bbb/pages/ProfileAndSettings/language_page.dart';
import 'package:bbb/pages/ProfileAndSettings/myprofile_page.dart';
import 'package:bbb/pages/Tools/GraphsReports/graph_and_reports_page.dart';
import 'package:bbb/pages/Tools/bonus_library_page.dart';
import 'package:bbb/pages/Tools/equipment_library_page.dart';
import 'package:bbb/pages/Tools/exercise_history.dart';
import 'package:bbb/pages/Tools/exercise_library_page.dart';
import 'package:bbb/pages/Tools/nutrition_calculator_page.dart';
import 'package:bbb/pages/Tools/recalculate_page.dart';
import 'package:bbb/pages/WatchTutorial/watch_tutorial.dart';
import 'package:bbb/pages/calendar_page.dart';
import 'package:bbb/pages/email_verification_page.dart';
import 'package:bbb/pages/join_the_challenge.dart';
import 'package:bbb/pages/login_page.dart';
import 'package:bbb/pages/main_page.dart';
import 'package:bbb/pages/meet_our_staff.dart';
import 'package:bbb/pages/on_boarding_page.dart';
import 'package:bbb/pages/register_page.dart';
import 'package:bbb/pages/reset_password_page.dart';
import 'package:bbb/pages/streak_page.dart';
import 'package:bbb/providers/data_provider.dart';
import 'package:bbb/providers/location_provider.dart';
import 'package:bbb/providers/main_page_provider.dart';
import 'package:bbb/providers/program_info_provider.dart';
import 'package:bbb/providers/user_data_provider.dart';
import 'package:bbb/values/app_routes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'pages/NewMonthView/Database/month_database.dart';
import 'pages/NewMonthView/Database/month_prefrence.dart';
import 'pages/NewMonthView/Providers/month_provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  log('notificationResponse :::::::::::::::::: ${notificationResponse.payload}');
}

BuildContext? c;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preferences.init();
  await DatabaseHelper().initDatabase();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();

  const androidInitializationSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosInitializationSetting = DarwinInitializationSettings();
  const initSettings = InitializationSettings(android: androidInitializationSetting, iOS: iosInitializationSetting);
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    onDidReceiveNotificationResponse: (details) {
      // var data = jsonDecode(details.payload!);
      // log('details :::::::::::::::::: ${details.payload}');
      // Navigator.pushNamed(c!, '/exercise', arguments: [
      //   data['name'] as String,
      //   '1',
      //   data['id'].toString(),
      // ]);
    },
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final dataProvider = ChangeNotifierProvider<DataProvider>(
    create: (context) => DataProvider(),
  );

  final userDataProvider = ChangeNotifierProvider<UserDataProvider>(
    create: (context) => UserDataProvider(),
  );
  final programInfoProvider = ChangeNotifierProvider<ProgramInfoProvider>(
    create: (context) => ProgramInfoProvider(),
  );

  final locationProvider = ChangeNotifierProvider<LocationProvider>(
    create: (context) => LocationProvider(),
  );

  final mainPageProvider = ChangeNotifierProvider<MainPageProvider>(
    create: (context) => MainPageProvider(),
  );
  final monthProvider = ChangeNotifierProvider<MonthProvider>(
    create: (context) => MonthProvider(),
  );

  // ignore: unused_field
  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  Future<void> _initDeepLinkListener() async {
    // Initialize AppLinks and handle the deep link in the callback
    // _appLinks = AppLinks(
    //   onAppLink: (Uri uri, String? stringUri) {
    //     _handleDeepLink(uri.toString());
    //   },
    // );
    _appLinks = AppLinks();
    _appLinks.uriLinkStream.listen((Uri uri) {
      _handleDeepLink(uri.toString());
    });
  }

  void _handleDeepLink(String? deepLink) {
    if (deepLink != null) {
      // Parse the deep link and navigate to the appropriate page
      Uri uri = Uri.parse(deepLink);
      // Check if the scheme and host are correct
      if (uri.scheme == 'https' && uri.host == 'bbbdev1.wpenginepowered.com') {
        // Example: Check the path
        Navigator.of(context).pushNamed(AppRoutes.mainScreen);
      } else {
        // Handle unsupported schemes or hosts if necessary
        debugPrint('Unsupported deep link: $deepLink');
      }
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    c = context;
    return MultiProvider(
      providers: [dataProvider, userDataProvider, locationProvider, mainPageProvider, programInfoProvider, monthProvider],
      child: MaterialApp(
        locale: !kReleaseMode ? DevicePreview.locale(context) : null,
        builder: !kReleaseMode ? DevicePreview.appBuilder : null,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.onBoardingScreen,
        routes: {
          AppRoutes.onBoardingScreen: (context) => const OnBoardingPage(),
          AppRoutes.mainScreen: (context) => const MainPage(
                welcomeDescription: '',
                welcomeImageUrl: '',
              ),
          AppRoutes.loginScreen: (context) => const LoginPage(
                image: '',
              ),
          AppRoutes.registerScreen: (context) => const RegisterPage(),
          AppRoutes.nutritionCalculatorScreen: (context) => const NutritionCalculatorPage(),
          AppRoutes.graphAndReportsScreen: (context) => const GraphAndReportsPage(),
          AppRoutes.exerciseHistory: (context) => const ExerciseHistoryPage(),
          AppRoutes.exerciseLibraryScreen: (context) => const ExerciseLibraryPage(),
          AppRoutes.equipmentLibraryScreen: (context) => const EquipmentLibraryPage(),
          AppRoutes.bonusLibraryScreen: (context) => const BonusLibraryPage(),
          AppRoutes.passwordresetScreen: (context) => const ResetPasswordScreen(),
          AppRoutes.emailVerificationScreen: (context) => const EmailVerificationScreen(),
          AppRoutes.dayOverviewScreen: (context) => const NewDayOverviewPage(),
          AppRoutes.todayScreen: (context) => const NewTodayPage(),
          AppRoutes.dayCompletedScreen: (context) => const NewDayCompletedPage(),
          AppRoutes.exerciseScreen: (context) => const NewExercisePage(),
          AppRoutes.recalculateScreen: (context) => const RecalculatePage(),
          AppRoutes.streakScreen: (context) => const StreakPage(),
          AppRoutes.calendarScreen: (context) => const CalendarPage(),
          AppRoutes.watchTutorialScreen: (context) => const WatchTutorial(),
          AppRoutes.myProfileScreen: (context) => const MyProfilePage(),
          AppRoutes.languageScreen: (context) => const LanguagePage(),
          AppRoutes.streakCalendarScreen: (context) => const StreakCalendarPage(),
          AppRoutes.notificationsScreen: (context) => const NotificationsPage(),
          AppRoutes.joinChallengeScreen: (context) => const JoinTheChallengePage(),
          AppRoutes.meetOurStaff: (context) => const MeetOurStaff(),
          AppRoutes.joinedChallengeScreen: (context) => const JoinedChallengePage(),
          AppRoutes.collectionDetailScreen: (context) => const CollectionDetailPage(),
        },
      ),
    );
  }
}
