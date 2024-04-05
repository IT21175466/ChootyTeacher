import 'dart:io';

import 'package:flutter/material.dart';
import 'package:koreanlms/providers/home/bottomnavbar_provider.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavBarProvider>(
      builder: (BuildContext context,
          BottomNavBarProvider bottomNavigationProvider, Widget? child) {
        return Container(
          height: Platform.isIOS ? 92 : 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 29, 48, 84),
                Color.fromARGB(255, 35, 81, 165),
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.8],
              tileMode: TileMode.clamp,
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            currentIndex: bottomNavigationProvider.currentIndex,
            onTap: (index) {
              bottomNavigationProvider.setIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.question_answer,
                ),
                label: "Quizes",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.notifications,
                ),
                label: "Notifications",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: "Settings",
              ),
            ],
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Poppins',
            ),
            selectedItemColor: Colors.grey,
            unselectedItemColor: Colors.white,
            elevation: 20.0,
            selectedIconTheme: IconThemeData(
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
