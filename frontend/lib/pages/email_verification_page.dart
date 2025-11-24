// ignore_for_file: use_build_context_synchronously

import 'dart:async';
// import 'package:bbb/components/app_alert_dialog.dart';
import 'package:bbb/components/button_widget.dart';
import 'package:bbb/pages/main_page.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key, this.email});

  final String? email;

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    sendVerificationMail();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  void sendVerificationMail()async{
    Uri url = Uri.parse('${AppConstants.serverUrl}/api/users/send_verification_mail');

    url = Uri.http(url.authority, url.path);

    await http.post(
      url,
      body: {
        'email': widget.email,
      },
    );
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color((0xff9A354E)),
          content: Text(
            "Email Verified Successfully",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      );
  }

  resendVerificationEmail() async {
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: size.height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.zero,
        color: Color.fromRGBO(0, 0, 0, 0.98),
        // Image set to background of the body
      ),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          const SizedBox(height: 40),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'CHECK ',
                style: GoogleFonts.bebasNeue(
                    color: const Color.fromARGB(255, 73, 14, 29), fontSize: 48),
              ),
              Text(
                'YOUR EMAIL',
                style: GoogleFonts.bebasNeue(
                    color: AppColors.primaryColor, fontSize: 48),
              )
            ],
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: Center(
              child: Text(
                  'We have sent you a confirmation email to ${widget.email}.\nPlease verify your email to proceed.',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFC5C5C5),
                    fontSize: 16, /*fontWeight: FontWeight.w100,*/
                  )),
            ),
          ),
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
            child: ButtonWidget(
              text: "Didn't receive?  Resend. ",
              textColor: Colors.white,
              onPress: sendVerificationMail,
              color: AppColors.primaryColor,
              isLoading: false,
            ),
          )
        ],
      ),
    ));
  }
}
