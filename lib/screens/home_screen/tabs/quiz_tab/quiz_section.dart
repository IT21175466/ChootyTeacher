import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:koreanlms/constants/app_colors.dart';
import 'package:koreanlms/models/paper.dart';
import 'package:koreanlms/providers/quiz/quiz_provider.dart';
import 'package:koreanlms/screens/quiz/question_screen.dart';
import 'package:koreanlms/widgets/quiz_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class QuizSection extends StatefulWidget {
  const QuizSection({super.key});

  @override
  State<QuizSection> createState() => _QuizSectionState();
}

class _QuizSectionState extends State<QuizSection> {
  String? studentID = '';

  var quizProvider = QuizProvider();

  @override
  void initState() {
    super.initState();
    getStudentID();
    quizProvider = Provider.of<QuizProvider>(context, listen: false);
    quizProvider.quizzes = [];
    listnToOngoings();
  }

  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('did_papers');

  void listnToOngoings() {
    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic>? values = dataSnapshot.value as Map?;

      if (values != null) {
        values.forEach((key, quizHistoryData) {
          if (key == studentID) {
            databaseReference.onValue.listen((event2) {
              DataSnapshot dataSnapshot2 = event2.snapshot.child(key);
              Map<dynamic, dynamic>? values2 = dataSnapshot2.value as Map?;

              if (values2 != null) {
                values2.forEach((key2, quizHistoryData2) {
                  print('Key: $key2');

                  if (quizProvider.didPapers
                      .contains(quizHistoryData2['paper_name'].toString())) {
                    print('This record available in the array list');
                  } else {
                    setState(() {
                      quizProvider.didPapers
                          .add(quizHistoryData2['paper_name'].toString());
                    });
                  }
                });
              }
            });
          }

          print('Key: $key');
          print('Did Quiz List: ${quizProvider.didPapers}');
        });
      } else {}
    });
  }

  getStudentID() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      studentID = prefs.getString('userID');
    });
  }

  @override
  Widget build(BuildContext context) {
    listnToOngoings();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Consumer(
        builder:
            (BuildContext context, QuizProvider quizProvider, Widget? child) =>
                Container(
          width: screenWidth,
          height: screenHeight,
          child: quizProvider.noBatch
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset('assets/images/admin.png'),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Please Contact Admin',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrl(
                            Uri(scheme: 'tel', path: '+94768021182')
                          //Uri.parse('https://dreamkoreanacademy.com/contact/'),
                        );
                      },
                      child: Text(
                        '076 802 1182',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                )
              : quizProvider.noBatch == false &&
                      quizProvider.payment == "not_yet"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        Text(
                          'Payment Required',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                      ],
                    )
                  : quizProvider.noPapers
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text(
                              'No papers yet!',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            Spacer(),
                          ],
                        )
                      : ListView.builder(
                          itemCount: quizProvider.papers.length,
                          itemBuilder: (context, index) {
                            Paper paper = quizProvider.papers[index];
                            print(paper.paperName);
                            return quizProvider.papers.isEmpty
                                ? Center(
                                    child: Text(
                                      'No Quizzes yet!',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      await quizProvider
                                          .getQuizzes(paper.paperName);
                                      quizProvider.isSelected = false;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuestionScreen(
                                              quizName: paper.paperName),
                                        ),
                                      );
                                    },
                                    child: QuizCard(
                                      title: paper.paperName,
                                      color: quizProvider.didPapers
                                              .contains(paper.paperName)
                                          ? Colors.white
                                          : AppColors.lightGrayColor,
                                      fontWeight: quizProvider.didPapers
                                              .contains(paper.paperName)
                                          ? FontWeight.w400
                                          : FontWeight.w600,
                                    ),
                                  );
                          },
                        ),
        ),
      ),
    );
  }
}
