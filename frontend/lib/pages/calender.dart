import 'package:bbb/pages/NewMonthView/MonthResponseModel/day_history_model.dart';
import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/providers/data_provider.dart';
import 'package:bbb/providers/user_data_provider.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  UserDataProvider? userData;
  DataProvider? dataProvider;

  @override
  void initState() {
    super.initState();
    dataProvider = Provider.of<DataProvider>(
      context,
      listen: false,
    );

    userData = Provider.of<UserDataProvider>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(65, 15, 65, 10),
            child: Text(
              'Mark a day a complete every day to keep the perfect flame streak going.',
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: ScreenUtil.verticalScale(2.2),
                fontWeight: FontWeight.normal,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const CustomCalendarWidget(),
        ],
      ),
    );
  }
}

class CustomCalendarWidget extends StatefulWidget {
  const CustomCalendarWidget({super.key});

  @override
  State<CustomCalendarWidget> createState() => _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  MonthProvider? monthProvider;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    monthProvider = Provider.of<MonthProvider>(context, listen: false);
  }

  // void _onLeftArrowTap() {
  //   setState(() {
  //     _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
  //   });
  // }
  //
  // void _onRightArrowTap() {
  //   setState(() {
  //     _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
  //   });
  // }
  //
  // String _getFormattedDate() {
  //   return DateFormat.yMMMM().format(_focusedDay);
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(12)),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       IconButton(
          //         icon: const Icon(Icons.arrow_back_ios, size: 20, color: AppColors.primaryColor),
          //         onPressed: _onLeftArrowTap,
          //       ),
          //       Text(
          //         _getFormattedDate(),
          //         style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
          //       ),
          //       IconButton(
          //         icon: const Icon(Icons.arrow_forward_ios_rounded, size: 20, color: AppColors.primaryColor),
          //         onPressed: _onRightArrowTap,
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(8)),
            child: Card(
              color: Colors.grey.shade50,
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  child: TableCalendar(
                    rowHeight: 40.0,
                    daysOfWeekHeight: 20.0,
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    // onDaySelected: (selectedDay, focusedDay) {
                    //   setState(() {
                    //     _selectedDay = selectedDay;
                    //   });
                    // },
                    // onPageChanged: (focusedDay) {
                    //   setState(() {
                    //     _focusedDay = focusedDay;
                    //   });
                    // },
                    // calendarFormat: CalendarFormat.month,
                    // availableCalendarFormats: const {
                    //   CalendarFormat.month: 'Month',
                    // },
                    headerStyle: HeaderStyle(
                      headerPadding: const EdgeInsets.only(bottom: 10),
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: const Icon(Icons.arrow_back_ios_rounded, size: 20, color: AppColors.primaryColor),
                      rightChevronIcon: const Icon(Icons.arrow_forward_ios_rounded, size: 20, color: AppColors.primaryColor),
                      titleTextFormatter: (date, locale) => DateFormat.yMMMM().format(date),
                      titleTextStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                    ),
                    calendarStyle: const CalendarStyle(
                      // selectedDecoration: BoxDecoration(
                      //   color: Colors.blue,
                      //   shape: BoxShape.circle,
                      // ),
                      // todayDecoration: BoxDecoration(
                      //   color: Colors.orange,
                      //   shape: BoxShape.circle,
                      // ),
                      defaultTextStyle: TextStyle(fontSize: 12.0),
                      weekendTextStyle: TextStyle(fontSize: 12.0),
                      outsideTextStyle: TextStyle(fontSize: 10.0),
                    ),
                    calendarBuilders: CalendarBuilders(
                      todayBuilder: (context, day, focusedDay) => _buildDayState(day),
                      // disabledBuilder: (context, date, _) {
                      //   return _buildDayState(date);
                      // },
                      outsideBuilder: (context, date, _) {
                        return _buildDayState(date);
                      },
                      defaultBuilder: (context, date, _) {
                        return _buildDayState(date);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildDayState(DateTime date) {
    DateTime? oldestStartDate =
        monthProvider?.monthLocalDataModel.map((e) => DateTime.parse(e.monthStartDate!)).reduce((a, b) => a.isBefore(b) ? a : b);
    List<DayHistoryModel> data = monthProvider!.decodedData();
    bool isCurrentDay = date.year == DateTime.now().year && date.month == DateTime.now().month && date.day == DateTime.now().day;

    if (data.isEmpty) {
      if (isCurrentDay) {
        return _buildCurrentWorkoutDay(date);
      } else if (oldestStartDate!.isBefore(date) && DateTime.now().isAfter(date)) {
        return _buildCustomDayCircle(date, Colors.blue);
      }
    }

    for (var day in data) {
      final workoutDate = day.endTime!;
      if ((workoutDate.day == date.day && workoutDate.month == date.month && workoutDate.year == date.year)) {
        if (day.status == Status.completed) {
          return _buildCustomDayCircle(date, AppColors.primaryColor);
        } else if (day.status == Status.skipped) {
          return _buildCustomDayCircle(date, Colors.blue);
        }
      }
    }

    if (isCurrentDay) {
      return _buildCurrentWorkoutDay(date);
    }

    if (oldestStartDate!.isBefore(date) && DateTime.now().isAfter(date)) {
      return _buildCustomDayCircle(date, Colors.blue);
    }

    return null;
  }

  Widget _buildCustomDayCircle(DateTime date, Color circleColor) {
    return Container(
      alignment: Alignment.center,
      width: 28.0,
      height: 28.0,
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor, // Set the color based on state
      ),
      child: Text(
        '${date.day}', // Display the day number
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.white, // Text color white inside the circle
        ),
      ),
    );
  }

  Widget _buildCurrentWorkoutDay(DateTime date) {
    return Container(
      alignment: Alignment.center,
      width: 28.0,
      height: 28.0,
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: AppColors.primaryColor), // Set the color based on state
      ),
      child: Text(
        '${date.day}', // Display the day number
        style: const TextStyle(
          fontSize: 14.0,
          color: AppColors.primaryColor, // Text color white inside the circle
        ),
      ),
    );
  }
}
