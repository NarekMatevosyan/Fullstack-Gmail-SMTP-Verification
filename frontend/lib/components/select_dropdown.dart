import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectDropdown extends StatefulWidget {
  final Function(String) onChange; // Callback function for when the value changes

  const SelectDropdown({super.key, required this.onChange});

  @override
  State<SelectDropdown> createState() => _SelectDropdownState();
}

class _SelectDropdownState extends State<SelectDropdown> {
  String _selectedEquipment = 'Fully equipped gym';

  MonthProvider? monthProvider;

  @override
  void initState() {
    monthProvider = Provider.of<MonthProvider>(
      context,
      listen: false,
    );

    _selectedEquipment = monthProvider!.equipmentType == "A"
        ? 'Fully equipped gym'
        : monthProvider!.equipmentType == "B"
            ? 'Home gym'
            : 'Dumbbells and bands';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
      elevation: 10, // Shadow depth
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ScreenUtil.verticalScale(4)), // Rounded corners
      ),
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil.horizontalScale(3),
          vertical: ScreenUtil.verticalScale(0.6),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenUtil.verticalScale(4)),
          // boxShadow: const [
          //   BoxShadow(
          //     color: Color(0x20888888),
          //     spreadRadius: 1,
          //     blurRadius: 1,
          //   ),
          // ],
        ),
        child: DropdownButton<String>(
          value: _selectedEquipment,
          icon: const Icon(Icons.keyboard_arrow_down_outlined),
          iconSize: ScreenUtil.verticalScale(4),
          dropdownColor: const Color.fromARGB(255, 252, 252, 252),
          iconEnabledColor: Colors.grey[400],
          isExpanded: true,
          style: TextStyle(
            color: Colors.black,
            fontSize: ScreenUtil.verticalScale(2),
          ),
          underline: Container(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedEquipment = newValue!;
            });
            widget.onChange(newValue == 'Fully equipped gym'
                ? 'A'
                : newValue == 'Home gym'
                    ? 'B'
                    : 'C'); // Trigger the onChange callback
          },
          items: <String>['Fully equipped gym', 'Home gym', 'Dumbbells and bands'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    radius: ScreenUtil.verticalScale(2),
                    child: Text(
                      value == 'Fully equipped gym'
                          ? 'A'
                          : value == 'Home gym'
                              ? 'B'
                              : 'C',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil.verticalScale(2.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    value,
                    style: TextStyle(
                      color: const Color(0xBB888888),
                      fontSize: ScreenUtil.verticalScale(1.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
