import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:koreanlms/constants/app_colors.dart';
import 'package:koreanlms/models/history_quiz.dart';
import 'package:koreanlms/providers/quiz/quiz_provider.dart';
import 'package:koreanlms/screens/quiz/preview_screen.dart';
import 'package:koreanlms/widgets/button_widget.dart';
import 'package:koreanlms/widgets/outline_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class QuizEnd extends StatefulWidget {
  final String quizName;
  const QuizEnd({super.key, required this.quizName});

  @override
  State<QuizEnd> createState() => _QuizEndState();
}

class _QuizEndState extends State<QuizEnd> {
  int correctAnswerAmount = 0;
  int wrongAnswerAmount = 0;
  int notGivenAnswerAmount = 0;

  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('did_papers');

  @override
  void initState() {
    super.initState();
    getUserID();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    print(quizProvider.answers);

    for (String answer in quizProvider.selectedAnswers) {
      if (answer == "0") {
        wrongAnswerAmount++;
      } else if (answer == "1") {
        correctAnswerAmount++;
      } else if (answer == "N") {
        notGivenAnswerAmount++;
      }
    }

    marks = ((correctAnswerAmount) / (quizProvider.quizzes.length) * 100)
        .toStringAsFixed(1);
  }

  String? userID = '';

  String? marks = '';

  String generateRandomId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userID');
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Consumer(
      builder:
          (BuildContext context, QuizProvider quizProvider, Widget? child) =>
              Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(
                width: screenWidth,
                height: AppBar().preferredSize.height * 2 + 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: AppBar().preferredSize.height,
                    ),
                    Text(
                      'Quizzes',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      'Quiz Finished',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppColors.grayColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: screenHeight - (AppBar().preferredSize.height * 2 + 10),
                width: screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset('assets/images/goodJob.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                        'Good Job',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Spacer(),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue,
                          ),
                          child: Column(
                            children: [
                              Text(
                                quizProvider.quizzes.length.toString(),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Questions',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.green,
                          ),
                          child: Column(
                            children: [
                              Text(
                                correctAnswerAmount.toString(),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Correct',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.red,
                          ),
                          child: Column(
                            children: [
                              Text(
                                wrongAnswerAmount.toString(),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Incorrect',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    notGivenAnswerAmount == 0
                        ? SizedBox()
                        : Container(
                            width: 100,
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 255, 179, 0),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  notGivenAnswerAmount.toString(),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Not Given',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    Spacer(),
                    Spacer(),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizPreviewScreen(
                              sID: userID!,
                              marks: marks.toString(),
                              name: widget.quizName,
                            ),
                          ),
                        );
                      },
                      child: CustomOutlineButton(
                        text: 'Preview',
                        height: 50,
                        width: screenWidth,
                        borderColor: Colors.green,
                        textColor: Colors.green,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        try {
                          String formattedDate =
                              DateFormat.yMMMMd().format(DateTime.now());

                          quizProvider.isLoading = true;
                          HistoryQuiz historyQuiz = HistoryQuiz(
                            studentID: userID!,
                            quizName: widget.quizName,
                            marks: marks.toString(),
                            date: formattedDate,
                          );
                          quizProvider.addQuizToFirebase(
                              historyQuiz, context, userID!);

                          databaseReference
                              .child(userID!)
                              .child(generateRandomId())
                              .set({
                            "studentID": userID,
                            "paper_name": widget.quizName,
                          });
                        } catch (e) {
                          print(e);
                        } finally {
                          quizProvider.isLoading = false;
                        }
                      },
                      child: quizProvider.isLoading
                          ? Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : CustomButton(
                              text: 'Done',
                              height: 50,
                              width: screenWidth,
                              backgroundColor: Colors.green,
                            ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
