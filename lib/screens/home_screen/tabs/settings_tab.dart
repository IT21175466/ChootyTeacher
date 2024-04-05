import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreanlms/providers/student_provider/student_provider.dart';
import 'package:koreanlms/widgets/user_info_card.dart';
import 'package:provider/provider.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  void initState() {
    super.initState();
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    studentProvider.isLoading = true;
    studentProvider.getStudentData(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Consumer(
        builder: (BuildContext context, StudentProvider studentProvider,
                Widget? child) =>
            Column(
          children: [
            Container(
              width: screenWidth,
              height: AppBar().preferredSize.height * 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: AppBar().preferredSize.height,
                  ),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: screenHeight -
                  (AppBar().preferredSize.height * 2) -
                  (Platform.isIOS ? 92 : 70),
              width: screenWidth,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Image.asset('assets/images/user.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    UserInfoCard(
                        hint: 'Full Name',
                        detail:
                            '${studentProvider.firstName} ${studentProvider.lastName}'),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User ID',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: screenWidth / 5 * 3.5,
                                child: Text(
                                  '${studentProvider.studentID}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  try {
                                    final value = ClipboardData(
                                        text: studentProvider.studentID
                                            .toString());
                                    Clipboard.setData(value);
                                  } catch (e) {
                                    print(e);
                                  } finally {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.done,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'Student ID Copied',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                                child: Icon(Icons.copy_rounded),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    UserInfoCard(
                        hint: 'Mobile Number',
                        detail: '${studentProvider.phoneNum}'),

                    UserInfoCard(
                        hint: 'Batch', detail: '${studentProvider.batch}'),
                    UserInfoCard(
                        hint: 'Class',
                        detail: '${studentProvider.studentClass}'),
                    UserInfoCard(
                        hint: 'Payment', detail: '${studentProvider.payment}'),
                    UserInfoCard(
                        hint: 'Email', detail: '${studentProvider.email}'),
                    UserInfoCard(hint: 'NIC', detail: '${studentProvider.nic}'),
                    UserInfoCard(
                        hint: 'Date of birth',
                        detail: '${studentProvider.dateOfBirth}'),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        'Registed in ${studentProvider.registedDate}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     final prefs = await SharedPreferences.getInstance();
                    //     prefs.setBool('logedIn', false);

                    //     Navigator.pushNamedAndRemoveUntil(
                    //         context, '/loginsplash', (route) => false);
                    //   },
                    //   child: CustomButton(
                    //     text: 'Logout',
                    //     height: 50,
                    //     width: screenWidth,
                    //     backgroundColor: Colors.green,
                    //   ),
                    // ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
