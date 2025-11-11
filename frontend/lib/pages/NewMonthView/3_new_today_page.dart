import 'dart:convert';

import 'package:bbb/components/button_widget.dart';
import 'package:bbb/components/common_network_image.dart';
import 'package:bbb/components/common_streak_with_notification.dart';
import 'package:bbb/pages/NewMonthView/Database/month_database.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/new_model.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/removed_exercise_model.dart';
import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/pages/NewMonthView/Widgets/new_circuits_view.dart';
import 'package:bbb/pages/video_intro_page.dart';
import 'package:bbb/providers/main_page_provider.dart';
import 'package:bbb/routes/fade_page_route.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class NewTodayPage extends StatefulWidget {
  const NewTodayPage({super.key});

  @override
  State<NewTodayPage> createState() => _NewTodayPageState();
}

class _NewTodayPageState extends State<NewTodayPage> {
  final today = DateTime.now();
  MonthProvider? monthProvider;

  late int week;
  late int day;

  List<ExerciseDataModel> exercises = [];
  List<RemovedExerciseModel> removedExercise = [];
  int totalWarmups = 0;
  bool isCurrentDayCompleted = false;
  bool isCurrentDaySkipped = false;

  @override
  void initState() {
    monthProvider = Provider.of<MonthProvider>(context, listen: false);
    fetchWarmupData();
    exercises = monthProvider!.isPumpDay ? monthProvider!.pumpDayModel!.exercises! : monthProvider!.dayDataModel!.exercises!;
    totalWarmups = monthProvider!.isPumpDay ? monthProvider!.pumpDayModel!.warmups!.length : monthProvider!.dayDataModel!.warmups!.length;
    DateTime startTime = monthProvider?.startTime ?? DateTime.now();
    int dayDelta = today.difference(startTime).inDays;
    week = (dayDelta ~/ 7);
    day = dayDelta % 7;
    monthProvider?.fetchExerciseStatusLocalData();
    fetchRemovedExerciseLocalData();
    isCurrentDayCompleted = monthProvider?.dayHistoryDetails?.status == Status.completed;
    isCurrentDaySkipped = monthProvider?.dayHistoryDetails?.status == Status.skipped;
    super.initState();
  }

  void fetchWarmupData() {
    final warmups = monthProvider!.isPumpDay ? monthProvider!.pumpDayModel!.warmups : monthProvider!.dayDataModel!.warmups;
    if (warmups != null && warmups.isNotEmpty) {
      monthProvider?.fetchWarmUp(warmups[0].warmupId!);
    }
  }

  Future<void> onPressed(int exerciseIndex, String dataId) async {
    monthProvider?.updateIsCircuit(false);
    monthProvider?.updateCircuit("", 0);
    monthProvider?.setSelectedExercise(exercises[exerciseIndex], exerciseIndex);
    monthProvider?.updateWarmUp(false);
    Navigator.pushNamed(context, '/exercise');
    monthProvider?.fetchExerciseSingleExerciseLocalData(dataId);
  }

  fetchRemovedExerciseLocalData() async {
    String dataId =
        "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}";
    final data = await DatabaseHelper().getDataFromTable(tableName: DatabaseHelper.removedExerciseHistory, where: 'dataId', id: dataId);
    if (data.isNotEmpty) {
      removedExercise = List<RemovedExerciseModel>.from(json.decode(jsonEncode(data)).map((x) => RemovedExerciseModel.fromJson(x)));
    } else {
      removedExercise = [];
    }
    setState(() {});
    monthProvider?.fetchAllRemovedExerciseLocalData();
  }

  Future<void> removeExercise(String exerciseId) async {
    String dataId =
        "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}";
    final data = {"exerciseId": exerciseId, "dataId": dataId};
    await DatabaseHelper().insertData(data: data, tableName: DatabaseHelper.removedExerciseHistory);
    await fetchRemovedExerciseLocalData();
  }

  Future fetchAllFilterEx(String searchQuery) async {
    if (searchQuery.isEmpty) {
      // allFilterExercises = allExercises;
    } else {
      // allFilterExercises = allExercises.where((exercise) => exercise.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    var contact = ModalRoute.of(context)?.settings.arguments;
    if (contact != null) {
      contact as Map;
      setState(() {});
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    context.watch<MainPageProvider>();
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
                          height: media.height / 3,
                          width: media.width,
                          child: SafeArea(
                            child: Column(
                              children: [
                                Container(
                                  width: ScreenUtil.horizontalScale(100),
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: ScreenUtil.horizontalScale(10),
                                            height: ScreenUtil.horizontalScale(10),
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            decoration: const BoxDecoration(
                                              color: Color(0XFFd18a9b),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () => Navigator.pop(context),
                                                child: Icon(
                                                  Icons.keyboard_arrow_left,
                                                  color: Colors.white,
                                                  size: ScreenUtil.verticalScale(4),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        'Day ${monthProvider!.overviewCurrentDay}, Option ${monthProvider!.alternateEquipmentType}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil.horizontalScale(5.8),
                                        ),
                                      ),
                                      const CommonStreakWithNotification(),
                                    ],
                                  ),
                                ),
                                SizedBox(height: ScreenUtil.verticalScale(3)),
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
                                          page: const VideoIntroWidget(vimeoId: '953289606'),
                                        ),
                                      );
                                    },
                                    textColor: AppColors.primaryColor,
                                    isLoading: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.height / 3.99,
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
                  margin: EdgeInsets.only(top: media.height / 4),
                  child: Container(
                    width: media.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil.horizontalScale(16)),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: ScreenUtil.horizontalScale(8)),
                      child: Column(
                        children: [
                          totalWarmups == 0 ? const SizedBox() : warmUpSection(media),
                          Container(
                            width: media.width,
                            margin: EdgeInsets.only(left: ScreenUtil.verticalScale(3)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Today's workout",
                                  style: TextStyle(
                                    fontSize: ScreenUtil.horizontalScale(5.5),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(height: media.height * 0.025),
                                monthProvider!.isPumpDay
                                    ? NewCircuitsView(circuit: monthProvider!.pumpDayModel!.circuits!)
                                    : const SizedBox(),
                                Column(
                                  children: List.generate(
                                    exercises.length,
                                    (i) {
                                      if (removedExercise.any((element) => element.exerciseId == exercises[i].exerciseId!)) {
                                        return const SizedBox();
                                      }

                                      String dataId =
                                          "${monthProvider!.splitType}-${monthProvider!.monthDataModel?.id}-${monthProvider!.weekDataModel?.id}-${monthProvider!.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}-${exercises[i].exerciseId}";

                                      bool isExist = (!monthProvider!.exerciseHistoryModel.any((item) => item.dataId != dataId)) &&
                                          monthProvider!.isPastWeek;

                                      return Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: ScreenUtil.verticalScale(3)),
                                            child: WorkoutCard(
                                              isCircuit: false,
                                              isCompleted: monthProvider!.exerciseHistoryModel
                                                  .any((element) => element.dataId == dataId && element.status == Status.completed),
                                              isSkipped: monthProvider!.exerciseHistoryModel
                                                      .any((element) => element.dataId == dataId && element.status == Status.skipped) ||
                                                  isExist,
                                              exerciseIndex: i,
                                              onPress: () => onPressed(i, dataId),
                                              openSwapModal: () {
                                                // await userData.fetchCurrentEx(exercises[i].id!, "today page 1464");
                                                // await userData.fetchAllExercise();
                                                // showRelatedExerciseDialog(i, exercises[i], false);
                                              },
                                              exercise: exercises[i],
                                              exerciseData: exercises[i].id!,
                                              name: exercises[i].name!.isEmpty ? "Exercise ${i + 1}" : exercises[i].name!,
                                              onRemove: () => removeExercise(exercises[i].exerciseId!),
                                              enabled: isCurrentDayCompleted || isCurrentDaySkipped
                                                  ? false
                                                  : monthProvider!.exerciseHistoryModel.any((element) =>
                                                              element.dataId == dataId && element.status == Status.completed) ||
                                                          isExist
                                                      ? false
                                                      : true,
                                            ),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil.verticalScale(3),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtil.verticalScale(2)),
                          monthProvider?.dayHistoryDetails == null ||
                                  (monthProvider?.dayHistoryDetails?.status == Status.skipped ||
                                          monthProvider?.dayHistoryDetails?.status == Status.completed) &&
                                      monthProvider!.isPastWeek
                              ? const SizedBox()
                              : Padding(
                                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil.verticalScale(5)),
                                  child: ButtonWidget(
                                    onPress: () {},
                                    isLoading: false,
                                    color: Colors.grey,
                                    textColor: Colors.white,
                                    text: "Add Exercise",
                                  ),
                                ),
                          // GestureDetector(
                          //   onTap: () async {
                          //     await userData?.fetchAllExercise();
                          //     showRelatedExerciseDialog(0, 0, true);
                          //   },
                          //   child: Container(
                          //     padding: EdgeInsets.all(
                          //       ScreenUtil.verticalScale(2),
                          //     ),
                          //     decoration: BoxDecoration(
                          //       gradient: LinearGradient(
                          //         colors: [
                          //           const Color(0xFF9B3651),
                          //           const Color(0xFFDB4671).withOpacity(0.79),
                          //         ],
                          //         begin: Alignment.bottomLeft,
                          //         end: Alignment.bottomRight,
                          //       ),
                          //       shape: BoxShape.circle,
                          //     ),
                          //     child: Icon(
                          //       Icons.add,
                          //       color: Colors.white,
                          //       size: ScreenUtil.verticalScale(3.5),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 36),
                          Container(
                            height: 1,
                            margin: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(6)),
                            width: media.width * 0.75,
                            color: Colors.black12,
                          ),
                          const SizedBox(height: 36),
                          monthProvider?.dayHistoryDetails == null ||
                                  (monthProvider?.dayHistoryDetails?.status == Status.skipped ||
                                          monthProvider?.dayHistoryDetails?.status == Status.completed) &&
                                      monthProvider!.isPastWeek
                              ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil.verticalScale(5)),
                                  child: ButtonWidget(
                                    text: monthProvider?.dayHistoryDetails?.status == Status.completed ? "Completed" : "Skipped",
                                    textColor: Colors.white,
                                    onPress: null,
                                    color: AppColors.primaryColor,
                                    isLoading: false,
                                  ),
                                )
                              : Consumer<MonthProvider>(
                                  builder: (context, value, child) => Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: ScreenUtil.verticalScale(5)),
                                        child: ButtonWidget(
                                          text: value.dayHistoryDetails?.status == Status.completed
                                              ? "Completed"
                                              : value.dayHistoryDetails?.status == Status.skipped
                                                  ? "Skipped"
                                                  : "Finish the workout",
                                          textColor: Colors.white,
                                          onPress: value.dayHistoryDetails?.status == Status.completed ||
                                                  value.dayHistoryDetails?.status == Status.skipped
                                              ? null
                                              : () async {
                                                  await _saveDayData(
                                                      status: Status.skipped,
                                                      type: monthProvider!.isPumpDay
                                                          ? "Pump Day - ${monthProvider?.pumpDayModel?.id}"
                                                          : "Workout Day",
                                                      status1: Status.completed);
                                                  Navigator.pushNamed(context, '/dayCompleted');
                                                },
                                          color: AppColors.primaryColor,
                                          isLoading: false,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      value.dayHistoryDetails?.status != Status.skipped &&
                                              value.dayHistoryDetails?.status != Status.completed
                                          ? Container(
                                              margin: EdgeInsets.symmetric(horizontal: ScreenUtil.verticalScale(5)),
                                              child: ButtonWidget(
                                                text: "Skip the workout",
                                                textColor: Colors.white,
                                                onPress: () async {
                                                  await _saveDayData(
                                                      status: Status.skipped,
                                                      type: monthProvider!.isPumpDay
                                                          ? "Pump Day- ${monthProvider?.pumpDayModel?.id}"
                                                          : "Workout Day",
                                                      status1: Status.skipped);
                                                  Navigator.pushNamed(context, '/home');
                                                },
                                                color: AppColors.skipDayColor,
                                                isLoading: false,
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
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

  /// WARMUP SECTION

  Widget warmUpSection(Size media) {
    return Container(
      width: media.width,
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil.horizontalScale(4),
        vertical: ScreenUtil.verticalScale(2),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil.verticalScale(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Warm-Up',
              style: TextStyle(
                fontSize: ScreenUtil.horizontalScale(6),
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Consumer<MonthProvider>(builder: (context, monthProvider, child) {
              String warmUpDataId =
                  "${monthProvider.splitType}-${monthProvider.monthDataModel?.id}-${monthProvider.weekDataModel?.id}-${monthProvider.weekDataModel?.idList![monthProvider.overviewCurrentDay - 1]}-${monthProvider.warmUpModel?.id}";

              bool isExist = (!monthProvider.exerciseHistoryModel.any((item) => item.dataId != warmUpDataId)) && monthProvider.isPastWeek;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: media.width / 3.7,
                    width: media.width / 3.7,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: monthProvider.warmUpModel?.thumbnail != ''
                            ? NetworkImage(
                                "${monthProvider.warmUpModel?.thumbnail}".startsWith('https://storage.cloud.google.com/')
                                    ? "${monthProvider.warmUpModel?.thumbnail}"
                                        .replaceFirst('https://storage.cloud.google.com/', 'https://storage.googleapis.com/')
                                    : "${monthProvider.warmUpModel?.thumbnail}",
                              )
                            : const AssetImage('assets/img/warm-up-placeholder.png'),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          ScreenUtil.verticalScale(1),
                        ),
                      ),
                    ),
                    child: Container(
                      decoration: monthProvider.exerciseHistoryModel
                              .any((element) => element.dataId == warmUpDataId && element.status == Status.completed)
                          ? BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFAADDAA).withOpacity(0.8),
                                  const Color(0xFFAADDAA).withOpacity(0.8),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  ScreenUtil.verticalScale(1),
                                ),
                              ),
                            )
                          : (monthProvider.exerciseHistoryModel
                                      .any((element) => element.dataId == warmUpDataId && element.status == Status.skipped) ||
                                  isExist)
                              ? BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.secondColor.withOpacity(0.8),
                                      AppColors.secondColor.withOpacity(0.8),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      ScreenUtil.verticalScale(1),
                                    ),
                                  ),
                                )
                              : BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      ScreenUtil.verticalScale(1),
                                    ),
                                  ),
                                ),
                      child: Icon(
                        monthProvider.exerciseHistoryModel
                                .any((element) => element.dataId == warmUpDataId && element.status == Status.completed)
                            ? Icons.check
                            : Icons.close,
                        color: (monthProvider.exerciseHistoryModel.any((element) =>
                                    element.dataId == warmUpDataId &&
                                    (element.status == Status.completed || element.status == Status.skipped)) ||
                                isExist)
                            ? Colors.white
                            : Colors.transparent,
                        size: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: media.width * 0.1,
                  ),
                  SizedBox(
                    height: media.width / 3.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: ScreenUtil.horizontalScale(6.5),
                          width: ScreenUtil.horizontalScale(6.5),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/img/deadline.png'),
                              fit: BoxFit.cover,
                              opacity: 0.5,
                            ),
                          ),
                        ),
                        Container(
                          height: ScreenUtil.horizontalScale(6.2),
                          width: ScreenUtil.horizontalScale(6.2),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/img/play.png'),
                              fit: BoxFit.cover,
                              opacity: 0.3,
                            ),
                          ),
                        ),
                        Container(
                          height: ScreenUtil.horizontalScale(6),
                          width: ScreenUtil.horizontalScale(6),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/img/question.png'),
                              fit: BoxFit.cover,
                              opacity: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    height: media.width / 3.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${monthProvider.warmUpModel?.length ?? ""} Min',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil.horizontalScale(4.5),
                          ),
                        ),
                        Text(
                          totalWarmups == 1 ? "1 Video" : '$totalWarmups Videos',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil.horizontalScale(4.5),
                          ),
                        ),
                        Text(
                          'Optional',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil.horizontalScale(4.5),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: ScreenUtil.verticalScale(3),
              ),
              child: Consumer<MonthProvider>(
                builder: (context, monthProvider, child) {
                  String warmUpDataId =
                      "${monthProvider.splitType}-${monthProvider.monthDataModel?.id}-${monthProvider.weekDataModel?.id}-${monthProvider.weekDataModel?.idList![monthProvider.overviewCurrentDay - 1]}-${monthProvider.warmUpModel?.id}";
                  bool isExist =
                      (!monthProvider.exerciseHistoryModel.any((item) => item.dataId != warmUpDataId)) && monthProvider.isPastWeek;

                  return ButtonWidget(
                    text: monthProvider.exerciseHistoryModel
                            .any((element) => element.dataId == warmUpDataId && element.status == Status.completed)
                        ? "Completed"
                        : monthProvider.exerciseHistoryModel
                                    .any((element) => element.dataId == warmUpDataId && element.status == Status.skipped) ||
                                isExist
                            ? "Skipped"
                            : "Start the warm-up",
                    textColor: Colors.white,
                    onPress: monthProvider.exerciseHistoryModel.any((element) =>
                                element.dataId == warmUpDataId &&
                                (element.status == Status.completed || element.status == Status.skipped)) ||
                            isExist
                        ? null
                        : () async {
                            monthProvider.updateWarmUp(true);
                            Navigator.pushNamed(context, '/exercise');
                          },
                    color: AppColors.primaryColor,
                    isLoading: false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ADD EXERCISE SECTION

  // Future<void> showRelatedExerciseDialog(int selectedIndex, dynamic exercise, bool addModal) {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       var media = MediaQuery.of(context).size;
  //       int? selectExerciseSwapIndex;
  //       bool showFindMore = false;
  //
  //       // Pagination variables
  //       int itemsPerPage = 5;
  //       int currentPageRelated = 0;
  //       int currentPageAll = 0;
  //
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           List<Widget> buildExerciseList(List exercises, int currentPage, bool isAll) {
  //             int startIndex = currentPage * itemsPerPage + (!isAll ? 0 : userData!.currentRelatedExercises.length);
  //             int endIndex = (startIndex + itemsPerPage) > exercises.length + (!isAll ? 0 : userData!.currentRelatedExercises.length)
  //                 ? exercises.length + (!isAll ? 0 : userData!.currentRelatedExercises.length)
  //                 : startIndex + itemsPerPage;
  //
  //             return [
  //               for (int i = startIndex; i < endIndex; i++) ...[
  //                 GestureDetector(
  //                   onTap: () {
  //                     setState(() {
  //                       selectExerciseSwapIndex = i;
  //                     });
  //                   },
  //                   child: Row(
  //                     children: [
  //                       SizedBox(width: ScreenUtil.horizontalScale(5)),
  //                       Expanded(
  //                         child: Row(
  //                           children: [
  //                             Container(
  //                               width: ScreenUtil.horizontalScale(10),
  //                               height: ScreenUtil.horizontalScale(10),
  //                               decoration: BoxDecoration(
  //                                 image: const DecorationImage(
  //                                   image: AssetImage('assets/img/card.png'),
  //                                   fit: BoxFit.cover,
  //                                 ),
  //                                 borderRadius: BorderRadius.all(
  //                                   Radius.circular(ScreenUtil.horizontalScale(1)),
  //                                 ),
  //                               ),
  //                             ),
  //                             SizedBox(width: ScreenUtil.horizontalScale(2)),
  //                             Flexible(
  //                                 child: Text(
  //                               exercises[i - (!isAll ? 0 : userData!.currentRelatedExercises.length)].title,
  //                               style: TextStyle(
  //                                 color: Colors.black,
  //                                 fontSize: ScreenUtil.verticalScale(2),
  //                               ),
  //                             )),
  //                             SizedBox(width: ScreenUtil.horizontalScale(2)),
  //                           ],
  //                         ),
  //                       ),
  //                       Container(
  //                         padding: EdgeInsets.all(
  //                           ScreenUtil.verticalScale(1),
  //                         ),
  //                         decoration: BoxDecoration(
  //                           shape: BoxShape.circle,
  //                           border: Border.all(
  //                             color: AppColors.primaryColor,
  //                             width: 2,
  //                           ),
  //                           color: selectExerciseSwapIndex == i ? AppColors.primaryColor : Colors.white,
  //                         ),
  //                         child: selectExerciseSwapIndex == i
  //                             ? Icon(
  //                                 Icons.check,
  //                                 size: ScreenUtil.verticalScale(2),
  //                                 color: Colors.white,
  //                               )
  //                             : Icon(
  //                                 null,
  //                                 size: ScreenUtil.verticalScale(2),
  //                               ),
  //                       ),
  //                       SizedBox(width: ScreenUtil.horizontalScale(5)),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //               ],
  //             ];
  //           }
  //
  //           Widget buildPaginationControls(int currentPage, int totalItems, Function(int) onPageChange) {
  //             int totalPages = (totalItems / itemsPerPage).ceil();
  //             return Padding(
  //               padding: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(8)), // Add horizontal padding here
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   IconButton(
  //                     onPressed: currentPage > 0 ? () => onPageChange(0) : null,
  //                     icon: const Icon(Icons.first_page),
  //                   ),
  //                   IconButton(
  //                     onPressed: currentPage > 0 ? () => onPageChange(currentPage - 1) : null,
  //                     icon: const Icon(Icons.arrow_back),
  //                   ),
  //                   Text('Page ${currentPage + 1} of $totalPages'),
  //                   IconButton(
  //                     onPressed: (currentPage + 1) < totalPages ? () => onPageChange(currentPage + 1) : null,
  //                     icon: const Icon(Icons.arrow_forward),
  //                   ),
  //                   IconButton(
  //                     onPressed: (currentPage + 1) < totalPages ? () => onPageChange(totalPages - 1) : null,
  //                     icon: const Icon(Icons.last_page),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }
  //
  //           return Dialog(
  //             backgroundColor: Colors.white,
  //             insetPadding: const EdgeInsets.all(0),
  //             child: SizedBox(
  //               width: ScreenUtil.horizontalScale(96),
  //               child: ConstrainedBox(
  //                 constraints: BoxConstraints(
  //                   maxHeight: ScreenUtil.verticalScale(65),
  //                 ),
  //                 child: SingleChildScrollView(
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       if (!addModal) ...[
  //                         Container(
  //                           width: media.width,
  //                           padding: const EdgeInsets.all(24),
  //                           child: Align(
  //                             alignment: Alignment.center,
  //                             child: Text(
  //                               'Select Related Exercise',
  //                               style: TextStyle(
  //                                 fontSize: ScreenUtil.horizontalScale(5.5),
  //                                 fontWeight: FontWeight.bold,
  //                                 color: AppColors.primaryColor,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         Consumer<UserDataProvider>(
  //                           builder: (context, userData, child) => userData.currentRelatedExercises.isNotEmpty
  //                               ? Column(
  //                                   children: [
  //                                     ConstrainedBox(
  //                                       constraints: BoxConstraints(
  //                                         maxHeight: ScreenUtil.verticalScale(60),
  //                                       ),
  //                                       child: SingleChildScrollView(
  //                                         child: Padding(
  //                                           padding: const EdgeInsets.all(8.0),
  //                                           child: Column(
  //                                             children: buildExerciseList(userData.currentRelatedExercises, currentPageRelated, false),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 )
  //                               : const SizedBox(),
  //                         ),
  //                         Container(
  //                           width: media.width,
  //                           padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
  //                           child: Align(
  //                             alignment: Alignment.center,
  //                             child: Text(
  //                               'Or select from the list:',
  //                               style: TextStyle(
  //                                 fontSize: ScreenUtil.horizontalScale(5.5),
  //                                 fontWeight: FontWeight.bold,
  //                                 color: AppColors.primaryColor,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         SearchEquipmentField(
  //                           onChanged: (query) {
  //                             setState(() {
  //                               _searchQuery = query; // Update the search query
  //                               currentPageAll = 0;
  //                               fetchAllFilterEx(query); // Reset pagination when searching
  //                             });
  //                           },
  //                         ),
  //                         Consumer<UserDataProvider>(
  //                           builder: (context, userData, child) => userData.allFilterExercises.isNotEmpty
  //                               ? Column(
  //                                   children: [
  //                                     ConstrainedBox(
  //                                       constraints: BoxConstraints(
  //                                         maxHeight: ScreenUtil.verticalScale(60),
  //                                       ),
  //                                       child: SingleChildScrollView(
  //                                         child: Padding(
  //                                           padding: const EdgeInsets.all(8.0),
  //                                           child: Column(
  //                                             children: buildExerciseList(userData.allFilterExercises, currentPageAll, true),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     // Pagination controls for all exercises
  //                                     buildPaginationControls(
  //                                       currentPageAll,
  //                                       userData.allFilterExercises.length,
  //                                       (page) {
  //                                         setState(() {
  //                                           currentPageAll = page;
  //                                         });
  //                                       },
  //                                     ),
  //                                   ],
  //                                 )
  //                               : const SizedBox(),
  //                         ),
  //                       ] else ...[
  //                         Container(
  //                           width: media.width,
  //                           padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
  //                           child: Align(
  //                             alignment: Alignment.center,
  //                             child: Text(
  //                               'Select from the list:',
  //                               style: TextStyle(
  //                                 fontSize: ScreenUtil.horizontalScale(5.5),
  //                                 fontWeight: FontWeight.bold,
  //                                 color: AppColors.primaryColor,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         SearchEquipmentField(
  //                           onChanged: (query) {
  //                             setState(() {
  //                               _searchQuery = query; // Update the search query
  //                               currentPageAll = 0;
  //                               fetchAllFilterEx(query); // Reset pagination when searching
  //                             });
  //                           },
  //                         ),
  //                         Consumer<UserDataProvider>(
  //                           builder: (context, userData, child) => userData.allFilterExercises.isNotEmpty
  //                               ? Column(
  //                                   children: [
  //                                     ConstrainedBox(
  //                                       constraints: BoxConstraints(
  //                                         maxHeight: ScreenUtil.verticalScale(60),
  //                                       ),
  //                                       child: SingleChildScrollView(
  //                                         child: Padding(
  //                                           padding: const EdgeInsets.all(8.0),
  //                                           child: Column(
  //                                             children: buildExerciseList(userData.allFilterExercises, currentPageAll, false),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     // Pagination controls for all exercises
  //                                     buildPaginationControls(
  //                                       currentPageAll,
  //                                       userData.allFilterExercises.length,
  //                                       (page) {
  //                                         setState(() {
  //                                           currentPageAll = page;
  //                                         });
  //                                       },
  //                                     ),
  //                                   ],
  //                                 )
  //                               : const SizedBox(),
  //                         ),
  //                       ],
  //                       // ignore: dead_code
  //                       if (showFindMore) ...[
  //                         const SizedBox(height: 10),
  //                         Padding(
  //                           padding: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(8)),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             children: [
  //                               const Icon(Icons.search, color: Colors.black), // Non-clickable icon
  //                               const SizedBox(width: 8), // Space between icon & text field
  //                               Expanded(
  //                                 child: TextField(
  //                                   decoration: const InputDecoration(
  //                                     hintText: 'Type to find more...',
  //                                     hintStyle: TextStyle(color: Colors.grey),
  //                                     border: OutlineInputBorder(),
  //                                   ),
  //                                   onSubmitted: (value) {
  //                                     setState(() {
  //                                       // Logic to load more items or search
  //                                     });
  //                                   },
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         const SizedBox(height: 10),
  //                       ],
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 Navigator.pop(context);
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 foregroundColor: Colors.black,
  //                                 backgroundColor: const Color(0xFFDDDDDD),
  //                                 shadowColor: Colors.grey,
  //                                 padding: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(12), vertical: 12),
  //                                 textStyle: const TextStyle(
  //                                   fontSize: 16,
  //                                 ),
  //                               ),
  //                               child: const Text('Cancel'),
  //                             ),
  //                             ElevatedButton(
  //                               onPressed: selectExerciseSwapIndex != null &&
  //                                       !((!addModal &&
  //                                               selectExerciseSwapIndex! < userData!.currentRelatedExercises.length &&
  //                                               userData!.currentDayObj.exercises.any((exerciseData) =>
  //                                                   exerciseData.id == userData!.currentRelatedExercises[selectExerciseSwapIndex!].id)) ||
  //                                           (!addModal &&
  //                                               selectExerciseSwapIndex! >= userData!.currentRelatedExercises.length &&
  //                                               userData!.currentDayObj.exercises.any((exerciseData) =>
  //                                                   exerciseData.id ==
  //                                                   userData!
  //                                                       .allFilterExercises[
  //                                                           selectExerciseSwapIndex! - userData!.currentRelatedExercises.length]
  //                                                       .id)) ||
  //                                           (addModal &&
  //                                               userData!.currentDayObj.exercises.any((exerciseData) =>
  //                                                   exerciseData.id == userData!.allFilterExercises[selectExerciseSwapIndex!].id)))
  //                                   ? () {
  //                                       // Your logic for swap or add
  //                                       if (!addModal) {
  //                                         if (selectExerciseSwapIndex! < userData!.currentRelatedExercises.length) {
  //                                           dataProvider?.swapExerciseById(
  //                                               userData!.currentWeek,
  //                                               userData!.currentDay,
  //                                               selectedIndex,
  //                                               exercise.id,
  //                                               userData!.currentRelatedExercises[selectExerciseSwapIndex!].title,
  //                                               userData!.currentRelatedExercises[selectExerciseSwapIndex!].id);
  //                                         } else {
  //                                           dataProvider?.swapExerciseById(
  //                                               userData!.currentWeek,
  //                                               userData!.currentDay,
  //                                               selectedIndex,
  //                                               exercise.id,
  //                                               userData!
  //                                                   .allFilterExercises[
  //                                                       selectExerciseSwapIndex! - userData!.currentRelatedExercises.length!]
  //                                                   .title,
  //                                               userData!
  //                                                   .allFilterExercises[
  //                                                       selectExerciseSwapIndex! - userData!.currentRelatedExercises.length!]
  //                                                   .id);
  //                                         }
  //
  //                                         userData?.removeExerciseDataById(selectedIndex);
  //                                       } else {
  //                                         // Add logic
  //                                         if (exercises.isNotEmpty) {
  //                                           DayExercise newDayExercise = DayExercise(
  //                                               id: userData?.allFilterExercises[selectExerciseSwapIndex!].id ?? "",
  //                                               id_: "",
  //                                               typeId: exercises[0].typeId ?? 1,
  //                                               name: userData?.allFilterExercises[selectExerciseSwapIndex!].title ??
  //                                                   "Exercise ${exercises.length + 1}",
  //                                               guide: exercises[0].guide ?? "",
  //                                               sets: exercises[0].sets ?? 0,
  //                                               reps: exercises[0].reps ?? 0,
  //                                               rest: exercises[0].rest ?? 0,
  //                                               weight: exercises[0].weight ?? 0,
  //                                               // weight: "",
  //                                               duration: exercises[0].duration ?? "",
  //                                               formats: exercises[0].formats ?? [],
  //                                               extra: exercises[0].extra ?? []);
  //
  //                                           debugPrint(selectExerciseSwapIndex.toString());
  //
  //                                           debugPrint(userData?.allFilterExercises[selectExerciseSwapIndex!].id);
  //
  //                                           dataProvider?.addExerciseById(userData!.currentWeek, userData!.currentDay, newDayExercise);
  //                                         } else {
  //                                           DayExercise newDayExercise = DayExercise(
  //                                               id: userData?.allFilterExercises[selectExerciseSwapIndex!].id ?? "",
  //                                               id_: "",
  //                                               typeId: userData!.currentDay,
  //                                               name: userData?.allFilterExercises[selectExerciseSwapIndex!].title ??
  //                                                   "Exercise ${exercises.length + 1}",
  //                                               guide: "",
  //                                               sets: 5,
  //                                               reps: 10,
  //                                               rest: 3,
  //                                               weight: 30,
  //                                               // weight: "",
  //                                               duration: "15",
  //                                               formats: ["A", "B", "C"],
  //                                               extra: []
  //
  //                                               ///
  //                                               );
  //
  //                                           debugPrint(userData?.allFilterExercises[selectExerciseSwapIndex!].id);
  //
  //                                           dataProvider?.addExerciseById(userData!.currentWeek, userData!.currentDay, newDayExercise);
  //                                         }
  //                                       }
  //                                       setCurrentDayObj();
  //                                       Navigator.pop(context);
  //                                     }
  //                                   : null,
  //                               style: ElevatedButton.styleFrom(
  //                                 foregroundColor: Colors.white,
  //                                 backgroundColor: AppColors.primaryColor,
  //                                 shadowColor: Colors.grey,
  //                                 padding: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(12), vertical: 12),
  //                                 textStyle: const TextStyle(
  //                                   fontSize: 16,
  //                                 ),
  //                               ),
  //                               child: const Text('Confirm'),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  /// SAVE DATA INTO SQL

  Future<void> _saveExerciseData({required String status, required String id, required String type}) async {
    String dataId =
        "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}-$id";

    final data = {
      "dataId": dataId,
      "exerciseId": id,
      "monthId": monthProvider?.monthDataModel?.id,
      "weekId": monthProvider?.weekDataModel?.id,
      "dayId": monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1],
      "split": monthProvider?.splitType,
      "date": "${DateTime.now().toUtc()}",
      "status": status,
      "type": type
    };

    final data1 = {
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

  Future<void> _saveDayData({required String status, required String type, required String status1}) async {
    await monthProvider?.fetchExerciseStatusLocalData();

    double totalWeight = 0;
    int exCount = 0;

    for (int i = 0; i < monthProvider!.exerciseHistoryModel.length; i++) {
      var element = monthProvider!.exerciseHistoryModel[i];
      if (element.status == Status.completed) {
        exCount++;
        totalWeight += double.parse(element.totalWeight!);
      }
    }

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
                await _saveExerciseData(status: status, id: "${elementZ?.exerciseId}-$i:$j", type: 'Circuit - $i:$j');
              }
            }
          }
        }
      }
    }

    if (exercises.isNotEmpty) {
      final data = exercises;

      for (int i = 0; i < data.length; i++) {
        var elementI = data[i];

        String dataId =
            "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}-${elementI.exerciseId}";

        bool? val = monthProvider?.exerciseHistoryModel
            .any((element) => element.dataId == dataId && (element.status == Status.completed || element.status == Status.skipped));
        if (val == false) {
          await _saveExerciseData(status: status, id: elementI.exerciseId!, type: 'Exercise');
        }
      }
    }

    if (monthProvider!.isPumpDay ? monthProvider?.pumpDayModel?.warmups != null : monthProvider!.dayDataModel!.warmups != null) {
      final data = monthProvider!.isPumpDay ? monthProvider?.pumpDayModel?.warmups : monthProvider!.dayDataModel!.warmups;
      for (int i = 0; i < data!.length; i++) {
        var elementI = data[i];

        String dataId =
            "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}-${elementI.warmupId}";
        bool? val = monthProvider?.exerciseHistoryModel
            .any((element) => element.dataId == dataId && (element.status == Status.completed || element.status == Status.skipped));
        if (val == false) {
          await _saveExerciseData(status: status, id: elementI.warmupId!, type: 'Warmup');
        }
      }
    }

    String dataId =
        "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}";

    ///

    final data1 = {
      "status": status1,
      "type": type,
      "endTime": (status == Status.completed || status == Status.skipped) ? "${DateTime.now().toUtc()}" : "",
      "totalWeight": totalWeight.toString(),
      "completedExercise": exCount.toString(),
    };

    DatabaseHelper().updateData(tableName: DatabaseHelper.dayStatus, id: dataId, data: data1);

    await monthProvider?.updateDayData();
    monthProvider?.fetchExerciseStatusLocalData();
    await monthProvider?.fetchDayStatusLocalData();
    await monthProvider?.fetchSingleDayHistoryLocalData();

    monthProvider?.manageStreak();
    monthProvider?.getLiftedWeightGraphData();
  }
}

class SearchEquipmentField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchEquipmentField({super.key, required this.onChanged});

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
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Search Equipment',
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

class WorkoutCard extends StatefulWidget {
  const WorkoutCard(
      {super.key,
      required this.isCompleted,
      required this.isSkipped,
      required this.exerciseIndex,
      this.onPress,
      required this.openSwapModal,
      required this.name,
      required this.exercise,
      required this.onRemove,
      required this.enabled,
      required this.exerciseData,
      required this.isCircuit,
      this.roundIndex});

  final bool isSkipped;
  final bool isCompleted;
  final int exerciseIndex;
  final void Function()? onPress;
  final void Function()? openSwapModal;
  final String name;
  final ExerciseDataModel exercise;
  final VoidCallback onRemove;
  final bool enabled;
  final bool isCircuit;
  final String exerciseData;
  final int? roundIndex;

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  final today = DateTime.now();
  String gImageUrl = "";

  @override
  void initState() {
    super.initState();
    getTotalSets();
  }

  num totalSets = 0;

  void getTotalSets() {
    if (widget.exercise.extra!.isNotEmpty) {
      for (var element in widget.exercise.extra!) {
        totalSets += int.parse(element.sets.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Slidable(
      enabled: widget.isCircuit ? false : true,
      endActionPane: widget.isCircuit
          ? null
          : widget.enabled
              ? ActionPane(
                  extentRatio: 0.35,
                  motion: const ScrollMotion(),
                  children: [
                    SizedBox(
                      width: ScreenUtil.horizontalScale(5),
                    ),
                    SizedBox(
                      height: ScreenUtil.verticalScale(4),
                      width: ScreenUtil.verticalScale(4),
                      child: Row(
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              // dataProvider?.removeExerciseById(userData!.currentWeek, userData!.currentDay, widget.exercise.id!);
                              widget.onRemove();
                            },
                            icon: Icons.close,
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(0),
                            borderRadius: BorderRadius.circular(ScreenUtil.verticalScale(3)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil.horizontalScale(5),
                    ),
                    SizedBox(
                      height: ScreenUtil.verticalScale(4),
                      width: ScreenUtil.verticalScale(4),
                      child: Row(
                        children: [
                          SlidableAction(
                            onPressed: (context) => widget.openSwapModal,
                            icon: Icons.swap_horiz,
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(0),
                            borderRadius: BorderRadius.circular(ScreenUtil.verticalScale(3)),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(ScreenUtil.verticalScale(12)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: widget.enabled ? widget.onPress : null,
          style: ElevatedButton.styleFrom(
              disabledBackgroundColor: const Color(0xFFF3F3F3),
              backgroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(ScreenUtil.verticalScale(12)),
                ),
                side: const BorderSide(
                  color: Color(0x12000000),
                  width: 0.5,
                ),
              ),
              padding: EdgeInsets.zero),
          child: Container(
            width: media.width,
            padding: EdgeInsets.only(right: ScreenUtil.verticalScale(2)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil.verticalScale(12)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    appImage(
                      height: media.width / 4,
                      width: media.width / 4,
                      networkImageUrl: gImageUrl,
                      errorImageUrl: 'assets/img/warm-up-placeholder.png',
                      fit: BoxFit.contain,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil.verticalScale(12)),
                        bottomLeft: Radius.circular(ScreenUtil.verticalScale(12)),
                      ),
                      child: Container(
                        decoration: widget.isCompleted
                            ? BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFAADDAA).withOpacity(0.8),
                                    const Color(0xFFAADDAA).withOpacity(0.8),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(ScreenUtil.verticalScale(12)),
                                  bottomLeft: Radius.circular(ScreenUtil.verticalScale(12)),
                                ),
                              )
                            : widget.isSkipped
                                ? BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.secondColor.withOpacity(0.8),
                                        AppColors.secondColor.withOpacity(0.8),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(ScreenUtil.verticalScale(12)),
                                      bottomLeft: Radius.circular(ScreenUtil.verticalScale(12)),
                                    ),
                                  )
                                : BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(ScreenUtil.verticalScale(12)),
                                      bottomLeft: Radius.circular(ScreenUtil.verticalScale(12)),
                                    ),
                                  ),
                        child: Icon(
                          widget.isCompleted ? Icons.check : Icons.close,
                          color: widget.isCompleted || widget.isSkipped ? Colors.white : Colors.transparent,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: media.width / 2.5,
                          child: Text(
                            widget.name,
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: widget.isCircuit ? ScreenUtil.horizontalScale(3) : ScreenUtil.horizontalScale(3.8),
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil.verticalScale(1.5),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 2),
                              child: SvgPicture.asset(
                                "assets/icons/trend.svg",
                                color: Colors.grey,
                                width: 20,
                              ),
                            ),
                            Text(
                              "$totalSets sets",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: widget.isCircuit ? ScreenUtil.verticalScale(1.3) : ScreenUtil.verticalScale(1.5),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                if (widget.enabled) ...[
                  GestureDetector(
                    onTap: widget.enabled ? widget.onPress : null,
                    child: Container(
                      padding: EdgeInsets.all(ScreenUtil.verticalScale(0.5)),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: ScreenUtil.verticalScale(3),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
