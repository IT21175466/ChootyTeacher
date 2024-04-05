import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayVideoScreen extends StatefulWidget {
  final String link;
  final String title;
  final String teacher;
  final String zoomLink;
  final String userID;

  const PlayVideoScreen({
    super.key,
    required this.link,
    required this.title,
    required this.teacher,
    required this.zoomLink,
    required this.userID,
  });

  @override
  State<PlayVideoScreen> createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  bool isFullScreen = false;
  late YoutubePlayerController _controller;

  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('watched_videos');

  String generateRandomId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  // void videoInfoAlertDialog() {
  //   if (Platform.isIOS) {
  //     showCupertinoDialog(
  //       context: context,
  //       builder: (ctx) => CupertinoAlertDialog(
  //         title: Text(
  //           "Video Details",
  //           style: TextStyle(
  //             fontFamily: 'Poppins',
  //             fontWeight: FontWeight.w600,
  //             fontSize: 20,
  //           ),
  //         ),
  //         content: Container(
  //           height: 200,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Spacer(),
  //               Text(
  //                 "${widget.teacher} ",
  //                 style: TextStyle(
  //                   fontFamily: 'Poppins',
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 15,
  //               ),
  //               Expanded(
  //                 child: Text(
  //                   "${widget.title}",
  //                   style: TextStyle(
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ),
  //               Spacer(),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(ctx).pop();
  //             },
  //             child: const Text(
  //               "OK",
  //               style: TextStyle(
  //                 fontFamily: 'Poppins',
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //         title: Text(
  //           "Video Details",
  //           style: TextStyle(
  //             fontFamily: 'Poppins',
  //             fontWeight: FontWeight.w600,
  //             fontSize: 20,
  //           ),
  //         ),
  //         content: Container(
  //           height: 200,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Spacer(),
  //               Text(
  //                 "${widget.teacher} ",
  //                 style: TextStyle(
  //                   fontFamily: 'Poppins',
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 15,
  //               ),
  //               Expanded(
  //                 child: Text(
  //                   "${widget.title}",
  //                   style: TextStyle(
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ),
  //               Spacer(),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(ctx).pop();
  //             },
  //             child: const Text(
  //               "OK",
  //               style: TextStyle(
  //                 fontFamily: 'Poppins',
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.link,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    Future.delayed(Duration(seconds: 5), () {
      setToHistory();
    });
  }

  setToHistory() async {
    await databaseReference.child(widget.userID).child(generateRandomId()).set({
      "studentID": widget.userID,
      "paper_name": widget.title,
    });
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: YoutubePlayerBuilder(
        onExitFullScreen: () {
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: [
              SystemUiOverlay.top,
              SystemUiOverlay.bottom,
            ],
          );
        },
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
        builder: (context, player) => Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            title: Row(
              children: [
                Text(
                  "Video Player",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 19,
                  ),
                ),
                // IconButton(
                //   onPressed: () {
                //     videoInfoAlertDialog();
                //   },
                //   icon: Icon(
                //     Icons.info,
                //     color: Colors.white,
                //     size: 20,
                //   ),
                // ),
                Spacer(),
                widget.zoomLink.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ZoomWebview(),
                          //   ),
                          // );
                          print(widget.zoomLink);
                          setState(() {
                            launchUrl(
                              Uri.parse(widget.zoomLink),
                              mode: LaunchMode.inAppWebView,
                            );
                          });
                        },
                        child: Text(
                          'Zoom Video',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            backgroundColor: Colors.green,
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
          body: Column(
            children: [
              player,
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 55,
                      width: 55,
                      child: Image.asset('assets/images/icon.png'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.teacher,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //isFullScreen
          // ? Container(
          //     height: screenHeight,
          //     width: screenWidth,
          //     color: Colors.black,
          //     child: AspectRatio(
          //       aspectRatio: 16 / 9,
          //       child: YoutubePlayer(
          //         controller: _controller,
          //         showVideoProgressIndicator: true,
          //       ),
          //     ),
          //   )
          // :
          // Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       AspectRatio(
          //         aspectRatio: 16 / 9,
          //         child: YoutubePlayer(
          //           controller: _controller,
          //           showVideoProgressIndicator: true,
          //         ),
          //       ),

          //       // AspectRatio(
          //       //   aspectRatio: 16 / 9,
          //       //   child: VimeoPlayer(
          //       //     videoId: widget.link,
          //       //   ),
          //       // ),

          //       Container(
          //         padding: EdgeInsets.all(15),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               widget.title,
          //               style: TextStyle(
          //                 fontFamily: 'Poppins',
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 20,
          //               ),
          //             ),
          //             Text(
          //               widget.teacher,
          //               style: TextStyle(
          //                 fontFamily: 'Poppins',
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 16,
          //                 color: Colors.grey,
          //               ),
          //             ),
          //             SizedBox(
          //               height: 15,
          //             ),
          //             widget.zoomLink.isNotEmpty
          //                 ? GestureDetector(
          //                     onTap: () {
          //                       // Navigator.push(
          //                       //   context,
          //                       //   MaterialPageRoute(
          //                       //     builder: (context) => ZoomWebview(),
          //                       //   ),
          //                       // );
          //                       print(widget.zoomLink);
          //                       setState(() {
          //                         launchUrl(
          //                           Uri.parse(widget.zoomLink),
          //                           mode: LaunchMode.inAppWebView,
          //                         );
          //                       });
          //                     },
          //                     child: CustomButton(
          //                       text: 'Zoom Video',
          //                       height: 50,
          //                       width: screenWidth / 2,
          //                       backgroundColor: Colors.green,
          //                     ),
          //                   )
          //                 : SizedBox(),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
        ),
      ),
    );
  }
}
