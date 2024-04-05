import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  String? studentID;

  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('notifications');

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');

    initPushNotification();
  }

  void handleMessage(
    RemoteMessage? message,
  ) {
    if (message == null) {
    } else {
      storeMessage(message);
    }
  }

  Future initPushNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  storeMessage(RemoteMessage message) async {
    await getStudentID();
    databaseReference.child(studentID!).child(generateRandomId()).set({
      "studentID": studentID,
      "title": message.notification!.title.toString(),
      "body": message.notification!.body.toString(),
      "data": message.data.toString(),
    });
  }

  String generateRandomId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  getStudentID() async {
    final prefs = await SharedPreferences.getInstance();

    studentID = prefs.getString('userID');
  }
}
