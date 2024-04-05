import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:koreanlms/models/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  List<AppNotification> notifications = [];
  List<String> notificationList = [];
  String? studentID = '';

  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('notifications');

  void listnToNotifications() async {
    await getStudentID();
    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic>? values = dataSnapshot.value as Map?;

      if (values != null) {
        values.forEach((key, notificationData) {
          if (key == studentID) {
            notifications.clear();
            notifyListeners();
            databaseReference.onValue.listen((event2) {
              DataSnapshot dataSnapshot2 = event2.snapshot.child(key);
              Map<dynamic, dynamic>? values2 = dataSnapshot2.value as Map?;

              if (values2 != null) {
                if (notificationList.isNotEmpty) {
                  notifications.clear();
                  notifyListeners();
                } else {
                  values2.forEach((key2, notificationData2) {
                    print('Key2: $key2');

                    // AppNotification notification = AppNotification(
                    //   title: notificationData2['title'].toString(),
                    //   body: notificationData2['body'].toString(),
                    // );
                    // notifications.add(notification);
                    notificationList.add(key2);
                    notifyListeners();
                  });
                }

                print(notificationList);
              }
            });
          }

          print('Key: $key');
        });
      } else {}
    });
  }

  getStudentID() async {
    final prefs = await SharedPreferences.getInstance();

    studentID = prefs.getString('userID');
    notifyListeners();
  }
}
