import 'dart:async';

import 'package:flutter/material.dart';
import 'package:koreanlms/models/answer.dart';
import 'package:koreanlms/providers/quiz/quiz_provider.dart';
import 'package:koreanlms/screens/quiz/quiz_ending.dart';
import 'package:koreanlms/widgets/answer_tile.dart';
import 'package:koreanlms/widgets/button_widget.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SingleQuestion extends StatefulWidget {
  final String quizName;
  final String question;
  final String answer1;
  final String answer2;
  final String answer3;
  final String answer4;
  final String answer5;
  final bool isSample;
  final bool isBackEnable;
  final String questionVideo;
  final String questionImage;
  final String answer1Image;
  final String answer2Image;
  final String answer3Image;
  final String answer4Image;
  final String answer5Image;
  final String answer1Video;
  final String answer2Video;
  final String answer3Video;
  final String answer4Video;
  final String answer5Video;
  final String correctAnswer;
  final int timer;
  final int indexOfQuiz;

  //Sample
  final String questionSample;
  final String answer1Sample;
  final String answer2Sample;
  final String answer3Sample;
  final String answer4Sample;
  final String answer5Sample;
  final String correctAnswerSample;
  final String questionVideoSample;
  final String questionImageSample;
  final String answer1ImageSample;
  final String answer2ImageSample;
  final String answer3ImageSample;
  final String answer4ImageSample;
  final String answer5ImageSample;
  final String answer1VideoSample;
  final String answer2VideoSample;
  final String answer3VideoSample;
  final String answer4VideoSample;
  final String answer5VideoSample;

  const SingleQuestion({
    super.key,
    required this.quizName,
    required this.question,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.answer4,
    required this.answer5,
    required this.isSample,
    required this.isBackEnable,
    required this.questionVideo,
    required this.questionImage,
    required this.answer1Image,
    required this.answer2Image,
    required this.answer3Image,
    required this.answer4Image,
    required this.answer5Image,
    required this.answer1Video,
    required this.answer2Video,
    required this.answer3Video,
    required this.answer4Video,
    required this.answer5Video,
    required this.correctAnswer,
    required this.timer,
    required this.indexOfQuiz,

    //Sample
    required this.questionSample,
    required this.answer1Sample,
    required this.answer2Sample,
    required this.answer3Sample,
    required this.answer4Sample,
    required this.answer5Sample,
    required this.correctAnswerSample,
    required this.questionVideoSample,
    required this.questionImageSample,
    required this.answer1ImageSample,
    required this.answer2ImageSample,
    required this.answer3ImageSample,
    required this.answer4ImageSample,
    required this.answer5ImageSample,
    required this.answer1VideoSample,
    required this.answer2VideoSample,
    required this.answer3VideoSample,
    required this.answer4VideoSample,
    required this.answer5VideoSample,
  });

  @override
  State<SingleQuestion> createState() => _SingleQuestionState();
}

class _SingleQuestionState extends State<SingleQuestion> {
  @override
  void initState() {
    super.initState();
  }

  late YoutubePlayerController _controller;

  void initializeController() {
    if (widget.questionVideo.isNotEmpty) {
      final videoID = YoutubePlayer.convertUrlToId(widget.questionVideo);

      _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          //hideControls: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    initializeController();

    void showSampleQuestion() {
      if (widget.isSample == true) {
        if (mounted) {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              height: screenHeight - AppBar().preferredSize.height * 2,
              width: screenWidth,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Sample Question',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CustomButton(
                            text: 'Exit',
                            height: 30,
                            width: 80,
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.questionSample,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    widget.questionImageSample.isEmpty &&
                            widget.questionVideoSample.isEmpty
                        ? SizedBox()
                        : Container(
                            height: 200,
                            width: screenWidth,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 224, 222, 222),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: widget.questionVideoSample.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: YoutubePlayer(
                                        controller: _controller,
                                        showVideoProgressIndicator: true,
                                        bottomActions: [
                                          FullScreenButton(
                                            color: Colors.transparent,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Image.network(
                                    '${widget.questionImageSample}',
                                    fit: BoxFit.contain,
                                  ),
                          ),
                    SizedBox(
                      height: 15,
                    ),
                    AnswerTile(
                      answer: widget.answer1Sample,
                      answerImage: widget.answer1ImageSample,
                      textColor:
                          widget.correctAnswerSample == widget.answer1Sample
                              ? Colors.white
                              : Colors.grey,
                      backgroundColor:
                          widget.correctAnswerSample == widget.answer1Sample
                              ? Colors.green
                              : Colors.white,
                      icon: Image.asset('assets/images/correct.png'),
                    ),
                    AnswerTile(
                      answer: widget.answer2Sample,
                      answerImage: widget.answer2ImageSample,
                      textColor:
                          widget.correctAnswerSample == widget.answer2Sample
                              ? Colors.white
                              : Colors.grey,
                      backgroundColor:
                          widget.correctAnswerSample == widget.answer2Sample
                              ? Colors.green
                              : Colors.white,
                      icon: Image.asset('assets/images/correct.png'),
                    ),
                    AnswerTile(
                      answer: widget.answer3Sample,
                      answerImage: widget.answer3ImageSample,
                      textColor:
                          widget.correctAnswerSample == widget.answer3Sample
                              ? Colors.white
                              : Colors.grey,
                      backgroundColor:
                          widget.correctAnswerSample == widget.answer3Sample
                              ? Colors.green
                              : Colors.white,
                      icon: Image.asset('assets/images/correct.png'),
                    ),
                    AnswerTile(
                      answer: widget.answer4Sample,
                      answerImage: widget.answer4ImageSample,
                      textColor:
                          widget.correctAnswerSample == widget.answer4Sample
                              ? Colors.white
                              : Colors.grey,
                      backgroundColor:
                          widget.correctAnswerSample == widget.answer4Sample
                              ? Colors.green
                              : Colors.white,
                      icon: Image.asset('assets/images/correct.png'),
                    ),
                    widget.answer5.isEmpty
                        ? SizedBox()
                        : AnswerTile(
                            answer: widget.answer5Sample,
                            answerImage: widget.answer5ImageSample,
                            textColor: widget.correctAnswerSample ==
                                    widget.answer5Sample
                                ? Colors.white
                                : Colors.grey,
                            backgroundColor: widget.correctAnswerSample ==
                                    widget.answer5Sample
                                ? Colors.green
                                : Colors.white,
                            icon: Image.asset('assets/images/correct.png'),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Correct Answer : ",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.correctAnswerSample,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    }

    //showSampleQuestion();

    Future.delayed(Duration.zero, () {
      showSampleQuestion();
    });

    return Container(
      //height: screenHeight - (AppBar().preferredSize.height * 2),
      width: screenWidth,
      child: Consumer(
        builder:
            (BuildContext context, QuizProvider quizProvider, Widget? child) =>
                Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            quizProvider.quizzes[0].paperTimer != 0
                ? Countdown(
                    seconds: quizProvider.quizzes[0].paperTimer,
                    build: (BuildContext context, double time) {
                      int minutes = time ~/ 60;
                      int seconds = (time % 60).toInt();

                      return Container(
                        width: screenWidth,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: (quizProvider.quizzes[0].paperTimer *
                                      75.0 /
                                      100.0) <
                                  10.0
                              ? Colors.red
                              : Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: FittedBox(
                          child: Text(
                            'Paper Timer - ${minutes} minutes and ${seconds} seconds left',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                    interval: Duration(seconds: 1),
                    onFinished: () {
                      print('Timer is done!');

                      print(quizProvider.quizzes.length);
                      print(quizProvider.answers.length);

                      if (quizProvider.quizzes.length !=
                          quizProvider.answers.length) {
                        int index = quizProvider.answers.length;

                        // setState(() {
                        //   index = quizProvider.quizzes.length -
                        //       quizProvider.answers.length;
                        // });

                        print(index);
                        try {
                          for (int i = index;
                              i < quizProvider.quizzes.length;
                              i++) {
                            print(quizProvider.quizzes.length);
                            print(quizProvider.answers.length);

                            Answer answer = Answer(
                              indexOfQuiz: index,
                              correctAnswer:
                                  quizProvider.quizzes[index].correctAnswer,
                              selectedAnswer: "",
                            );

                            // String selectedAnswer =
                            //     'Not_Selected_987123567677645495898785476584';
                            // quizProvider.selectedAnswers.add(selectedAnswer);
                            quizProvider.answers.add(answer);

                            print(quizProvider.quizzes.length);
                            print(quizProvider.answers.length);
                          }
                        } catch (e) {
                          print(e);
                        } finally {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizEnd(
                                quizName: widget.quizName,
                              ),
                            ),
                          );
                        }
                      }

                      // if (quizProvider.selectedAnswer == "") {
                      //   setState(() {
                      //     quizProvider.selectedAnswer =
                      //         "Not_Selected_987123567677645495898785476584";
                      //   });
                      // }

                      // setState(() {
                      //   quizProvider.timerDone = true;

                      // });
                    },
                  )
                : SizedBox(),
            Divider(),

            quizProvider.quizzes[widget.indexOfQuiz].timer == 0
                ? SizedBox()
                : Countdown(
                    seconds: widget.timer,
                    build: (BuildContext context, double time) => Container(
                      width: screenWidth,
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: (time * 75.0 / 100.0) < 10.0
                            ? Colors.red
                            : Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '${time.toStringAsFixed(0)} seconds left',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    interval: Duration(seconds: 1),
                    onFinished: () {
                      print('Timer is done!');

                      if (quizProvider.selectedAnswer == "") {
                        setState(() {
                          quizProvider.selectedAnswer =
                              "Not_Selected_987123567677645495898785476584";
                        });
                      }

                      setState(() {
                        quizProvider.timerDone = true;

                        //quizProvider.countCorrectAnswers();

                        // Answer answer = Answer(
                        //   indexOfQuiz: widget.indexOfQuiz,
                        //   correctAnswer: quizProvider.coorectAnswer,
                        //   selectedAnswer: quizProvider.selectedAnswer,
                        // );

                        // quizProvider.answers.add(answer);
                      });
                    },
                  ),
            widget.isSample
                ? Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          showSampleQuestion();
                        },
                        child: Text(
                          'See Sample',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.question,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            widget.questionImage.isEmpty && widget.questionVideo.isEmpty
                ? SizedBox()
                : Container(
                    height: 200,
                    width: screenWidth,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 224, 222, 222),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: widget.questionVideo.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: YoutubePlayer(
                                controller: _controller,
                                showVideoProgressIndicator: true,
                                bottomActions: [
                                  FullScreenButton(
                                    color: Colors.transparent,
                                  )
                                ],
                              ),
                            ),
                          )
                        : Image.network(
                            '${widget.questionImage}',
                            fit: BoxFit.contain,
                          ),
                  ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                if (quizProvider.timerDone == false) {
                  setState(() {
                    //quizProvider.isSelected = true;
                    //quizProvider.coorectAnswer = widget.correctAnswer;
                    quizProvider.selectedAnswer = widget.answer1;

                    ///quizProvider.countCorrectAnswers();

                    // Answer answer = Answer(
                    //   indexOfQuiz: widget.indexOfQuiz,
                    //   correctAnswer: quizProvider.coorectAnswer,
                    //   selectedAnswer: quizProvider.selectedAnswer,
                    // );

                    //quizProvider.answers.add(answer);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Timeout!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: AnswerTile(
                answer: widget.answer1,
                answerImage: widget.answer1Image,
                textColor: quizProvider.selectedAnswer == widget.answer1
                    ? Colors.white
                    : Colors.grey,
                backgroundColor: quizProvider.selectedAnswer == widget.answer1
                    ? Colors.green
                    : Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (quizProvider.timerDone == false) {
                  setState(() {
                    quizProvider.selectedAnswer = widget.answer2;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Timeout!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: AnswerTile(
                answer: widget.answer2,
                answerImage: widget.answer2Image,
                textColor: quizProvider.selectedAnswer == widget.answer2
                    ? Colors.white
                    : Colors.grey,
                backgroundColor: quizProvider.selectedAnswer == widget.answer2
                    ? Colors.green
                    : Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (quizProvider.timerDone == false) {
                  setState(() {
                    quizProvider.selectedAnswer = widget.answer3;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Timeout!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: AnswerTile(
                answer: widget.answer3,
                answerImage: widget.answer3Image,
                textColor: quizProvider.selectedAnswer == widget.answer3
                    ? Colors.white
                    : Colors.grey,
                backgroundColor: quizProvider.selectedAnswer == widget.answer3
                    ? Colors.green
                    : Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (quizProvider.timerDone == false) {
                  setState(() {
                    quizProvider.selectedAnswer = widget.answer4;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Timeout!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: AnswerTile(
                answer: widget.answer4,
                answerImage: widget.answer4Image,
                textColor: quizProvider.selectedAnswer == widget.answer4
                    ? Colors.white
                    : Colors.grey,
                backgroundColor: quizProvider.selectedAnswer == widget.answer4
                    ? Colors.green
                    : Colors.white,
              ),
            ),
            widget.answer5.isEmpty
                ? SizedBox()
                : GestureDetector(
                    onTap: () {
                      if (quizProvider.timerDone == false) {
                        setState(() {
                          quizProvider.selectedAnswer = widget.answer5;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Timeout!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: AnswerTile(
                      answer: widget.answer5,
                      answerImage: widget.answer5Image,
                      textColor: quizProvider.selectedAnswer == widget.answer5
                          ? Colors.white
                          : Colors.grey,
                      backgroundColor:
                          quizProvider.selectedAnswer == widget.answer5
                              ? Colors.green
                              : Colors.white,
                    ),
                  ),
            // SizedBox(
            //   height: 10,
            // ),
            // quizProvider.isSelected == false
            //     ? SizedBox()
            //     : Row(
            //         children: [
            //           Text(
            //             "Correct Answer : ",
            //             style: TextStyle(
            //               fontFamily: 'Poppins',
            //               fontWeight: FontWeight.w700,
            //               fontSize: 15,
            //               color: Colors.black,
            //             ),
            //           ),
            //           Text(
            //             widget.correctAnswer,
            //             style: TextStyle(
            //               fontFamily: 'Poppins',
            //               fontWeight: FontWeight.w500,
            //               fontSize: 15,
            //               color: Colors.black,
            //             ),
            //           ),
            //         ],
            //       ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
