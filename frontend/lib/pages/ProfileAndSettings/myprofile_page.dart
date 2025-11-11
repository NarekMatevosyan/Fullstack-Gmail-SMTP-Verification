import 'dart:io';

import 'package:bbb/components/back_arrow_widget.dart';
import 'package:bbb/components/button_widget.dart';
import 'package:bbb/components/common_streak_with_notification.dart';
import 'package:bbb/components/profile_image_handler.dart';
import 'package:bbb/providers/location_provider.dart';
import 'package:bbb/providers/user_data_provider.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String? _imageUrl;
  String? selectedName = "";
  DateTime? selectedDate;
  String? selectedWeight;
  String? selectedGender;
  String? selectedHeight;
  String? selectedLocation;
  String? selectedGoal;
  String? _id;

  UserDataProvider? userData;

  final List<String> weightOptions = [
    '100 lbs',
    '110 lbs',
    '121 lbs',
    '130 lbs',
    '140 lbs',
  ];

  final List<String> genderOptions = ['Female', 'Male', 'Other'];
  final List<String> goalsOptions = ['Muscle Growth', 'Weight Gain', 'Strength & Performance'];
  final List<String> heightOptions = ['5\'0"', '5\'5"', '6\'0"', '6\'5"']; // Example heights
  late LocationProvider locationProvider; // Example locations

  @override
  void initState() {
    locationProvider = Provider.of<LocationProvider>(context, listen: false);
    userData = Provider.of<UserDataProvider>(context, listen: false);
    _fetchUserData();
    super.initState();
  }

  File? image;

  Future<void> _fetchUserData() async {
    // try {
    final userData1 = await userData!.fetchUserInfo();
    // userData['detail'] = jsonDecode( userData['detail']);

    setState(() {
      _id = userData1['_id'];
      selectedName = userData1["name"];
      selectedDate = DateTime.parse(userData1["detail"]['dob']);
      selectedWeight = '${userData1["detail"]["weight"]} lbs'; //'${userData['detail']['weight']} lbs';
      selectedHeight =
          '${userData1["detail"]["height"].toString()[0]}\'${userData1["detail"]["height"].toString()[1]}"'; //'${userData['detail']['height']}\'0"';
      selectedLocation = userData1['detail']['location'];
      _imageUrl = userData1['detail']['avatarUrl'];
      selectedGender = genderOptions[userData1['detail']['sex'] == true ? 1 : 0];
      selectedGoal = userData1['detail']['mygoal'];

      if (userData1['detail']['country'] == null || userData1['detail']['country'] == '') {
        locationProvider.generateToken();
      } else {
        locationProvider.fillDetails(userData1['detail']['country'], userData1['detail']['state'], userData1['detail']['city']);
      }
    });
    // } catch (e) {
    //   print('Failed to load user data: $e');
    // }
  }

  bool isLoading = false;
  Future<void> _saveUserData() async {
    setState(() {
      isLoading = true;
    });
    final userDetails = {
      // 'firstName': 'Nick',
      // 'lastName': 'Vlacic',
      'sex': genderOptions.indexOf(selectedGender!),
      'dob': selectedDate!.toIso8601String(),
      'weight': int.parse(selectedWeight!.split(' ')[0]),
      'height': int.parse(selectedHeight!.replaceAll('\'', '').replaceAll("\"", "")),
      'location': selectedLocation,
      'mygoal': selectedGoal,
      'avatarUrl': _imageUrl ?? '',
      'country': locationProvider.selectedCountry,
      'state': locationProvider.selectedState,
      'city': locationProvider.selectedCity
    };
    if (kDebugMode) {
      print('HERE IS USERDETAIL##, $userDetails');
    }

    if (_id != null) {
      await userData!.updateUserInfo(_id!, userDetails, image);
      setState(() {
        isLoading = false;
      });
    } else {
      if (kDebugMode) {
        print("Error: User ID is null");
      }
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
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
                        SizedBox(
                          height: media.height / 1.5,
                          width: media.width,
                          child: SafeArea(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    right: ScreenUtil.horizontalScale(3),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      BackArrowWidget(onPress: () => {Navigator.pop(context)}),
                                      const CommonStreakWithNotification()
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil.horizontalScale(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Consumer<UserDataProvider>(
                                        builder: (context, userData, child) => userData.userName != ""
                                            ? ProfileImageWidget(
                                                avatarUrl:
                                                    userData.userData['detail'] != null && userData.userData['detail']['avatarUrl'] != ""
                                                        ? userData.userData['detail']['avatarUrl']
                                                        : "",
                                                name: userData.userName,
                                                callBack: (pickedImage) {
                                                  image = pickedImage!;
                                                  setState(() {});
                                                },
                                                showPickImageButton: true,
                                              )
                                            : const SizedBox(),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil.horizontalScale(5),
                                      ),
                                      Consumer<UserDataProvider>(
                                        builder: (context, userData, child) => userData.userName != ""
                                            ? Text(
                                                // 'Hi, Nick',
                                                '${userData.userName}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil.horizontalScale(8),
                                                  fontWeight: FontWeight.bold,
                                                  height: 1,
                                                ),
                                              )
                                            : const SizedBox(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.height / 2.64,
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
                    top: media.height / 2.65,
                    bottom: ScreenUtil.verticalScale(15),
                  ),
                  child: Container(
                    width: media.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil.verticalScale(6)),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileField(
                          context: context,
                          label: 'Birthday',
                          value: selectedDate != null ? DateFormat('MM/dd/yyyy').format(selectedDate!) : 'Select Birthday',
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(1998, 9, 21),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null && pickedDate != selectedDate) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                        ),
                        _buildDropdownField(
                          context: context,
                          label: 'Gender',
                          value: selectedGender,
                          options: genderOptions,
                          hint: 'Female',
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGender = newValue!;
                            });
                          },
                        ),
                        _buildDropdownField(
                          context: context,
                          label: 'My Goals',
                          value: selectedGoal,
                          options: goalsOptions,
                          hint: 'Goals',
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGoal = newValue!;
                            });
                          },
                        ),
                        Consumer<LocationProvider>(
                          builder: (context, value, child) => Column(
                            children: [
                              _buildDropdownField(
                                context: context,
                                label: 'Country',
                                value: value.selectedCountry,
                                options: value.country.map((e) => e.countryName).toList(),
                                hint: 'Country',
                                onChanged: value.onCountrySelect,
                              ),
                              _buildDropdownField(
                                context: context,
                                label: 'State',
                                value: value.selectedState,
                                options: value.states.map((e) => e.stateName).toList(),
                                hint: 'State',
                                onChanged: value.onStateSelect,
                              ),
                              _buildDropdownField(
                                context: context,
                                label: 'City',
                                value: value.selectedCity,
                                options: value.cities.map((e) => e.cityName).toList(),
                                hint: 'City',
                                onChanged: value.onCitySelect,
                              ),
                            ],
                          ),
                        ),
                        // _buildDropdownField(
                        //   context: context,
                        //   label: 'Location',
                        //   value: selectedLocation,
                        //   options: locationOptions,
                        //   hint: 'Location',
                        //   onChanged: (String? newValue) {
                        //     setState(() {
                        //       selectedLocation = newValue!;
                        //     });
                        //   },
                        // ),
                        _buildDropdownField(
                          context: context,
                          label: 'Height',
                          value: selectedHeight,
                          options: heightOptions,
                          hint: '6\'0"',
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedHeight = newValue!;
                            });
                          },
                        ),
                        _buildDropdownField(
                          context: context,
                          label: 'Weight',
                          value: selectedWeight,
                          options: weightOptions,
                          hint: '81 lbs',
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedWeight = newValue!;
                            });
                          },
                        ),
                        isLoading == true
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: ScreenUtil.verticalScale(4)),
                                child: const Center(
                                    child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                )),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: ScreenUtil.verticalScale(4),
                                  horizontal: ScreenUtil.horizontalScale(10),
                                ),
                                child: ButtonWidget(
                                  text: "Save",
                                  textColor: Colors.white,
                                  onPress: _saveUserData,
                                  color: AppColors.primaryColor,
                                  isLoading: false,
                                ),
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

// Profile Field for Birthday and Other Text Inputs
  Widget _buildProfileField({
    required BuildContext context,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: ScreenUtil.horizontalScale(12),
        right: ScreenUtil.horizontalScale(12),
        bottom: ScreenUtil.verticalScale(0.8),
        top: ScreenUtil.verticalScale(3.5),
      ),
      height: ScreenUtil.verticalScale(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil.horizontalScale(1),
                ),
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
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  // Center the text
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: (value == 'Select Birthday') ? FontWeight.normal : FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, // Align the text at the center
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Dropdown Field for Gender, Location, etc.
  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required String? value,
    required List<String> options,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil.horizontalScale(12), vertical: ScreenUtil.verticalScale(0.8)),
      height: ScreenUtil.verticalScale(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil.horizontalScale(1),
              ),
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
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                // Center the dropdown content
                child: DropdownButton<String>(
                  value: value,
                  dropdownColor: const Color.fromARGB(255, 252, 252, 252),
                  elevation: 12,
                  hint: Text(hint),
                  isDense: true,
                  isExpanded: true,
                  alignment: Alignment.center,
                  // Align the dropdown text to the center
                  items: options.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(
                        // Center the individual items in dropdown
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                  onChanged: onChanged,
                  underline: Container(),
                ),

                // DropdownButton<String>(
                //   value: value,
                //   hint: Text(hint),
                //   isExpanded: true,
                //   alignment: Alignment.center, // Align the dropdown text to the center
                //   items: options.map((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Center(
                //         // Center the individual items in dropdown
                //         child: Text(value),
                //       ),
                //     );
                //   }).toList(),
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       value = newValue;
                //     });
                //   },
                //   underline: Container(),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
