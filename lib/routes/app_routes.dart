import 'package:flutter/material.dart';
import 'package:koreanlms/screens/authentication/login_screen/login_page.dart';
import 'package:koreanlms/screens/authentication/signup_screen/signup_screen.dart';
import 'package:koreanlms/screens/home_screen/home_screen.dart';
import 'package:koreanlms/screens/splash_screen/initial_splash.dart';
import 'package:koreanlms/screens/splash_screen/login_splash.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/initsplash': (context) => InitialSplash(),
      '/login': (context) => LoginScreen(),
      '/loginsplash': (context) => LoginSplash(),
      '/signup': (context) => SignUPScreen(),
      '/home': (context) => HomeScreen(),
    };
  }
}
