import 'package:bbb/components/button_widget.dart';
import 'package:bbb/components/common_streak_with_notification.dart';
import 'package:bbb/components/select_dropdown.dart';
import 'package:bbb/pages/NewMonthView/Database/month_database.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/day_history_model.dart';
import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/pages/video_intro_page.dart';
import 'package:bbb/providers/main_page_provider.dart';
import 'package:bbb/providers/user_data_provider.dart';
import 'package:bbb/routes/fade_page_route.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewDayOverviewPage extends StatefulWidget {
  const NewDayOverviewPage({super.key});

  @override
  State<NewDayOverviewPage> createState() => _DayOverviewPageState();
}

class _DayOverviewPageState extends State<NewDayOverviewPage> {
  MonthProvider? monthProvider;
  late MainPageProvider mainPageProvider;
  UserDataProvider? userData;

  bool isInit = true;

  String currentDayTitle = '';

  @override
  void initState() {
    mainPageProvider = Provider.of<MainPageProvider>(context, listen: false);
    monthProvider = Provider.of<MonthProvider>(context, listen: false);
    userData = Provider.of<UserDataProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async => await initData());
    super.initState();
  }

  Future<void> initData() async {
    final weekIndex = monthProvider!.overviewCurrentWeek;
    final dayIndex = monthProvider!.overviewCurrentDay;
    final data = monthProvider!.monthDataModel!.weeks![weekIndex - 1].dayList![dayIndex - 1];
    await monthProvider?.fetchSingleDayHistoryLocalData();
    await monthProvider?.fetchDayStatusLocalData();
    await monthProvider?.fetchExerciseStatusLocalData();
    monthProvider?.setInitialPumpDayValues();

    int nextWorkOutIndex = monthProvider!.weekDataModel!.dayList![dayIndex - 1].toString().contains("Workout")
        ? int.parse(monthProvider!.weekDataModel!.dayList![dayIndex - 1].toString().replaceAll("Day ", "").replaceAll(" Workout", "")) - 1
        : 0;

    currentDayTitle = monthProvider!.weekDataModel!.dayList![dayIndex - 1].toString().contains("Workout")
        ? monthProvider!.weekDataModel!.days![nextWorkOutIndex].title ?? ""
        : monthProvider!.weekDataModel!.dayList![dayIndex - 1];

    await monthProvider?.checkForPumpDay(data);

    await monthProvider?.getRestDayData();

    String dataId =
        "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}";
    if (monthProvider!.allDayHistoryModel.any((element) => element.dataId == dataId && element.type!.contains("Pump Day"))) {
      monthProvider?.changeIsPumpDay(true);
      monthProvider?.changeValue(['Start Workout', 'Swap To Rest Day'], "Start Workout");
    }
    isInit = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    ScreenUtil.init(context);
    return isInit
        ? Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Consumer<MonthProvider>(builder: (context, monthProvider, child) {
                    return Stack(
                      children: [
                        monthProvider.dayHistoryDetails?.status == Status.completed
                            ? Container(
                                height: media.height / 2.35,
                                width: media.width,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/img/back.jpg'),
                                    fit: BoxFit.cover,
                                    opacity: 1,
                                  ),
                                ),
                                child: ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.saturation,
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/img/back.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: media.height / 2.35,
                                width: media.width,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/img/back.jpg'),
                                    fit: BoxFit.cover,
                                    opacity: 1,
                                  ),
                                ),
                              ),
                        monthProvider.dayHistoryDetails?.status == Status.completed
                            ? Container(
                                height: media.height / 1.8,
                                width: media.width,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.grey.withOpacity(.5),
                                      Colors.black.withOpacity(1),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: SafeArea(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    left: ScreenUtil.horizontalScale(4),
                                                  ),
                                                  decoration: const BoxDecoration(
                                                    color: Color(0XFFd18a9b),
                                                    // color: (isThisWeek && isCompleted)
                                                    //     ? Colors.grey.withOpacity(.99)
                                                    //     : const Color(0XFFd18a9b),
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
                                                        // userData?.previousPage == 1
                                                        //     ? mainPageProvider.changeTab(0)
                                                        //     : mainPageProvider.changeTab(1);
                                                        Navigator.pop(context);
                                                      },
                                                      iconSize: ScreenUtil.verticalScale(4),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const CommonStreakWithNotification()
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(7)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Aug, 2024',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ScreenUtil.verticalScale(2),
                                              ),
                                            ),
                                            SizedBox(
                                              height: ScreenUtil.verticalScale(1.5),
                                            ),
                                            Text(
                                              "Week ${monthProvider.overviewCurrentWeek}, Day ${monthProvider.overviewCurrentDay}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ScreenUtil.verticalScale(2),
                                                fontWeight: FontWeight.bold,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(
                                              height: ScreenUtil.verticalScale(0.5),
                                            ),
                                            Consumer<MonthProvider>(builder: (context, monthProvider, child) {
                                              return Text(
                                                monthProvider.isPumpDay ? monthProvider.pumpDayModel?.title ?? "Pump Day" : currentDayTitle,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  height: 1.1,
                                                  fontSize: ScreenUtil.verticalScale(4),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: ScreenUtil.verticalScale(2.5)),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil.horizontalScale(10),
                                        ),
                                        child: Builder(builder: (context) {
                                          return ButtonWidget(
                                            text: (monthProvider.dayDataModel != null &&
                                                    monthProvider.dayDataModel!.formats != null &&
                                                    monthProvider.dayDataModel!.formats!
                                                        .contains(monthProvider.splitType.toString().replaceAll("split", "")))
                                                ? "Watch Video"
                                                : "Watch Video Intro",
                                            color: const Color(0xEEFFFFFF),
                                            onPress: () {
                                              Navigator.of(context).push(
                                                FadePageRoute(page: const VideoIntroWidget(vimeoId: '953289606')),
                                              );
                                            },
                                            textColor: AppColors.primaryColor,
                                            isLoading: false,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                height: media.height / 1.8,
                                width: media.width,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primaryColor.withOpacity(0.7),
                                      AppColors.primaryColor.withOpacity(0.7),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: SafeArea(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Stack(
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
                                                        // userData?.previousPage == 1
                                                        //     ? mainPageProvider.changeTab(0)
                                                        //     : mainPageProvider.changeTab(1);
                                                        Navigator.pop(context);
                                                      },
                                                      iconSize: ScreenUtil.verticalScale(4),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const CommonStreakWithNotification()
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(7)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat('MMM, yyyy').format(DateTime.now()),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ScreenUtil.verticalScale(2),
                                              ),
                                            ),
                                            monthProvider.currentWeek != 0
                                                ? Text(
                                                    "Week ${monthProvider.overviewCurrentWeek}, Day ${monthProvider.overviewCurrentDay}",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: ScreenUtil.verticalScale(2.3),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            SizedBox(
                                              height: ScreenUtil.verticalScale(0.5),
                                            ),
                                            Consumer<MonthProvider>(builder: (context, monthProvider, child) {
                                              return Text(
                                                monthProvider.isPumpDay ? monthProvider.pumpDayModel?.title ?? "Pump Day" : currentDayTitle,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  height: 1.1,
                                                  fontSize: ScreenUtil.verticalScale(4),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: ScreenUtil.verticalScale(2.5)),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil.horizontalScale(10),
                                        ),
                                        child: Builder(builder: (context) {
                                          return ButtonWidget(
                                            text: (monthProvider.dayDataModel != null &&
                                                    monthProvider.dayDataModel!.formats != null &&
                                                    monthProvider.dayDataModel!.formats!
                                                        .contains(monthProvider.splitType.toString().replaceAll("split", "")))
                                                ? "Watch Video"
                                                : "Watch Video Intro",
                                            color: const Color(0xEEFFFFFF),
                                            onPress: () {
                                              Navigator.of(context).push(
                                                FadePageRoute(page: const VideoIntroWidget(vimeoId: '953289606')),
                                              );
                                            },
                                            textColor: AppColors.primaryColor,
                                            isLoading: false,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    );
                  }),
                  SizedBox(
                    height: media.height / 2.64,
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
                  Positioned(
                    // bottom: -33,
                    child: Container(
                      width: media.width,
                      margin: EdgeInsets.only(
                        top: media.height / 2.65,
                        bottom: ScreenUtil.verticalScale(2),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ScreenUtil.verticalScale(6)),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: media.height / 19),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Notes',
                                    style: TextStyle(
                                      fontSize: ScreenUtil.verticalScale(3.5),
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  Consumer<MonthProvider>(
                                    builder: (context, monthProvider, child) {
                                      return monthProvider.dayDataModel!.formats != null &&
                                              monthProvider.dayDataModel!.formats!
                                                  .contains(monthProvider.splitType.toString().replaceAll("split", "")) &&
                                              !monthProvider.isPumpDay
                                          ? BulletPoint(text: monthProvider.dayDataModel!.description!)
                                          : monthProvider.isPumpDay
                                              ? BulletPoint(
                                                  text: (context.watch<MonthProvider>().pumpDayModel?.description ?? ""),
                                                )
                                              : monthProvider.restDayModel[monthProvider.overviewCurrentWeek].description!.isNotEmpty
                                                  ? BulletPoint(
                                                      text: monthProvider.restDayModel[monthProvider.overviewCurrentWeek].description!,
                                                    )
                                                  : const SizedBox();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil.verticalScale(20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Wrap(
              children: [
                SizedBox(
                  height: ScreenUtil.verticalScale(5),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.horizontalScale(10),
                    vertical: ScreenUtil.verticalScale(2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (monthProvider?.dayDataModel!.formats != null &&
                          monthProvider!.dayDataModel!.formats!.contains(monthProvider!.splitType.toString().replaceAll("split", ""))) ...[
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil.verticalScale(2)),
                          child: Text(
                            'Choose equipment availability',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black54, fontSize: ScreenUtil.verticalScale(1.5)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SelectDropdown(
                          onChange: (String newValue) {
                            monthProvider?.alternateEquipmentType = newValue;
                            monthProvider?.innerFilter();
                          },
                        ),
                      ]
                    ],
                  ),
                ),
                Consumer<MonthProvider>(
                  builder: (context, monthProvider, child) {
                    String buttonText = "";
                    VoidCallback? onPress;
                    Color buttonColor = AppColors.primaryColor;

                    if (currentDayTitle.contains("Rest Day") && monthProvider.isPastWeek) {
                      buttonText = monthProvider.dayHistoryDetails?.status == Status.completed ? "Completed" : "Skipped";
                      onPress = null;
                    } else if (monthProvider.isPastWeek ||
                        (monthProvider.isPumpDay &&
                            (monthProvider.dayHistoryDetails?.status == Status.completed ||
                                monthProvider.dayHistoryDetails?.status == Status.skipped))) {
                      buttonText = "View the workout";
                      onPress = () {
                        Navigator.pushNamed(context, '/today');
                      };
                    } else if (currentDayTitle.contains("Rest Day") && (monthProvider.isPumpDay || monthProvider.isPumpDayAvailable)) {
                      if (monthProvider.dayHistoryDetails?.status == Status.skipped ||
                          monthProvider.dayHistoryDetails?.status == Status.completed) {
                        return const SizedBox();
                      } else {
                        return Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: media.height * 0.075,
                                margin: EdgeInsets.only(
                                  bottom: ScreenUtil.verticalScale(2),
                                  left: ScreenUtil.horizontalScale(10),
                                  top: ScreenUtil.verticalScale(2),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFFD2CBCB)),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(ScreenUtil.verticalScale(4)),
                                    bottomLeft: Radius.circular(ScreenUtil.verticalScale(4)),
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x20888888),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: DropdownButton<String>(
                                    value: monthProvider.selectedButtonTitle,
                                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                    iconSize: ScreenUtil.verticalScale(4),
                                    iconEnabledColor: Colors.grey[400],
                                    elevation: 16,
                                    style: TextStyle(
                                      color: const Color(0xBB888888),
                                      fontSize: ScreenUtil.verticalScale(1.8),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    underline: Container(),
                                    onChanged: (String? newValue) {
                                      monthProvider.changeSelectedButtonTitle(newValue ?? "");
                                    },
                                    items: monthProvider.buttonTitle.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () async {
                                  if (monthProvider.selectedButtonTitle == "Mark Complete") {
                                    Navigator.pushNamed(context, '/dayCompleted');
                                    _saveDayData(status: Status.completed, type: 'Rest Day');
                                  } else if (monthProvider.selectedButtonTitle == "Swap To Pump Day") {
                                    monthProvider.changeIsPumpDay(true);
                                    monthProvider.changeValue(['Start Workout', 'Swap To Rest Day'], "Start Workout");

                                    _saveDayData(
                                      type: "Pump Day - ${monthProvider.pumpDayModel?.id}",
                                      status: Status.empty,
                                      title: monthProvider.pumpDayModel?.title,
                                    );
                                  } else if (monthProvider.selectedButtonTitle == "Start Workout") {
                                    await _saveDayData(
                                      type: "Pump Day - ${monthProvider.pumpDayModel?.id}",
                                      status: Status.started,
                                      title: monthProvider.pumpDayModel?.title,
                                    );
                                    Navigator.pushNamed(context, '/today');
                                  } else if (monthProvider.selectedButtonTitle == "Swap To Rest Day") {
                                    monthProvider.changeValue(["Mark Complete", "Swap To Pump Day"], "Mark Complete");
                                    await _saveDayData(type: "Rest Day", status: Status.empty);
                                    monthProvider.checkPumpDayAvail();
                                  }
                                },
                                child: Container(
                                  height: media.height * 0.075,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 10),
                                  margin: EdgeInsets.only(
                                    bottom: ScreenUtil.verticalScale(2),
                                    right: ScreenUtil.horizontalScale(10),
                                    top: ScreenUtil.verticalScale(2),
                                    left: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(ScreenUtil.verticalScale(4)),
                                      bottomRight: Radius.circular(ScreenUtil.verticalScale(4)),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x20888888),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(
                                      fontSize: ScreenUtil.verticalScale(1.8),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    } else {
                      buttonText = currentDayTitle.contains("Rest Day")
                          ? "Mark Complete"
                          : monthProvider.dayHistoryDetails?.status == Status.started ||
                                  monthProvider.dayHistoryDetails?.status == Status.completed
                              ? "View the workout"
                              : monthProvider.dayHistoryDetails?.status == Status.skipped
                                  ? "Skipped. View here"
                                  : "Start the workout";

                      onPress = () async {
                        if (currentDayTitle.contains("Rest Day")) {
                          Navigator.pushNamed(context, '/dayCompleted');
                          _saveDayData(status: Status.completed, type: 'Rest Day');
                        } else {
                          if (monthProvider.dayHistoryDetails?.status != Status.skipped &&
                              monthProvider.dayHistoryDetails?.status != Status.completed) {
                            monthProvider.changeIsPumpDay(false);
                            await _saveDayData(status: Status.started, type: 'Workout Day');
                          }
                          Navigator.pushNamed(context, '/today');
                        }
                      };
                    }

                    return buttonText.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(10)),
                            child: ButtonWidget(
                              text: buttonText,
                              textColor: Colors.white,
                              onPress: onPress,
                              color: buttonColor,
                              isLoading: false,
                            ),
                          )
                        : const SizedBox();
                  },
                ),
                SizedBox(height: ScreenUtil.verticalScale(8)),
                Consumer<MonthProvider>(
                  builder: (context, monthProvider, child) {
                    if (monthProvider.isPastWeek) {
                      return const SizedBox();
                    }

                    if (currentDayTitle.contains("Rest Day") &&
                        monthProvider.dayHistoryDetails?.status == Status.completed &&
                        !monthProvider.isPumpDay) {
                      return Container(
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(10)),
                        child: const ButtonWidget(
                          text: "Completed",
                          textColor: Colors.white,
                          onPress: null,
                          color: AppColors.primaryColor,
                          isLoading: false,
                        ),
                      );
                    }

                    if (monthProvider.dayHistoryDetails?.status != Status.completed) {
                      String buttonText = monthProvider.dayHistoryDetails?.status == Status.skipped ? "Unskip?" : "Skip Day";
                      onPress() async {
                        bool isSkipped = monthProvider.dayHistoryDetails?.status == Status.skipped;
                        String newStatus = isSkipped ? '' : Status.skipped;
                        String type = monthProvider.isPumpDay
                            ? "Pump Day - ${monthProvider.pumpDayModel?.id}"
                            : currentDayTitle.contains("Rest Day")
                                ? 'Rest Day'
                                : 'Workout Day';

                        if (!isSkipped) Navigator.pop(context);
                        await _skipUnskipDayData(status: newStatus, type: type);
                      }

                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(10)),
                        child: ButtonWidget(
                          text: buttonText,
                          textColor: Colors.white,
                          onPress: onPress,
                          color: AppColors.skipDayColor,
                          isLoading: false,
                        ),
                      );
                    }

                    return const SizedBox(height: 0);
                  },
                ),
                SizedBox(height: ScreenUtil.verticalScale(11)),
              ],
            ),
          );
  }

  Future<void> _skipExerciseData({required String status, required String id, required String type}) async {
    String dataId =
        "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}-$id";

    final data = {
      "dataId": dataId,
      "exerciseId": id.toString(),
      "monthId": monthProvider?.monthDataModel?.id,
      "weekId": monthProvider?.weekDataModel?.id,
      "dayId": monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1],
      "split": monthProvider?.splitType,
      "date": "${DateTime.now().toUtc()}",
      "status": status,
      "type": type
    };

    final data1 = {
      "date": "${DateTime.now().toUtc()}",
      "status": status,
      "type": type,
    };

    if (monthProvider!.exerciseHistoryModel.isNotEmpty) {
      if (monthProvider!.exerciseHistoryModel.any((element) => element.dataId == dataId)) {
        DatabaseHelper().updateData(data: data1, tableName: DatabaseHelper.exerciseStatus, id: dataId);
      } else {
        DatabaseHelper().insertData(data: data, tableName: DatabaseHelper.exerciseStatus);
      }
    } else {
      DatabaseHelper().insertData(data: data, tableName: DatabaseHelper.exerciseStatus);
    }
  }

  Future<void> _unskipExerciseData({required String status, required String id, required String type}) async {
    String dataId =
        "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}-$id";
    final data = {
      "status": status,
      "type": type,
    };
    DatabaseHelper().updateData(tableName: DatabaseHelper.exerciseStatus, id: dataId, data: data);
  }

  Future<void> unSkipped(String status) async {
    if (monthProvider!.isPumpDay) {
      if (monthProvider!.pumpDayModel!.circuits!.isNotEmpty) {
        final data = monthProvider!.pumpDayModel!.circuits!;
        for (int i = 0; i < data.length; i++) {
          var elementI = data[i];
          for (int j = 0; j < elementI.round!; j++) {
            for (int z = 0; z < elementI.circuitExercises!.length; z++) {
              var elementZ = elementI.circuitExercises?[z];
              String dataId =
                  "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}-${elementZ?.exerciseId}-$i:$j";
              bool? val =
                  monthProvider?.exerciseHistoryModel.any((element) => element.dataId == dataId && element.status == Status.skipped);
              if (val == true) {
                await _unskipExerciseData(status: status, id: "${elementZ?.exerciseId}-$i:$j", type: 'Circuit - $i:$j');
              }
            }
          }
        }
      }
    }
    if (monthProvider!.isPumpDay ? monthProvider!.pumpDayModel!.exercises != null : monthProvider!.dayDataModel!.exercises != null) {
      final data = monthProvider!.isPumpDay ? monthProvider!.pumpDayModel!.exercises : monthProvider!.dayDataModel!.exercises;
      for (int i = 0; i < data!.length; i++) {
        var elementI = data[i];
        String dataId =
            "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}-${elementI.exerciseId}";
        bool? val = monthProvider?.exerciseHistoryModel.any((element) => element.dataId == dataId && element.status == Status.skipped);
        if (val == true) {
          await _unskipExerciseData(status: status, id: elementI.exerciseId!, type: 'Exercise');
        }
      }
    }
    if (monthProvider!.isPumpDay ? monthProvider!.pumpDayModel!.warmups != null : monthProvider!.dayDataModel!.warmups != null) {
      final data = monthProvider!.isPumpDay ? monthProvider!.pumpDayModel!.warmups : monthProvider!.dayDataModel!.warmups;
      for (int i = 0; i < data!.length; i++) {
        var elementI = data[i];
        String dataId =
            "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}-${elementI.warmupId}";
        bool? val = monthProvider?.exerciseHistoryModel.any((element) => element.dataId == dataId && element.status == Status.skipped);
        if (val == true) {
          await _unskipExerciseData(status: status, id: elementI.warmupId!, type: 'Warmup');
        }
      }
    }
  }

  Future<void> skipped(String status) async {
    if (monthProvider!.isPumpDay) {
      if (monthProvider!.pumpDayModel!.circuits!.isNotEmpty) {
        final data = monthProvider!.pumpDayModel!.circuits!;
        for (int i = 0; i < data.length; i++) {
          var elementI = data[i];
          for (int j = 0; j < elementI.round!; j++) {
            for (int z = 0; z < elementI.circuitExercises!.length; z++) {
              var elementZ = elementI.circuitExercises?[z];
              String dataId =
                  "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}-${elementZ?.exerciseId}-$i:$j";
              bool? val = monthProvider?.exerciseHistoryModel
                  .any((element) => element.dataId == dataId && (element.status == Status.completed || element.status == Status.skipped));
              if (val == false) {
                await _skipExerciseData(status: status, id: "${elementZ?.exerciseId}-$i:$j", type: 'Circuit - $i:$j');
              }
            }
          }
        }
      }
    }
    if (monthProvider!.dayDataModel!.exercises != null) {
      final data = monthProvider!.dayDataModel!.exercises;
      for (int i = 0; i < data!.length; i++) {
        var elementI = data[i];
        String dataId =
            "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}-${elementI.exerciseId}";
        bool? val = monthProvider?.exerciseHistoryModel
            .any((element) => element.dataId == dataId && (element.status == Status.completed || element.status == Status.skipped));
        if (val == false) {
          await _skipExerciseData(status: status, id: elementI.exerciseId!, type: 'Exercise');
        }
      }
    }
    if (monthProvider!.dayDataModel!.warmups != null) {
      final data = monthProvider!.dayDataModel!.warmups;
      for (int i = 0; i < data!.length; i++) {
        var elementI = data[i];
        String dataId =
            "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}-${elementI.warmupId}";
        bool? val = monthProvider?.exerciseHistoryModel
            .any((element) => element.dataId == dataId && (element.status == Status.completed || element.status == Status.skipped));
        if (val == false) {
          await _skipExerciseData(status: status, id: elementI.warmupId!, type: 'Warmup');
        }
      }
    }
  }

  Future<void> _skipUnskipDayData({required String status, required String type}) async {
    if (type != "Rest Day" || monthProvider!.isPumpDay) {
      if (status == Status.skipped) {
        await skipped(status);
      } else {
        await unSkipped(status);
      }
    }

    String dataId =
        "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}";

    final data = {
      "dataId": dataId,
      "monthId": monthProvider?.monthDataModel?.id,
      "weekId": monthProvider?.weekDataModel?.id,
      "dayId": monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1],
      "split": monthProvider?.splitType,
      "date": "${DateTime.now().toUtc()}",
      "status": status,
      "type": type,
      "startTime": status == Status.empty ? "" : "${DateTime.now().toUtc()}",
      "endTime": status == Status.empty ? "" : "${DateTime.now().toUtc()}",
    };

    DayHistoryModel? matchingElement = monthProvider?.dayHistoryModel.firstWhere(
      (element) => element.dataId == dataId,
      orElse: () => DayHistoryModel(),
    );

    final data1 = {
      "status": status,
      "type": type,
      "startTime": status == Status.empty
          ? ""
          : matchingElement?.startTime == null
              ? "${DateTime.now().toUtc()}"
              : matchingElement?.startTime.toString(),
      "endTime": status == Status.empty ? "" : "${DateTime.now().toUtc()}",
    };

    if (matchingElement?.id != null) {
      DatabaseHelper().updateData(tableName: DatabaseHelper.dayStatus, id: dataId, data: data1);
    } else {
      DatabaseHelper().insertData(data: data, tableName: DatabaseHelper.dayStatus);
    }

    await monthProvider?.fetchExerciseHistoryLocalData();
    await monthProvider?.fetchExerciseStatusLocalData();
    await monthProvider?.updateDayData();
    await monthProvider?.fetchDayStatusLocalData();
    await monthProvider?.fetchSingleDayHistoryLocalData();
    monthProvider?.manageStreak();
    monthProvider?.getLiftedWeightGraphData();
  }

  Future<void> _saveDayData({required String status, required String type, String? title}) async {
    String dataId =
        "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}";

    final data = {
      "title": title ?? "",
      "dataId": dataId,
      "monthId": monthProvider?.monthDataModel?.id,
      "weekId": monthProvider?.weekDataModel?.id,
      "dayId": monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1],
      "split": monthProvider?.splitType,
      "date": "${DateTime.now().toUtc()}",
      "status": status,
      "type": type,
      "startTime": (status == Status.started || status == Status.completed) ? "${DateTime.now().toUtc()}" : "",
      "endTime": (status == Status.completed) ? "${DateTime.now().toUtc()}" : "",
    };

    DayHistoryModel? matchingElement = monthProvider?.dayHistoryModel.firstWhere(
      (element) => element.dataId == dataId,
      orElse: () => DayHistoryModel(),
    );

    final data1 = {
      "title": title,
      "status": status,
      "type": type,
      "startTime": status == Status.empty
          ? ""
          : matchingElement?.startTime == null
              ? "${DateTime.now().toUtc()}"
              : matchingElement?.startTime.toString(),
      "endTime": (status == Status.completed) ? "${DateTime.now().toUtc()}" : "",
    };

    if (matchingElement?.id != null) {
      DatabaseHelper().updateData(tableName: DatabaseHelper.dayStatus, id: dataId, data: data1);
    } else {
      DatabaseHelper().insertData(data: data, tableName: DatabaseHelper.dayStatus);
    }

    await monthProvider?.fetchDayStatusLocalData();
    await monthProvider?.fetchSingleDayHistoryLocalData();
    await monthProvider?.updateDayData();
    monthProvider?.manageStreak();
    monthProvider?.getLiftedWeightGraphData();
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil.verticalScale(0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text != ""
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(height: ScreenUtil.verticalScale(1.3)),
                  Icon(Icons.circle, size: ScreenUtil.verticalScale(0.6), color: Colors.black54),
                ])
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(height: ScreenUtil.verticalScale(1.3)),
                ]),
          const SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(maxWidth: media.width / 1.4),
            child: Text(
              text,
              style: TextStyle(
                fontSize: ScreenUtil.horizontalScale(4),
                color: Colors.black54,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
