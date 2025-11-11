import 'package:bbb/components/common_streak_with_notification.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:flutter/material.dart';
import 'package:bbb/components/button_widget.dart';
import 'package:bbb/components/back_arrow_widget.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String selectedLanguage = 'English'; // Default selected language

  // List of languages with their flags  // due to
  final List<Map<String, String>> languages = [
    {'name': 'English', 'flag': '\u{1F1FA}\u{1F1F8}'},
    {'name': 'Spanish', 'flag': '\u{1F1EA}\u{1F1F8}'}, // Spain flag
  ];

  @override
  void initState() {
    super.initState();
  }

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
                          height: media.height / 1.5,
                          width: media.width,
                          child: SafeArea(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil.horizontalScale(3),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      BackArrowWidget(
                                          onPress: () =>
                                          {Navigator.pop(context)}),
                                      CommonStreakWithNotification()
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil.horizontalScale(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: ScreenUtil.horizontalScale(10),
                                      ),
                                      Container(
                                        height: ScreenUtil.horizontalScale(15),
                                        width: ScreenUtil.horizontalScale(25),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              ScreenUtil.horizontalScale(2.5),
                                            ),
                                          ),
                                        ),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              ScreenUtil.horizontalScale(1.5),
                                            ),
                                            child: selectedLanguage == 'English'
                                                ? Image.asset(
                                              'assets/img/american.png',
                                              fit: BoxFit.fill,
                                            )
                                                : Image.asset(
                                              'assets/img/spanish.png',
                                              fit: BoxFit.fill,
                                            )),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil.horizontalScale(5),
                                      ),
                                      Text(
                                        "Select Your Language",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                          ScreenUtil.horizontalScale(8),
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
                          height: media.height / 2.64,
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
                    top: media.height / 2.65,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Builder(builder: (context) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics:
                            ClampingScrollPhysics(), // Prevent scrolling if content fits
                            itemCount: languages.length,
                            itemBuilder: (context, index) {
                              final language = languages[index];
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(24, 0, 8,
                                        0), // Add padding to left and right
                                    child: ListTile(
                                      title: Text(
                                        language['name'] ?? '',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                              height:
                                              ScreenUtil.horizontalScale(8),
                                              width: ScreenUtil.horizontalScale(
                                                  12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    ScreenUtil.horizontalScale(
                                                        .5),
                                                  ),
                                                ),
                                              ),
                                              child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    ScreenUtil.horizontalScale(
                                                        1),
                                                  ),
                                                  child: language['name'] ==
                                                      'English'
                                                      ? Image.asset(
                                                    'assets/img/american.png',
                                                    fit: BoxFit.fill,
                                                  )
                                                      : Image.asset(
                                                    'assets/img/spanish.png',
                                                    fit: BoxFit.fill,
                                                  ))),
                                          SizedBox(width: 10),
                                          Radio<String>(
                                            activeColor: AppColors.primaryColor,
                                            value: language['name'] ?? '',
                                            groupValue: selectedLanguage,
                                            onChanged: (String? value) {
                                              setState(() {
                                                selectedLanguage = value!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  index == languages.length - 1
                                      ? SizedBox(
                                    height: 0,
                                  )
                                      : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        28, 0, 28, 0),
                                    child: Divider(
                                      thickness: 0.3,
                                    ),
                                  ), // Divider between items
                                ],
                              );
                            },
                          );
                        }),
                        Container(
                            margin: EdgeInsets.symmetric(
                              vertical: ScreenUtil.verticalScale(4),
                              horizontal: ScreenUtil.horizontalScale(10),
                            ),
                            child: Container(
                              color: Colors.white,
                              height: 60,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(
          vertical: ScreenUtil.verticalScale(4),
          horizontal: ScreenUtil.horizontalScale(10),
        ),
        child: ButtonWidget(
          text: "Confirm Language",
          textColor: Colors.white,
          onPress: () {
            Navigator.of(context).pop();
          },
          color: AppColors.primaryColor,
          isLoading: false,
        ),
      ),
    );
  }

}