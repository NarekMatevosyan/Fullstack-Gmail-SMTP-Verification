import 'package:bbb/components/button_widget.dart';
import 'package:bbb/components/common_streak_with_notification.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bbb/components/back_arrow_widget.dart';

class NutritionCalculatorPage extends StatefulWidget {
  const NutritionCalculatorPage({super.key});

  @override
  State<NutritionCalculatorPage> createState() =>
      _NutritionCalculatorPageState();
}

class _NutritionCalculatorPageState extends State<NutritionCalculatorPage> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _selectedGender = 'Female';
  String _selectedActivityLevel = 'Active';
  String _selectedEquipment = '121lbs';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1998, 9, 21),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _ageController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _weightController.text = '121 lbs';
    _ageController.text = '09/21/1998';
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
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
                          height: media.height / 2.5,
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
                                      BackArrowWidget(
                                          onPress: () =>
                                              {Navigator.pop(context)}),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: ScreenUtil.horizontalScale(8),
                                            top: ScreenUtil.horizontalScale(8)),
                                        child: Text(
                                          'Hi, Nick',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                ScreenUtil.horizontalScale(5.5),
                                          ),
                                        ),
                                      ),
                                      const CommonStreakWithNotification()
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil.horizontalScale(5),
                                    vertical: ScreenUtil.horizontalScale(2),
                                  ),
                                  height: media.height * 0.2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: ScreenUtil.horizontalScale(50),
                                        child: Text(
                                          "Let's calculate your nutritional requirements",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                ScreenUtil.verticalScale(1.8),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.height / 4.59,
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
                  margin: EdgeInsets.only(top: media.height / 4.6),
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
                        Container(
                          width: media.width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(55),
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil.horizontalScale(5),
                              vertical: ScreenUtil.horizontalScale(3),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil.verticalScale(3)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Your Age',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryColor,
                                          fontSize:
                                              ScreenUtil.horizontalScale(5),
                                        ),
                                      ),
                                      const SizedBox(width: 50),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                ScreenUtil.horizontalScale(1),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                ScreenUtil.verticalScale(5)),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0x20888888),
                                                spreadRadius: 3,
                                                blurRadius: 10,
                                                offset: Offset(
                                                  0,
                                                  1,
                                                ),
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            controller: _ageController,
                                            readOnly: true,
                                            onTap: () => _selectDate(context),
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  ScreenUtil.verticalScale(5),
                                                ),
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0), // White border
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  ScreenUtil.verticalScale(5),
                                                ),
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0), // White border
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  ScreenUtil.verticalScale(5),
                                                ),
                                                borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 2.0,
                                                ), // White border
                                              ),
                                              suffixIcon: Icon(
                                                Icons.keyboard_arrow_down,
                                                size:
                                                    ScreenUtil.verticalScale(4),
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Your Weight',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryColor,
                                            fontSize:
                                                ScreenUtil.horizontalScale(5),
                                          )),
                                      const SizedBox(width: 25),
                                      Expanded(
                                          child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                ScreenUtil.horizontalScale(3),
                                            vertical:
                                                ScreenUtil.verticalScale(0.1)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil.verticalScale(5)),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x20888888),
                                              spreadRadius: 3,
                                              blurRadius: 10,
                                              offset: Offset(
                                                0,
                                                1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        child: DropdownButton<String>(
                                          value: _selectedEquipment,
                                          dropdownColor: const Color.fromARGB(
                                              255, 252, 252, 252),
                                          icon: const Icon(Icons
                                              .keyboard_arrow_down_outlined),
                                          iconSize: ScreenUtil.verticalScale(4),
                                          iconEnabledColor: Colors.grey[400],
                                          elevation: 12,
                                          isExpanded: true,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                          underline: Container(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedEquipment = newValue!;
                                            });
                                          },
                                          items: <String>[
                                            '121lbs',
                                            '200lbs',
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    value,
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      )),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Your Gender',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryColor,
                                            fontSize:
                                                ScreenUtil.horizontalScale(5),
                                          )),
                                      const SizedBox(width: 22),
                                      Expanded(
                                          child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                ScreenUtil.horizontalScale(3),
                                            vertical:
                                                ScreenUtil.verticalScale(0.1)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            ScreenUtil.verticalScale(5),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x20888888),
                                              spreadRadius: 3,
                                              blurRadius: 10,
                                              offset: Offset(
                                                0,
                                                1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        child: DropdownButton<String>(
                                          value: _selectedGender,
                                          dropdownColor: const Color.fromARGB(
                                              255, 252, 252, 252),
                                          icon: const Icon(Icons
                                              .keyboard_arrow_down_outlined),
                                          iconSize: ScreenUtil.verticalScale(4),
                                          iconEnabledColor: Colors.grey[400],
                                          elevation: 12,
                                          isExpanded: true,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                          underline: Container(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedGender = newValue!;
                                            });
                                          },
                                          items: <String>[
                                            'Female',
                                            'Male',
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    value,
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      )),
                                    ],
                                  ),
                                  SizedBox(
                                      height: ScreenUtil.horizontalScale(7)),
                                  DottedDashedLine(
                                    height: 0,
                                    width: media.width,
                                    dashColor: Colors.grey.withOpacity(0.3),
                                    axis: Axis.horizontal,
                                  ),
                                  SizedBox(
                                      height: ScreenUtil.horizontalScale(6)),
                                  Text(
                                    'Activity Level',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: ScreenUtil.horizontalScale(5),
                                        color: AppColors.primaryColor),
                                  ),
                                  const SizedBox(height: 12),
                                  Column(
                                    children: <Widget>[
                                      _buildActivityLevelTile(
                                        title:
                                            'Inactive: Never or rarely include physical activity in your day.',
                                        value: 'Inactive',
                                      ),
                                      _buildActivityLevelTile(
                                        title:
                                            'Somewhat active: Include light activity or moderate activity about two to three times a week.',
                                        value: 'Somewhat active',
                                      ),
                                      _buildActivityLevelTile(
                                        title:
                                            'Active: Include at least 30 minutes of moderate activity most days of the week, or 20 minutes of vigorous activity at least three days a week.',
                                        value: 'Active',
                                      ),
                                      _buildActivityLevelTile(
                                        title:
                                            'Very active: Include large amounts of moderate or vigorous activity in your day.',
                                        value: 'Very active',
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ScreenUtil.horizontalScale(7),
                                  ),
                                  DottedDashedLine(
                                    height: 0,
                                    width: media.width,
                                    dashColor: Colors.grey.withOpacity(0.3),
                                    axis: Axis.horizontal,
                                  ),
                                  SizedBox(
                                    height: ScreenUtil.horizontalScale(7),
                                  ),
                                  ButtonWidget(
                                    text: 'Calculate',
                                    textColor: Colors.white,
                                    color: AppColors.primaryColor,
                                    onPress: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/recalculate',
                                      );
                                    },
                                    isLoading: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        )
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

  Widget _buildActivityLevelTile(
      {required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color(0x20888888),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedActivityLevel = value;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 2.0,
          ),
          padding: const EdgeInsets.all(7.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${value.split(':')[0]}: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      TextSpan(
                        text:
                            title.replaceFirst('${value.split(':')[0]}: ', ''),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil.horizontalScale(3.2),
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: ScreenUtil.horizontalScale(2)),
              _customRadioButton(value),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customRadioButton(String value) {
    bool isSelected = _selectedActivityLevel == value;
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryColor, width: 2.0),
        color: isSelected ? AppColors.primaryColor : Colors.white,
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              size: 16.0,
              color: Colors.white,
            )
          : null,
    );
  }
}
