import 'dart:math' as math;

import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatefulWidget {
  BarChartWidget({super.key});

  final shadowColor = const Color(0xFFCCCCCC);
  final dataList = [
    const _BarData(AppColors.primaryColor, 20, 18),
    const _BarData(AppColors.primaryColor, 5, 8),
    const _BarData(AppColors.primaryColor, 15, 15),
    const _BarData(AppColors.primaryColor, 10.5, 5),
    const _BarData(AppColors.primaryColor, 10, 2.5),
    const _BarData(AppColors.primaryColor, 5, 2),
    const _BarData(AppColors.primaryColor, 20, 2),
  ];

  @override
  State<BarChartWidget> createState() => _BarChartSample7State();
}

class _BarChartSample7State extends State<BarChartWidget> {
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
  Widget build(BuildContext context) {
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
            leftTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 36, getTitlesWidget: getTitles),
            ),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
          ),
          gridData: FlGridData(
            verticalInterval: 0.125,
            horizontalInterval: 5,
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
          barGroups: widget.dataList.asMap().entries.map((e) {
            final index = e.key;
            final data = e.value;
            return generateBarGroup(
              index,
              data.color,
              data.value,
              data.shadowValue,
            );
          }).toList(),
          maxY: 25,
          minY: 0,
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
                      )
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
  }

  Widget getTitles(double value, TitleMeta meta) {
    List<String> daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    DateTime today = DateTime.now();
    int currentDayIndex = today.weekday; // 1 for Monday, 7 for Sunday

// Adjust to 0-indexed days, where Monday is 0, Sunday is 6
    currentDayIndex = (currentDayIndex - 1); // 0 for Monday, 6 for Sunday

// Create a new list for the days starting from the next day after 'today'
    List<String> reverseDays = [];
    for (int i = 1; i <= 7; i++) {
      reverseDays.add(daysOfWeek[(currentDayIndex + i) % 7]);
    }

    var style = const TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(reverseDays[0], style: style);
        break;
      case 1:
        text = Text(reverseDays[1], style: style);
        break;
      case 2:
        text = Text(reverseDays[2], style: style);
        break;
      case 3:
        text = Text(reverseDays[3], style: style);

        break;
      case 4:
        text = Text(reverseDays[4], style: style);
        break;
      case 5:
        text = Text(reverseDays[5], style: style);
        break;
      case 6:
        text = Text(
          reverseDays[6],
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        );
        break;
      default:
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(
        // axisSide: meta.axisSide,
        space: 9,
        meta: meta,
        child: text);
  }
}

class _BarData {
  const _BarData(this.color, this.value, this.shadowValue);
  final Color color;
  final double value;
  final double shadowValue;
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
