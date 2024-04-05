import 'package:flutter/material.dart';

class AnswerTile extends StatefulWidget {
  final String answer;
  final String answerImage;
  final Color textColor;
  final Color backgroundColor;
  final Image? icon;
  const AnswerTile({
    super.key,
    required this.answer,
    required this.answerImage,
    required this.textColor,
    required this.backgroundColor,
    this.icon,
  });

  @override
  State<AnswerTile> createState() => _AnswerTileState();
}

class _AnswerTileState extends State<AnswerTile> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
        ),
        color: widget.backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.answer,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: widget.textColor,
                ),
              ),
              Spacer(),
              SizedBox(
                height: 20,
                width: 20,
                child: widget.icon,
              )
            ],
          ),
          widget.answerImage.isEmpty
              ? SizedBox()
              : Container(
                  height: 150,
                  width: 500,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 224, 222, 222),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Image.network(
                    '${widget.answerImage}',
                    fit: BoxFit.contain,
                  ),
                ),
        ],
      ),
    );
  }
}
