import 'package:bbb/components/button_widget.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StreakPage extends StatefulWidget {
  const StreakPage({super.key});

  @override
  State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage> {
  List<String> streakHistory = [
    '2024-07-19T20:00:00.000+00:00',
    '2024-07-21T20:00:00.000+00:00',
    '2024-07-22T20:00:00.000+00:00',
    '2024-07-23T20:00:00.000+00:00',
  ];

  List<Map<String, String>> dynamicStreakArr = [];
  List<String> streakDays = [];

  @override
  void initState() {
    super.initState();
    _calculateStreakDays();
  }

  DateTime _utcToZoneTime(String dateString) {
    final date = DateTime.parse(dateString);
    return date.toLocal();
  }

  void _calculateStreakDays() {
    final today = DateTime.now();
    final DateFormat fullDayFormat = DateFormat('EEEE');
    final DateFormat shortDayFormat = DateFormat('EEE');

    final List<Map<String, String>> last7Days = List.generate(7, (i) {
      final date = today.subtract(Duration(days: 6 - i));
      return {
        'day': shortDayFormat.format(date),
        'id': fullDayFormat.format(date),
      };
    });

    setState(() {
      dynamicStreakArr = last7Days;
    });

    final List<DateTime> parseAllStreakDates =
        streakHistory.map((date) => _utcToZoneTime(date)).toList();
    final List<String> currentWeekStreaks =
        parseAllStreakDates.map((date) => fullDayFormat.format(date)).toList();

    setState(() {
      streakDays = currentWeekStreaks;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil.verticalScale(1),
            bottom: ScreenUtil.verticalScale(3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil.horizontalScale(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: ScreenUtil.horizontalScale(9),
                      height: ScreenUtil.horizontalScale(9),
                      decoration: const BoxDecoration(
                        color: Color(0XFFd18a9b),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => {Navigator.pop(context)},
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            size: ScreenUtil.verticalScale(2.5),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: ScreenUtil.horizontalScale(8),
                          height: ScreenUtil.horizontalScale(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => {Navigator.pop(context)},
                              icon: Icon(
                                Icons.local_fire_department_outlined,
                                size: ScreenUtil.verticalScale(3),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil.horizontalScale(1),
                        ),
                        Text(
                          '5',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: ScreenUtil.verticalScale(2),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: ScreenUtil.horizontalScale(50),
                        height: ScreenUtil.horizontalScale(50),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => {Navigator.pop(context)},
                            icon: Icon(
                              Icons.local_fire_department_outlined,
                              size: ScreenUtil.verticalScale(20),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.verticalScale(6),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: dynamicStreakArr.map((day) {
                      final isChecked = streakDays.contains(day['id']);
                      final isToday =
                          DateFormat.EEEE().format(DateTime.now()) == day['id'];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil.horizontalScale(1.2),
                        ),
                        child: streakCircle(day['day']!, isChecked, isToday),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: ScreenUtil.verticalScale(2),
                  ),
                  Text(
                    '5 Days Streak!',
                    style: TextStyle(
                      fontSize: ScreenUtil.verticalScale(3.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil.verticalScale(0.5),
                  ),
                  SizedBox(
                    width: ScreenUtil.horizontalScale(70),
                    child: Text(
                      'You are on fire, keep the flame lit everyday, Today was awesome',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ScreenUtil.verticalScale(2),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.horizontalScale(5)),
                child: ButtonWidget(
                  text: 'CONTINUE',
                  textColor: Colors.white,
                  color: AppColors.primaryColor,
                  onPress: () {},
                  isLoading: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget streakCircle(String day, bool isChecked, bool isToday) {
    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            color: isToday ? AppColors.primaryColor : Colors.black,
            fontSize: ScreenUtil.verticalScale(2),
          ),
        ),
        SizedBox(
          height: ScreenUtil.verticalScale(0.5),
        ),
        Container(
          width: ScreenUtil.horizontalScale(10),
          height: ScreenUtil.horizontalScale(10),
          decoration: BoxDecoration(
            color: isChecked
                ? AppColors.primaryColor
                : Colors.blueAccent.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => {},
              icon: Icon(
                isChecked ? Icons.check : Icons.close,
                size: ScreenUtil.verticalScale(3),
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
