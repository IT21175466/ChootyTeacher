import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koreanlms/providers/quiz/quiz_provider.dart';
import 'package:koreanlms/widgets/quiz_history_card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HistorySection extends StatefulWidget {
  final String sID;
  const HistorySection({super.key, required this.sID});

  @override
  State<HistorySection> createState() => _HistorySectionState();
}

class _HistorySectionState extends State<HistorySection> {
  @override
  Widget build(BuildContext context) {
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
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('HistoryQuizzes')
                      .doc(widget.sID)
                      .collection("Quizzes")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Connection Error!',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      Text(
                        'Loading.....',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      var docs = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            return QuizHistoryCard(
                              title: docs[index]['QuizName'],
                              marks: docs[index]['Marks'],
                              didDate: docs[index]['Date'],
                              id: docs[index]['StudentID'],
                            );
                          });
                      //Text('${docs.length}');
                    }
                    return Text(
                      'No Docs',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
          // Column(
          //     children: [
          //       SizedBox(
          //         height: 15,
          //       ),
          //       QuizHistoryCard(),
          //       QuizHistoryCard(),
          //       SizedBox(
          //         height: 30,
          //       ),
          //     ],
          //   ),
        ),
      ),
    );
  }
}
