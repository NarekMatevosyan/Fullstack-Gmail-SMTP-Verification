import 'package:bbb/models/staffs.dart';
import 'package:bbb/providers/data_provider.dart';
import 'package:bbb/providers/user_data_provider.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MeetOurStaff extends StatefulWidget {
  const MeetOurStaff({Key? key}) : super(key: key);

  @override
  State<MeetOurStaff> createState() => _MeetOurStaffState();
}

class _MeetOurStaffState extends State<MeetOurStaff> {
  final today = DateTime.now();
  DataProvider? dataProvider;
  UserDataProvider? userData;
  int? week;
  int? day;

  bool isToday = true;
  bool isThisWeek = true;
  bool isSkipped = false;
  bool isCompleted = false;

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

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final staffData = ModalRoute.of(context)?.settings.arguments as Staffs?;
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
                          height: media.height / 1.7, // 2,//2.35,
                          width: media.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: staffData != null
                                    ? NetworkImage(staffData!.photo.startsWith('https://storage.cloud.google.com/')
                                        ? staffData!.photo.replaceFirst(
                                            'https://storage.cloud.google.com/',
                                            'https://storage.googleapis.com/')
                                        : staffData!.photo)
                                    : const AssetImage('assets/img/back.jpg'),
                              fit: BoxFit.cover,
                              opacity: 1,
                            ),
                          ),
                        ),
                        Container(
                          height: media.height / 1.8,
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
                                      Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                              left:
                                                  ScreenUtil.horizontalScale(4),
                                            ),
                                            decoration: BoxDecoration(
                                              color: //(isThisWeek && isCompleted)?
                                                  // Color(0xFF8A2BE2):
                                                  Color(0XFFd18a9b),
                                              shape: BoxShape.circle,
                                            ),
                                            child: SizedBox(
                                              width: ScreenUtil.horizontalScale(
                                                  10), // Size of the circle
                                              height:
                                                  ScreenUtil.horizontalScale(
                                                      10),
                                              child: IconButton(
                                                padding: EdgeInsets
                                                    .zero, // Removes the default padding
                                                icon: const Icon(
                                                  Icons.keyboard_arrow_left,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                iconSize: ScreenUtil.verticalScale(
                                                    4), // Icon size remains the same
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          ScreenUtil.horizontalScale(7)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: ScreenUtil.verticalScale(1.5),
                                      ),
                                      SizedBox(
                                          height: ScreenUtil.verticalScale(4)),
                                    ],
                                  ),
                                ),
                                SizedBox(height: ScreenUtil.verticalScale(2.5)),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.height / 1.9, // 2.64,
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
                    top: media.height / 1.905, //2.65,
                    bottom: ScreenUtil.verticalScale(2),
                  ),
                  child: Container(
                    width: media.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil.verticalScale(6)),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        top: media.height / 19, //19
                      ),
                      child: Column(
                        children: [
                          // const IconRowWithDot(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil.horizontalScale(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  staffData != null? staffData.title : 'Name',
                                  style: TextStyle(
                                    fontSize: ScreenUtil.verticalScale(3.5),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom:
                                          10.0), // Added bottom margin for spacing
                                  alignment: Alignment
                                      .centerLeft, // Center-align the header text
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        0.0), // Add padding for better layout
                                    child: Text(
                                      staffData != null? staffData.bio : "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                                          "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",

                                      style: const TextStyle(
                                        fontSize:
                                            16, // Customize font size for better readability
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign
                                          .left, // Center align the description
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil.verticalScale(5),
                          ),
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
    );
  }
}
