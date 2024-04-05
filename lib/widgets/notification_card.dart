import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  final String msg;
  const NotificationCard({super.key, required this.msg});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications,
            size: 30,
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              widget.msg,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
