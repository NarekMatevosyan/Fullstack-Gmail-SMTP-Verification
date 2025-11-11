import 'package:flutter/material.dart';

class SplashIntroPage extends StatelessWidget {
  const SplashIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/img/splash.png',
                ), // Add your image asset here
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
