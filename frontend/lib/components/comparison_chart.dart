import 'package:bbb/values/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ComparisonChart extends StatefulWidget {
  const ComparisonChart({super.key});

  @override
  State<ComparisonChart> createState() => _ComparisonChartState();
}

class _ComparisonChartState extends State<ComparisonChart> {
  List<int> showingTooltipOnSpots = [4];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
        height: media.width * 0.6,
        width: double.maxFinite,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              enabled: true,
              handleBuiltInTouches: false,
              mouseCursorResolver:
                  (FlTouchEvent event, LineTouchResponse? response) {
                if (response == null || response.lineBarSpots == null) {
                  return SystemMouseCursors.basic;
                }
                return SystemMouseCursors.click;
              },
              getTouchedSpotIndicator:
                  (LineChartBarData barData, List<int> spotIndexes) {
                return spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    const FlLine(
                      color: Colors.transparent,
                    ),
                    FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
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
            maxY: 10,
            maxX: 15,
            titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: bottomTitles,
                ),
                leftTitles: AxisTitles(
                  sideTitles: leftTitles,
                )),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 1,
              drawVerticalLine: true,
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
        lineChartBarData1_2,
        lineChartBarData1_3,
        lineChartBarData1_4,
        lineChartBarData1_5
      ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: Colors.yellow,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        spots: const [
          FlSpot(0, 4),
          FlSpot(6, 7),
          FlSpot(10, 6),
          FlSpot(15, 8),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: Colors.green,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        spots: const [
          FlSpot(0, 3),
          FlSpot(5, 6),
          FlSpot(9, 5),
          FlSpot(15, 7),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: Colors.blue,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        spots: const [
          FlSpot(0, 2),
          FlSpot(4, 5),
          FlSpot(8, 4),
          FlSpot(15, 6),
        ],
      );

  LineChartBarData get lineChartBarData1_4 => LineChartBarData(
        isCurved: true,
        color: Colors.indigo,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        spots: const [
          FlSpot(0, 1),
          FlSpot(3, 4),
          FlSpot(7, 3),
          FlSpot(15, 5),
        ],
      );

  LineChartBarData get lineChartBarData1_5 => LineChartBarData(
        isCurved: true,
        color: Colors.red,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        spots: const [
          FlSpot(1, 1),
          FlSpot(5, 6),
        ],
      );

  SideTitles get leftTitles => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 1:
        text = '10';
        break;
      case 2:
        text = '20';
        break;
      case 3:
        text = '30';
        break;
      case 4:
        text = '40';
        break;
      case 5:
        text = '50';
        break;
      case 6:
        text = '60';
        break;
      case 7:
        text = '70';
        break;
      case 8:
        text = '80';
        break;
      case 9:
        text = '90';
        break;
      case 10:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 30,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '15';
        break;
      case 1:
        text = '16';
        break;
      case 2:
        text = '17';
        break;
      case 3:
        text = '18';
        break;
      case 4:
        text = '19';
        break;
      case 5:
        text = '20';
        break;
      case 6:
        text = '21';
        break;
      case 7:
        text = '22';
        break;
      case 8:
        text = '23';
        break;
      case 9:
        text = '24';
        break;
      case 10:
        text = '25';
        break;
      case 11:
        text = '26';
        break;
      case 12:
        text = '27';
        break;
      case 13:
        text = '28';
        break;
      case 14:
        text = '29';
        break;
      case 15:
        text = '30';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }
}
