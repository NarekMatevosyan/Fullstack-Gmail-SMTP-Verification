import 'package:bbb/pages/NewMonthView/3_new_today_page.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/circuit_model.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/new_model.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/pump_day_model.dart';
import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:provider/provider.dart';

class NewCircuitsView extends StatefulWidget {
  final List<PumpCircuit> circuit;

  const NewCircuitsView({super.key, required this.circuit});

  @override
  State<NewCircuitsView> createState() => _NewCircuitsViewState();
}

class _NewCircuitsViewState extends State<NewCircuitsView> {
  MonthProvider? monthProvider;
  @override
  void initState() {
    monthProvider = Provider.of<MonthProvider>(context, listen: false);
    initData();
    super.initState();
  }

  initData() async {
    await monthProvider?.fetchCircuitModelLocalData();
  }

  int completedRound = 0;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Consumer<MonthProvider>(builder: (context, monthProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///CircuitsBuilder
          ListView.builder(
            itemCount: widget.circuit.length,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, circuitsIndex) {
              String exId = monthProvider.pumpDayModel?.circuits?[circuitsIndex].id ?? "";

              String dataId1 =
                  "${monthProvider.splitType}-${monthProvider.monthDataModel?.id}-${monthProvider.weekDataModel?.id}-${monthProvider.weekDataModel?.idList![monthProvider.overviewCurrentDay - 1]}-$exId";

              int? indexW = monthProvider.circuitModel.indexWhere((element) => element.dataId == dataId1);
              CircuitModel? data = CircuitModel();
              if (indexW != -1) {
                data = monthProvider.circuitModel[indexW];
              }

              String dayDtaId =
                  "${monthProvider.splitType}-${monthProvider.monthDataModel?.id}-${monthProvider.weekDataModel?.id}-${monthProvider.weekDataModel?.idList![monthProvider.overviewCurrentDay - 1]}";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: ScreenUtil.verticalScale(3)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Circuits ${circuitsIndex + 1} : ${widget.circuit[circuitsIndex].round} Rounds",
                          style: TextStyle(
                            fontSize: ScreenUtil.horizontalScale(3),
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),

                        ///round indicator
                        Row(
                          children: List.generate(
                            widget.circuit[circuitsIndex].round!,
                            (index) {
                              return Container(
                                height: ScreenUtil.verticalScale(4),
                                width: ScreenUtil.verticalScale(4),
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: monthProvider.dayHistoryModel.any((element) =>
                                          element.dataId == dayDtaId && element.status == Status.completed ||
                                          element.status == Status.skipped)
                                      ? AppColors.primaryColor
                                      : data == null
                                          ? Colors.transparent
                                          : ((data.lastRound ?? 1) - 1) > index
                                              ? AppColors.primaryColor
                                              : Colors.transparent,
                                  border: Border.all(
                                      color: monthProvider.dayHistoryModel.any((element) =>
                                              element.dataId == dayDtaId && element.status == Status.completed ||
                                              element.status == Status.skipped)
                                          ? AppColors.primaryColor
                                          : data == null
                                              ? AppColors.primaryColor
                                              : ((data.lastRound ?? 1) - 1) > index
                                                  ? Colors.transparent
                                                  : AppColors.primaryColor),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: data == null
                                      ? Text(
                                          "${index + 1}",
                                          style: TextStyle(
                                            fontSize: ScreenUtil.horizontalScale(3),
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryColor,
                                          ),
                                        )
                                      : (((data.lastRound ?? 1) - 1) > index) ||
                                              monthProvider.dayHistoryModel.any((element) =>
                                                  element.dataId == dayDtaId && element.status == Status.completed ||
                                                  element.status == Status.skipped)
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: ScreenUtil.verticalScale(2.5),
                                            )
                                          : Text(
                                              "${index + 1}",
                                              style: TextStyle(
                                                fontSize: ScreenUtil.horizontalScale(3),
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: media.height * 0.14,
                    decoration: const BoxDecoration(
                      border: DashedBorder(
                        spaceLength: 5,
                        strokeCap: StrokeCap.round,
                        dashLength: 1,
                        top: BorderSide(color: AppColors.primaryColor, width: 1),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: DashedBorder(
                        spaceLength: 5,
                        strokeCap: StrokeCap.round,
                        dashLength: 1.5,
                        left: BorderSide(color: AppColors.primaryColor, width: 1),
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpandablePageView(
                          onPageChanged: (value) {
                            widget.circuit[circuitsIndex].selectedDot = value;
                            setState(() {});
                          },

                          ///round builder
                          children: List.generate(
                            widget.circuit[circuitsIndex].round!,
                            (roundIndex) {
                              return Container(
                                margin: EdgeInsets.only(right: ScreenUtil.verticalScale(3)),

                                ///exercisesBuilder
                                child: ListView.builder(
                                  itemCount: widget.circuit[circuitsIndex].circuitExercises!.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemBuilder: (context, exerciseIndex) {
                                    ///
                                    /// CIRCUIT ===>>> ROUND ===>> EXERCISE

                                    ExerciseDataModel exercise = widget.circuit[circuitsIndex].circuitExercises![exerciseIndex];

                                    String tempIndex = "$circuitsIndex:$roundIndex";

                                    String dataId =
                                        "${monthProvider.splitType}-${monthProvider.monthDataModel?.id}-${monthProvider.weekDataModel?.id}-${monthProvider.weekDataModel?.idList![monthProvider.overviewCurrentDay - 1]}-${exercise.exerciseId}-$tempIndex";

                                    bool isExist = (!monthProvider.exerciseHistoryModel.any((item) => item.dataId != dataId)) &&
                                        monthProvider.isPastWeek;

                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          top: media.height * 0.032,
                                          bottom: exerciseIndex == (widget.circuit[circuitsIndex].circuitExercises!.length - 1)
                                              ? media.height * 0.032
                                              : 0),
                                      child: Builder(builder: (context) {
                                        String exId = monthProvider.pumpDayModel?.circuits?[circuitsIndex].id ?? "";

                                        String dataId1 =
                                            "${monthProvider.splitType}-${monthProvider.monthDataModel?.id}-${monthProvider.weekDataModel?.id}-${monthProvider.weekDataModel?.idList![monthProvider.overviewCurrentDay - 1]}-$exId";

                                        int indexW = monthProvider.circuitModel.indexWhere((element) => element.dataId == dataId1);

                                        CircuitModel? data = CircuitModel();
                                        if (indexW != -1) {
                                          data = monthProvider.circuitModel[indexW];
                                        }

                                        return WorkoutCard(
                                          roundIndex: roundIndex,
                                          isCircuit: true,
                                          isCompleted: monthProvider.exerciseHistoryModel
                                              .any((element) => element.dataId == dataId && element.status == Status.completed),
                                          isSkipped: monthProvider.exerciseHistoryModel
                                                  .any((element) => element.dataId == dataId && element.status == Status.skipped) ||
                                              isExist,
                                          exerciseIndex: exerciseIndex,
                                          onPress: indexW == -1
                                              ? roundIndex == 0
                                                  ? () {
                                                      monthProvider.updateIsCircuit(true);
                                                      monthProvider.updateCircuit("$circuitsIndex:$roundIndex", circuitsIndex);
                                                      String dataId =
                                                          "${monthProvider.splitType}-${monthProvider.monthDataModel?.id}-${monthProvider.weekDataModel?.id}-${monthProvider.weekDataModel?.idList![monthProvider.overviewCurrentDay - 1]}-${widget.circuit[circuitsIndex].circuitExercises![exerciseIndex].exerciseId}-${monthProvider.circuitIndex}";
                                                      monthProvider.setSelectedExercise(
                                                          widget.circuit[circuitsIndex].circuitExercises![exerciseIndex], exerciseIndex);
                                                      monthProvider.updateWarmUp(false);
                                                      Navigator.pushNamed(context, '/exercise');

                                                      monthProvider.fetchExerciseSingleExerciseLocalData(dataId);
                                                    }
                                                  : null
                                              : ((data.lastRound ?? 1) - 1) >= widget.circuit[circuitsIndex].selectedDot!
                                                  ? () {
                                                      monthProvider.updateIsCircuit(true);
                                                      monthProvider.updateCircuit("$circuitsIndex:$roundIndex", circuitsIndex);
                                                      String dataId =
                                                          "${monthProvider.splitType}-${monthProvider.monthDataModel?.id}-${monthProvider.weekDataModel?.id}-${monthProvider.weekDataModel?.idList![monthProvider.overviewCurrentDay - 1]}-${widget.circuit[circuitsIndex].circuitExercises![exerciseIndex].exerciseId}-${monthProvider.circuitIndex}";
                                                      monthProvider.setSelectedExercise(
                                                          widget.circuit[circuitsIndex].circuitExercises![exerciseIndex], exerciseIndex);
                                                      monthProvider.updateWarmUp(false);
                                                      Navigator.pushNamed(context, '/exercise');

                                                      monthProvider.fetchExerciseSingleExerciseLocalData(dataId);
                                                    }
                                                  : null,
                                          openSwapModal: () {},
                                          exercise: widget.circuit[circuitsIndex].circuitExercises![exerciseIndex],
                                          exerciseData: exercise.exerciseId ?? "",
                                          name: exercise.name ?? "Exercise ${exerciseIndex + 1}",
                                          onRemove: () {},
                                          enabled: true,
                                        );
                                      }),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: -5,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: media.height * 0.14,
                                decoration: const BoxDecoration(
                                  border: DashedBorder(
                                    spaceLength: 5,
                                    strokeCap: StrokeCap.round,
                                    dashLength: 1,
                                    top: BorderSide(color: AppColors.primaryColor, width: 1),
                                  ),
                                ),
                              ),
                              Row(
                                children: List.generate(
                                  widget.circuit[circuitsIndex].round!,
                                  (index) => Container(
                                    height: 10,
                                    width: 10,
                                    margin: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      color:
                                          widget.circuit[circuitsIndex].selectedDot != index ? Colors.transparent : AppColors.primaryColor,
                                      border: Border.all(
                                          color: widget.circuit[circuitsIndex].selectedDot == index
                                              ? Colors.transparent
                                              : AppColors.primaryColor),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: media.height * 0.14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: media.height * 0.05,
                  ),
                ],
              );
            },
          )
        ],
      );
    });
  }
}

class ExpandablePageView extends StatefulWidget {
  final List<Widget> children;
  final Function(int value) onPageChanged;

  const ExpandablePageView({
    super.key,
    required this.children,
    required this.onPageChanged,
  });

  @override
  State<ExpandablePageView> createState() => _ExpandablePageViewState();
}

class _ExpandablePageViewState extends State<ExpandablePageView> with TickerProviderStateMixin {
  late PageController _pageController;
  late List<double> _heights;
  int _currentPage = 0;

  double get _currentHeight => _heights[_currentPage];

  @override
  void initState() {
    _heights = widget.children.map((e) => 0.0).toList();
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        final newPage = _pageController.page?.round() ?? 0;
        if (_currentPage != newPage) {
          setState(() => _currentPage = newPage);
          widget.onPageChanged(_currentPage);
        }
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: Curves.easeInOutCubic,
      duration: const Duration(milliseconds: 100),
      tween: Tween<double>(begin: _heights[0], end: _currentHeight),
      builder: (context, value, child) => SizedBox(height: value, child: child),
      child: PageView(
        controller: _pageController,
        pageSnapping: true,
        children: _sizeReportingChildren
            .asMap() //
            .map((index, child) => MapEntry(index, child))
            .values
            .toList(),
      ),
    );
  }

  List<Widget> get _sizeReportingChildren => widget.children
      .asMap() //
      .map(
        (index, child) => MapEntry(
          index,
          OverflowBox(
            //needed, so that parent won't impose its constraints on the children, thus skewing the measurement results.
            minHeight: 0,
            maxHeight: double.infinity,
            alignment: Alignment.topCenter,
            child: SizeReportingWidget(
              onSizeChange: (size) => setState(() => _heights[index] = size.height),
              child: Align(child: child),
            ),
          ),
        ),
      )
      .values
      .toList();
}

class SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const SizeReportingWidget({
    super.key,
    required this.child,
    required this.onSizeChange,
  });

  @override
  State<SizeReportingWidget> createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return widget.child;
  }

  void _notifySize() {
    if (!mounted) {
      return;
    }
    final size = context.size;
    if (_oldSize != size && size != null) {
      _oldSize = size;
      widget.onSizeChange(size);
    }
  }
}
