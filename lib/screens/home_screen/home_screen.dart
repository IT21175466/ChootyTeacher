import 'package:flutter/material.dart';
import 'package:koreanlms/providers/home/bottomnavbar_provider.dart';
import 'package:koreanlms/providers/app_data/app_data_provider.dart';
import 'package:koreanlms/screens/home_screen/tabs/home_tab.dart';
import 'package:koreanlms/screens/home_screen/tabs/notification_tab.dart';
import 'package:koreanlms/screens/home_screen/tabs/quiz_tab/quizes_tab.dart';
import 'package:koreanlms/screens/home_screen/tabs/settings_tab.dart';
import 'package:koreanlms/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Tabs
  final List<Widget> pages = [
    HomeTab(),
    QuizTab(),
    NotificationTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Consumer(
        builder: (BuildContext context, AppDataProvider appDataProvider,
                Widget? child) =>
            Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              opacity: 0.5,
              image: NetworkImage(
                '${appDataProvider.appBackgroudImage}',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Consumer(
            builder: (BuildContext context,
                    BottomNavBarProvider bottomNavigationProvider,
                    Widget? child) =>
                IndexedStack(
              index: bottomNavigationProvider.currentIndex,
              children: pages,
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
