import 'package:flutter/material.dart';
import 'package:koreanlms/constants/app_colors.dart';
import 'package:koreanlms/providers/app_data/app_data_provider.dart';
import 'package:provider/provider.dart';

class InitialSplash extends StatefulWidget {
  const InitialSplash({super.key});

  @override
  State<InitialSplash> createState() => _InitialSplashState();
}

class _InitialSplashState extends State<InitialSplash> {
  @override
  void initState() {
    super.initState();
    final appDataProvider =
        Provider.of<AppDataProvider>(context, listen: false);
    appDataProvider.isLoading = true;
    appDataProvider.getStudentID(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            Spacer(),
            SizedBox(
              height: 220,
              width: 220,
              child: Image.asset('assets/images/splashLogo.png'),
            ),
            SizedBox(
              height: 10,
            ),
            FittedBox(
              child: Text(
                'Chooty Teacher',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            Spacer(),
            Text(
              'By V P S Kothalawala',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: AppColors.grayColor,
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
