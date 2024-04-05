import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentProvider extends ChangeNotifier {
  String? studentID = '';
  bool isLoading = false;

  //Student
  String firstName = '...';
  String? lastName = '...';
  String? email = '...';
  String? nic = '...';
  String? phoneNum = '...';
  String? dateOfBirth = '...';
  String? batch = '...';
  String? studentClass = '...';
  String? payment = '...';
  String? registedDate = '...';
  String? deviceID = '...';

  getStudentID() async {
    final prefs = await SharedPreferences.getInstance();

    studentID = prefs.getString('userID');
    notifyListeners();
  }

  getStudentData(BuildContext context) async {
    try {
      await getStudentID();

      final DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection("Students")
          .doc(studentID)
          .get();

      firstName = studentDoc.get('FirstName');
      lastName = studentDoc.get('LastName');
      email = studentDoc.get('Email');
      nic = studentDoc.get('NIC');
      phoneNum = studentDoc.get('PhoneNumber');
      dateOfBirth = studentDoc.get('DateOfBirth');
      batch = studentDoc.get('Batch');
      studentClass = studentDoc.get('Student_Class');
      payment = studentDoc.get('Payment');
      registedDate = studentDoc.get('Registed_Date');
      deviceID = studentDoc.get('Device_ID');

      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }

  getDeviceData(BuildContext context) async {
    try {
      await getStudentID();

      final DocumentSnapshot<Map<String, dynamic>> studentDoc =
          await FirebaseFirestore.instance
              .collection("Students")
              .doc(studentID)
              .get();

      // final DocumentSnapshot studentDoc = await FirebaseFirestore.instance
      //     .collection("Students")
      //     .doc(studentID)
      //     .get();

      // deviceID = studentDoc.get('Device_ID');

      if (studentDoc.exists) {
        Map<String, dynamic>? data = studentDoc.data();
        if (data != null && data.containsKey('Device_ID')) {
          deviceID = data['Device_ID'];
          notifyListeners();
        } else {
          deviceID = 'not';
          notifyListeners();
        }
      } else {
        print('Document does not exist');
        deviceID = 'not';
        notifyListeners();
      }
    } catch (e) {
      print(e);
    } finally {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
