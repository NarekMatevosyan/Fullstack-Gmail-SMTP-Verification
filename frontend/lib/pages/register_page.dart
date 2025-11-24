// ignore_for_file: use_build_context_synchronously

import 'package:bbb/components/app_alert_dialog.dart';
import 'package:bbb/components/app_text_form_field.dart';
import 'package:bbb/components/back_arrow_widget.dart';
import 'package:bbb/components/button_widget.dart';
import 'package:bbb/pages/email_verification_page.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/app_constants.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  bool isObscure = true;
  bool isLoading = false;

  registerUser(String emailAddress, String password) async {
    try {
      setState(() {
        isLoading = true;
      });
      // final credentials =
      //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //   email: emailAddress,
      //   password: password,
      // );

      AddUserDetailInfo(emailController.text);

      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => EmailVerificationScreen(email: emailController.text)));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AppAlertDialog(
                title: "",
                description:
                    "An account with this email already exists.\nPlease log in instead.",
              );
            });
      }
      // Optionally show an error message to the user
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future AddUserDetailInfo(String email) async {
    final Map<String, String> bodyParams = {
      'email': email,
    };

    Uri url = Uri.parse('${AppConstants.serverUrl}/api/users/register_user');
    url = Uri.http(url.authority, url.path);

    String? userIdToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    final response = await http.post(
      url,
      headers: <String, String>{
        'FIREBASE_AUTH_TOKEN': userIdToken!,
      },
      body: bodyParams,
    );

    if (response.statusCode == 200) {
      print("Succesfully added user data");
    } else {
      throw Exception('Failed to create user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(), 
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: media.height / 3.49,
                width: media.width,
                child: Stack(
                  children: [
                    Container(
                      width: media.width,
                      height: media.height / 2.42,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    BackArrowWidget(onPress: () => {Navigator.pop(context)}),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ClipPath(
                        clipper: DiagonalClipper(),
                        child: Container(
                          height: 70,
                          width: 60,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    width: media.width,
                    height: media.height,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Container(
                    height: media.height,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                        ),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          const Text(
                            'Create an account',
                            style: TextStyle(
                              fontSize: 22,
                              color: Color(0xff9A354E),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextFormField(
                            hintText: 'Email Address',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {},
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Please, Enter Email Address'
                                  : AppConstants.emailRegex.hasMatch(value)
                                      ? null
                                      : 'Invalid Email Address';
                            },
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
                            hintText: 'Password',
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {},
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Please, Enter Password'
                                  : value.length <= 5
                                      ? 'Password length must be greater than 6'
                                      : null;
                              //: AppConstants.passwordRegex.hasMatch(value)
                              //    ? null
                              //    : 'Invalid Password';
                            },
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
                          AppTextFormField(
                            hintText: 'Confirm Password',
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {},
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Please, Confirm Password'
                                  : passwordController.text == value
                                      ? null
                                      : 'Password Does not Match';
                              //: AppConstants.passwordRegex.hasMatch(value)
                              //    ? null
                              //    : 'Invalid Password';
                            },
                            controller: confirmPasswordController,
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
                          AppTextFormField(
                            hintText: 'Phone Number',
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {},
                            // validator: (value) {
                            //   return value!.isEmpty
                            //       ? 'Please enter Phone Number'
                            //       : null;
                            // },
                            controller: phoneController,
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
                          const SizedBox(
                            height: 40,
                          ),
                          ButtonWidget(
                            text: 'Create an Account',
                            textColor: Colors.white,
                            color: const Color(0xff9A354E),
                            onPress: () => {
                              if (_formKey.currentState?.validate() == true)
                                {
                                  registerUser(
                                    emailController.text,
                                    passwordController.text,
                                  )
                                }
                            },
                            isLoading: isLoading,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
