import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:koreanlms/models/history_quiz.dart';
import 'package:koreanlms/providers/quiz/quiz_provider.dart';
import 'package:koreanlms/screens/quiz/singleQuestion_preview.dart';
import 'package:koreanlms/widgets/button_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class QuizPreviewScreen extends StatefulWidget {
  final String sID;
  final String marks;
  final String name;
  const QuizPreviewScreen(
      {super.key, required this.sID, required this.marks, required this.name});

  @override
  State<QuizPreviewScreen> createState() => _QuizPreviewScreenState();
}

class _QuizPreviewScreenState extends State<QuizPreviewScreen> {
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('did_papers');

  String generateRandomId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Consumer(
        builder:
            (BuildContext context, QuizProvider quizProvider, Widget? child) =>
                Container(
          height: screenHeight,
          width: screenWidth,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: quizProvider.quizzes.length,
                  itemBuilder: (context, index) {
                    final String userSelectedAnser =
                        quizProvider.answers[index].selectedAnswer;
                    return SingleQuestionToPreview(
                      question: quizProvider.quizzes[index].question,
                      answer1: quizProvider.quizzes[index].answer1,
                      answer2: quizProvider.quizzes[index].answer2,
                      answer3: quizProvider.quizzes[index].answer3,
                      answer4: quizProvider.quizzes[index].answer4,
                      answer5: quizProvider.quizzes[index].answer5,
                      questionVideo: quizProvider.quizzes[index].questionVideo,
                      questionImage: quizProvider.quizzes[index].questionImage,
                      answer1Image: quizProvider.quizzes[index].answer1Image,
                      answer2Image: quizProvider.quizzes[index].answer2Image,
                      answer3Image: quizProvider.quizzes[index].answer3Image,
                      answer4Image: quizProvider.quizzes[index].answer4Image,
                      answer5Image: quizProvider.quizzes[index].answer5Image,
                      answer1Video: quizProvider.quizzes[index].answer1Video,
                      answer2Video: quizProvider.quizzes[index].answer2Video,
                      answer3Video: quizProvider.quizzes[index].answer3Video,
                      answer4Video: quizProvider.quizzes[index].answer4Video,
                      answer5Video: quizProvider.quizzes[index].answer5Video,
                      correctAnswer: quizProvider.quizzes[index].correctAnswer,
                      indexOfQuiz: quizProvider.quizzes[index].toString(),
                      userSelected: userSelectedAnser,
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  try {
                    String formattedDate =
                        DateFormat.yMMMMd().format(DateTime.now());

                    quizProvider.isLoading = true;
                    HistoryQuiz historyQuiz = HistoryQuiz(
                      studentID: widget.sID,
                      quizName: widget.name,
                      marks: widget.marks,
                      date: formattedDate,
                    );
                    quizProvider.addQuizToFirebase(
                        historyQuiz, context, widget.sID);

                    databaseReference
                        .child(widget.sID)
                        .child(generateRandomId())
                        .set({
                      "studentID": widget.sID,
                      "paper_name": widget.name,
                    });
                  } catch (e) {
                    print(e);
                  } finally {
                    quizProvider.isLoading = false;
                  }
                },
                child: CustomButton(
                  text: 'Done',
                  height: 50,
                  width: screenWidth,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
