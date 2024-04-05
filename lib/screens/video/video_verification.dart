import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreanlms/constants/app_colors.dart';
import 'package:koreanlms/screens/video/play_video.dart';
import 'package:koreanlms/widgets/button_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoVerificationScreen extends StatefulWidget {
  final String userID;
  final String msgCode;
  final String link;
  final String title;
  final String teacher;
  final String zoomLink;
  const VideoVerificationScreen({
    super.key,
    required this.msgCode,
    required this.link,
    required this.title,
    required this.teacher,
    required this.zoomLink,
    required this.userID,
  });

  @override
  State<VideoVerificationScreen> createState() =>
      _VideoVerificationScreenState();
}

class _VideoVerificationScreenState extends State<VideoVerificationScreen> {
  final TextEditingController otpController = TextEditingController();

  // @override
  // void initState() {
  //   SystemChrome.setEnabledSystemUIMode(
  //     SystemUiMode.manual,
  //     overlays: [
  //       SystemUiOverlay.top,
  //       SystemUiOverlay.bottom,
  //     ],
  //   );
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Video Verification',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: screenWidth,
        height: screenHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "We have send an OTP to your number",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
            // SizedBox(
            //   height: 2,
            // ),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     widget.phoneNumber,
            //     style: TextStyle(
            //       fontFamily: 'Poppins',
            //       fontWeight: FontWeight.w600,
            //       fontSize: 15,
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 30,
            ),
            Pinput(
              controller: otpController,
              length: 6,
              defaultPinTheme: PinTheme(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.grayColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                if (otpController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please Enter OTP Code!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  if (otpController.text == widget.msgCode) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayVideoScreen(
                          link: '${YoutubePlayer.convertUrlToId(widget.link)}',
                          title: widget.title,
                          teacher: widget.teacher,
                          zoomLink: widget.zoomLink,
                          userID: widget.userID,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Verification Failed!',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: CustomButton(
                text: 'Verify',
                height: 50,
                width: screenWidth,
                backgroundColor: Colors.green,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
