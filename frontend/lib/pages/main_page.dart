import 'dart:async';

import 'package:bbb/pages/NewMonthView/1_new_month_view.dart';
import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/pages/ProfileAndSettings/profile_settings_page.dart';
import 'package:bbb/pages/Tools/tools_page.dart';
import 'package:bbb/pages/dashboard_page.dart';
import 'package:bbb/providers/data_provider.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

import '../components/streak_calendar.dart';
import '../providers/main_page_provider.dart';
import '../providers/user_data_provider.dart';

class MainPage extends StatefulWidget {
  final bool showWelcomeModal;
  final String welcomeDescription;
  final String welcomeImageUrl;
  const MainPage({
    super.key,
    this.showWelcomeModal = false,
    required this.welcomeDescription,
    required this.welcomeImageUrl,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late UserDataProvider userData;
  late DataProvider? dataProvider;
  late MainPageProvider mainPageProvider;
  late MonthProvider monthProvider;

  VimeoVideoPlayer? vimeoVideoPlayer;
  late List<Widget> _pages;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    mainPageProvider = Provider.of<MainPageProvider>(context, listen: false);
    monthProvider = Provider.of<MonthProvider>(context, listen: false);
    vimeoVideoPlayer = VimeoVideoPlayer(
      // url: 'https://player.vimeo.com/video/953289606',
      // autoPlay: true,
      videoId: "953289606",
    );

    if (widget.showWelcomeModal || widget.welcomeDescription.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _showWelcomeModal();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('hasSeenWelcome', true);
      });
    }

    userData = Provider.of<UserDataProvider>(context, listen: false);

    // _initializeData();
    _startPeriodicUpdate();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async => await _initializeFetchData().then(
        (value) async => await monthProvider.onInit(),
      ),
    );

    _pages = [
      const DashboardPage(),
      const NewMonthView(),
      // const MonthlyViewPage(),
      const ToolsPage(),
      const ProfileSettingsPage(),
      // StreakPage()
      const StreakCalendarPage(),
    ];
  }

  Future<void> _initializeData() async {
    dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider?.fetchCheckoutPoint();
    if (dataProvider?.equipmentCheckpointState == true) {
      Fluttertoast.showToast(
        msg: "New Equipment Data updated!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP_RIGHT,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      dataProvider?.equipmentCheckpointState = false;
    }
    if (dataProvider?.bonusCheckpointState == true) {
      Fluttertoast.showToast(
        msg: "New Bonus data updated!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP_RIGHT,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      dataProvider?.bonusCheckpointState = false;
    }
    if (dataProvider?.workoutCheckpointState == true) {
      Fluttertoast.showToast(
        msg: "New Workout data updated!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP_RIGHT,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // await dataProvider?.fetchMonthWorkouts(3);
      _initializeFetchData();
      dataProvider?.workoutCheckpointState = false;
    }
  }

  Future<void> _initializeFetchData() async {
    debugPrint("this is initial state func");
    dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider?.monthProvider = Provider.of<MonthProvider>(context, listen: false);
    if (dataProvider != null) {
      await dataProvider?.fetchMonthWorkouts(3);
    } else {
      debugPrint("dataProvider is null");
    }
  }

  void _startPeriodicUpdate() {
    _timer = Timer.periodic(
      const Duration(minutes: 1), // Set the interval to 5 minutes
      (Timer timer) {
        _initializeData(); // Call the data initialization method
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _showWelcomeModal() {
    Navigator.pushNamed(context, '/watchtutorial', arguments: {"buttontext": "Go to Dashboard"});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // fully transparent status bar
        statusBarIconBrightness: Brightness.light, // dark icons for light background
      ),
      child: Consumer<MainPageProvider>(
        builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.white,
          extendBody: true,
          bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil.horizontalScale(15),
              vertical: ScreenUtil.verticalScale(2),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil.verticalScale(1),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ScreenUtil.verticalScale(5)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      mainPageProvider.changeTab(0);
                    },
                    icon: Consumer<UserDataProvider>(
                      builder: (context, userData, child) => SvgPicture.asset(
                        'assets/img/1-home.svg',
                        color: value.selectedPage == 0 ? AppColors.primaryColor : Colors.grey,
                        width: ScreenUtil.horizontalScale(8.5),
                        height: ScreenUtil.horizontalScale(8.5),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      mainPageProvider.changeTab(1);
                    },
                    icon: Consumer<UserDataProvider>(
                      builder: (context, userData, child) => SvgPicture.asset(
                        'assets/img/2-calendar.svg',
                        color: value.selectedPage == 1 ? AppColors.primaryColor : Colors.grey,
                        width: ScreenUtil.horizontalScale(8.5),
                        height: ScreenUtil.horizontalScale(8.5),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      mainPageProvider.changeTab(2);
                    },
                    icon: Consumer<UserDataProvider>(
                      builder: (context, userData, child) => SvgPicture.asset(
                        'assets/img/3-statistics.svg',
                        color: value.selectedPage == 2 ? AppColors.primaryColor : Colors.grey,
                        width: ScreenUtil.horizontalScale(8.5),
                        height: ScreenUtil.horizontalScale(8.5),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      mainPageProvider.changeTab(3);
                    },
                    icon: Consumer<UserDataProvider>(
                      builder: (context, userData, child) => SvgPicture.asset(
                        'assets/img/4-account.svg',
                        color: value.selectedPage == 3 ? AppColors.primaryColor : Colors.grey,
                        width: ScreenUtil.horizontalScale(9),
                        height: ScreenUtil.horizontalScale(9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: _pages[value.otherPage > 3 ? value.otherPage : value.selectedPage],
        ),
      ),
    );
  }
}
