import 'dart:math' as math;

import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportExerciseCompletedGraph extends StatefulWidget {
  const ReportExerciseCompletedGraph({super.key});
  @override
  State<ReportExerciseCompletedGraph> createState() => _ReportExerciseCompletedGraphState();
}

class _ReportExerciseCompletedGraphState extends State<ReportExerciseCompletedGraph> {
  BarChartGroupData generateBarGroup(
    int x,
    Color color,
    double value,
    double shadowValue,
  ) {
    ScreenUtil.init(context);
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: ScreenUtil.horizontalScale(5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ScreenUtil.horizontalScale(3)),
            topRight: Radius.circular(ScreenUtil.horizontalScale(3)),
          ),
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  int touchedGroupIndex = -1;
  @override
  void initState() {
    MonthProvider monthProvider = Provider.of<MonthProvider>(context, listen: false);
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => monthProvider.changeWeekExerciseCompleted("Week ${monthProvider.currentWeek}"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MonthProvider>(
      builder: (context, monthProvider, child) {
        return AspectRatio(
          aspectRatio: 1.4,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              borderData: FlBorderData(
                show: true,
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Colors.black.withOpacity(0.1),
                  ),
                  vertical: BorderSide(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: monthProvider.reportMaximumValueOfTotalEx > 32 ? monthProvider.reportMaximumValueOfTotalEx / 10 : 2,
                    reservedSize: 30, // Space for titles
                    getTitlesWidget: getLeftTitles, // Use this method to generate Y-axis titles
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (value, meta) => getTitles(value, meta, monthProvider), // This method generates titles for the X-axis
                  ),
                ),
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
              ),
              gridData: FlGridData(
                verticalInterval: 0.125,
                horizontalInterval: monthProvider.reportMaximumValueOfTotalEx > 32 ? monthProvider.reportMaximumValueOfTotalEx / 10 : 2,
                show: true,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.black.withOpacity(0.1),
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.black.withOpacity(0.1),
                  strokeWidth: 1,
                ),
              ),
              barGroups: monthProvider.reportExerciseCompletedGraphHistory.asMap().entries.map((e) {
                final index = e.key;
                final data = e.value['totalCompletedExercise'];
                return generateBarGroup(
                  index,
                  AppColors.primaryColor,
                  data.value,
                  data.shadowValue,
                );
              }).toList(),

              maxY: monthProvider.reportMaximumValueOfTotalEx > 16 ? monthProvider.reportMaximumValueOfTotalEx : 16,
              minY: 0, // Set min Y value
              barTouchData: BarTouchData(
                enabled: true,
                handleBuiltInTouches: false,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => Colors.transparent,
                  tooltipMargin: 0,
                  getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                  ) {
                    return BarTooltipItem(
                      rod.toY.toString(),
                      TextStyle(
                        fontWeight: FontWeight.bold,
                        color: rod.color,
                        fontSize: 18,
                        shadows: const [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                touchCallback: (event, response) {
                  if (event.isInterestedForInteractions && response != null && response.spot != null) {
                    setState(() {
                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                    });
                  } else {
                    setState(() {
                      touchedGroupIndex = -1;
                    });
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getTitles(double value, TitleMeta meta, MonthProvider monthProvider) {
    List titles = monthProvider.reportExerciseCompletedGraphHistory.asMap().entries.map((e) {
      return e.value['day'];
    }).toList();

    final isd = int.parse(monthProvider.reportExerciseCompletedWeek.toString().replaceAll("Week ", ""));
    DateTime today = DateTime.now();
    String todayDayName = DateFormat('EEE').format(today);
    int index = -1;
    if (isd == monthProvider.currentWeek) {
      index = titles.indexWhere((element) => element == todayDayName);
    }

    var todayStyle = const TextStyle(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    var style = const TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(titles[0], style: index == 0 ? todayStyle : style);
        break;
      case 1:
        text = Text(titles[1], style: index == 1 ? todayStyle : style);
        break;
      case 2:
        text = Text(titles[2], style: index == 2 ? todayStyle : style);
        break;
      case 3:
        text = Text(titles[3], style: index == 3 ? todayStyle : style);
        break;
      case 4:
        text = Text(titles[4], style: index == 4 ? todayStyle : style);
        break;
      case 5:
        text = Text(titles[5], style: index == 5 ? todayStyle : style);
        break;
      case 6:
        text = Text(titles[6], style: index == 6 ? todayStyle : style);
        break;
      default:
        text = Text('', style: index == 0 ? todayStyle : style);
        break;
    }
    return SideTitleWidget(
      // axisSide: meta.axisSide,
      meta: meta,
      space: 9,
      child: text,
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );
    return Text(value.toString().split(".").first, style: style);
  }
}

class _IconWidget extends ImplicitlyAnimatedWidget {
  const _IconWidget({
    required this.color,
    required this.isSelected,
  }) : super(duration: const Duration(milliseconds: 300));
  final Color color;
  final bool isSelected;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() => _IconWidgetState();
}

class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
  Tween<double>? _rotationTween;

  @override
  Widget build(BuildContext context) {
    final rotation = math.pi * 4 * _rotationTween!.evaluate(animation);
    final scale = 1 + _rotationTween!.evaluate(animation) * 0.5;
    return Transform(
      transform: Matrix4.rotationZ(rotation).scaled(scale, scale),
      origin: const Offset(14, 14),
      child: Icon(
        widget.isSelected ? Icons.face_retouching_natural : Icons.face,
        color: widget.color,
        size: 28,
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rotationTween = visitor(
      _rotationTween,
      widget.isSelected ? 1.0 : 0.0,
      (dynamic value) => Tween<double>(
        begin: value as double,
        end: widget.isSelected ? 1.0 : 0.0,
      ),
    ) as Tween<double>?;
  }
}
