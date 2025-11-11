import 'dart:developer';

import 'package:bbb/components/button_widget.dart';
import 'package:bbb/components/common_streak_with_notification.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/new_model.dart';
import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/pages/calender.dart';
import 'package:bbb/providers/data_provider.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StreakCalendarPage extends StatefulWidget {
  const StreakCalendarPage({super.key});

  @override
  State<StreakCalendarPage> createState() => _StreakCalendarPageState();
}

class _StreakCalendarPageState extends State<StreakCalendarPage> {
  DataProvider? dataProvider;
  // UserDataProvider? userData;
  // late Month thisMonthWorkout;
// List<dynamic> monthlyWorkOutSchedule = [];
  int currentMonth = 0;

  List monthOverView = [
    {"month": 'January', "year": "2024"},
    {"month": 'February', "year": "2024"},
    {"month": 'March', "year": "2024"},
    {"month": 'April', "year": "2024"},
    {"month": 'May', "year": "2024"},
    {"month": 'June', "year": "2024"},
    {"month": 'July1', "year": "2024"},
    {"month": 'July2', "year": "2024"},
    {"month": 'August', "year": "2024"},
  ];

  @override
  void initState() {
    // userData = Provider.of<UserDataProvider>(
    //   context,
    //   listen: false,
    // );
    loadUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadUserInfo() async {
    // userData?.loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    log('4. Buttons position on sign in screen');
    var media = MediaQuery.of(context).size;
    // final mainPageProvider = context.watch<MainPageProvider>();
    // DataProvider? dataProvider = Provider.of<DataProvider>(
    //   context,
    //   listen: false,
    // );
    // thisMonthWorkout = dataProvider.workout;

    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 11, 11),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            child: FittedBox(
              child: Container(
                height: media.height / 2,
                width: media.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/back.jpg'),
                    fit: BoxFit.cover,
                    opacity: 1,
                  ),
                ),
                child: SizedBox(
                  height: media.height / 1.8,
                  width: media.width,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: ScreenUtil.horizontalScale(4),
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0XFFd18a9b),
                                shape: BoxShape.circle,
                              ),
                              child: SizedBox(
                                width: ScreenUtil.horizontalScale(10), // Size of the circle
                                height: ScreenUtil.horizontalScale(10),
                                child: IconButton(
                                  padding: EdgeInsets.zero, // Removes the default padding
                                  icon: const Icon(
                                    Icons.keyboard_arrow_left,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // mainPageProvider.changeTab(mainPageProvider.selectedPage);
                                  },
                                  iconSize: ScreenUtil.verticalScale(4), // Icon size remains the same
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Streaks",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil.verticalScale(3),
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                right: ScreenUtil.horizontalScale(4),
                              ),
                              child: SizedBox(
                                width: ScreenUtil.horizontalScale(10), // Size of the circle
                                height: ScreenUtil.horizontalScale(10),
                              ),
                            ),
                            const CommonStreakWithNotification(),
                            SizedBox(
                              width: ScreenUtil.verticalScale(1.15),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil.horizontalScale(12),
                          ),
                          height: media.height * 0.28,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 22,
                              ),
                              Text(
                                'Your current Streak',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil.verticalScale(2.5),
                                  fontWeight: FontWeight.normal,
                                  height: 1,
                                ),
                              ),
                              Builder(builder: (context) {
                                final streak = context.watch<MonthProvider>().streak;
                                log('streak :::::::::::::::::: $streak');
                                return Text(
                                  '$streak',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil.verticalScale(4),
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil.verticalScale(10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                SizedBox(
                  height: media.height / 3.80,
                  width: media.width,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ClipPath(
                      clipper: DiagonalClipper(),
                      child: Container(
                        height: media.height / 11,
                        width: media.width / 6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: media.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ScreenUtil.verticalScale(6)),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: ScreenUtil.verticalScale(4),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(ScreenUtil.horizontalScale(14), 1, ScreenUtil.horizontalScale(14), 0),
                        child: Text(
                          'Mark a day a complete every day to keep the perfect flame streak going.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil.verticalScale(1.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil.verticalScale(2),
                      ),
                      const CustomCalendarWidget(),
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 25.0, //
                          horizontal: ScreenUtil.horizontalScale(10),
                        ),
                        child: Consumer<MonthProvider>(builder: (context, monthProvider, child) {
                          return ButtonWidget(
                            text: monthProvider.todayTitleId.isEmpty ? "Completed" : "Start Your Workout",
                            textColor: Colors.white,
                            onPress: monthProvider.todayTitleId.isEmpty
                                ? null
                                : () {
                                    int? index = monthProvider.monthDataModel?.weeks?[(monthProvider.week ?? 1) - 1].idList?.indexWhere(
                                      (element) {
                                        return element == monthProvider.todayTitleId;
                                      },
                                    );
                                    final dayIndex = int.parse((monthProvider
                                                .monthDataModel?.weeks![(monthProvider.week ?? 1) - 1].dayList?[index ?? 0]
                                                .toString()
                                                .replaceAll("Workout", "")
                                                .replaceAll("Rest", "")
                                                .replaceAll("Day", "")
                                                .replaceAll(" ", "") ??
                                            "0")) -
                                        1;
                                    DayDataModel dayData =
                                        "${monthProvider.monthDataModel?.weeks?[(monthProvider.week ?? 1) - 1].dayList![index ?? 0] ?? ""}"
                                                .toString()
                                                .contains("Workout")
                                            ? monthProvider.monthDataModel!.weeks![(monthProvider.week ?? 1) - 1].days![dayIndex]
                                            : DayDataModel();
                                    monthProvider.overviewCurrentWeek = monthProvider.week ?? 1;
                                    monthProvider.overviewCurrentDay = ((index ?? 1) + 1);
                                    monthProvider.dayDataModel = dayData;
                                    monthProvider.alternateEquipmentType = monthProvider.equipmentType;
                                    monthProvider.weekDataModel = monthProvider.monthDataModel!.weeks![(monthProvider.week ?? 1) - 1];
                                    monthProvider
                                        .updateIsPastWeek(monthProvider.weekStatuses[(monthProvider.week ?? 1) - 1] == WeekType.pastWeek);
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, '/dayOverview');
                                  },
                            color: AppColors.primaryColor,
                            isLoading: false,
                          );
                        }),
                      ),
                      SizedBox(
                        height: ScreenUtil.verticalScale(10),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
