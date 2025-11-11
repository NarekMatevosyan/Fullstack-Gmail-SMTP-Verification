import 'package:bbb/values/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivityLineChart extends StatefulWidget {
  const ActivityLineChart({super.key});

  @override
  State<ActivityLineChart> createState() => _ActivityLineChartState();
}

class _ActivityLineChartState extends State<ActivityLineChart> {
  List<int> showingTooltipOnSpots = [4];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return SizedBox(
        height: media.width * 0.41,
        width: double.maxFinite,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              enabled: true,
              handleBuiltInTouches: false,
              touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                if (response == null || response.lineBarSpots == null) {
                  return;
                }
                if (event is FlTapUpEvent) {
                  final spotIndex = response.lineBarSpots!.first.spotIndex;
                  showingTooltipOnSpots.clear();
                  setState(() {
                    showingTooltipOnSpots.add(spotIndex);
                  });
                }
              },
              mouseCursorResolver: (FlTouchEvent event, LineTouchResponse? response) {
                if (response == null || response.lineBarSpots == null) {
                  return SystemMouseCursors.basic;
                }
                return SystemMouseCursors.click;
              },
              getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                return spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    const FlLine(
                      color: Colors.transparent,
                    ),
                    FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 3,
                        color: Colors.white,
                        strokeWidth: 1,
                        strokeColor: AppColors.primaryColor,
                      ),
                    ),
                  );
                }).toList();
              },
              touchTooltipData: LineTouchTooltipData(
                tooltipRoundedRadius: 5,
                getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                  return lineBarsSpot.map((lineBarSpot) {
                    return LineTooltipItem(
                      "${lineBarSpot.y.toInt()} hours",
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: lineBarsData1,
            minY: -0.01,
            maxY: 8,
            maxX: 7,
            titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: bottomTitles,
                ),
                leftTitles: const AxisTitles()),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: true,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.15),
                  strokeWidth: 2,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.15),
                  strokeWidth: 2,
                );
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.grey.withOpacity(0.15),
              ),
            ),
          ),
        ));
  }

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        gradient: const LinearGradient(colors: [
          Color(0xFFD40F54),
          Color(0xFFD40F54),
        ]),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          checkToShowDot: (spot, barData) => spot.x == barData.spots[barData.spots.length - 3].x,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: 6,
            color: Colors.white,
            strokeWidth: 6,
            strokeColor: const Color(0xFFD40F54).withOpacity(0.6),
          ),
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(colors: [
            const Color(0xFFD40F54).withOpacity(0.05),
            Colors.white.withOpacity(0.4),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          spotsLine: BarAreaSpotsLine(
            show: true,
            checkToShowSpotLine: (spot) => spot.x > 4 && spot.x <= 5,
            flLineStyle: FlLine(
              color: const Color(0xFFD40F54),
              strokeWidth: 24,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD40F54).withOpacity(1),
                  Colors.white.withOpacity(0.5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        spots: const [
          FlSpot(1, 3),
          FlSpot(2, 5),
          FlSpot(3, 4),
          FlSpot(4, 7),
          FlSpot(5, 5),
          FlSpot.nullSpot,
          FlSpot(8, 0),
        ],
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 1:
        text = '1';
        break;
      case 2:
        text = '2';
        break;
      case 3:
        text = '3';
        break;
      case 4:
        text = '4';
        break;
      case 5:
        text = '5';
        break;
      case 6:
        text = '6';
        break;
      case 7:
        text = '7';
        break;
      default:
        return Container();
    }

    return Text(
      text,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }
}
