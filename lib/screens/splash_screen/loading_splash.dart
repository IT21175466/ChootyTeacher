import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/authentication/login_provider.dart';

class LoadingSplash extends StatefulWidget {
  final String id;
  const LoadingSplash({
    super.key,
    required this.id,
  });

  @override
  State<LoadingSplash> createState() => _LoadingSplashState();
}

class _LoadingSplashState extends State<LoadingSplash> {
  @override
  void initState() {
    super.initState();
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    loginProvider.checkUserIsSignUp(widget.id, context);
    print(widget.id);
    loginProvider.getUserName(widget.id);
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
              'Loading infomation.....',
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
