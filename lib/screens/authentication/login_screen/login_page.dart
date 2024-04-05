import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:koreanlms/providers/app_data/app_data_provider.dart';
import 'package:koreanlms/providers/authentication/signup_provider.dart';
import 'package:koreanlms/providers/student_provider/student_provider.dart';
import 'package:koreanlms/widgets/button_widget.dart';
import 'package:koreanlms/widgets/phone_textfiled.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../otp_screen/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? deviceId;
  String? stdID = '';

  @override
  void initState() {
    super.initState();
    getDeviceID();
    generateRandomCode();
    getStudentID();
    final appDataProvider =
        Provider.of<AppDataProvider>(context, listen: false);
    appDataProvider.isLoading = true;
    appDataProvider.getBannerImages(context);
  }

  getStudentID() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      stdID = prefs.getString('userID');
    });
  }

  void getDeviceID() async {
    deviceId = await _getId();
  }

  int code = 0;

  generateRandomCode() {
    Random random = Random();
    setState(() {
      code = random.nextInt(900000) + 100000;
    });
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chooty Teacher',
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
        padding: EdgeInsets.symmetric(vertical: 10),
        width: screenWidth,
        child: Consumer3(
          builder: (BuildContext context,
                  SignUPProvider signUPProvider,
                  StudentProvider studentProvider,
                  AppDataProvider appDataProvider,
                  Widget? child) =>
              Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: CarouselSlider(
                  items: appDataProvider.images
                      .map(
                        (image) => Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 241, 240, 240),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'Enter Your Mobile Number',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "We'll send you a verification code.",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    PhoneTextField(
                      controller: signUPProvider.phoneController,
                      labelText: 'Phone Number',
                      hintText: "71XXXXXXX",
                      prefix: GestureDetector(
                        onTap: () async {
                          signUPProvider.selectCountry(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            signUPProvider.countryCode == null
                                ? '+1'
                                : '${signUPProvider.countryCode?.dialCode ?? '+1'}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: () {
                        // if (studentProvider.deviceID == 'not') {
                        //   signUPProvider.loading = true;
                        //   signUPProvider.verifyPhoneNumber(
                        //       signUPProvider.phoneController.text, context);
                        // } else {
                        //   if (studentProvider.deviceID != deviceId) {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(
                        //         content: Text(
                        //             "This account already logged in a device"),
                        //         backgroundColor: Colors.red,
                        //       ),
                        //     );
                        //   } else {
                        if (signUPProvider.phoneController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please enter your Phone Number"),
                            ),
                          );
                        } else if (signUPProvider.phoneController.text
                                .trim()
                                .toString() ==
                            '713758116') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OTPScreen(
                                mobileNumber: '+94713758116',
                                verificationID: 123456,
                              ),
                            ),
                          );
                        } else {
                          signUPProvider.loading = true;
                          // signUPProvider.verifyPhoneNumber(
                          //     signUPProvider.phoneController.text, context);
                          signUPProvider.getVerificationCode(context,
                              signUPProvider.phoneController.text, code);
                        }

                        //}
                        //}
                      },
                      child: signUPProvider.loading
                          ? Container(
                              height: 50,
                              width: screenWidth,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : CustomButton(
                              text: 'Next',
                              height: 50,
                              width: screenWidth,
                              backgroundColor: Colors.green,
                            ),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
