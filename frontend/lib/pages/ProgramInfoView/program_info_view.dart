import 'package:bbb/models/program_info_model.dart';
import 'package:bbb/providers/program_info_provider.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../components/common_streak_with_notification.dart';
import '../../utils/screen_util.dart';
import '../../values/app_colors.dart';
import '../../values/clip_path.dart';

class ProgramInfoView extends StatefulWidget {
  const ProgramInfoView({super.key});

  @override
  State<ProgramInfoView> createState() => _ProgramInfoViewState();
}

class _ProgramInfoViewState extends State<ProgramInfoView> {
  final Map<int, bool> _expandedStates = {0: true};

  List<Map<String, dynamic>> data = [
    {"title": "Training Guidelines", "description": ""},
    {"title": "Nutrition Plane", "description": ""},
    {"title": "Equipment", "description": ""},
    {"title": "Resource", "description": ""}
  ];
  late ProgramInfoProvider provider;

  @override
  void initState() {
    provider = context.read<ProgramInfoProvider>();
    provider.getProgramInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

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
                          height: media.height / 2.3,
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
                                          left: ScreenUtil.horizontalScale(4),
                                        ),
                                        decoration: const BoxDecoration(
                                          color: Color(0XFFd18a9b),
                                          shape: BoxShape.circle,
                                        ),
                                        child: SizedBox(
                                          width: ScreenUtil.horizontalScale(10),
                                          height: ScreenUtil.horizontalScale(10),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.keyboard_arrow_left,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              // Add navigation logic here
                                            },
                                            iconSize: ScreenUtil.verticalScale(4),
                                          ),
                                        ),
                                      ),
                                      CommonStreakWithNotification()
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil.verticalScale(6),
                                ),
                                Text(
                                  "Program Info",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil.verticalScale(3.5),
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.height / 3.5,
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
                    top: media.height / 3.5,
                    bottom: ScreenUtil.verticalScale(15),
                  ),
                  child: Container(
                    width: media.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil.verticalScale(7)),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: ScreenUtil.verticalScale(4),
                        ),
                        Consumer<ProgramInfoProvider>(builder: (context, value, child) {
                          return value.loading
                              ? SizedBox(
                                  height: media.height / 1.8,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : value.programInfoModel == null
                                  ? SizedBox(
                                      height: media.height / 1.5,
                                      child: Text(
                                        "No program info available",
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.primaryColor,
                                          fontSize: ScreenUtil.verticalScale(2),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(7)),
                                      child: ExpansionTileGroup(
                                        spaceBetweenItem: 15,
                                        // onExpansionItemChanged: (id, value) {
                                        //   setState(() {
                                        //     _expandedStates[id] = value;
                                        //   });
                                        // },
                                        children: List.generate(
                                          value.programInfoModel!.sections.length,
                                          (index) {
                                            return buildExpansionTileItem(index, value.programInfoModel!.sections[index]);
                                          },
                                        ),
                                      ),
                                    );
                        }),
                        SizedBox(
                          height: ScreenUtil.verticalScale(4),
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

  ExpansionTileItem buildExpansionTileItem(int index, Section item) {
    return ExpansionTileItem(
      tilePadding: EdgeInsets.symmetric(
        horizontal: ScreenUtil.horizontalScale(5),
        vertical: ScreenUtil.verticalScale(0.5),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              item.title,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.primaryColor,
                fontSize: ScreenUtil.verticalScale(2),
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
      initiallyExpanded: _expandedStates[index] ?? false,
      onExpansionChanged: (bool value) {
        setState(() {
          _expandedStates[index] = value;
        });
      },
      backgroundColor: const Color(0xFF0D0D0D),
      collapsedBackgroundColor: const Color(0xFF0D0D0D),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ScreenUtil.verticalScale(3)),
        color: Colors.grey[100],
      ),
      iconColor: AppColors.primaryColor,
      collapsedIconColor: Colors.white,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            child: Container(
              padding: EdgeInsets.all(ScreenUtil.verticalScale(0.3)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryColor,
                  width: 2,
                ),
                color: AppColors.primaryColor,
              ),
              child: Icon(
                _expandedStates[index] == true ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined,
                color: Colors.white,
                size: ScreenUtil.verticalScale(3),
              ),
            ),
          ),
        ],
      ),
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil.verticalScale(6)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil.horizontalScale(1),
            ),
            child: Text(
              item.description,
              style: TextStyle(
                fontSize: ScreenUtil.verticalScale(1.7),
                color: const Color(0xFF888888),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
