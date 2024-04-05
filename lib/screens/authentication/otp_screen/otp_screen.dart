import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreanlms/constants/app_colors.dart';
import 'package:koreanlms/providers/authentication/otp_provider.dart';
import 'package:koreanlms/screens/splash_screen/phone_check_splash.dart';
import 'package:koreanlms/widgets/button_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;
  final int verificationID;
  const OTPScreen(
      {super.key, required this.mobileNumber, required this.verificationID});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();

  String uuid = '';
  String? stdID = '';

  @override
  void initState() {
    super.initState();
    getStudentID();
  }

  generateNewUuid() {
    setState(() {
      uuid = Uuid().v4();
    });
  }

  getStudentID() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      stdID = prefs.getString('userID');
    });
  }

  Future<void> setUserID(String uID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userID', uID);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Phone Verification',
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
        child: Consumer(
          builder:
              (BuildContext context, OTPProvider otpProvider, Widget? child) =>
                  Column(
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
              SizedBox(
                height: 2,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.mobileNumber,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
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
                onTap: () async {
                  if (otpController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter OTP"),
                      ),
                    );
                  } else {
                    if (otpController.text ==
                        widget.verificationID.toString()) {
                      try {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PhoneCheckSplash(phone: widget.mobileNumber),
                          ),
                        );
                        // if (stdID == null) {
                        //   await generateNewUuid();
                        //   await setUserID(uuid);
                        //   print(uuid);
                        //   final prefs = await SharedPreferences.getInstance();
                        //   prefs.setBool('logedIn', true);

                        //   Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => LoadingSplash(
                        //         id: uuid,
                        //       ),
                        //     ),
                        //   );
                        // } else {
                        //   final prefs = await SharedPreferences.getInstance();
                        //   prefs.setBool('logedIn', true);
                        //   print(stdID);
                        //   Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => LoadingSplash(
                        //         id: stdID!,
                        //       ),
                        //     ),
                        //   );
                        // }
                      } catch (e) {
                        print(e);
                      }
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
                child: otpProvider.loading
                    ? Container(
                        height: 50,
                        width: screenWidth,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : CustomButton(
                        text: 'Verify',
                        height: 50,
                        width: screenWidth,
                        backgroundColor: Colors.green,
                      ),
              ),
              Spacer(),
              Spacer(),
              Spacer(),
              // SizedBox(
              //   height: 70,
              //   width: 70,
              //   child: Image.asset('assets/images/icon.png'),
              // ),
              SizedBox(
                height: Platform.isIOS ? 60 : 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
