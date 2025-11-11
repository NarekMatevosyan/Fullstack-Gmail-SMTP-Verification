import 'package:bbb/components/button_widget.dart';
import 'package:bbb/models/collections.dart';
import 'package:bbb/models/equipment.dart';
import 'package:bbb/models/notifications.dart';
import 'package:bbb/providers/data_provider.dart';
import 'package:bbb/providers/user_data_provider.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  DataProvider? dataProvider;
  UserDataProvider? userData;
  bool isSwitchOn = false;
  List<Notifications> notificationData = [
    // Notifications(id: "1", title: "Test1", description: "Test Notification 1"),
    // Notifications(id: "2", title: "Test2", description: "Test Notification 2"),
    // Notifications(id: "3", title: "Test3", description: "Test Notification 3"),
    // Notifications(id: "4", title: "Test4", description: "Test Notification 4 Test Notification 4 Test Notification 4 Test Notification 4"),
    // Notifications(id: "5", title: "Test5", description: "Test Notification 5"),
    // Notifications(id: "6", title: "Test6", description: "Test Notification 6"),
  ];

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
    super.initState();
  }

  Widget notificationCard(String title, String description) {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          // _launchURL(link); // Launch the external URL when tapped
        },
        child: Container(
          decoration: const BoxDecoration(
              // color: Color(0xFF000000),
              ),
          child: Stack(
            children: [
              Container(
                  width: ScreenUtil.horizontalScale(100),
                  margin: EdgeInsets.symmetric(
                      horizontal: ScreenUtil.horizontalScale(5), vertical: ScreenUtil.verticalScale(0.2)),
                  padding: EdgeInsets.all(ScreenUtil.verticalScale(2)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil.verticalScale(2)),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x20888888),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: title,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil.verticalScale(2),
                            ),
                          ),
                          TextSpan(
                            text: "  ",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                              fontSize: ScreenUtil.verticalScale(2),
                            ),
                          ),
                          TextSpan(
                            text: description,
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                              fontSize: ScreenUtil.verticalScale(2),
                            ),
                          ),
                        ])),
                      ),
                      Icon(
                        Icons.close_rounded,
                        size: ScreenUtil.verticalScale(2),
                        color: AppColors.blackColor,
                      )
                    ],
                  ) // Ensure the background takes up all available space
                  ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                          height: 176.25,
                          width: media.width,
                          child: SafeArea(
                            child: Column(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
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
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Notifications',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil.verticalScale(3),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 126.34,
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
                notificationData.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.only(top: 125.89),
                        child: Container(
                          width: media.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(ScreenUtil.horizontalScale(15)),
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(top: media.height / 19, right: 20, left: 20),
                            child: Column(
                              children: notificationData.map((notification) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 14),
                                    notificationCard(
                                      notification.title,
                                      notification.description,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(top: 125.89),
                        child: Container(
                          width: media.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(ScreenUtil.horizontalScale(15)),
                            ),
                          ),
                          child: Container(
                              margin:
                                  EdgeInsets.only(top: (ScreenUtil.verticalScale(80) - 300) / 2, right: 20, left: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/img/notifications.png",
                                    width: ScreenUtil.horizontalScale(25),
                                    height: ScreenUtil.horizontalScale(25),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'No notifications yet',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: ScreenUtil.verticalScale(2.5),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Your notifications will show up here\nas you use the app.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: ScreenUtil.verticalScale(2),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Wrap(
        children: [
          Container(
            margin:
                EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(10), vertical: ScreenUtil.verticalScale(2)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Enable notifications?",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: ScreenUtil.verticalScale(2.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: isSwitchOn, // Boolean value
                      onChanged: (bool value) {
                        setState(() {
                          isSwitchOn = value; // Update state
                        });
                      },
                      activeColor: AppColors.primaryColor,
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil.verticalScale(1),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(0)),
                  child: ButtonWidget(
                    text: "Continue Working Out",
                    textColor: Colors.white,
                    onPress: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    color: AppColors.primaryColor,
                    isLoading: false,
                  ),
                ),
                SizedBox(
                  height: ScreenUtil.horizontalScale(6.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
