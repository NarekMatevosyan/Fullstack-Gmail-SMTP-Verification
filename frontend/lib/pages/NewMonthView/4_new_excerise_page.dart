import 'dart:async';
import 'dart:convert';

import 'package:bbb/components/button_widget.dart';
import 'package:bbb/pages/NewMonthView/Database/month_database.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/circuit_model.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/extra_set_model.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/new_model.dart';
import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/pages/NewMonthView/Widgets/4_1_new_exercise_card.dart';
import 'package:bbb/pages/NewMonthView/Widgets/4_2_add_notes.dart';
import 'package:bbb/pages/NewMonthView/Widgets/new_equipment_section.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../middleware/notification_service.dart';
import '../../../values/clip_path.dart';

class NewExercisePage extends StatefulWidget {
  const NewExercisePage({super.key});

  @override
  State<NewExercisePage> createState() => _NewExercisePageState();
}

class _NewExercisePageState extends State<NewExercisePage> {
  MonthProvider? monthProvider;
  bool loading = false;
  bool videoNotInitialized = false;

  int exerciseIndex = 0;
  String exerciseDesc = "";
  String exerciseName = "";
  int setCount = 0;
  int isExercise = 0;

  final GlobalKey _containerKey = GlobalKey();

  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  Size? videoSize;

  @override
  void initState() {
    monthProvider = Provider.of<MonthProvider>(context, listen: false);
    fetchExercise();
    NotificationService.clearNotification();

    super.initState();
  }

  List values = [];
  Timer? _hideControlsTimer;
  void fetchExercise() async {
    if (monthProvider?.isWarmup == false) {
      setState(() {
        loading = true;
      });

      await monthProvider?.fetchCurrentExercise(
        monthProvider!.selectedExercise!.exerciseId.toString(),
      );

      isExercise = 1;
      exerciseIndex = monthProvider!.selectedExIndex;

      if (monthProvider!.exerciseDetailModel!.files!.isNotEmpty) {
        initializeVideo(monthProvider!.exerciseDetailModel!.files!.first.link!);
      } else {
        loading = false;
        videoNotInitialized = false;
      }
      exerciseDesc = monthProvider!.exerciseDetailModel!.description ?? "";
      exerciseName = monthProvider!.exerciseDetailModel!.title ?? "";
    } else {
      if (monthProvider!.warmUpModel!.files!.isNotEmpty) {
        initializeVideo(monthProvider!.warmUpModel!.files!.first.link!);
      } else {
        loading = false;
        videoNotInitialized = false;
      }
      exerciseDesc = monthProvider!.warmUpModel!.description ?? "";
      exerciseName = monthProvider!.warmUpModel!.title ?? "";
    }

    await monthProvider?.fetchExerciseHistoryLocalData();
    await monthProvider?.fetchExerciseStatusLocalData();

    String exId = monthProvider!.isPumpDay && monthProvider!.isCircuit
        ? "${monthProvider?.exerciseDetailModel!.sId.toString()}-${monthProvider?.circuitIndex}"
        : monthProvider!.exerciseDetailModel!.sId.toString();

    String dataId =
        "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}-$exId";

    fetchExtraSetLocalData(dataId);

    setState(() {});
  }

  List<ExtraSetModel> extraSetModel = [];

  fetchExtraSetLocalData(String dataId) async {
    final data = await DatabaseHelper().getDataFromTable(tableName: DatabaseHelper.extraSetHistory, where: 'dataId', id: dataId);
    if (data.isNotEmpty) {
      extraSetModel = List<ExtraSetModel>.from(json.decode(jsonEncode(data)).map((x) => ExtraSetModel.fromJson(x)));
    } else {
      extraSetModel = [];
    }
    setState(() {});
  }

  Future<void> initializeVideo(String url) async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        showControls: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
      );

      if (_chewieController != null && _chewieController!.videoPlayerController.value.isInitialized) {
        videoSize = calculateVideoSize(aspectRatio: _chewieController!.aspectRatio!, context: context);
        setState(() {});
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        videoNotInitialized = true;
        loading = false;
      });
      debugPrint("VIDEO NOT INITIALIZED: $e");
    }
  }

  bool showControls = true;
  bool isFullscreen = false;

  void hideControls() {
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        showControls = false;
      });
    });
  }

  void showControlsOnTap() {
    setState(() {
      showControls = !showControls;
    });
    _hideControlsTimer?.cancel();
  }

  void toggleFullscreen() {
    setState(() {
      isFullscreen = !isFullscreen;
    });
    if (isFullscreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }
  }

  Size calculateVideoSize({
    required BuildContext context,
    required double aspectRatio,
  }) {
    final screenSize = MediaQuery.of(context).size;

    double maxWidth = screenSize.width;
    double maxHeight = screenSize.height;

    double calculatedHeight = maxWidth / aspectRatio;

    if (calculatedHeight > maxHeight) {
      calculatedHeight = maxHeight;
      maxWidth = maxHeight * aspectRatio;
    }

    return Size(maxWidth, calculatedHeight);
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    ScreenUtil.init(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            )
          : SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.loose,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showControlsOnTap();
                            },
                            child: Stack(
                              children: [
                                Container(
                                  color: Colors.black,
                                  child: Column(
                                    children: [
                                      (isExercise == 1
                                              ? monthProvider!.exerciseDetailModel!.files!.isNotEmpty &&
                                                  !videoNotInitialized &&
                                                  videoSize != null
                                              : monthProvider!.warmUpModel!.files!.isNotEmpty && !videoNotInitialized && videoSize != null)
                                          ? SizedBox(
                                              height: videoSize!.height,
                                              width: videoSize!.width,
                                              child: Chewie(
                                                controller: _chewieController!,
                                              ),
                                            )
                                          : Container(
                                              height: media.height * 0.4,
                                              color: Colors.black12,
                                              child: const Center(
                                                  child: Text(
                                                'No Video Available',
                                                style: TextStyle(color: Colors.white),
                                              )),
                                            ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // height: media.height / 1.1,
                                  width: media.width,
                                  decoration: const BoxDecoration(),
                                  child: SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Row(
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
                                                onPressed: () => Navigator.pop(context),
                                                iconSize: ScreenUtil.verticalScale(4),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      videoSize != null
                          ? Positioned(
                              bottom: videoSize!.height / 2,
                              left: 10,
                              right: 10,
                              child: Visibility(
                                visible: showControls,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    // Skip backward button
                                    IconButton(
                                      iconSize: 40,
                                      icon: const Icon(
                                        Icons.replay_10,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        _videoPlayerController.seekTo(
                                          _videoPlayerController.value.position - const Duration(seconds: 10),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      iconSize: 60,
                                      icon: Icon(
                                        _videoPlayerController.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (_videoPlayerController.value.isPlaying) {
                                            _videoPlayerController.pause();
                                          } else {
                                            _videoPlayerController.play();
                                            hideControls();
                                          }
                                        });
                                      },
                                    ),

                                    IconButton(
                                      iconSize: 40,
                                      icon: const Icon(
                                        Icons.forward_10,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        _videoPlayerController.seekTo(
                                          _videoPlayerController.value.position + const Duration(seconds: 10),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
                      videoSize != null
                          ? Positioned(
                              bottom: media.height * 0.09,
                              left: 10,
                              right: 10,
                              child: !videoNotInitialized && _chewieController!.videoPlayerController.value.isInitialized == true
                                  ? Container(
                                      margin: EdgeInsets.only(bottom: media.height * 0.06, left: 20, right: 20),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: VideoProgressIndicator(
                                              _videoPlayerController,
                                              allowScrubbing: true,
                                              colors: const VideoProgressColors(
                                                playedColor: AppColors.primaryColor,
                                                bufferedColor: Colors.white,
                                                backgroundColor: Colors.black26,
                                              ),
                                            ),
                                          )
                                        ],
                                      ))
                                  : const SizedBox(),
                            )
                          : const SizedBox(),
                      Positioned(
                        bottom: media.height * 0.12,
                        right: 0,
                        child: SizedBox(
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
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          key: _containerKey,
                          height: media.height * 0.12,
                          width: media.width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(70),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.bottomCenter,
                                decoration:
                                    const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(50))),
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: media.height * 0.018,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 8, right: 10),
                                            child: Text(
                                              exerciseName,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                height: 1.3,
                                                color: AppColors.primaryColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  "/exerciseHistory",
                                                  arguments: {
                                                    'exerciseName': exerciseName,
                                                    'exerciseIndex': exerciseIndex,
                                                  },
                                                );
                                              },
                                              child: const Icon(
                                                Icons.insert_chart_outlined_sharp,
                                                color: AppColors.primaryColor,
                                                size: 30,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  backgroundColor: Colors.white,
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (BuildContext context) {
                                                    return const AddNoteBottomSheet();
                                                  },
                                                );
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                color: AppColors.primaryColor,
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    // padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),

                        ///Guideline Section
                        guideLineText(),
                        const SizedBox(height: 15),

                        if (isExercise == 1)
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  exerciseDesc,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ListView.builder(
                                itemCount: monthProvider?.selectedExercise!.extra!.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final extraItem = monthProvider?.selectedExercise!.extra![index];

                                  setCount = int.parse(extraItem!.sets.toString()) + (extraItem.type == 3 ? (extraSetModel.length) : 0);

                                  return ListView.builder(
                                    itemCount: setCount,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, countIndex) {
                                      String ctId =
                                          "${monthProvider?.splitType}-${monthProvider?.selectedExercise?.id}-${monthProvider?.exerciseDetailModel?.sId}-$index-$countIndex-${monthProvider?.circuitIndex}";

                                      bool isCompleted() {
                                        final val = monthProvider!.historyDataModel.where((element) => element.dataId == ctId);
                                        bool val1 = false;
                                        if (val.isNotEmpty) {
                                          val1 = val.first.status == Status.completed;
                                        }
                                        return val1;
                                      }

                                      bool isTimerRunning = monthProvider!.timerAddress ==
                                          "$index-$countIndex-$exerciseIndex-${monthProvider?.overviewCurrentWeek}-${monthProvider?.overviewCurrentDay}";

                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 20),
                                        child: NewExerciseCard(
                                          makeRefresh: () {
                                            setState(() {});
                                          },
                                          isCompleted: isCompleted(),
                                          extraDataModel: extraItem,
                                          color: extraItem.type == 3
                                              ? const Color.fromARGB(255, 248, 248, 248)
                                              : extraItem.type == 2
                                                  ? AppColors.backOffSetColor
                                                  : AppColors.warmupColor,
                                          isTimerRunning: isTimerRunning,
                                          exerciseName: exerciseName,
                                          title: extraItem.type == 1
                                              ? "Warmup Set"
                                              : extraItem.type == 2
                                                  ? "Back-Off Set"
                                                  : "Normal Set",
                                          isOpened: isTimerRunning
                                              ? true
                                              : index == 0 && countIndex == 0
                                                  ? true
                                                  : false,
                                          index: index,
                                          subIndex: countIndex,
                                          exercise: exerciseIndex,
                                          set: int.parse(extraItem.sets.toString()),
                                          weight: int.parse(extraItem.weight.toString()),
                                          reps: int.parse(extraItem.reps.toString()),
                                          repsInReverse: 100,
                                          load: int.parse(extraItem.load == null ? "0" : extraItem.load.toString()),
                                          type: int.parse(extraItem.type.toString()),
                                          restDuration: int.parse(extraItem.rest.toString()),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 40),
                                child: ButtonWidget(
                                  onPress: () {
                                    final data = monthProvider?.selectedExercise!.extra!.where((element) => element.type == 3);
                                    if (data!.isNotEmpty) {
                                      _addExtraSet(data.first);
                                    }
                                    setState(() {});
                                  },
                                  isLoading: false,
                                  color: Colors.grey,
                                  textColor: Colors.white,
                                  text: "Add Set",
                                ),
                              ),
                              Container(
                                height: 0.5,
                                margin: const EdgeInsets.symmetric(horizontal: 40),
                                width: media.width,
                                color: Colors.black12,
                              ),
                              const SizedBox(height: 30),
                              Consumer<MonthProvider>(
                                builder: (context, monthProvider, child) {
                                  return monthProvider.exerciseHistoryDetails?.status == Status.skipped
                                      ? const SizedBox()
                                      : Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: ButtonWidget(
                                            text: monthProvider.isPumpDay && monthProvider.isCircuit ? "Finish" : "Finish & Next",
                                            textColor: Colors.white,
                                            onPress: () async {
                                              int count = 0;
                                              await _saveExerciseData(
                                                status: Status.completed,
                                                id: monthProvider.isPumpDay && monthProvider.isCircuit
                                                    ? "${monthProvider.exerciseDetailModel!.sId.toString()}-${monthProvider.circuitIndex}"
                                                    : monthProvider.exerciseDetailModel!.sId.toString(),
                                                type: monthProvider.isCircuit ? "Circuit - ${monthProvider.circuitIndex}" : "Exercise",
                                              );

                                              if (monthProvider.isPumpDay && monthProvider.isCircuit) {
                                                Navigator.pop(context);
                                              } else {
                                                for (var element in monthProvider.exerciseHistoryModel) {
                                                  if (element.status.toString() == Status.completed) {
                                                    count++;
                                                  }
                                                }

                                                if (monthProvider.dayDataModel?.exercises?.length != count &&
                                                    monthProvider.dayDataModel?.exercises?.length != monthProvider.selectedExIndex + 1) {
                                                  Navigator.pop(context);

                                                  await Future.delayed(const Duration(milliseconds: 100));

                                                  int skipIndex = monthProvider.selectedExIndex + 1;
                                                  for (int i = skipIndex; i < monthProvider.dayDataModel!.exercises!.length; i++) {
                                                    var elementI = monthProvider.dayDataModel!.exercises![i];
                                                    String dataId =
                                                        "${monthProvider.splitType}-${monthProvider.monthDataModel?.id}-${monthProvider.weekDataModel?.id}-${monthProvider.weekDataModel?.idList![monthProvider.overviewCurrentDay - 1]}-${elementI.exerciseId}";
                                                    bool val = monthProvider.exerciseHistoryModel
                                                        .any((element) => element.dataId == dataId && element.status == Status.completed);
                                                    if (val == false) {
                                                      monthProvider.setSelectedExercise(elementI, i);
                                                      monthProvider.updateWarmUp(false);
                                                      await Navigator.pushNamed(context, '/exercise');
                                                      break;
                                                    }
                                                  }
                                                } else {
                                                  Navigator.pop(context);
                                                }
                                              }
                                            },
                                            color: AppColors.primaryColor,
                                            isLoading: false,
                                          ),
                                        );
                                },
                              ),
                              const SizedBox(height: 10),
                              Consumer<MonthProvider>(builder: (context, monthProvider, child) {
                                return ButtonWidget(
                                  text: monthProvider.exerciseHistoryDetails?.status == Status.skipped ? "Unskip?" : "Skip the exercise",
                                  textColor: const Color(0xFFFFFFFF),
                                  color: AppColors.skipDayColor,
                                  onPress: () async {
                                    await _saveExerciseData(
                                      status: monthProvider.exerciseHistoryDetails?.status == Status.skipped ? "" : "Skipped",
                                      id: monthProvider.isPumpDay && monthProvider.isCircuit
                                          ? "${monthProvider.exerciseDetailModel!.sId.toString()}-${monthProvider.circuitIndex}"
                                          : monthProvider.exerciseDetailModel!.sId.toString(),
                                      type: monthProvider.isPumpDay && monthProvider.isCircuit
                                          ? "Circuit - ${monthProvider.circuitIndex}"
                                          : "Exercise",
                                    );
                                    if (monthProvider.exerciseHistoryDetails?.status != Status.skipped) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  isLoading: false,
                                );
                              }),
                              const NewEquipmentSection(),
                            ],
                          )
                        else
                          const SizedBox(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
      bottomNavigationBar: isExercise == 1
          ? const SizedBox(height: 0, width: 0)
          : loading
              ? const SizedBox(
                  height: 0,
                  width: 0,
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 35),
                  child: ButtonWidget(
                    text: "Mark Complete",
                    textColor: Colors.white,
                    onPress: () async {
                      await _saveExerciseData(
                        status: Status.completed,
                        id: monthProvider!.warmUpModel!.id.toString(),
                        type: "Warmup",
                      );

                      Navigator.pop(context);
                    },
                    color: AppColors.primaryColor,
                    isLoading: false,
                  ),
                ),
    );
  }

  Row guideLineText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Align(
          alignment: Alignment.topLeft,
          child: isExercise == 1
              ? Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(254, 233, 232, 1.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Text(
                    (monthProvider!.selectedExercise!.guide == "" || monthProvider!.selectedExercise!.guide == null
                        ? "Exercise GuideLines will be displayed here."
                        : monthProvider!.selectedExercise!.guide.toString()),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                )
              : Text(
                  (monthProvider!.warmUpModel!.description == ""
                      ? "Warm-Up GuideLines will be displayed here."
                      : monthProvider!.warmUpModel!.description.toString()),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
        )),
      ],
    );
  }

  double calculateHeight(double width, double aspectRatio) {
    return width / aspectRatio;
  }

  Future<void> _addExtraSet(ExtraDataModel extra) async {
    String exId = monthProvider!.isPumpDay && monthProvider!.isCircuit
        ? "${monthProvider?.exerciseDetailModel!.sId.toString()}-${monthProvider?.circuitIndex}"
        : monthProvider!.exerciseDetailModel!.sId.toString();

    String dataId =
        "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}-$exId";

    final data = {
      "sets": 1,
      "reps": extra.reps,
      "weight": extra.weight,
      "rest": extra.reps,
      "load": extra.load,
      "type": extra.type,
      "extraId": "",
      "date": "${DateTime.now().toUtc()}",
      "dataId": dataId,
    };
    await DatabaseHelper().insertData(data: data, tableName: DatabaseHelper.extraSetHistory);

    await fetchExtraSetLocalData(dataId);
  }

  Future<void> _saveExerciseData({required String status, required String id, required String type}) async {
    await monthProvider?.fetchExerciseHistoryLocalData();
    await monthProvider?.fetchCircuitModelLocalData();

    if (monthProvider!.isPumpDay && monthProvider!.isCircuit) {
      String exId = monthProvider?.pumpDayModel!.circuits?[monthProvider!.circuitsIndex].id ?? "";

      String dataId1 =
          "${monthProvider?.splitType}-${monthProvider?.monthDataModel?.id}-${monthProvider?.weekDataModel?.id}-${monthProvider?.weekDataModel?.idList![monthProvider!.overviewCurrentDay - 1]}-$exId";

      final data2 = {
        "dataId": dataId1,
        "lastExerciseCount": 1,
        "lastRound": monthProvider?.pumpDayModel!.circuits?[monthProvider!.circuitsIndex].circuitExercises?.length == 1 ? 2 : 1,
        "exerciseCountList": monthProvider?.pumpDayModel!.circuits?[monthProvider!.circuitsIndex].circuitExercises?.length == 1
            ? ""
            : monthProvider!.exerciseDetailModel!.sId.toString(),
      };

      if (monthProvider!.circuitModel.isNotEmpty) {
        CircuitModel? matchingElement = monthProvider?.circuitModel.firstWhere(
          (element) => element.dataId == dataId1,
          orElse: () => CircuitModel(),
        );

        if (matchingElement?.id != null) {
          if (!matchingElement!.exerciseCountList!.contains(monthProvider!.exerciseDetailModel!.sId.toString())) {
            final data3;

            if (monthProvider?.pumpDayModel!.circuits?[monthProvider!.circuitsIndex].circuitExercises?.length == 1) {
              data3 = {
                "lastExerciseCount": 1,
                "lastRound": (matchingElement.lastRound! + 1),
                "exerciseCountList": "",
              };
            } else if (monthProvider?.pumpDayModel!.circuits?[monthProvider!.circuitsIndex].circuitExercises?.length ==
                (matchingElement.lastExerciseCount! + 1)) {
              data3 = {
                "dataId": dataId1,
                "lastExerciseCount": 0,
                "lastRound": (matchingElement.lastRound! + 1),
                "exerciseCountList": "",
              };
            } else {
              data3 = {
                "dataId": dataId1,
                "lastExerciseCount":
                    matchingElement.exerciseCountList.toString().replaceAll("-", "").isEmpty ? 1 : (matchingElement.lastExerciseCount! + 1),
                "lastRound": matchingElement.lastRound,
                "exerciseCountList": "${matchingElement.exerciseCountList}-${monthProvider!.exerciseDetailModel!.sId.toString()}",
              };
            }

            await DatabaseHelper().updateData(data: data3, tableName: DatabaseHelper.circuitManager, id: dataId1);
          }
        } else {
          await DatabaseHelper().insertData(data: data2, tableName: DatabaseHelper.circuitManager);
        }
      } else {
        await DatabaseHelper().insertData(data: data2, tableName: DatabaseHelper.circuitManager);
      }
    }

    double totalWeight = 0;

    if (status == Status.completed) {
      totalWeight = 0;
      monthProvider?.historyDataModel.forEach(
        (element) {
          final weight = double.parse(element.weight.toString());
          final reps = double.parse(element.reps.toString());
          final effort = double.parse(element.effort.toString().replaceAll("+", ""));
          final cal = weight * (reps + effort);
          totalWeight += cal;
        },
      );
    }

    await monthProvider?.fetchCircuitModelLocalData();

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
      "type": type,
      "totalWeight": totalWeight.toString(),
    };

    final data1 = {
      "status": status,
      "type": type,
      "totalWeight": totalWeight.toString(),
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
    await monthProvider?.fetchExerciseStatusLocalData();
    monthProvider?.fetchExerciseSingleExerciseLocalData(dataId);

    await monthProvider?.updateDayData();
    monthProvider?.getLiftedWeightGraphData();
  }
}
