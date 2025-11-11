import 'package:bbb/components/common_streak_with_notification.dart';
import 'package:bbb/components/tools_page_button.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:flutter/material.dart';

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
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
                          height: media.height / 4,
                          width: media.width,
                          child: SafeArea(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, bottom: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                        width: media.width / 5,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: ScreenUtil.verticalScale(1),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Tools',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ScreenUtil.verticalScale(
                                                        2.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const CommonStreakWithNotification(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.height / 7.9,
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
                  margin: EdgeInsets.only(
                    top: media.height / 8,
                    bottom: ScreenUtil.verticalScale(15),
                  ),
                  child: Container(
                    width: media.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil.verticalScale(6)),
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
                              horizontal: ScreenUtil.horizontalScale(5),
                              vertical: ScreenUtil.verticalScale(2),
                            ),
                            child: Column(
                              children: [
                                const ToolsPageButton(
                                  title: 'Exercise Library',
                                  icon: 'assets/icons/exercise_library.svg',
                                  url: '/exerciseLibrary',
                                ),
                                SizedBox(
                                  height: ScreenUtil.verticalScale(1.3),
                                ),
                                const ToolsPageButton(
                                  title: 'Graphs & Reports',
                                  icon: 'assets/icons/graphs.svg',
                                  url: '/graphAndReports',
                                ),
                                SizedBox(
                                  height: ScreenUtil.verticalScale(1.3),
                                ),
                                const ToolsPageButton(
                                  title: 'Nutrition Calculator',
                                  icon: 'assets/icons/nutrition.svg',
                                  url: '/nutritionCalculator',
                                ),
                                SizedBox(
                                  height: ScreenUtil.verticalScale(1.3),
                                ),
                                const ToolsPageButton(
                                  title: 'Apparel & Equipment',
                                  icon: 'assets/icons/apparel.svg',
                                  url: '/equipmentLibrary',
                                ),
                                SizedBox(
                                  height: ScreenUtil.verticalScale(1.3),
                                ),
                                const ToolsPageButton(
                                  title: 'Bonuses',
                                  icon: 'assets/icons/bonuses.svg',
                                  url: '/bonusLibrary',
                                ),
                                SizedBox(
                                  height: ScreenUtil.verticalScale(1.3),
                                ),
                              ],
                            ),
                          ),
                        ),
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
}
