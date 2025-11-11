import 'package:bbb/components/button_widget.dart';
import 'package:bbb/components/common_streak_with_notification.dart';
import 'package:bbb/components/rep_line_chart.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';

class RecalculatePage extends StatefulWidget {
  const RecalculatePage({super.key});

  @override
  State<RecalculatePage> createState() => _RecalculatePageState();
}

class _RecalculatePageState extends State<RecalculatePage> {
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
                        Container(
                          height: media.height / 2.5,
                          width: media.width,
                          child: SafeArea(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          left:ScreenUtil.horizontalScale(4),
                                        ),
                                        decoration: const BoxDecoration(
                                          color:Color(0XFFd18a9b),
                                          shape: BoxShape.circle,
                                        ),
                                        child: SizedBox(
                                          width: ScreenUtil.horizontalScale(10), // Size of the circle
                                          height:ScreenUtil.horizontalScale(10),
                                          child: IconButton(
                                            padding: EdgeInsets.zero, // Removes the default padding
                                            icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white,),
                                            onPressed: () => Navigator.pop(context),
                                            iconSize: ScreenUtil.verticalScale(4), // Icon size remains the same
                                          ),
                                        ),
                                      ),
                                      const SizedBox(),
                                      const CommonStreakWithNotification()
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: ScreenUtil.horizontalScale(10),
                                    right: ScreenUtil.horizontalScale(10),
                                    top: ScreenUtil.horizontalScale(6),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '2200',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // const SizedBox(height: 5),
                                      const SizedBox(
                                        child: Text(
                                          "Calories needed",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: ScreenUtil.horizontalScale(3)),
                                      ButtonWidget(
                                        text: 'Recalculate',
                                        textColor: Colors.white,
                                        color: AppColors.primaryColor,
                                        onPress: () {},
                                        isLoading: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.height / 2.86,
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
                  margin: EdgeInsets.only(top: media.height / 2.87),
                  child: Container(
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
                          width: media.width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(55),
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil.horizontalScale(3),
                              vertical: 20,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil.horizontalScale(5),
                                    ),
                                    child: Text(
                                      'This number shows your estimated calorie need (rounded to the nearest 50 ccal).',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: ScreenUtil.horizontalScale(3.6),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil.horizontalScale(6.2)),
                                  DottedDashedLine(
                                    height: 0,
                                    width: media.width,
                                    dashColor: Colors.grey.withOpacity(0.5),
                                    axis: Axis.horizontal,
                                  ),
                                  SizedBox(height: ScreenUtil.horizontalScale(8.2)),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      'See how your daily calorie change at different activity levels',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: ScreenUtil.horizontalScale(4),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil.horizontalScale(9)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          colorieCard("Inactive", false),
                                          SizedBox(height: ScreenUtil.horizontalScale(5)),
                                          colorieCard("Active", false),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          colorieCard("Somewhat Active", true),
                                          SizedBox(height: ScreenUtil.horizontalScale(5)),
                                          colorieCard("Very Active", false),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  DottedDashedLine(
                                    height: 0,
                                    width: media.width,
                                    dashColor: Colors.grey.withOpacity(0.5),
                                    axis: Axis.horizontal,
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 5,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Needs over time",
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              items: [
                                                "Month 1",
                                                "Month 2",
                                                "Month 3",
                                                "Month 4"
                                              ]
                                                  .map((name) =>
                                                      DropdownMenuItem(
                                                        value: name,
                                                        child: Text(
                                                          name,
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xA09F9F9F),
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {},
                                              icon: const Icon(
                                                Icons.expand_more,
                                                color: Color(0xA09F9F9F),
                                                size: 25,
                                              ),
                                              hint: const Text(
                                                "Month",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color(0xA09F9F9F),
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const RepLineChart(),
                                  SizedBox(height: ScreenUtil.horizontalScale(6)),
                                  Column(
                                    children: [
                                      ButtonWidget(
                                        text: 'Back to Dashboard',
                                        textColor: const Color(0x40000000),
                                        color: const Color(0xC0FFFFFF),
                                        onPress: () {

                                          Navigator.pushNamed(
                                            context,
                                            "/home",
                                          );
                                        },
                                        isLoading: false,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      ButtonWidget(
                                        text: 'Start Workout',
                                        textColor: Colors.white,
                                        color: AppColors.primaryColor,
                                        onPress: () {},
                                        isLoading: false,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        )
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

  Widget colorieCard(String title, bool isActive) {
    var media = MediaQuery.of(context).size;
    return Container(
      width: media.width / 2.5,
      padding: EdgeInsets.all(ScreenUtil.horizontalScale(3.2)),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black54,
              ),
            ),
            SizedBox(height: ScreenUtil.horizontalScale(2)),
            Text(
              '2200 ccal',
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFFDD1166),
                fontSize: 21,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
