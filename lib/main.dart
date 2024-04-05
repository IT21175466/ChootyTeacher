import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:koreanlms/constants/primary_colors.dart';
import 'package:koreanlms/firebase_options.dart';
import 'package:koreanlms/providers/authentication/login_provider.dart';
import 'package:koreanlms/providers/authentication/otp_provider.dart';
import 'package:koreanlms/providers/authentication/signup_provider.dart';
import 'package:koreanlms/providers/home/bottomnavbar_provider.dart';
import 'package:koreanlms/providers/app_data/app_data_provider.dart';
import 'package:koreanlms/providers/mobile_validation/phone_validation_provider.dart';
import 'package:koreanlms/providers/notification_provider.dart/nnotification_provider.dart';
import 'package:koreanlms/providers/quiz/quiz_provider.dart';
import 'package:koreanlms/providers/student_provider/student_provider.dart';
import 'package:koreanlms/providers/video/video_provider.dart';
import 'package:koreanlms/repositories/firebase_api.dart';
import 'package:koreanlms/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'chooty-teacher',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();

  // final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // analytics.setAnalyticsCollectionEnabled(true);

  final prefs = await SharedPreferences.getInstance();
  final loginStatus = prefs.getBool('logedIn') ?? false;

  runApp(MyApp(loginStatus: loginStatus));
  WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  });
}

class MyApp extends StatelessWidget {
  final bool loginStatus;
  const MyApp({super.key, required this.loginStatus});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PhoneValidationProvider()),
        ChangeNotifierProvider(create: (context) => SignUPProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavBarProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => OTPProvider()),
        ChangeNotifierProvider(create: (context) => AppDataProvider()),
        ChangeNotifierProvider(create: (context) => StudentProvider()),
        ChangeNotifierProvider(create: (context) => VideoProvider()),
        ChangeNotifierProvider(create: (context) => QuizProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: primary,
        ),
        //home: QuizTab(),
        navigatorKey: navigatorKey,
        initialRoute: loginStatus ? '/initsplash' : '/loginsplash',
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
