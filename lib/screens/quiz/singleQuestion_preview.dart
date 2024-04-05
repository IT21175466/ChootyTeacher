import 'package:flutter/material.dart';
import 'package:koreanlms/providers/quiz/quiz_provider.dart';
import 'package:koreanlms/widgets/answer_tile.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SingleQuestionToPreview extends StatefulWidget {
  final String question;
  final String answer1;
  final String answer2;
  final String answer3;
  final String answer4;
  final String answer5;
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
  final String indexOfQuiz;
  final String userSelected;
  const SingleQuestionToPreview({
    super.key,
    required this.question,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.answer4,
    required this.answer5,
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
    required this.indexOfQuiz,
    required this.userSelected,
  });

  @override
  State<SingleQuestionToPreview> createState() =>
      _SingleQuestionToPreviewState();
}

class _SingleQuestionToPreviewState extends State<SingleQuestionToPreview> {
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
    initializeController();
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      //height: screenHeight - (AppBar().preferredSize.height * 2),
      width: screenWidth,
      child: Consumer(
        builder:
            (BuildContext context, QuizProvider quizProvider, Widget? child) =>
                Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
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
            AnswerTile(
              answer: widget.answer1,
              answerImage: widget.answer1Image,
              textColor: widget.userSelected == widget.answer1
                  ? Colors.white
                  : Colors.grey,
              backgroundColor: widget.userSelected == widget.answer1
                  ? widget.userSelected == widget.correctAnswer
                      ? Colors.green
                      : Colors.red
                  : Colors.white,
              icon: widget.userSelected == widget.answer1
                  ? widget.userSelected == widget.correctAnswer
                      ? Image.asset('assets/images/correct.png')
                      : Image.asset('assets/images/wrong.png')
                  : Image.asset('assets/images/correct.png'),
            ),
            AnswerTile(
              answer: widget.answer2,
              answerImage: widget.answer2Image,
              textColor: widget.userSelected == widget.answer2
                  ? Colors.white
                  : Colors.grey,
              backgroundColor: widget.userSelected == widget.answer2
                  ? widget.userSelected == widget.correctAnswer
                      ? Colors.green
                      : Colors.red
                  : Colors.white,
              icon: widget.userSelected == widget.answer2
                  ? widget.userSelected == widget.correctAnswer
                      ? Image.asset('assets/images/correct.png')
                      : Image.asset('assets/images/wrong.png')
                  : Image.asset('assets/images/correct.png'),
            ),
            AnswerTile(
              answer: widget.answer3,
              answerImage: widget.answer3Image,
              textColor: widget.userSelected == widget.answer3
                  ? Colors.white
                  : Colors.grey,
              backgroundColor: widget.userSelected == widget.answer3
                  ? widget.userSelected == widget.correctAnswer
                      ? Colors.green
                      : Colors.red
                  : Colors.white,
              icon: widget.userSelected == widget.answer3
                  ? widget.userSelected == widget.correctAnswer
                      ? Image.asset('assets/images/correct.png')
                      : Image.asset('assets/images/wrong.png')
                  : Image.asset('assets/images/correct.png'),
            ),
            AnswerTile(
              answer: widget.answer4,
              answerImage: widget.answer4Image,
              textColor: widget.userSelected == widget.answer4
                  ? Colors.white
                  : Colors.grey,
              backgroundColor: widget.userSelected == widget.answer4
                  ? widget.userSelected == widget.correctAnswer
                      ? Colors.green
                      : Colors.red
                  : Colors.white,
              icon: widget.userSelected == widget.answer4
                  ? widget.userSelected == widget.correctAnswer
                      ? Image.asset('assets/images/correct.png')
                      : Image.asset('assets/images/wrong.png')
                  : Image.asset('assets/images/correct.png'),
            ),
            widget.answer5.isEmpty
                ? SizedBox()
                : AnswerTile(
                    answer: widget.answer5,
                    answerImage: widget.answer5Image,
                    textColor: widget.userSelected == widget.answer5
                        ? Colors.white
                        : Colors.grey,
                    backgroundColor: widget.userSelected == widget.answer5
                        ? widget.userSelected == widget.correctAnswer
                            ? Colors.green
                            : Colors.red
                        : Colors.white,
                    icon: widget.userSelected == widget.answer5
                        ? widget.userSelected == widget.correctAnswer
                            ? Image.asset('assets/images/correct.png')
                            : Image.asset('assets/images/wrong.png')
                        : Image.asset('assets/images/correct.png'),
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
                  widget.correctAnswer,
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
    );
  }
}
