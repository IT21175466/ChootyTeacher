import 'package:flutter/material.dart';
import 'package:koreanlms/providers/authentication/otp_provider.dart';
import 'package:provider/provider.dart';

class PhoneCheckSplash extends StatefulWidget {
  final String phone;
  const PhoneCheckSplash({
    super.key,
    required this.phone,
  });

  @override
  State<PhoneCheckSplash> createState() => _PhoneCheckSplashState();
}

class _PhoneCheckSplashState extends State<PhoneCheckSplash> {
  @override
  void initState() {
    super.initState();
    final otpProvider = Provider.of<OTPProvider>(context, listen: false);
    otpProvider.checkPhoneNumberIsSignUp(context, widget.phone);
    //loginProvider.getUserName(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        color: const Color.fromARGB(255, 247, 247, 247),
        child: Column(
          children: [
            Spacer(),
            SizedBox(
              height: 180,
              width: 180,
              child: Image.asset('assets/images/icon.png'),
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text(
              'Checking Phone Number.....',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
