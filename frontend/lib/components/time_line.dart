import 'package:bbb/values/app_colors.dart';
import 'package:flutter/material.dart';

class Timeline extends StatefulWidget {
  const Timeline({super.key});

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  int _selectedPointIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 32.5, horizontal: 8),
              width: double.infinity,
              height: 1,
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPointIndex = index;
                    });
                  },
                  child: Column(
                    children: [
                      _selectedPointIndex != index
                          ? const SizedBox(height: 20)
                          : const SizedBox(width: 0),
                      _selectedPointIndex == index
                          ? (index == 0
                              ? Text('0 - ${(index + 6).toString()}')
                              : Text((index + 6).toString()))
                          : const SizedBox(width: 0),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selectedPointIndex == index
                                ? AppColors.primaryColor
                                : Colors.transparent,
                            width: 8,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: _selectedPointIndex == index
                              ? Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFFFFFFF),
                                  ))
                              : Container(
                                  width: 1,
                                  height: 12,
                                  color: Colors.black,
                                ),
                        ),
                      ),
                      _selectedPointIndex == index
                          ? const SizedBox(height: 20)
                          : const SizedBox(width: 0),
                      _selectedPointIndex != index
                          ? (index == 0 ? Text((index + 6).toString()) : Text((index + 6).toString()))
                          // ? (index == 0 ? Text('0 - ${(index + 6).toString()}') : Text((index + 6).toString()))
                          : const SizedBox(width: 0),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}
