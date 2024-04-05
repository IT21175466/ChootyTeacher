import 'package:flutter/material.dart';
import 'package:koreanlms/constants/app_colors.dart';

class QuizHistoryCard extends StatefulWidget {
  final String id;
  final String title;
  final String marks;
  final String didDate;
  const QuizHistoryCard(
      {super.key,
      required this.title,
      required this.marks,
      required this.didDate,
      required this.id});

  @override
  State<QuizHistoryCard> createState() => _QuizHistoryCardState();
}

class _QuizHistoryCardState extends State<QuizHistoryCard> {
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
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.history,
            size: 35,
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Text(
                widget.title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                widget.didDate,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: AppColors.grayColor,
                ),
              ),
              Spacer(),
            ],
          ),
          Spacer(),
          Text(
            '${widget.marks}%',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: AppColors.grayColor,
            ),
          ),
        ],
      ),
    );
  }
}
