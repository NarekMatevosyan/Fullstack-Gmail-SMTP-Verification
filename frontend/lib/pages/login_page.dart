import 'dart:convert';

import 'package:bbb/components/app_text_form_field.dart';
import 'package:bbb/components/back_arrow_widget.dart';
import 'package:bbb/components/button_widget.dart';
// import 'package:bbb/pages/email_verification_page.dart';
import 'package:bbb/pages/main_page.dart';
import 'package:bbb/pages/reset_password_page.dart';
import 'package:bbb/providers/main_page_provider.dart';
import 'package:bbb/providers/user_data_provider.dart';
// import 'package:bbb/values/app_constants.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/app_constants.dart';
import 'package:bbb/values/clip_path.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this for shared preferences

class LoginPage extends StatefulWidget {
  final String image;

  const LoginPage({super.key, required this.image});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isObscure = true;
  bool isLoading = false;

  String image = '';

  late MainPageProvider mainPageProvider;

  @override
  void initState() {
    super.initState();

    mainPageProvider = Provider.of<MainPageProvider>(context, listen: false);

    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.image == "") {
      image = prefs.getString("login_image") ?? '';
    } else {
      image = widget.image;
    }

    setState(() {});
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MainPage(
                  welcomeDescription: '',
                  welcomeImageUrl: '',
                )),
      );
    } else {
      debugPrint("----TESTING BOTTOM INDEX IS 0");
      try {
        UserDataProvider userData;
        userData = Provider.of<UserDataProvider>(
          context,
          listen: false,
        );
        mainPageProvider.changeTab(0);
      } catch (e) {
        debugPrint(
            "----TESTING BOTTOM INDEX IS 0 ----Error in indexing login_page");
      }
    }
  }

  Future<void> _saveLoginState(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  void signInUser(String emailAddress, String password) async {
    if (emailAddress.isEmpty || password.isEmpty) {
      showBottomAlert(context, 'Please fill out the inputs');
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });

      final url = Uri.parse(
          'https://bbbdev1.wpenginepowered.com/wp-json/jwt-auth/v1/token');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          'username': emailAddress,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveLoginState(true);
        String token = data['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);

        // Fetch additional data for the welcome modal
        final descriptionResponse = await http.get(
          Uri.parse(
              '${AppConstants.serverUrl}/api/screens/get_screens'), // replace with actual endpoint
          headers: {"Authorization": "Bearer $token"},
        );

        if (descriptionResponse.statusCode == 200) {
          final descriptionData = json.decode(descriptionResponse.body);

          // Check if the welcome modal has been shown
          bool hasSeenWelcome = prefs.getBool('hasSeenWelcome') ?? false;

          // Navigate to MainPage, passing the welcome data if modal should be shown
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(
                showWelcomeModal: !hasSeenWelcome,
                welcomeDescription: descriptionData['description'] ?? "",
                welcomeImageUrl:
                    descriptionData['vimeoId'], // pass fetched description
              ),
            ),
          );
        } else {
          // Handle error if fetching description fails
          showBottomAlert(context, 'Failed to load description');
          debugPrint('this is login page ${descriptionResponse.statusCode}');
        }
      } else {
        showBottomAlert(context, 'Login failed');
      }
    } catch (e) {
      showBottomAlert(context, 'An error occurred');
      debugPrint('this is login page $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: media.height / 1.6,
                  width: media.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: image.isNotEmpty
                          ? NetworkImage(
                              image.startsWith(
                                      'https://storage.cloud.google.com/')
                                  ? image.replaceFirst(
                                      'https://storage.cloud.google.com/',
                                      'https://storage.googleapis.com/')
                                  : image,
                            )
                          : const AssetImage('assets/img/card.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: SafeArea(
                          child: BackArrowWidget(onPress: () {
                            Navigator.pop(context);
                          }),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: ScreenUtil.horizontalScale(15)),
                          height: media.height / 7,
                          width: media.width,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/img/bbb-logo.png'),
                                fit: BoxFit.fitHeight,
                                opacity: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
                bottom: -1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipPath(
                      clipper: DiagonalClipper(),
                      child: Container(
                        height: media.height / 9.8,
                        width: media.width / 6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: media.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil.verticalScale(4.4)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: ScreenUtil.verticalScale(5),
                            ),
                            const Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 26,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil.verticalScale(1.7),
                            ),
                            AppTextFormField(
                              hintText: 'Your Email',
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {},
                              // validator: (value) {
                              //   return value!.isEmpty
                              //       ? 'Please, Enter Email Address'
                              //       : AppConstants.emailRegex.hasMatch(value)
                              //           ? null
                              //           : 'Invalid Email Address';
                              // },
                              controller: emailController,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: IconButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    minimumSize: WidgetStateProperty.all(
                                      const Size(48, 48),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.person,
                                    color: Color(0XFFd9d9d9),
                                  ),
                                ),
                              ),
                            ),
                            AppTextFormField(
                              hintText: 'Your Password',
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              onChanged: (value) {},
                              // validator: (value) {
                              //   return value!.isEmpty
                              //       ? 'Please, Enter Password'
                              //       : value.length <= 5
                              //           ? 'Password length must be greater than 6'
                              //           : null;
                              // },
                              controller: passwordController,
                              obscureText: isObscure,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  },
                                  style: ButtonStyle(
                                    minimumSize: WidgetStateProperty.all(
                                      const Size(48, 48),
                                    ),
                                  ),
                                  icon: Icon(
                                    isObscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: const Color(0XFFd9d9d9),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil.verticalScale(0.8),
                            ),
                            Text.rich(TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFFA51E22),
                                  ),
                                  text: "Forgot",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              const ResetPasswordScreen(),
                                        ),
                                      );
                                    },
                                ),
                                const TextSpan(
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF848484)),
                                  text: " password?",
                                ),
                              ],
                            )),
                            SizedBox(
                              height: ScreenUtil.horizontalScale(5.948),
                            ),
                            ButtonWidget(
                              text: 'Sign in',
                              textColor: Colors.white,
                              color: AppColors.primaryColor,
                              onPress: () {
                                if (_formKey.currentState?.validate() == true) {
                                  signInUser(
                                    emailController.text,
                                    passwordController.text,
                                  );
                                }
                              },
                              isLoading: isLoading,
                            ),
                            SizedBox(
                              height: ScreenUtil.horizontalScale(14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

void showBottomAlert(BuildContext context, String msg) {
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 20.0,
      left: MediaQuery.of(context).size.width * 0.1,
      right: MediaQuery.of(context).size.width * 0.1,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              msg,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);

  // Remove the alert after 3 seconds
  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}
