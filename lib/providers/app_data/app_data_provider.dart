import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koreanlms/screens/splash_screen/loading_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDataProvider extends ChangeNotifier {
  String? appBackgroudImage;
  String? bannerImage1;
  String? bannerImage2;
  String? bannerImage3;

  String? studentID = '';

  final images = [];

  bool isLoading = false;

  getImageData() async {
    try {
      final DocumentSnapshot backImageDoc = await FirebaseFirestore.instance
          .collection("AppBackground")
          .doc('zCojuOQIG5czAQvEcsXw')
          .get();

      appBackgroudImage = backImageDoc.get('background');
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  getBannerImages(BuildContext context) async {
    try {
      final DocumentSnapshot imageDoc = await FirebaseFirestore.instance
          .collection("Banner_Images")
          .doc('TicWfNp4bI5It7mTIqt9')
          .get();

      images.add(imageDoc.get('bannerImage1'));
      images.add(imageDoc.get('bannerImage2'));
      images.add(imageDoc.get('bannerImage3'));

      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  getStudentID(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    studentID = prefs.getString('userID');
    notifyListeners();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingSplash(id: studentID!),
        ),
      ),
    );
    notifyListeners();
  }
}
