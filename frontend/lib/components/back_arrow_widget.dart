import 'package:flutter/material.dart';
import 'package:bbb/utils/screen_util.dart';

class BackArrowWidget extends StatelessWidget {
  const BackArrowWidget({super.key, required this.onPress});

  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.only(
        left: ScreenUtil.horizontalScale(4),
      ),
      decoration: const BoxDecoration(
        color: Color(0XFFd18a9b), // Make sure color is correct
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: ScreenUtil.horizontalScale(10), // Size of the circle
        height: ScreenUtil.horizontalScale(10),
        child: IconButton(
          padding: EdgeInsets.zero, // Removes the default padding
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
            size: ScreenUtil.verticalScale(4), // Adjust size using ScreenUtil
          ),
          onPressed: onPress,
        ),
      ),
    ));
  }
}
