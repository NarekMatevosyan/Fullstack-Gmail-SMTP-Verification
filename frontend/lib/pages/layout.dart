import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Stack(
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
                          image: AssetImage('assets/imgback.jpg'),
                          fit: BoxFit.cover,
                          opacity: 1,
                        ),
                      ),
                    ),
                    Container(
                      height: media.height / 2.6,
                      width: media.width,
                    ),
                    Positioned(
                      bottom: media.height * 0.07,
                      right: 0,
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
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: media.height / 3.2),
              child: Container(
                width: media.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70),
                  ),
                ),
                child: const Column(
                  children: [
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
