import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QuizCard extends StatelessWidget {
  String title;
  FontWeight fontWeight;
  Color color;
  QuizCard({
    super.key,
    required this.title,
    required this.color,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
        color: color,
      ),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            child: Image.asset('assets/images/quiz.png'),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Text(
                '$title',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: fontWeight,
                  fontSize: 16,
                ),
              ),
              // Text(
              //   "${widget.quizAmount} Questions",
              //   style: TextStyle(
              //     fontFamily: 'Poppins',
              //     fontWeight: FontWeight.w600,
              //     fontSize: 14,
              //     color: AppColors.grayColor,
              //   ),
              // ),
              Spacer(),
            ],
          ),
          Spacer(),
          Icon(
            Icons.arrow_circle_right_outlined,
            size: 35,
          ),
        ],
      ),
    );
  }
}
