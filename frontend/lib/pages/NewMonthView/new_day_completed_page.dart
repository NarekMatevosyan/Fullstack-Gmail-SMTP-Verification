import 'package:bbb/components/activity_line_chart.dart';
import 'package:bbb/components/button_widget.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/day_history_model.dart';
import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewDayCompletedPage extends StatefulWidget {
  const NewDayCompletedPage({super.key});

  @override
  State<NewDayCompletedPage> createState() => _NewDayCompletedPageState();
}

class _NewDayCompletedPageState extends State<NewDayCompletedPage> {
  MonthProvider? monthProvider;

  DateTime today = DateTime.now();
  List<DayHistoryModel> data = [];
  double totalWeight = 0;
  String time = "";

  bool loader = true;

  @override
  void initState() {
    monthProvider = Provider.of<MonthProvider>(context, listen: false);

    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) async => await monthProvider?.fetchAllDayStatusLocalData().then((value) => onInit()));
    super.initState();
  }

  List<DateTime> dateList = [];
  List<String> formattedDates = [];

  onInit() async {
    time = "";
    totalWeight = 0;

    data = monthProvider!.decodedData();
    DateTime oneWeekAgo = today.subtract(const Duration(days: 6));
    dateList = List.generate(7, (index) => oneWeekAgo.add(Duration(days: index)));
    formattedDates = dateList.map((date) => DateFormat('yyyy-MM-dd').format(date)).toList();

    int totalWorkoutDuration = 0;
    monthProvider?.allDayHistoryModel.forEach(
      (element) {
        if (element.endTime != null) {
          if (DateFormat('yyyy-MM-dd').format(element.endTime!) == DateFormat('yyyy-MM-dd').format(DateTime.now()) &&
              element.status == Status.completed) {
            int duration = element.endTime!.difference(element.startTime!).inSeconds;
            totalWorkoutDuration += duration;
            totalWeight += double.parse(element.totalWeight ?? "0");
          }
        }
      },
    );

    time = formatDuration(totalWorkoutDuration);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (loader != false) {
      loader = false;
      setState(() {});
    }
  }

  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    return '$hours Hour${hours < 1 ? "s" : ""}\n$minutes Minute${minutes < 1 ? "s" : ""}';
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: media.height / 2,
                          width: media.width,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/img/back.jpg'),
                              fit: BoxFit.cover,
                              opacity: 1,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.height / 2,
                          width: media.width,
                          child: SafeArea(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // mainPageProvider.changeTab(4);
                                          Navigator.pushNamed(context, '/streak-calendar');
                                          // Navigator.pushNamed(
                                          // context, '/streak');
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(ScreenUtil.verticalScale(0.65)),
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                shape: BoxShape.circle,
                                                border: Border.all(color: Colors.white),
                                              ),
                                              child: Consumer<MonthProvider>(builder: (context, monthProvider, child) {
                                                return Text(
                                                  monthProvider.streak.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: ScreenUtil.verticalScale(0.8),
                                                  ),
                                                );
                                              }),
                                            ),
                                            Icon(
                                              Icons.local_fire_department_outlined,
                                              color: Colors.white,
                                              size: ScreenUtil.verticalScale(3),
                                            )
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/notifications');
                                        },
                                        icon: Icon(
                                          Icons.notifications_none,
                                          color: Colors.white,
                                          size: ScreenUtil.verticalScale(3),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil.horizontalScale(5),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: ScreenUtil.horizontalScale(10)),
                                      Text(
                                        'Congratulations!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil.horizontalScale(8.5),
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'You completed',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil.verticalScale(2),
                                        ),
                                      ),
                                      Text(
                                        "Week ${monthProvider?.overviewCurrentWeek}, Day ${monthProvider?.overviewCurrentDay}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil.verticalScale(3),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.height / 2.79,
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
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: media.height / 2.8),
                  child: Container(
                    width: media.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil.horizontalScale(15)),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: media.height / 19),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: ScreenUtil.verticalScale(4)),
                            child: IconRow(
                              icons: List.generate(
                                formattedDates.length,
                                (index) => data.any(
                                  (element) =>
                                      DateFormat('yyyy-MM-dd').format(element.endTime!) == formattedDates[index] &&
                                      element.status == Status.completed &&
                                      element.split == monthProvider!.splitType,
                                )
                                    ? IconDataWithDot(
                                        icon: Icons.check,
                                        iconColor: Colors.white,
                                        backgroundColor: AppColors.primaryColor,
                                        showDot: true,
                                        dotColor: Colors.transparent,
                                      )
                                    : IconDataWithDot(
                                        icon: Icons.close,
                                        iconColor: Colors.white,
                                        backgroundColor: Colors.blue,
                                        showDot: true,
                                        dotColor: Colors.transparent,
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(height: ScreenUtil.horizontalScale(6)),
                          Text(
                            "Here's an overview of your today's workout.",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: ScreenUtil.horizontalScale(3.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Now recover and get ready for tomorrow!",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: ScreenUtil.horizontalScale(3.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: ScreenUtil.horizontalScale(3)),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil.horizontalScale(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(ScreenUtil.verticalScale(2)),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.bolt,
                                              color: Colors.black38,
                                              size: ScreenUtil.horizontalScale(5),
                                            ),
                                            Text(
                                              "Today's Activity",
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: ScreenUtil.horizontalScale(3.3),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: ScreenUtil.horizontalScale(2)),
                                        const ActivityLineChart(),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil.verticalScale(4.1),
                                          vertical: ScreenUtil.verticalScale(2),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(ScreenUtil.verticalScale(3)),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              spreadRadius: 2,
                                              blurRadius: 10,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Time Spent',
                                              style: TextStyle(color: Colors.black54),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              time,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Color(0xFFDD1166),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil.verticalScale(3.5),
                                          vertical: ScreenUtil.verticalScale(2),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              ScreenUtil.verticalScale(3),
                                            ),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              spreadRadius: 2,
                                              blurRadius: 10,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Weight Lifted',
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '${totalWeight.toStringAsFixed(0)} Lbs',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(color: Color(0xFFDD1166), fontSize: 15, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(7)),
                            child: ButtonWidget(
                              text: "Back to Dashboard",
                              textColor: const Color(0x40000000),
                              onPress: () {
                                // mainPageProvider.changeTab(0);
                                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                              },
                              color: const Color(0xC0FFFFFF),
                              isLoading: false,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(7)),
                            child: ButtonWidget(
                              text: "Next Workout",
                              textColor: Colors.white,
                              onPress: () {
                                // mainPageProvider.changeTab(1);
                                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                              },
                              color: AppColors.primaryColor,
                              isLoading: false,
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.black54),
          const SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(maxWidth: media.width / 1.4),
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class IconRow extends StatelessWidget {
  final List<IconDataWithDot> icons;

  const IconRow({super.key, required this.icons});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: icons
          .map(
            (iconData) => IconWithDot(iconData: iconData),
          )
          .toList(),
    );
  }
}

class IconDataWithDot {
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool showDot;
  final Color? dotColor;

  IconDataWithDot({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.dotColor,
    this.borderColor,
    this.showDot = false,
  });
}

class IconWithDot extends StatelessWidget {
  final IconDataWithDot iconData;

  const IconWithDot({super.key, required this.iconData});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(ScreenUtil.horizontalScale(
            1,
          )),
          decoration: BoxDecoration(
            color: iconData.backgroundColor,
            shape: BoxShape.circle,
            border: iconData.borderColor != null ? Border.all(color: iconData.borderColor!) : null,
          ),
          child: iconData.icon != null
              ? Icon(
                  iconData.icon,
                  color: iconData.iconColor,
                  size: ScreenUtil.verticalScale(
                    3,
                  ),
                )
              : Icon(
                  null,
                  size: ScreenUtil.verticalScale(
                    3,
                  ),
                ),
        ),
        if (iconData.showDot)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Icon(
              Icons.circle,
              size: ScreenUtil.verticalScale(
                0.7,
              ),
              color: iconData.dotColor ?? Colors.red[700],
            ),
          ),
      ],
    );
  }
}
