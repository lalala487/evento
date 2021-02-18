
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/BlueButtonWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tasty_cookpad/main.dart' as main;
import 'package:tasty_cookpad/model/post.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class  LivePage extends StatefulWidget {
  String userID;
  LivePage({this.userID});

  @override
  _LivePageState createState() => _LivePageState();
}



class _LivePageState extends State<LivePage> {
  YoutubePlayerController _controller;
  bool isLoading = true;
  @override
  void initState() {

    String videoId;


    videoId = YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=BBAyRBTfsOU");
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
        isLive: true,
      ),
    );
    print(videoId); //
    super.initState();
    isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {

    double mediaQueryData = MediaQuery.of(context).size.height;
    return Scaffold(

        backgroundColor: Colors.black,
        body:Stack(
          children: [

            /*
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressColors: ProgressBarColors(
                playedColor: Colors.amber,
                handleColor: Colors.amberAccent,
              ),
            ),

             */
            isLoading? Text(""):
          YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
            ),
            builder: (context,player){
              return Column(
                children: [

                  // some widgets
                  player,
                  //some other widgets
                ],
              );
            }
          ),
            Positioned(
                left: 0,
                top:20,
                child:
                ButtonTheme(
                  minWidth: 10.0,
                  height: 10.0,
                  child:FlatButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child:
                      Image(
                        image: AssetImage("assets/image/yellowback.png"),
                      )
                  ),
                )

            ),
          ],
        )

    );
  }
}
