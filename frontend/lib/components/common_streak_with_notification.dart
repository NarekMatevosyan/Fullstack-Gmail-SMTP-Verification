import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonStreakWithNotification extends StatefulWidget {
  const CommonStreakWithNotification({super.key});

  @override
  State<CommonStreakWithNotification> createState() => _CommonStreakWithNotificationState();
}

class _CommonStreakWithNotificationState extends State<CommonStreakWithNotification> {
  @override
  Widget build(BuildContext context) {
    final streak = context.watch<MonthProvider>();
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/streak-calendar');
          },
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(ScreenUtil.verticalScale(0.65)),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
                child: Text(
                  '${streak.streak}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil.verticalScale(0.8),
                  ),
                ),
              ),
              Icon(
                Icons.local_fire_department_outlined,
                color: Colors.white,
                size: ScreenUtil.verticalScale(3),
              )
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/notifications');
          },
          icon: Icon(
            Icons.notifications_none,
            color: Colors.white,
            size: ScreenUtil.verticalScale(3),
          ),
        )
      ],
    );
  }
}
