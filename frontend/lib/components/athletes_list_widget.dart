import 'package:bbb/components/common_network_image.dart';
import 'package:bbb/models/staffs.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:flutter/material.dart';

class AthletesListWidget extends StatelessWidget {
  final double height;
  final double width;
  final Staffs? oneAthlete;
  const AthletesListWidget({super.key, required this.height, required this.width, this.oneAthlete});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return appImage(
      height: height,
      width: width,
      networkImageUrl: oneAthlete?.photo ?? "",
      errorImageUrl: "assets/img/card.png",
      fit: BoxFit.cover,
      borderRadius: BorderRadius.all(Radius.circular(ScreenUtil.verticalScale(5))),
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil.horizontalScale(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Member',
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil.horizontalScale(3.6),
              ),
            ),
            Text(
              oneAthlete?.title ?? 'Erica Stone',
              style: TextStyle(color: Colors.white, fontSize: ScreenUtil.horizontalScale(5), fontWeight: FontWeight.bold, height: 1.35),
            ),
            Text(
              oneAthlete?.location ?? 'Miami FL',
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil.horizontalScale(4.2),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/meetOurStaff', arguments: oneAthlete);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil.horizontalScale(6),
                  vertical: ScreenUtil.verticalScale(1.5),
                ),
              ),
              child: Text(
                "Read more",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil.verticalScale(1.5),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
