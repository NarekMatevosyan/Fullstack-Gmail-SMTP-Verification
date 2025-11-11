import 'dart:async';

import 'package:bbb/components/button_widget.dart';
import 'package:bbb/providers/data_provider.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

class VideoIntroWidget extends StatefulWidget {
  final String vimeoId;

  const VideoIntroWidget({super.key, required this.vimeoId});

  @override
  _VideoIntroWidgetState createState() => _VideoIntroWidgetState();
}

class _VideoIntroWidgetState extends State<VideoIntroWidget> {
  bool loading = false;
  bool videoNotInitialized = false;
  String tutorialDesc = "";
  DataProvider? dataProvider;
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  late Size videoSize;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    dataProvider = Provider.of<DataProvider>(context, listen: false);
    fetchTutorialData();
    super.initState();
  }

  void fetchTutorialData()async{
    setState(() {
      loading = true;
    });
    await dataProvider?.fetchTutorialData();
    if( dataProvider!.tutorialData.files.isNotEmpty){
      initializeVideo(dataProvider?.tutorialData.files[0]['link']);
    }else{
      loading=false;
      videoNotInitialized=true;
      setState(() {
      });
    }

    tutorialDesc = dataProvider?.tutorialData.description ?? "";
  }

  Future<void> initializeVideo(String url) async {
    try {
      // Initialize the video player controller
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
      await _videoPlayerController.initialize();

      // Initialize the ChewieController with custom controls
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        showControls: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        // Disable default controls// Use custom controls here
      );

      if(_chewieController != null &&
          _chewieController!.videoPlayerController.value.isInitialized){
        hideControls();
        videoSize = calculateVideoSize(aspectRatio: _chewieController!.aspectRatio!,context: context);
        setState(() {
        });
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        videoNotInitialized = true;
        loading = false;
      });
      debugPrint("VIDEO NOT INITIALIZED: $e");
    }
  }

  bool showControls = true;
  bool isFullscreen = false;

  void hideControls() {
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        showControls = false;
      });
    });
  }

  void showControlsOnTap() {
    setState(() {
      showControls = !showControls;
    });
    _hideControlsTimer?.cancel(); // Cancel any active timer
    // hideControls(); // Start the timer again to hide the controls after 3 seconds
  }


  void toggleFullscreen() {
    setState(() {
      isFullscreen = !isFullscreen;
    });
    if (isFullscreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }
  }


  Size calculateVideoSize({
    required BuildContext context,
    required double aspectRatio, // Aspect ratio of the video (width/height)
  }) {
    // Maximum allowable width and height based on screen dimensions
    double maxWidth = ScreenUtil.horizontalScale(100);
    double maxHeight = ScreenUtil.verticalScale(70);

    // Calculate height dynamically based on width and aspect ratio
    double calculatedHeight = maxWidth / aspectRatio;

    // If calculated height exceeds maxHeight, adjust width instead
    if (calculatedHeight > maxHeight) {
      calculatedHeight = maxHeight;
      maxWidth = maxHeight * aspectRatio;
    }

    return Size(maxWidth, calculatedHeight);
  }

  @override
  void dispose() {
    _chewieController!.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: loading 
      ? const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        )
      : Column(
        children: [
          SizedBox(height: ScreenUtil.verticalScale(5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: ScreenUtil.horizontalScale(3),),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
          Expanded(child: Container()),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  showControlsOnTap();
                },
                child: Container(
                  color: Colors.black,
                  child: Column(
                    children: [
                      dataProvider!.tutorialData.files.isNotEmpty && !videoNotInitialized
                      ? SizedBox(
                          height: videoSize.height,
                          width: videoSize.width,
                          child: Chewie(
                            controller: _chewieController!,
                        ),
                      )
                      : Container(
                          height: ScreenUtil.verticalScale(40),
                          color: Colors.black12,
                          child: const Center(child: Text('No Video Available',style: TextStyle(color: Colors.white),)),
                        ),
                    ],
                  ),
                ),
              ),
              
              Positioned(
                bottom: videoSize.height/2,
                left: 10,
                right: 10,
                child: Visibility(
                  visible: showControls,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Skip backward button
                      IconButton(
                        iconSize: 40,
                        icon: const Icon(
                          Icons.replay_10,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          _videoPlayerController.seekTo(
                            _videoPlayerController.value.position -
                                const Duration(seconds: 10),
                          );
                        },
                      ),
                      IconButton(
                        iconSize: 60,
                        icon: Icon(
                          _videoPlayerController.value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_videoPlayerController.value.isPlaying) {
                              _videoPlayerController.pause();
                            } else {
                              _videoPlayerController.play();
                            }
                          });
                        },
                      ),
                      // Skip forward button
                      IconButton(
                        iconSize: 40,
                        icon: const Icon(
                          Icons.forward_10,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          _videoPlayerController.seekTo(
                            _videoPlayerController.value.position +
                                const Duration(seconds: 10),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: ScreenUtil.verticalScale(1),
                left: 10,
                right: 10,
                child: !videoNotInitialized && _chewieController!.videoPlayerController.value.isInitialized == true
                  ? Container(
                      margin: EdgeInsets.only(
                          bottom: ScreenUtil.verticalScale(6),left: 20,right: 20),
                      child: Row(
                        children: [

                          Flexible(
                            child: VideoProgressIndicator(
                              _videoPlayerController,
                              allowScrubbing: true,
                              colors:  const VideoProgressColors(
                                playedColor: Colors.red,
                                bufferedColor: Colors.white,
                                backgroundColor: Colors.black26,
                              ),
                            ),
                          ),
                        ],
                      ))
                  : const SizedBox(),
              ),
            ],
          ),
  
          Expanded(child: Container()),
          // Button at the bottom
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil.verticalScale(2),
              bottom: ScreenUtil.verticalScale(3),
              left: ScreenUtil.horizontalScale(10),
              right: ScreenUtil.horizontalScale(10),
            ),
            child: ButtonWidget(
              text: "Continue Working Out",
              textColor: Colors.white,
              onPress: () {
                Navigator.pop(context);
              },
              color: AppColors.primaryColor,
              isLoading: false,
            ),
          ),
        ],
      ),
    );
  }
}
