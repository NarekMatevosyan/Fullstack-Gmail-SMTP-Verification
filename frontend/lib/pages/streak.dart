// import 'dart:math';

import 'package:bbb/components/athletes_list_widget.dart';
import 'package:bbb/components/bar_chart_widget.dart';
import 'package:bbb/components/join_challenge_widget.dart';
import 'package:bbb/components/button_widget.dart';
import 'package:bbb/components/collection_grid.dart';
import 'package:bbb/models/challenges.dart';
import 'package:bbb/models/collections.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  final VoidCallback onNavigateToMonthlyView;

  const DashboardPage({
    super.key,
    required this.onNavigateToMonthlyView,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Challenges featureChallengeData =
      Challenges(id: '', title: '', description: '', photo: '');
  void _navigateToMonthlyView() {
    widget.onNavigateToMonthlyView();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    ScreenUtil.init(context);
    return SingleChildScrollView(
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
                        height: media.height / 2,
                        width: media.width,
                        child: SafeArea(
                          child: Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 10, bottom: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: ScreenUtil.horizontalScale(8),
                                        top: ScreenUtil.verticalScale(0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Hi, Nick,',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil.verticalScale(2.7),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: ScreenUtil.horizontalScale(43),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: ScreenUtil.verticalScale(2.3),
                                            width: ScreenUtil.verticalScale(2.3),
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ScreenUtil.verticalScale(1.8)),
                                              ),
                                              border: Border.all(color: Colors.white),
                                            ),
                                            child: const Text(
                                              '0',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/streak');
                                            },
                                            child: Icon(
                                              Icons.local_fire_department_outlined,
                                              color: Colors.white,
                                              size: ScreenUtil.verticalScale(3),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.notifications_none,
                                              color: Colors.white,
                                              size: ScreenUtil.verticalScale(3),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil.horizontalScale(8),
                                  vertical: ScreenUtil.verticalScale(2),
                                ),
                                height: media.height * 0.23,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          Text(
                                            'Your current workout:',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  ScreenUtil.verticalScale(2),
                                            ),
                                          ),
                                          Text(
                                            'May: Day 2',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  ScreenUtil.verticalScale(4),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ButtonWidget(
                                      text: 'Continue Workout',
                                      textColor: AppColors.primaryColor,
                                      color: Colors.white,
                                      onPress: () {
                                        Navigator.pushNamed(
                                          context,
                                          "/today",
                                        );
                                      },
                                      isLoading: false,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: media.height / 2.54,
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
                  // Extra content below the Stack if needed
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  top: media.height / 2.55,
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
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil.horizontalScale(10),
                          vertical: ScreenUtil.verticalScale(2),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '7/12 days tracked',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: ScreenUtil.verticalScale(1.5),
                                  ),
                                ),
                                Text(
                                  '67% Complete',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: ScreenUtil.verticalScale(1.5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Stack(
                              children: [
                                Container(
                                  width: media.width,
                                  height: ScreenUtil.verticalScale(0.5),
                                  decoration:
                                      BoxDecoration(color: Colors.grey[300]),
                                ),
                                Container(
                                  width: media.width / 2.5,
                                  height: ScreenUtil.verticalScale(0.5),
                                  decoration: const BoxDecoration(
                                      color: AppColors.primaryColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil.horizontalScale(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: (_navigateToMonthlyView),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                ),
                                child: Text(
                                  'Month View',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil.verticalScale(2),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  side: const BorderSide(
                                    color:
                                        AppColors.primaryColor, // Border color
                                    width: 2, // Border width
                                  ),
                                ),
                                child: Text(
                                  'Edit Schedule',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: ScreenUtil.verticalScale(2),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil.horizontalScale(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Recent Activity",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: ScreenUtil.horizontalScale(5.2),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              height: media.height * 0.05,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  items: ["Session Score",
                                        "Average RiR",
                                        "Time Spent",
                                        "Workouts Done",
                                      ]
                                      .map(
                                        (name) => DropdownMenuItem(
                                          value: name,
                                          child: Text(
                                            name,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize:
                                                  ScreenUtil.verticalScale(2),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {},
                                  icon: Icon(
                                    Icons.expand_more,
                                    color: Colors.grey,
                                    size: ScreenUtil.verticalScale(3.5),
                                  ),
                                  hint: Text(
                                    "Session Score",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: ScreenUtil.verticalScale(2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil.horizontalScale(10),
                        ),
                        child: BarChartWidget(),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil.horizontalScale(10),
                        ),
                        child: ButtonWidget(
                          text: 'See all progress reports',
                          textColor: Colors.white,
                          color: AppColors.primaryColor,
                          onPress: () {},
                          isLoading: false,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil.horizontalScale(5),
                          vertical: ScreenUtil.verticalScale(5),
                        ),
                        child: JoinChallengeWidget(featureChallenge: featureChallengeData),
                      ),
                      Container(
                        width: media.width,
                        margin: EdgeInsets.symmetric(
                          vertical: ScreenUtil.verticalScale(3),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            AthletesListWidget(
                              height: ScreenUtil.verticalScale(38),
                              width: ScreenUtil.horizontalScale(60),
                            ),
                            AthletesListWidget(
                              height: ScreenUtil.verticalScale(38),
                              width: ScreenUtil.horizontalScale(60),
                            ),
                            AthletesListWidget(
                              height: ScreenUtil.verticalScale(38),
                              width: ScreenUtil.horizontalScale(70),
                            ),
                          ]),
                        ),
                      ),
                      Container(
                        width: media.width,
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil.horizontalScale(5),
                          vertical: ScreenUtil.verticalScale(4),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: media.width,
                              margin:
                                  const EdgeInsets.only(bottom: 20, left: 6),
                              child: Text(
                                "Featured Collections",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: ScreenUtil.verticalScale(2.4),
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: CollectionGrid(
                                  collection: Collections(id: "1", title: "BBB", description: "Outfits", photo: "photo", equipments: []),
                                )),
                                Expanded(
                                    child: CollectionGrid(
                                  collection: Collections(id: "2", title: "Perfect", description: "Warm-ups", photo: "photo", equipments: []),
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: CollectionGrid(
                                  collection: Collections(id: "3", title: "Guide", description: "To Split", photo: "photo", equipments: []),
                                )),
                                Expanded(
                                    child: CollectionGrid(
                                  collection: Collections(id: "4", title: "All the", description: "Equipment", photo: "photo", equipments: []),
                                )),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: media.width,
                        child: Column(
                          children: [
                            Container(
                              width: media.width,
                              margin: EdgeInsets.symmetric(
                                horizontal: ScreenUtil.horizontalScale(10),
                                vertical: ScreenUtil.verticalScale(2),
                              ),
                              child: Text(
                                "Meet our staff",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: ScreenUtil.verticalScale(2.4),
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(children: [
                                AthletesListWidget(
                                  height: ScreenUtil.verticalScale(37),
                                  width: ScreenUtil.horizontalScale(62),
                                ),
                                AthletesListWidget(
                                  height: ScreenUtil.verticalScale(37),
                                  width: ScreenUtil.horizontalScale(62),
                                ),
                                AthletesListWidget(
                                  height: ScreenUtil.verticalScale(37),
                                  width: ScreenUtil.horizontalScale(62),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
