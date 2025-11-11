import 'package:bbb/pages/NewMonthView/MonthResponseModel/day_history_model.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/new_model.dart';
import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewWeeklyTrackCard extends StatefulWidget {
  const NewWeeklyTrackCard({
    super.key,
    required this.index,
    this.monthProvider,
    required this.title,
    required this.thisWeek,
    required this.weekIndex,
    required this.isOpened,
    required this.isCompleted,
    required this.startDate,
    required this.cardData,
    required this.daySplit,
    required this.expandedVal,
    required this.completedWeek,
    required this.restDayId,
    required this.pumpDayIds,
  });

  final int index;
  final MonthProvider? monthProvider;
  final String title;
  final bool thisWeek;
  final int weekIndex;
  final bool isOpened;
  final bool isCompleted;
  final DateTime startDate;
  final WeekDataModel cardData;
  final String daySplit;
  final bool expandedVal;
  final int completedWeek;
  final String restDayId;
  final List<String> pumpDayIds;

  @override
  State<NewWeeklyTrackCard> createState() => _WeeklyTrackCardState();
}

class _WeeklyTrackCardState extends State<NewWeeklyTrackCard> {
  List<String> moreOptions = ["None", "Recommended", "Last Visited"];

  MonthProvider? monthProvider;
  int? mainIndex;
  WeekDataModel? weekDataModel;
  List<DayDataModel> dayDataList = [];
  int curExpandedIdx = 0;
  bool ischecked = false;
  bool _isExpanded = false;
  bool thisWeek = false;
  List<String> dayTitles = [];

  @override
  void initState() {
    super.initState();
    monthProvider = widget.monthProvider;
    mainIndex = widget.index;
    weekDataModel = widget.monthProvider?.weeksDataList[mainIndex!];
    thisWeek = ((mainIndex! + 1) == monthProvider?.week);
    _isExpanded = (mainIndex! + 1) == monthProvider?.week ? true : false;
    dayDataList = weekDataModel!.days!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FilterViewList(),
    );
  }

  Widget FilterViewList() {
    return SingleChildScrollView(
      child: Column(children: [
        ExpansionTileGroup(
          toggleType: ToggleType.expandOnlyCurrent,
          spaceBetweenItem: 15,
          children: [
            filterViewItem(
              _isExpanded,
              widget.title,
              onExpansionChanged: (bool isExpanded) {
                setState(() {
                  _isExpanded = isExpanded;
                  curExpandedIdx = isExpanded ? 0 : -1;
                });
              },
            ),
          ],
        ),
      ]),
    );
  }

  // Widget filterViewList() {
  //   return SingleChildScrollView(
  //     child: Column(
  //       children: [
  //         ExpansionTileGroup(
  //           toggleType: ToggleType.expandOnlyCurrent,
  //           spaceBetweenItem: 15,
  //           onExpansionItemChanged: (idx, isExpand) => {curExpandedIdx = idx},
  //           children: [
  //             filterViewItem(_isExpanded, weekDataModel?.title ?? ""),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  ExpansionTileItem filterViewItem(bool initExpanded, String title, {required Null Function(bool isExpanded) onExpansionChanged}) {
    ScreenUtil.init(context);
    return ExpansionTileItem(
      tilePadding: EdgeInsets.symmetric(
        horizontal: ScreenUtil.horizontalScale(5),
        vertical: ScreenUtil.verticalScale(0.5),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title != "" ? title : "Week",
              style: GoogleFonts.plusJakartaSans(
                color: monthProvider?.weekStatuses[mainIndex!] == WeekType.pastWeek ? Colors.white : AppColors.primaryColor,
                fontSize: ScreenUtil.verticalScale(2),
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ),
          SizedBox(width: ScreenUtil.verticalScale(3)),
          if (!_isExpanded)
            Text(
              '${monthProvider?.splitType.toString().replaceAll("split", "")} workouts',
              style: GoogleFonts.plusJakartaSans(
                color: monthProvider?.weekStatuses[mainIndex!] == WeekType.pastWeek ? Colors.white : Colors.black38,
                fontSize: ScreenUtil.verticalScale(1.5),
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
      backgroundColor: const Color(0xFF0D0D0D),
      collapsedBackgroundColor:
          monthProvider?.weekStatuses[mainIndex!] == WeekType.pastWeek ? AppColors.primaryColor : const Color(0xFF0D0D0D),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ScreenUtil.verticalScale(3)),
        color: monthProvider?.weekStatuses[mainIndex!] == WeekType.pastWeek ? AppColors.primaryColor : Colors.grey[100],
      ),
      iconColor: monthProvider?.weekStatuses[mainIndex!] == WeekType.pastWeek ? AppColors.primaryColor : Colors.grey[400],
      collapsedIconColor: monthProvider?.weekStatuses[mainIndex!] == WeekType.pastWeek ? Colors.white : AppColors.primaryColor,
      initiallyExpanded: initExpanded,
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // InkWell(
          //   onTap: () {
          //     setState(() {
          //       ischecked = !ischecked;
          //     });
          //   },
          //   child: Container(
          //     padding: EdgeInsets.all(
          //       ScreenUtil.verticalScale(1),
          //     ),
          //     decoration: widget.isCompleted
          //         ? BoxDecoration(
          //             shape: BoxShape.circle,
          //             border: Border.all(color: AppColors.primaryColor, width: 2),
          //             color: AppColors.primaryColor,
          //           )
          //         : null,
          //     child: widget.isCompleted
          //         ? Icon(
          //             Icons.check,
          //             size: ScreenUtil.verticalScale(2),
          //             color: Colors.white,
          //           )
          //         : Icon(null, size: ScreenUtil.verticalScale(2)),
          //   ),
          // ),
          const SizedBox(width: 3),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(ScreenUtil.verticalScale(0.3)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: monthProvider?.weekStatuses[mainIndex!] == WeekType.pastWeek ? Colors.white : AppColors.primaryColor,
                  width: 2,
                ),
                color: monthProvider?.weekStatuses[mainIndex!] == WeekType.pastWeek ? Colors.white : AppColors.primaryColor,
              ),
              child: Icon(
                _isExpanded ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined,
                color: monthProvider?.weekStatuses[mainIndex!] == WeekType.pastWeek ? AppColors.primaryColor : Colors.white,
                weight: 900,
                size: ScreenUtil.verticalScale(3),
              ),
            ),
          ),
        ],
      ),
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(ScreenUtil.verticalScale(6))),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil.horizontalScale(1),
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      weekDataModel?.description ?? "",
                      style: TextStyle(
                          fontSize: ScreenUtil.verticalScale(1.7),
                          color: monthProvider?.weekStatuses[mainIndex!] == WeekType.pastWeek ? Colors.white : const Color(0xFF888888)),
                    ),
                    SizedBox(
                      height: ScreenUtil.verticalScale(3),
                    ),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: weekDataModel!.dayList!.length,
                      itemBuilder: (context, index) {
                        final dayIndex = int.parse(weekDataModel!.dayList![index]
                                .toString()
                                .replaceAll("Workout", "")
                                .replaceAll("Rest", "")
                                .replaceAll("Day", "")
                                .replaceAll(" ", "")) -
                            1;
                        DayDataModel dayData =
                            weekDataModel!.dayList![index].toString().contains("Workout") ? dayDataList[dayIndex] : DayDataModel();
                        bool isRestDay = weekDataModel?.dayList?[index].contains("Rest Day");
                        final exerciseDetails = isRestDay ? null : dayData.exercises!;

                        int? exerciseCount = 0;
                        if (exerciseDetails != null && monthProvider!.allRemovedExercise.isNotEmpty) {
                          String dataId1 =
                              "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.monthDataModel?.weeks?[mainIndex!].id}-${monthProvider?.monthDataModel?.weeks?[mainIndex!].idList![index]}";
                          List<String> matchingExerciseIds = monthProvider!.allRemovedExercise
                              .where((entry) => entry.dataId == dataId1)
                              .map((entry) => entry.exerciseId!)
                              .toList();
                          exerciseCount = exerciseDetails.where(
                            (element) {
                              return !matchingExerciseIds.contains(element.exerciseId);
                            },
                          ).length;
                        } else {
                          exerciseCount = exerciseDetails?.length;
                        }

                        String dataId =
                            "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.monthDataModel!.weeks![mainIndex!].id}-${weekDataModel!.idList![index]}";

                        int nextWorkOutIndex = weekDataModel!.dayList![index].toString().contains("Workout")
                            ? int.parse(weekDataModel!.dayList![index].toString().replaceAll("Day ", "").replaceAll(" Workout", "")) - 1
                            : 0;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                if (index != 0)
                                  DottedDashedLine(
                                    height: 15,
                                    width: 0,
                                    dashColor: Colors.grey.withOpacity(0.5),
                                    axis: Axis.vertical,
                                  )
                                else
                                  const SizedBox(
                                    height: 15,
                                  ),
                                Consumer<MonthProvider>(
                                  builder: (context, value, child) {
                                    return (value.weekStatuses[mainIndex!] == WeekType.pastWeek && value.allDayHistoryModel.isEmpty) ||
                                            value.allDayHistoryModel
                                                .any((element) => element.status == Status.skipped && element.dataId == dataId)
                                        ? skipped()
                                        : value.weekStatuses[mainIndex!] == WeekType.futureWeek
                                            ? future()
                                            : value.allDayHistoryModel
                                                    .any((element) => element.status == Status.completed && element.dataId == dataId)
                                                ? completed()
                                                : value.weekStatuses[mainIndex!] == WeekType.currentWeek
                                                    ? value.todayTitleId == (value.monthDataModel!.weeks![mainIndex!].idList?[index])
                                                        ? today()
                                                        : nonToday()
                                                    : skipped();
                                  },
                                ),
                                if (index != 6)
                                  DottedDashedLine(
                                    height: 15,
                                    width: 0,
                                    dashColor: Colors.grey.withOpacity(0.5),
                                    axis: Axis.vertical,
                                  )
                                else
                                  const SizedBox(
                                    height: 15,
                                  )
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SizedBox(
                                height: 60,
                                child: InkWell(
                                  onTap: monthProvider!.weekStatuses[mainIndex!] == WeekType.futureWeek
                                      ? null
                                      : () async {
                                          bool val = monthProvider!.allDayHistoryModel.any(
                                            (element) => element.dataId == dataId && element.type!.contains("Pump Day"),
                                          );
                                          monthProvider?.changeIsPumpDay(val);
                                          monthProvider?.overviewCurrentWeek = widget.weekIndex + 1;
                                          monthProvider?.overviewCurrentDay = index + 1;
                                          monthProvider?.dayDataModel = dayData;
                                          monthProvider?.alternateEquipmentType = monthProvider!.equipmentType;
                                          monthProvider?.weekDataModel = weekDataModel;
                                          monthProvider?.updateIsPastWeek(monthProvider!.weekStatuses[mainIndex!] == WeekType.pastWeek);
                                          Navigator.pushNamed(context, '/dayOverview');
                                        },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                            child: Builder(builder: (context) {
                                              DayHistoryModel? matchingElement = monthProvider!.allDayHistoryModel.firstWhere(
                                                (element) => element.dataId == dataId && element.type!.contains("Pump Day"),
                                                orElse: () => DayHistoryModel(),
                                              );
                                              return Text(
                                                matchingElement.id != null
                                                    ? matchingElement.title ?? "Pump Day"
                                                    : !isRestDay
                                                        ? weekDataModel!.days![nextWorkOutIndex].title
                                                        : weekDataModel!.dayList![index],
                                                style: TextStyle(
                                                  color: monthProvider?.weekStatuses[mainIndex!] == WeekType.pastWeek
                                                      ? Colors.white
                                                      : AppColors.primaryColor,
                                                  fontSize: ScreenUtil.verticalScale(2),
                                                  fontWeight: FontWeight.bold,
                                                  height: 1,
                                                ),
                                              );
                                            }),
                                          ),
                                          const SizedBox(height: 8),
                                          if (!isRestDay) ...[
                                            Text(
                                              exerciseCount! > 1 ? '$exerciseCount Exercises' : " $exerciseCount Exercise",
                                              style: TextStyle(
                                                fontSize: ScreenUtil.verticalScale(1.4),
                                                color: monthProvider?.weekStatuses[mainIndex!] == WeekType.pastWeek
                                                    ? Colors.white
                                                    : Colors.grey,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ]
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(
                                          ScreenUtil.verticalScale(0.5),
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Icon(
                                          Icons.keyboard_arrow_right_outlined,
                                          color: AppColors.primaryColor,
                                          size: ScreenUtil.verticalScale(2.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  today() {
    return Container(
      padding: EdgeInsets.all(ScreenUtil.verticalScale(0.5)),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        shape: BoxShape.circle,
      ),
      child: Container(
        height: ScreenUtil.verticalScale(3.4),
        width: ScreenUtil.verticalScale(3.4),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  nonToday() {
    return Container(
      padding: EdgeInsets.all(ScreenUtil.verticalScale(0.5)),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Container(
        height: ScreenUtil.verticalScale(3.4),
        width: ScreenUtil.verticalScale(3.4),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  skipped() {
    return Container(
      padding: EdgeInsets.all(ScreenUtil.verticalScale(0.5)),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Container(
        height: ScreenUtil.verticalScale(3.4),
        width: ScreenUtil.verticalScale(3.4),
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.close, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  completed() {
    return Container(
      padding: EdgeInsets.all(ScreenUtil.verticalScale(0.5)),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Container(
        height: ScreenUtil.verticalScale(3.4),
        width: ScreenUtil.verticalScale(3.4),
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.check, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  future() {
    return Container(
      padding: EdgeInsets.all(ScreenUtil.verticalScale(0.5)),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Container(
        height: ScreenUtil.verticalScale(3.4),
        width: ScreenUtil.verticalScale(3.4),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: const Center(child: Icon(Icons.hourglass_top, color: Colors.black38, size: 20)),
      ),
    );
  }
}
