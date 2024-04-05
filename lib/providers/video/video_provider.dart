import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koreanlms/models/video.dart';

class VideoProvider extends ChangeNotifier {
  bool noBatch = false;
  bool paymentDone = false;
  String batch = '';
  String sClass = '';
  String payment = '';
  bool isLoading = false;

  String teacherName = '';
  String title = '';

  //List<String> videoDocumentIDs = [];

  List<String> watchedVideos = [];

  List<Video> videos = [];
  List<Video> lockedVideos = [];

  checkUserInBatch(String sID) async {
    try {
      final DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection("Students")
          .doc(sID)
          .get();

      //Get All Data
      batch = studentDoc.get('Batch');
      sClass = studentDoc.get('Student_Class');
      payment = studentDoc.get('Payment');

      print(batch);
      print(sClass);
      print(payment);

      //Check Batch
      if (batch == 'no_batch' || sClass == 'no_class') {
        noBatch = true;
        notifyListeners();
      } else {
        noBatch = false;
        notifyListeners();

        //Check Payment
        if (payment == 'not_yet') {
          paymentDone = false;
          print('Not yet payment');
          notifyListeners();
        } else {
          getVideos();
          paymentDone = true;
          notifyListeners();
        }
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      // isLoading = false;
      // notifyListeners();
    }
  }

  Future<void> getVideos() async {
    try {
      final QuerySnapshot videoQuerySnapshot = await FirebaseFirestore.instance
          .collection("Batches")
          .doc(batch)
          .collection("Classes")
          .doc(sClass)
          .collection("Videos")
          .get();

      videos.clear();
      lockedVideos.clear();

      for (QueryDocumentSnapshot videoDoc in videoQuerySnapshot.docs) {
        String title = videoDoc['Title'];
        String teacher = videoDoc['Teacher_Name'];
        String paymentTerm = videoDoc['Payment_term'];
        String link = videoDoc['Video_link'];
        String zoomLink = videoDoc['zoomLink'];

        Video video = Video(
          paymentTerm: paymentTerm,
          link: link,
          title: title,
          teacher: teacher,
          zoomLink: zoomLink,
        );

        if (payment.contains(paymentTerm)) {
          videos.add(video);
        } else {
          lockedVideos.add(video);
        }
      }

      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      videos.addAll(lockedVideos);
    }
  }
}
