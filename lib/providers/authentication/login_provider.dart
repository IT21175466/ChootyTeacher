import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  String? userName = 'User';
  String? phoneNumber = '';

  checkUserIsSignUp(String userID, BuildContext context) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      //Users
      DocumentReference documentRefUsers =
          firestore.collection("Students").doc(userID);

      DocumentSnapshot docSnapshotUsers = await documentRefUsers.get();

      if (docSnapshotUsers.exists) {
        print("User document exists");
        Navigator.pushReplacementNamed(context, '/home');
        notifyListeners();
      } else {
        print("Any document does not exist");
        Navigator.pushReplacementNamed(context, '/signup');
        notifyListeners();
      }
    } catch (error) {
      print("Error checking document: $error");
    }
  }

  getUserName(String sID) async {
    try {
      final DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection("Students")
          .doc(sID)
          .get();

      userName = studentDoc.get('FirstName');
      phoneNumber = studentDoc.get('PhoneNumber');
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
