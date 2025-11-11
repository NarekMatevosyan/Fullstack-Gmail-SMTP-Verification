import 'package:bbb/components/back_arrow_widget.dart';
import 'package:bbb/components/button_widget.dart';
import 'package:bbb/components/common_streak_with_notification.dart';
import 'package:bbb/models/exerciselibrary.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/new_model.dart';
import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/pages/Tools/GraphsReports/Charts/report_exercise_completed.dart';
import 'package:bbb/pages/Tools/GraphsReports/Charts/report_time_spent.dart';
import 'package:bbb/pages/Tools/GraphsReports/Charts/report_weight_lifted.dart';
import 'package:bbb/providers/data_provider.dart';
import 'package:bbb/providers/user_data_provider.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/screen_util.dart';

class GraphAndReportsPage extends StatefulWidget {
  const GraphAndReportsPage({super.key});

  @override
  State<GraphAndReportsPage> createState() => _GraphAndReportsPageState();
}

class _GraphAndReportsPageState extends State<GraphAndReportsPage> {
  DataProvider? dataProvider;
  List<ExerciseLibrary> _filteredExercises = [];

  final TextEditingController _controller = TextEditingController();
  List<String> items = [];
  List<String> filteredItems = [];
  bool isDropdownOpen = false;

  MonthProvider? monthProvider;

  @override
  void initState() {
    super.initState();
    dataProvider = Provider.of<DataProvider>(context, listen: false);
    monthProvider = Provider.of<MonthProvider>(context, listen: false);
    dataProvider?.fetchAdminData().then((_) {
      setState(() {
        _filteredExercises = dataProvider!.adminExercises;
        items = _filteredExercises.map((exercise) => exercise.title).toList();
      });
    }).catchError((error) {
      debugPrint('Error fetching admin exercises: $error');
    });
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = items.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
      isDropdownOpen = query.isNotEmpty && filteredItems.isNotEmpty;
    });
  }

  void _selectItem(String item) {
    _controller.text = item;
    setState(() {
      isDropdownOpen = false;
    });
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
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: media.height / 3.2),
                  child: Container(
                    width: media.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil.horizontalScale(15)),
                      ),
                    ),
                    child: Column(
                      children: [
                        /// EXERCISE COMPLETED

                        SizedBox(height: ScreenUtil.horizontalScale(7)),
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: ScreenUtil.verticalScale(1.5),
                            horizontal: ScreenUtil.horizontalScale(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Exercises Completed",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: ScreenUtil.verticalScale(2.3),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                height: ScreenUtil.verticalScale(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    ScreenUtil.verticalScale(2),
                                  ),
                                ),
                                child: Consumer<MonthProvider>(
                                  builder: (context, monthProvider, child) {
                                    return DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        value: monthProvider.reportExerciseCompletedWeek,
                                        items: ["Week 1", "Week 2", "Week 3", "Week 4"]
                                            .map(
                                              (name) => DropdownMenuItem(
                                                value: name,
                                                child: Text(
                                                  name,
                                                  style: TextStyle(
                                                    color: const Color(0xA09F9F9F),
                                                    fontSize: ScreenUtil.horizontalScale(
                                                      3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: monthProvider.changeWeekExerciseCompleted,
                                        icon: Icon(
                                          Icons.expand_more,
                                          color: const Color(0xA09F9F9F),
                                          size: ScreenUtil.verticalScale(3),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ScreenUtil.horizontalScale(2)),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil.horizontalScale(8),
                          ),
                          // child: BarChartWidget(),
                          child: const ReportExerciseCompletedGraph(),
                        ),

                        /// WEIGHT LIFTED

                        SizedBox(height: ScreenUtil.horizontalScale(4)),
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: ScreenUtil.verticalScale(1.5),
                            horizontal: ScreenUtil.horizontalScale(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Weight Lifted",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: ScreenUtil.verticalScale(2.3),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                height: ScreenUtil.verticalScale(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(ScreenUtil.verticalScale(2)),
                                ),
                                child: Consumer<MonthProvider>(
                                  builder: (context, monthProvider, child) {
                                    return DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        value: monthProvider.reportWeightLifted,
                                        items: ["Week 1", "Week 2", "Week 3", "Week 4"]
                                            .map(
                                              (name) => DropdownMenuItem(
                                                value: name,
                                                child: Text(
                                                  name,
                                                  style: TextStyle(
                                                    color: const Color(0xA09F9F9F),
                                                    fontSize: ScreenUtil.verticalScale(1.5),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: monthProvider.changeWeekWeightLifted,
                                        icon: const Icon(
                                          Icons.expand_more,
                                          color: Color(0xA09F9F9F),
                                          size: 25,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ScreenUtil.horizontalScale(2)),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(8)),
                            child: const ReportWeightLiftedGraph()),

                        /// TIME SPENT

                        SizedBox(height: ScreenUtil.horizontalScale(4)),
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: ScreenUtil.verticalScale(1.5),
                            horizontal: ScreenUtil.horizontalScale(8),
                          ),
                          width: media.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Time Spent',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: ScreenUtil.horizontalScale(5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: ScreenUtil.verticalScale(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(ScreenUtil.verticalScale(2)),
                                ),
                                child: Consumer<MonthProvider>(
                                  builder: (context, monthProvider, child) {
                                    return DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        value: monthProvider.reportTimeSpent,
                                        items: ["Week 1", "Week 2", "Week 3", "Week 4"]
                                            .map((name) => DropdownMenuItem(
                                                  value: name,
                                                  child: Text(
                                                    name,
                                                    style: TextStyle(
                                                      color: const Color(0xA09F9F9F),
                                                      fontSize: ScreenUtil.verticalScale(1.5),
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: monthProvider.changeWeekTimeSpent,
                                        icon: const Icon(
                                          Icons.expand_more,
                                          color: Color(0xA09F9F9F),
                                          size: 25,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ScreenUtil.horizontalScale(2)),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(8)),
                          child: const ReportTimeSpentGraph(),
                        ),

                        /// BOTTOM CONTAINERS

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(8), vertical: 35),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: ScreenUtil.horizontalScale(3),
                                      right: ScreenUtil.horizontalScale(5),
                                      top: ScreenUtil.verticalScale(2),
                                      bottom: ScreenUtil.verticalScale(2),
                                    ),
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total Weight Lifted',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.black54, fontSize: ScreenUtil.horizontalScale(3.6)),
                                        ),
                                        const SizedBox(height: 10),
                                        Consumer<MonthProvider>(
                                          builder: (context, monthProvider, child) {
                                            return Text(
                                              '${monthProvider.totalWeightLiftedInAWeek.toStringAsFixed(0)} lbs',
                                              style: TextStyle(
                                                color: const Color(0xFFDD1166),
                                                fontSize: ScreenUtil.horizontalScale(5),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: ScreenUtil.horizontalScale(3),
                                      right: ScreenUtil.horizontalScale(5),
                                      top: ScreenUtil.verticalScale(2),
                                      bottom: ScreenUtil.verticalScale(2),
                                    ),
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total completed Exercises',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: ScreenUtil.horizontalScale(3.6),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Consumer<MonthProvider>(
                                          builder: (context, monthProvider, child) {
                                            return Text(
                                              monthProvider.totalExerciseCompletedInAWeek.toStringAsFixed(0),
                                              style: TextStyle(
                                                color: const Color(0xFFDD1166),
                                                fontSize: ScreenUtil.horizontalScale(5),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          width: media.width,
                          margin: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(8)).copyWith(bottom: 50),
                          child: Column(
                            children: [
                              ButtonWidget(
                                text: "Back To Tools",
                                textColor: const Color(0x30000000),
                                onPress: () {
                                  Navigator.pop(context);
                                },
                                color: const Color(0xC8FFFFFF),
                                isLoading: false,
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              Consumer<MonthProvider>(builder: (context, monthProvider, child) {
                                return ButtonWidget(
                                  text: monthProvider.todayTitleId.isEmpty ? "Completed" : "Continue Workout",
                                  textColor: Colors.white,
                                  onPress: monthProvider.todayTitleId.isEmpty
                                      ? null
                                      : () {
                                          int? index =
                                              monthProvider.monthDataModel?.weeks?[(monthProvider.week ?? 1) - 1].idList?.indexWhere(
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
                                          monthProvider.updateIsPastWeek(
                                              monthProvider.weekStatuses[(monthProvider.week ?? 1) - 1] == WeekType.pastWeek);
                                          Navigator.pop(context);
                                          Navigator.pushNamed(context, '/dayOverview');
                                        },
                                  color: AppColors.primaryColor,
                                  isLoading: false,
                                );
                              })

                              // ButtonWidget(
                              //   text: 'Continue Workout',
                              //   textColor: Colors.white,
                              //   color: AppColors.primaryColor,
                              //   onPress: () {
                              //     Navigator.pop(context);
                              //   },
                              //   isLoading: false,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: media.height / 2,
                          width: media.width,
                        ),
                        SizedBox(
                          height: media.height * 2,
                          width: media.width,
                          child: SafeArea(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      BackArrowWidget(onPress: () => {Navigator.pop(context)}),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil.horizontalScale(8), top: ScreenUtil.horizontalScale(8)),
                                        child: Consumer<UserDataProvider>(builder: (context, userData, child) {
                                          return Text(
                                            // 'Hi, Nick',
                                            'Hi ${userData.userName}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil.horizontalScale(5.5),
                                            ),
                                          );
                                        }),
                                      ),
                                      const CommonStreakWithNotification()
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(7)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(children: [
                                        const SizedBox(height: 4),
                                        SizedBox(
                                          width: media.width * 0.4,
                                          child: Text(
                                            "Here's some fun graphs for you",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil.horizontalScale(4.5),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(
                                          height: ScreenUtil.horizontalScale(4),
                                        ),
                                      ]),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil.horizontalScale(3),
                                          vertical: ScreenUtil.horizontalScale(1),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(ScreenUtil.verticalScale(4)),
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
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SearchExerciseField(
                                              controller: _controller,
                                              onChanged: _filterItems,
                                            ),
                                            if (isDropdownOpen)
                                              Column(
                                                children: [
                                                  ListView(
                                                    shrinkWrap: true, // Allows ListView to take only the space it needs
                                                    physics: const AlwaysScrollableScrollPhysics(), // Disable scrolling if needed
                                                    children: filteredItems.map((item) {
                                                      return ListTile(
                                                        title: Text(
                                                          item,
                                                          style: const TextStyle(fontSize: 16), // Adjust font size as needed
                                                          maxLines: 3, // Limit to 3 lines; adjust as needed
                                                          overflow: TextOverflow.ellipsis, // Show ellipsis if text is too long
                                                        ),
                                                        onTap: () => _selectItem(item),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.height / 3.19,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SearchExerciseField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  final TextEditingController controller;

  void _selectAllText() {
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );
  }

  const SearchExerciseField({super.key, required this.onChanged, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil.horizontalScale(3),
        vertical: ScreenUtil.horizontalScale(1),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil.verticalScale(6)),
      ),
      child: TextField(
        controller: controller,
        onTap: _selectAllText,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'All Exercises',
          hintStyle: TextStyle(
            color: Colors.black45,
            fontSize: ScreenUtil.verticalScale(2),
          ),
          suffixIcon: Icon(
            Icons.search,
            size: ScreenUtil.verticalScale(4),
            color: Colors.grey[300],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ScreenUtil.horizontalScale(2),
          ),
        ),
      ),
    );
  }
}
