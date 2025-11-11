import 'package:bbb/utils/screen_util.dart';
import 'package:flutter/material.dart';

Widget appImage({required String networkImageUrl, required String errorImageUrl ,double? height, double? width, BoxFit? fit, BorderRadiusGeometry? borderRadius,Widget? child}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(ScreenUtil.verticalScale(5))),
      image: DecorationImage(
        image: networkImageUrl.isNotEmpty
            ? NetworkImage(
          networkImageUrl.startsWith('https://storage.cloud.google.com/')
                    ? networkImageUrl.replaceFirst('https://storage.cloud.google.com/', 'https://storage.googleapis.com/')
                    : networkImageUrl,
              )
            :  AssetImage(errorImageUrl ?? 'assets/img/card.png'),
        fit: fit,

      ),
    ),

    child: child,
  );
}
