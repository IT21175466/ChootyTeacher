import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:koreanlms/models/student.dart';
import 'package:koreanlms/screens/authentication/otp_screen/otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignUPProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;

  TextEditingController brithdayController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String selectedDate = '';
  final countryPicker = const FlCountryCodePicker();
  CountryCode? countryCode;
  bool loading = false;
  bool isSucess = false;

  Future<void> selectBirthDay(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );

    if (picked != null && picked != DateTime.now()) {
      brithdayController.text = DateFormat.yMMMMd().format(picked);
      notifyListeners();
    }
  }

  selectCountry(BuildContext context) async {
    countryCode = await countryPicker.showPicker(
      pickerMinHeight: 30,
      context: context,
    );
    notifyListeners();
  }

  Future<void> getVerificationCode(
      BuildContext context, String? phone, int? code) async {
    String Url =
        'http://send.ozonedesk.com/api/v2/send.php?user_id=105281&api_key=evj05adndinxxahxh&sender_id=LocalSEO.lk&to=${phone}&message=Your verification code is ${code}';

    try {
      loading = true;
      notifyListeners();
      var response = await http.get(
        Uri.parse(Url),
      );
      if (response.statusCode == 200) {
        loading = false;
        isSucess = true;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Verification Code Sent',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              mobileNumber:
                  (countryCode?.dialCode ?? '') + phoneController.text,
              verificationID: code!,
            ),
          ),
        );
      } else {
        loading = false;
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please try again later!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // verifyPhoneNumber(String phone, BuildContext context) async {
  //   try {
  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
  //       verificationFailed: (FirebaseAuthException ex) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(ex.message.toString()),
  //           ),
  //         );
  //         print(ex.message.toString());
  //         loading = false;
  //         notifyListeners();
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => OTPScreen(
  //               mobileNumber: (countryCode?.dialCode ?? '') +
  //                   (' ') +
  //                   phoneController.text,
  //               verificationID: verificationId,
  //             ),
  //           ),
  //         );
  //         loading = false;
  //         notifyListeners();
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {},
  //       phoneNumber: countryCode!.dialCode + phone,
  //     );
  //     notifyListeners();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  addStudentToFirebase(
      Student student, BuildContext context, String uID) async {
    try {
      db
          .collection("Students")
          .doc(uID)
          .set(student.toJson())
          .then((value) async {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('logedIn', true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("User Registration Success!"),
          ),
        );

        loading = false;
        Navigator.pushReplacementNamed(context, '/home');
        notifyListeners();
      });
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      notifyListeners();
    }
  }
}
