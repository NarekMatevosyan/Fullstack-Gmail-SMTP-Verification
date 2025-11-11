import 'dart:async';

import 'package:bbb/middleware/notification_service.dart';
import 'package:bbb/pages/NewMonthView/Database/month_database.dart';
import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewTimerWithProgressBar extends StatefulWidget {
  final int initialDuration;
  final VoidCallback onClose;
  final VoidCallback onComplete;
  final String currentTime;
  final String dataId;
  final bool isTimerRunning;

  const NewTimerWithProgressBar({
    super.key,
    required this.initialDuration,
    required this.onClose,
    required this.onComplete,
    required this.currentTime,
    required this.isTimerRunning,
    required this.dataId,
  });

  @override
  State<NewTimerWithProgressBar> createState() => _NewTimerWithProgressBarState();
}

class _NewTimerWithProgressBarState extends State<NewTimerWithProgressBar> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late MonthProvider monthProvider;

  @override
  void initState() {
    monthProvider = Provider.of<MonthProvider>(context, listen: false);
    timerOnInit();
    super.initState();
  }

  late int totalTime;
  late int currentTime;
  late AnimationController controller;
  late String formattedTime;

  Timer? timerTimer;
  bool isPaused = false;
  bool animationCompleted = false;
  String? previousData;

  timerOnInit() {
    NotificationService.clearNotification();
    totalTime = widget.initialDuration;
    WidgetsBinding.instance.addObserver(this);

    currentTime = 0;
    formattedTime = _formatTime(currentTime);

    previousData = monthProvider.currentExpandedItem;

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: totalTime),
    );

    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        animationCompleted = true;
        widget.onComplete();

        DatabaseHelper().updateSingleValue(
            tableName: DatabaseHelper.exerciseHistory, id: widget.dataId, columnName: 'status', newValue: Status.completed);
      }
    });

    startTimer();
  }

  timerSavePassedTime(widget, context) {
    monthProvider.savePassedTime(widget.isTimerRunning ? currentTime.toString() : "0", widget.initialDuration, context);
  }

  void startTimer() async {
    await monthProvider.getPassedTime();
    if (monthProvider.timePassed != "") {
      if (widget.isTimerRunning) {
        currentTime = int.parse(monthProvider.timePassed);
      }
    }
    timerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused) {
        currentTime++;
        formattedTime = _formatTime(currentTime);
        if (!animationCompleted && currentTime <= totalTime) {
          controller.value = currentTime / totalTime;
        }
        setState(() {});
        if (currentTime == totalTime && !animationCompleted) {
          controller.forward();
          widget.onComplete();
        }
      }
    });
    setState(() {});
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> pauseOrResumeTimer() async {
    if (isPaused) {
      isPaused = false;
      if (!animationCompleted) {
        controller.forward();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isPause", false);
      }
    } else {
      isPaused = true;
      controller.stop();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isPause", true);
    }
    setState(() {});
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        NotificationService.clearNotification();
        await monthProvider.getPassedTime();
        if (monthProvider.timePassed != "") {
          currentTime = 0;
          if (widget.isTimerRunning) {
            currentTime = int.parse(monthProvider.timePassed);
          }
          if (int.parse(monthProvider.timePassed) > totalTime) {
            DatabaseHelper().updateSingleValue(
                tableName: DatabaseHelper.exerciseHistory, id: widget.dataId, columnName: 'status', newValue: Status.completed);
          }
        }
        setState(() {});
        break;
      case AppLifecycleState.inactive:
        timerSavePassedTime(widget, context);
        break;
      case AppLifecycleState.paused:
        timerSavePassedTime(widget, context);
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    timerSavePassedTime(widget, context);
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    timerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final data = context.select<MonthProvider, String>((monthProvider) => monthProvider.currentExpandedItem);
    // if (previousData != data) {
    //   previousData = data;
    //   if (widget.isTimerRunning) {
    //     monthProvider.setShowTimerIndex(-1, -1, -1);
    //     widget.onClose();
    //   }
    // }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        color: currentTime >= totalTime * 0.9 ? const Color(0xff008000) : AppColors.primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 10),
          Text(
            formattedTime,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: LinearProgressIndicator(
              value: currentTime <= totalTime ? currentTime / totalTime : 1.0,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 3,
            ),
          ),
          const SizedBox(width: 5),
          SizedBox(
            width: 45,
            height: 30,
            child: ElevatedButton(
              onPressed: pauseOrResumeTimer,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(20, 20),
              ),
              child: Icon(
                isPaused ? Icons.play_arrow : Icons.pause,
                color: AppColors.skipDayColor,
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.close,
              size: 18,
              color: Colors.white,
            ),
            onPressed: () {
              monthProvider.setShowTimerIndex(-1, -1, -1);
              widget.onClose();
            },
          ),
        ],
      ),
    );
  }
}
