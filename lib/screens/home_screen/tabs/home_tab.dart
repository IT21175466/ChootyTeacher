import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:koreanlms/constants/app_colors.dart';
import 'package:koreanlms/global/variables.dart';
import 'package:koreanlms/models/video.dart';
import 'package:koreanlms/providers/app_data/app_data_provider.dart';
import 'package:koreanlms/providers/authentication/login_provider.dart';
import 'package:koreanlms/providers/quiz/quiz_provider.dart';
import 'package:koreanlms/providers/video/video_provider.dart';
import 'package:koreanlms/screens/video/play_video.dart';
import 'package:koreanlms/widgets/play_video_sample.dart';
import 'package:koreanlms/widgets/single_video_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController searchController = TextEditingController();

  String? studentID = '';

  var videoProvider = VideoProvider();
  var quizProvider = QuizProvider();

  String phone = '';

  bool isLoading = false;
  bool isSucess = false;

  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('watched_videos');

  @override
  void initState() {
    super.initState();
    getStudentID();

    final appDataProvider =
        Provider.of<AppDataProvider>(context, listen: false);
    appDataProvider.isLoading = true;
    appDataProvider.getImageData();

    videoProvider = Provider.of<VideoProvider>(context, listen: false);
    quizProvider = Provider.of<QuizProvider>(context, listen: false);
    // final notificationProvider =
    //     Provider.of<NotificationProvider>(context, listen: false);
    // notificationProvider.listnToNotifications();
    listnToOngoings();
  }

  searchVideo(String query) {
    final suggestions = videoProvider.videos.where((video) {
      final title = video.title.toLowerCase();
      final input = query.toLowerCase();

      return title.contains(input);
    }).toList();

    if (query.isEmpty) {
      setState(() {
        videoProvider.getVideos();
      });
    } else {
      setState(() {
        videoProvider.videos = suggestions;
      });
    }
  }

  getStudentID() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      studentID = prefs.getString('userID');
      globleStudentID = prefs.getString('userID');
    });

    videoProvider.checkUserInBatch(studentID!);
    quizProvider.checkUserInBatch(studentID!);
  }

  String generateRandomCode() {
    Random random = Random();
    int code = random.nextInt(900000) + 100000;
    return code.toString();
  }

  void listnToOngoings() {
    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic>? values = dataSnapshot.value as Map?;

      if (values != null) {
        values.forEach((key, videoHistoryData) {
          if (key == studentID) {
            databaseReference.onValue.listen((event2) {
              DataSnapshot dataSnapshot2 = event2.snapshot.child(key);
              Map<dynamic, dynamic>? values2 = dataSnapshot2.value as Map?;

              if (values2 != null) {
                values2.forEach((key2, videoHistoryData2) {
                  print('Key: $key2');

                  if (videoProvider.watchedVideos
                      .contains(videoHistoryData2['paper_name'].toString())) {
                    print('This record available in the array list');
                  } else {
                    setState(() {
                      videoProvider.watchedVideos
                          .add(videoHistoryData2['paper_name'].toString());
                    });
                  }
                });
              }
            });
          }

          print('Key: $key');
        });
      } else {}
    });
  }

  Future<void> sendVerificationCode({
    String? phone,
    String? code,
  }) async {
    String Url =
        'http://send.ozonedesk.com/api/v2/send.php?user_id=105281&api_key=evj05adndinxxahxh&sender_id=DreamKorea&to=${phone}&message=Your video verification code is ${code}';

    try {
      setState(() {
        isLoading = true;
      });
      var response = await http.get(
        Uri.parse(Url),
      );
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          isSucess = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Verification Code Sent',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please try again later!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Consumer2(
            builder: (BuildContext context, VideoProvider videoProvider,
                    LoginProvider loginProvider, Widget? child) =>
                Column(
              children: [
                SizedBox(
                  height: AppBar().preferredSize.height,
                ),
                Container(
                  width: screenWidth,
                  height: screenHeight / 6,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi, ${loginProvider.userName}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Unlock Your Learning Potential Today!',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: AppColors.grayColor,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          // Icon(
                          //   Icons.person,
                          //   size: 30,
                          //   color: Colors.black,
                          // ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 60, 58, 58),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 7),
                        height: 45,
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: searchController,
                          onChanged: searchVideo,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: const Color.fromARGB(255, 60, 58, 58),
                                width: 0.5,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            hintText: "Search",
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: screenWidth,
                  height: screenHeight / 6 * 5 -
                      (AppBar().preferredSize.height +
                          (Platform.isIOS ? 92 : 70)),
                  //padding: EdgeInsets.symmetric(horizontal: 10),
                  child: videoProvider.noBatch
                      ?
                      // Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      Column(
                          children: [
                            Expanded(
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('InitialVideo')
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

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    Center(
                                      child: Text(
                                        'Loading.....',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  }

                                  if (snapshot.hasData) {
                                    var docs = snapshot.data!.docs;
                                    return ListView.builder(
                                        itemCount: docs.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              if (docs[index]['Accept']) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PlayVideoSampleScreen(
                                                      link:
                                                          '${YoutubePlayer.convertUrlToId(docs[index]['link'])}',
                                                      title: docs[index]
                                                          ['Title'],
                                                      teacher: docs[index]
                                                          ['Teacher'],
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Make payment and try again!',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                              }
                                            },
                                            child: VideoCard(
                                              title: docs[index]['Title'],
                                              teacher: docs[index]['Teacher'],
                                              isAccepted: docs[index]['Accept'],
                                              isWatched: false,
                                            ),
                                          );
                                        });
                                  }
                                  return Text(
                                    'No Videos',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Please Contact Admin for Access',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                launchUrl(
                                    Uri(scheme: 'tel', path: '+94768021182')
                                  // Uri.parse(
                                  //     'https://dreamkoreanacademy.com/contact/'),
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
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) =>
                      //             PlayVideoSampleScreen(
                      //           link: link,
                      //           title: title,
                      //           teacher: teacher,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   child: VideoCard(
                      //     isAccepted: true,
                      //     isWatched: false,
                      //     title: 'title',
                      //     teacher: 'teacher',
                      //   ),
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //         content: Text(
                      //           'Make payment and try again!',
                      //           style: TextStyle(
                      //             fontFamily: 'Poppins',
                      //             fontWeight: FontWeight.w500,
                      //             color: Colors.white,
                      //           ),
                      //         ),
                      //         backgroundColor: Colors.green,
                      //       ),
                      //     );
                      //   },
                      //   child: VideoCard(
                      //     isAccepted: false,
                      //     isWatched: false,
                      //     title: 'Language Basics',
                      //     teacher: 'Mr. Dilan',
                      //   ),
                      // ),

                      // SizedBox(
                      //   height: 150,
                      //   width: 150,
                      //   child: Image.asset('assets/images/admin.png'),
                      // ),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      // Text(
                      //   'Please Contact Admin for Access',
                      //   style: TextStyle(
                      //     fontFamily: 'Poppins',
                      //     fontWeight: FontWeight.w500,
                      //     fontSize: 16,
                      //   ),
                      // ),
                      //   ],
                      //)
                      : videoProvider.paymentDone
                          ? ListView.builder(
                              itemCount: videoProvider.videos.length,
                              itemBuilder: (context, index) {
                                Video video = videoProvider.videos[index];
                                return GestureDetector(
                                  onTap: () async {
                                    if (videoProvider.payment
                                        .contains(video.paymentTerm)) {
                                      // String verificationCode =
                                      //     await generateRandomCode();

                                      // await sendVerificationCode(
                                      //   phone: loginProvider.phoneNumber,
                                      //   code: verificationCode,
                                      // );

                                      //if (isSucess = true) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlayVideoScreen(
                                            link:
                                                '${YoutubePlayer.convertUrlToId(video.link)}',
                                            title: video.title,
                                            teacher: video.teacher,
                                            zoomLink: video.zoomLink,
                                            userID: studentID!,
                                          ),
                                        ),
                                      );
                                      //}
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Make payment and try again!',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  },
                                  child: VideoCard(
                                    isAccepted: videoProvider.payment
                                            .contains(video.paymentTerm)
                                        ? true
                                        : false,
                                    isWatched: videoProvider.watchedVideos
                                            .contains(videoProvider
                                                .videos[index].title)
                                        ? true
                                        : false,
                                    teacher: video.teacher,
                                    title: video.title,
                                  ),
                                );
                              },
                            )
                          : Column(
                              children: [
                                VideoCard(
                                  isAccepted: false,
                                  isWatched: false,
                                  title: 'Language Basics',
                                  teacher: 'Mr.Frenando',
                                ),
                                VideoCard(
                                  isAccepted: false,
                                  isWatched: false,
                                  title: 'Language Basics II',
                                  teacher: 'Mr.Frenando',
                                ),
                              ],
                            ),
                ),
              ],
            ),
          ),
        ),
        isLoading
            ? Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    //borderRadius: BorderRadius.circular(5),
                  ),
                ),
              )
            : SizedBox(),
        isLoading
            ? Positioned(
                top: screenHeight / 2 - 60,
                left: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Please Wait...."),
                    ],
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
