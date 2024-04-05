import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koreanlms/models/answer.dart';
import 'package:koreanlms/models/history_quiz.dart';
import 'package:koreanlms/models/paper.dart';
import 'package:koreanlms/models/quiz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;

  bool noBatch = false;
  bool paymentDone = false;
  bool noPapers = false;

  String batch = '';
  String sClass = '';
  String payment = '';
  bool isLoading = false;

  List<Quiz> quizzes = [];
  List<Paper> papers = [];
  List<Answer> answers = [];

  List<String> selectedAnswers = [];

  bool isSelected = false;

  String coorectAnswer = '';
  String selectedAnswer = '';

  bool loading = false;

  bool timerDone = false;

  List<String> didPapers = [];

  // countCorrectAnswers() {
  //   if (coorectAnswer == selectedAnswer) {
  //     selectedAnswers.add('1');
  //     notifyListeners();
  //     print('Answer is Correct');
  //   } else if (selectedAnswer ==
  //       "Not_Selected_987123567677645495898785476584") {
  //     selectedAnswers.add('N');
  //     notifyListeners();
  //     print('Answer is Not Given');
  //   } else {
  //     selectedAnswers.add('0');
  //     notifyListeners();
  //     print('Answer is Wrong');
  //   }
  // }

  addQuizToFirebase(
      HistoryQuiz historyQuiz, BuildContext context, String uID) async {
    try {
      db
          .collection("HistoryQuizzes")
          .doc(uID)
          .collection("Quizzes")
          .doc()
          .set(historyQuiz.toJson())
          .then((value) async {
        Navigator.pop(context);
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
    } finally {
      answers = [];
      quizzes = [];
      isSelected = false;
      selectedAnswers = [];
      coorectAnswer = '';
      selectedAnswer = '';
      loading = false;
      notifyListeners();
    }
  }

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
          //getQuizzes();
          getPapers();
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

  Future<void> getPapers() async {
    FirebaseFirestore.instance
        .collection("Batches")
        .doc(batch)
        .collection("Classes")
        .doc(sClass)
        .collection("Papers")
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        noPapers = true;
        notifyListeners();
      } else {
        noPapers = false;
        querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          String documentId = documentSnapshot.id;
          Paper paper = Paper(
            paperName: documentId,
          );
          papers.add(paper);
          notifyListeners();
        });
      }
    });
  }

  String? userID = '';

  getUserID() async {
    final prefs = await SharedPreferences.getInstance();

    userID = prefs.getString('userID');
    notifyListeners();
  }

  Future<void> getQuizzes(String quizName) async {
    await getUserID();
    try {
      final QuerySnapshot quizQuerySnapshot = await FirebaseFirestore.instance
          .collection("Batches")
          .doc(batch)
          .collection("Classes")
          .doc(sClass)
          .collection("Papers")
          .doc(quizName)
          .collection("Questions")
          .get();

      for (QueryDocumentSnapshot quizDoc in quizQuerySnapshot.docs) {
        Map<String, dynamic> data = quizDoc.data() as Map<String, dynamic>;

        //String quizID = quizDoc['QuizID'];
        String question = quizDoc['Question'];
        //String paymentTerm = quizDoc['Payment_term'];
        String answer1 = quizDoc['Answer1'];
        String answer2 = quizDoc['Answer2'];
        String answer3 = quizDoc['Answer3'];
        String answer4 = quizDoc['Answer4'];
        String correctAnswer = quizDoc['CorrectAnswer'];
        int timer;
        int paperTimer;

        if (data.containsKey('Timer')) {
          timer = quizDoc['Timer'];
        } else {
          timer = 0;
        }

        if (data.containsKey('Paper_Timer')) {
          paperTimer = quizDoc['Paper_Timer'];
        } else {
          paperTimer = 0;
        }

        String answer5 = '';

        if (data.containsKey('Answer5')) {
          answer5 = quizDoc['Answer5'];
        } else {
          answer5 = '';
        }

        bool isSample = quizDoc['isSample'];
        bool isBackEnable = quizDoc['isBackEnable'];
        String questionVideo = '';

        if (data.containsKey('questionVideo')) {
          questionVideo = quizDoc['questionVideo'];
        } else {
          questionVideo = '';
        }

        String questionImage = '';

        if (data.containsKey('questionImage')) {
          questionImage = quizDoc['questionImage'];
        } else {
          questionImage = '';
        }

        String answer1Image = '';

        if (data.containsKey('answer1Image')) {
          answer1Image = quizDoc['answer1Image'];
        } else {
          answer1Image = '';
        }

        String answer2Image = '';

        if (data.containsKey('answer2Image')) {
          answer2Image = quizDoc['answer2Image'];
        } else {
          answer2Image = '';
        }

        String answer3Image = '';

        if (data.containsKey('answer3Image')) {
          answer3Image = quizDoc['answer3Image'];
        } else {
          answer3Image = '';
        }

        String answer4Image = '';

        if (data.containsKey('answer4Image')) {
          answer4Image = quizDoc['answer4Image'];
        } else {
          answer4Image = '';
        }

        String answer5Image = '';

        if (data.containsKey('answer5Image')) {
          answer5Image = quizDoc['answer5Image'];
        } else {
          answer5Image = '';
        }

        String answer1Video = '';

        if (data.containsKey('answer1Video')) {
          answer1Video = quizDoc['answer1Video'];
        } else {
          answer1Video = '';
        }

        String answer2Video = '';

        if (data.containsKey('answer2Video')) {
          answer2Video = quizDoc['answer2Video'];
        } else {
          answer2Video = '';
        }

        String answer3Video = '';

        if (data.containsKey('answer3Video')) {
          answer3Video = quizDoc['answer3Video'];
        } else {
          answer3Video = '';
        }

        String answer4Video = '';

        if (data.containsKey('answer4Video')) {
          answer4Video = quizDoc['answer4Video'];
        } else {
          answer4Video = '';
        }

        String answer5Video = '';

        if (data.containsKey('answer5Video')) {
          answer5Video = quizDoc['answer5Video'];
        } else {
          answer5Video = '';
        }

        //String quizAmount = quizDoc['quizAmount'];

        //Sample

        String correctAnswerSample = '';

        if (data.containsKey('correctAnswerSample')) {
          correctAnswerSample = quizDoc['correctAnswerSample'];
        } else {
          correctAnswerSample = '';
        }

        String questionSample = '';

        if (data.containsKey('questionSample')) {
          questionSample = quizDoc['questionSample'];
        } else {
          questionSample = '';
        }

        String answer1Sample = '';

        if (data.containsKey('Answer1Sample')) {
          answer1Sample = quizDoc['Answer1Sample'];
        } else {
          answer1Sample = '';
        }

        String answer2Sample = '';

        if (data.containsKey('Answer2Sample')) {
          answer2Sample = quizDoc['Answer2Sample'];
        } else {
          answer2Sample = '';
        }

        String answer3Sample = '';

        if (data.containsKey('Answer3Sample')) {
          answer3Sample = quizDoc['Answer3Sample'];
        } else {
          answer3Sample = '';
        }

        String answer4Sample = '';

        if (data.containsKey('Answer4Sample')) {
          answer4Sample = quizDoc['Answer4Sample'];
        } else {
          answer4Sample = '';
        }

        String answer5Sample = '';

        if (data.containsKey('Answer5Sample')) {
          answer5Sample = quizDoc['Answer5Sample'];
        } else {
          answer5Sample = '';
        }

        String answer1ImageSample = '';

        if (data.containsKey('answer1ImageSample')) {
          answer1ImageSample = quizDoc['answer1ImageSample'];
        } else {
          answer1ImageSample = '';
        }

        String answer2ImageSample = '';

        if (data.containsKey('answer2ImageSample')) {
          answer2ImageSample = quizDoc['answer2ImageSample'];
        } else {
          answer2ImageSample = '';
        }

        String answer3ImageSample = '';

        if (data.containsKey('answer3ImageSample')) {
          answer3ImageSample = quizDoc['answer3ImageSample'];
        } else {
          answer3ImageSample = '';
        }

        String answer4ImageSample = '';

        if (data.containsKey('answer4ImageSample')) {
          answer4ImageSample = quizDoc['answer4ImageSample'];
        } else {
          answer4ImageSample = '';
        }

        String answer5ImageSample = '';

        if (data.containsKey('answer5ImageSample')) {
          answer5ImageSample = quizDoc['answer5ImageSample'];
        } else {
          answer5ImageSample = '';
        }

        String answer1VideoSample = '';

        if (data.containsKey('answer1VideoSample')) {
          answer1VideoSample = quizDoc['answer1VideoSample'];
        } else {
          answer1VideoSample = '';
        }

        String answer2VideoSample = '';

        if (data.containsKey('answer2VideoSample')) {
          answer2VideoSample = quizDoc['answer2VideoSample'];
        } else {
          answer2VideoSample = '';
        }

        String answer3VideoSample = '';

        if (data.containsKey('answer3VideoSample')) {
          answer3VideoSample = quizDoc['answer3VideoSample'];
        } else {
          answer3VideoSample = '';
        }

        String answer4VideoSample = '';

        if (data.containsKey('answer4VideoSample')) {
          answer4VideoSample = quizDoc['answer4VideoSample'];
        } else {
          answer4VideoSample = '';
        }

        String answer5VideoSample = '';

        if (data.containsKey('answer5VideoSample')) {
          answer5VideoSample = quizDoc['answer5VideoSample'];
        } else {
          answer5VideoSample = '';
        }

        String questionVideoSample = '';

        if (data.containsKey('questionVideoSample')) {
          questionVideoSample = quizDoc['questionVideoSample'];
        } else {
          questionVideoSample = '';
        }

        String questionImageSample = '';

        if (data.containsKey('questionImageSample')) {
          questionImageSample = quizDoc['questionImageSample'];
        } else {
          questionImageSample = '';
        }

        Quiz quiz = Quiz(
          //quizID: quizID,
          question: question,
          answer1: answer1,
          answer2: answer2,
          answer3: answer3,
          answer4: answer4,
          answer5: answer5,
          //paymentTerm: paymentTerm,
          isSample: isSample,
          isBackEnable: isBackEnable,
          questionVideo: questionVideo,
          questionImage: questionImage,
          answer1Image: answer1Image,
          answer2Image: answer2Image,
          answer3Image: answer3Image,
          answer4Image: answer4Image,
          answer5Image: answer5Image,
          answer1Video: answer1Video,
          answer2Video: answer2Video,
          answer3Video: answer3Video,
          answer4Video: answer4Video,
          answer5Video: answer5Video,
          correctAnswer: correctAnswer,
          timer: timer,
          questionSample: questionSample,
          answer1Sample: answer1Sample,
          answer2Sample: answer2Sample,
          answer3Sample: answer3Sample,
          answer4Sample: answer4Sample,
          answer5Sample: answer5Sample,
          correctAnswerSample: correctAnswerSample,
          questionVideoSample: questionVideoSample,
          questionImageSample: questionImageSample,
          answer1ImageSample: answer1ImageSample,
          answer2ImageSample: answer2ImageSample,
          answer3ImageSample: answer3ImageSample,
          answer4ImageSample: answer4ImageSample,
          answer5ImageSample: answer5ImageSample,
          answer1VideoSample: answer1VideoSample,
          answer2VideoSample: answer2VideoSample,
          answer3VideoSample: answer3VideoSample,
          answer4VideoSample: answer4VideoSample,
          answer5VideoSample: answer5VideoSample,
          paperTimer: paperTimer,
          //quizAmount: quizAmount,
        );

        quizzes.add(quiz);
        notifyListeners();
      }
      print(quizzes);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // getHistoryQuizzes() async {
  //   try {
  //     final DocumentSnapshot driversDoc = await FirebaseFirestore.instance
  //         .collection("Drivers")
  //         .doc(driverID)
  //         .get();

  //     if (driversDoc.exists) {
  //       setState(() {
  //         firstName = driversDoc.get('firstName').toString();
  //         phoneNumber = driversDoc.get('telephone').toString();
  //         dialNumber = Uri(scheme: 'tel', path: phoneNumber);
  //       });
  //       return Driver.fromJson(driversDoc.data() as Map<String, dynamic>);
  //     }
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     print("Succesfully get data");
  //   }
  // }
}
