import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ToolsPageButton extends StatelessWidget {
  const ToolsPageButton(
      {super.key, required this.title, required this.icon, required this.url});

  final String title;
  final String url;
  final String icon;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    void onPress() {
      Navigator.pushNamed(context, url);
    }

    return Material(
      child: SizedBox(
        width: media.width,
        child: InkWell(
          onTap: onPress,
          child: Container(
            padding: EdgeInsets.only(
              top: ScreenUtil.horizontalScale(12),
              left: ScreenUtil.horizontalScale(8),
              right: ScreenUtil.horizontalScale(8),
              bottom: ScreenUtil.horizontalScale(13),
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(35),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                SvgPicture.asset(
                  icon, // Path to your SVG file
                  width: 30,
                  height: 30,
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ), // Spacing between icon and text
                const SizedBox(
                  width: 30,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
