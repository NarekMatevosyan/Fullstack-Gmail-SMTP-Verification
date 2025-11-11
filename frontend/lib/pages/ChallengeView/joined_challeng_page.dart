import 'package:bbb/components/activity_line_chart.dart';
import 'package:bbb/components/button_widget.dart';
import 'package:bbb/components/common_streak_with_notification.dart';
import 'package:bbb/components/icon_row_with_dot.dart';
import 'package:bbb/models/challenges.dart';
import 'package:bbb/providers/data_provider.dart';
// import 'package:bbb/storage/userdata_manager.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:bbb/providers/data_provider.dart';
import 'package:bbb/providers/user_data_provider.dart';
import 'package:flutter/widgets.dart';

class JoinedChallengePage extends StatefulWidget {
  const JoinedChallengePage({super.key});

  @override
  State<JoinedChallengePage> createState() => _JoinedChallengePageState();
}

class _JoinedChallengePageState extends State<JoinedChallengePage> {
  DataProvider? dataProvider;
  UserDataProvider? userData;
  late int totalWeight = 0;

  Challenges featureChallengeData = Challenges(id: '', title: '', description: '', photo: '');

  @override
  void initState() {
    dataProvider = Provider.of<DataProvider>(
      context,
      listen: false,
    );

    userData = Provider.of<UserDataProvider>(
      context,
      listen: false,
    );
    loadFeaturedChallengeData();
    super.initState();
  }

  void loadFeaturedChallengeData() async {
    setState(() {
      if (dataProvider?.featureChallengeData != null) {
        featureChallengeData = dataProvider!.featureChallengeData;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final currentDay = ModalRoute.of(context)!.settings.arguments as int;
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
                          height: media.height / 2.35,
                          width: media.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: featureChallengeData.photo.isNotEmpty
                                  ? NetworkImage(featureChallengeData.photo.startsWith('https://storage.cloud.google.com/')
                                      ? featureChallengeData.photo
                                          .replaceFirst('https://storage.cloud.google.com/', 'https://storage.googleapis.com/')
                                      : featureChallengeData.photo)
                                  : const AssetImage('assets/img/back.jpg'),
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
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      const CommonStreakWithNotification()
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil.horizontalScale(5),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: ScreenUtil.horizontalScale(10)),
                                      Text(
                                        'Thank you for joining',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil.verticalScale(2.4),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        featureChallengeData.title.isNotEmpty ? '${featureChallengeData.title}!' : 'Challenge Name!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil.horizontalScale(8.5),
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.height / 2.79,
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
                  margin: EdgeInsets.only(top: media.height / 2.8),
                  child: Container(
                    width: media.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil.horizontalScale(15)),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: media.height / 19),
                      child: Column(
                        children: [
                          SizedBox(height: ScreenUtil.horizontalScale(40)),
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
      bottomNavigationBar: Wrap(
        children: [
          SizedBox(
            height: ScreenUtil.verticalScale(10),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(10)),
              child: ButtonWidget(
                text: "Back to Home",
                textColor: Colors.white,
                onPress: () {
                  Navigator.pushNamed(context, '/home');
                },
                color: AppColors.primaryColor,
                isLoading: false,
              )),
          SizedBox(
            height: ScreenUtil.verticalScale(10),
          ),
        ],
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.black54),
          const SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(maxWidth: media.width / 1.4),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
