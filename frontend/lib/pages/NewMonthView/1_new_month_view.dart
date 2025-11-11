import 'package:bbb/components/button_widget.dart';
import 'package:bbb/components/common_streak_with_notification.dart';
import 'package:bbb/components/select_dropdown.dart';
import 'package:bbb/components/select_dropdown1.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/new_model.dart';
import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/pages/NewMonthView/Widgets/1_1_new_track_card.dart';
import 'package:bbb/pages/ProgramInfoView/program_info_view.dart';
import 'package:bbb/pages/video_intro_page.dart';
import 'package:bbb/providers/main_page_provider.dart';
import 'package:bbb/routes/fade_page_route.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewMonthView extends StatefulWidget {
  const NewMonthView({super.key});

  @override
  State<NewMonthView> createState() => _NewMonthViewState();
}

class _NewMonthViewState extends State<NewMonthView> {
  MonthProvider? monthProvider;

  @override
  void initState() {
    monthProvider = Provider.of<MonthProvider>(context, listen: false);
    monthProvider?.mainPageProvider = Provider.of<MainPageProvider>(context, listen: false);
    super.initState();
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
                                          width: ScreenUtil.horizontalScale(10),
                                          height: ScreenUtil.horizontalScale(10),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.keyboard_arrow_left,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              monthProvider!.mainPageProvider.changeTab(0);
                                            },
                                            iconSize: ScreenUtil.verticalScale(4),
                                          ),
                                        ),
                                      ),
                                      const CommonStreakWithNotification()
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil.horizontalScale(8),
                                    vertical: ScreenUtil.verticalScale(2),
                                  ),
                                  height: media.height * 0.23,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: Column(
                                          children: [
                                            monthProvider!.startTime != null && monthProvider!.endTime != null
                                                ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        monthProvider!.startTime == null || monthProvider!.startTime.toString() == ""
                                                            ? ""
                                                            : DateFormat('MM/dd').format(monthProvider!.startTime!),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil.verticalScale(2),
                                                        ),
                                                      ),
                                                      Text(
                                                        monthProvider!.endTime == null || monthProvider!.endTime.toString() == ""
                                                            ? ""
                                                            : DateFormat(' - MM/dd').format(monthProvider!.endTime!),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil.verticalScale(2),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            // const SizedBox(height: 5),
                                            Text(
                                              monthProvider!.monthDataModel?.title ?? "",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ScreenUtil.verticalScale(3),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // const SizedBox(height: 10),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil.horizontalScale(10),
                                        ),
                                        child: ButtonWidget(
                                          text: "Watch Video Intro",
                                          color: const Color(0xEEFFFFFF),
                                          onPress: () {
                                            Navigator.of(context).push(
                                              FadePageRoute(
                                                page: const VideoIntroWidget(
                                                  vimeoId: '953289606',
                                                ),
                                              ),
                                            );
                                          },
                                          textColor: AppColors.primaryColor,
                                          isLoading: false,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                            vertical: ScreenUtil.verticalScale(33.5),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProgramInfoView(),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "View Program Info",
                                  style: TextStyle(
                                    decorationColor: Colors.white,
                                    color: Colors.white,
                                    fontSize: ScreenUtil.verticalScale(2.2),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.height / 2.54,
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
                  margin: EdgeInsets.only(
                    top: media.height / 2.55,
                    bottom: ScreenUtil.verticalScale(15),
                  ),
                  child: Container(
                    width: media.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil.verticalScale(7)),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil.horizontalScale(8),
                            vertical: ScreenUtil.verticalScale(3),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: ScreenUtil.horizontalScale(3),
                                ),
                                child: Text(
                                  'Choose workout day split',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: const Color(0xBB888888),
                                    fontSize: ScreenUtil.verticalScale(1.5),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Consumer<MonthProvider>(
                                builder: (context, value, child) => SelectDropdown1(
                                  onChange: (String newValue) async {
                                    await value.changeDaySplit(newValue);
                                    await value.filterWorkouts();
                                    await value.updateLocalData();
                                    await value.manageStreak();
                                    await value.getLiftedWeightGraphData();
                                  },
                                ),
                              ),
                              const SizedBox(height: 32),
                              Container(
                                margin: EdgeInsets.only(left: ScreenUtil.horizontalScale(3)),
                                child: Text(
                                  'Choose equipment availability',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: const Color(0xBB888888),
                                    fontSize: ScreenUtil.verticalScale(1.5),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Consumer<MonthProvider>(
                                builder: (context, value, child) => SelectDropdown(
                                  onChange: (String newValue) async {
                                    value.changeEquipmentType(newValue);
                                    await value.filterWorkouts();
                                    await value.updateLocalData();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Consumer<MonthProvider>(
                          builder: (context, value, child) => value.isFilterLoading
                              ? const SizedBox()
                              : value.weeksDataList.isNotEmpty
                                  ? Container(
                                      margin: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(6)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          for (int i = 0; i < value.weeksDataList.length; i++) ...[
                                            NewWeeklyTrackCard(
                                                index: i,
                                                monthProvider: value,
                                                pumpDayIds: value.weeksDataList[i].pumpDayIds!,
                                                title: value.weeksDataList[i].title == "" ? "Week ${i + 1}" : value.weeksDataList[i].title!,
                                                thisWeek: ((i + 1) == value.week),
                                                restDayId: value.weeksDataList[i].restdayId!,
                                                weekIndex: i,
                                                isOpened: false,
                                                isCompleted: false,
                                                startDate: (value.startTime ?? DateTime.now()).add(Duration(days: i * 7)),
                                                cardData: value.weeksDataList[i],
                                                daySplit: value.splitType!,
                                                expandedVal: (i + 1) == value.week ? true : false,
                                                completedWeek: i + 1),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ],
                                      ),
                                    )
                                  : const Center(
                                      child: Text("No workout data available"),
                                    ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil.horizontalScale(5),
                          ),
                          child: ButtonWidget(
                            text: monthProvider!.todayTitleId.isEmpty ? "Completed" : "Start Your Workout",
                            textColor: Colors.white,
                            onPress: monthProvider!.todayTitleId.isEmpty
                                ? null
                                : () async {
                                    int? index = monthProvider!.monthDataModel?.weeks?[(monthProvider!.week ?? 1) - 1].idList?.indexWhere(
                                      (element) {
                                        return element == monthProvider!.todayTitleId;
                                      },
                                    );

                                    final dayIndex = int.parse((monthProvider!
                                                .monthDataModel?.weeks![(monthProvider!.week ?? 1) - 1].dayList?[index ?? 0]
                                                .toString()
                                                .replaceAll("Workout", "")
                                                .replaceAll("Rest", "")
                                                .replaceAll("Day", "")
                                                .replaceAll(" ", "") ??
                                            "0")) -
                                        1;

                                    DayDataModel dayData =
                                        "${monthProvider!.monthDataModel?.weeks?[(monthProvider!.week ?? 1) - 1].dayList![index ?? 0] ?? ""}"
                                                .toString()
                                                .contains("Workout")
                                            ? monthProvider!.monthDataModel!.weeks![(monthProvider!.week ?? 1) - 1].days![dayIndex]
                                            : DayDataModel();
                                    monthProvider!.overviewCurrentWeek = monthProvider!.week ?? 1;
                                    monthProvider!.overviewCurrentDay = ((index ?? 1) + 1);
                                    monthProvider!.dayDataModel = dayData;
                                    monthProvider!.alternateEquipmentType = monthProvider!.equipmentType;
                                    monthProvider!.weekDataModel = monthProvider!.monthDataModel!.weeks![(monthProvider!.week ?? 1) - 1];
                                    monthProvider?.updateIsPastWeek(
                                        monthProvider!.weekStatuses[(monthProvider!.week ?? 1) - 1] == WeekType.pastWeek);
                                    Navigator.pushNamed(context, '/dayOverview');
                                  },
                            color: AppColors.primaryColor,
                            isLoading: false,
                          ),
                        ),
                      ],
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
