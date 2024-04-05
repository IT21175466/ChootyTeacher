import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPProvider extends ChangeNotifier {
  bool loading = false;
  bool isSignUp = false;

  String userId = '';

  // getOTPCode(String vID, String otp, BuildContext context) async {
  //   try {
  //     PhoneAuthCredential credential =
  //         await PhoneAuthProvider.credential(verificationId: vID, smsCode: otp);

  //     FirebaseAuth.instance.signInWithCredential(credential).then(
  //       (UserCredential userCredential) async {
  //         userId = await userCredential.user!.uid;
  //         print("User ID: $userId");
  //         setUserID(userId);

  //         final prefs = await SharedPreferences.getInstance();
  //         prefs.setBool('logedIn', true);

  //         notifyListeners();
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => LoadingSplash(
  //               id: userId,
  //             ),
  //           ),
  //         );
  //         loading = false;
  //         notifyListeners();
  //       },
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'invalid-verification-code') {
  //       print(
  //           'Invalid verification code. Please check and enter the correct verification code again.');
  //     } else {
  //       print('Error: ${e.message}');
  //     }
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: ${e.message}'),
  //       ),
  //     );
  //     loading = false;
  //     notifyListeners();
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(e.toString()),
  //       ),
  //     );
  //     loading = false;
  //     notifyListeners();
  //   }
  //   notifyListeners();
  // }

  checkPhoneNumberIsSignUp(BuildContext context, String phone) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore
          .collection("Students")
          .where("PhoneNumber", isEqualTo: phone)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("User document exists");

        print(querySnapshot.docs[0]['UserID']);

        await setUserID(querySnapshot.docs[0]['UserID']);
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('logedIn', true);

        Navigator.pushReplacementNamed(context, '/home');
        notifyListeners();
      } else {
        print("No document exists with the provided phone number");
        Navigator.pushReplacementNamed(context, '/signup');
        notifyListeners();
      }
    } catch (error) {
      print("Error checking document: $error");
    }
  }

  Future<void> setUserID(String uID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userID', uID);
  }
}
