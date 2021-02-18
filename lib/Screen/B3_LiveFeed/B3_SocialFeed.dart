
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/PostItem.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/TimeAgo.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/Live.dart';
import 'package:tasty_cookpad/Style/Style.dart';

Random random = Random();
List names = [
  "Ling Waldner",
  "Gricelda Barrera",
  "Lenard Milton",
  "Bryant Marley",
  "Rosalva Sadberry",
  "Guadalupe Ratledge",
  "Brandy Gazda",
  "Kurt Toms",
  "Rosario Gathright",
  "Kim Delph",
  "Stacy Christensen",
];

List posts = List.generate(13, (index)=>{
  "name": names[random.nextInt(10)],
  "dp": "assets/dm/images/cm${random.nextInt(10)}.jpeg",
  "time": "${random.nextInt(50)} min ago",
  "img": "assets/dm/images/cm${random.nextInt(10)}.jpeg"
});

class B2ScoailFeed extends StatefulWidget {
  String userID;
  B2ScoailFeed({this.userID});

  @override
  _B2ScoailFeedState createState() => _B2ScoailFeedState();
}





class ListPost extends StatelessWidget {

  final List<DocumentSnapshot> list;
  String rUserId;
  ListPost({ this.list,this.rUserId});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: list.length+1,
      itemBuilder: (context, i) {
        i = i-1;
        if (i == -1)
        {
          return Container(
              height: 200,
              width: double.infinity,
              child:
              Stack(
                  children:[
                    Align(
                      alignment: Alignment.center,
                      child:
                      Container(
                        width: 120,
                        height: 120,
                        decoration: new BoxDecoration(
                          color: Color.fromRGBO(248, 161, 39, 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: null,
                      ),

                    ),
                    Positioned(
                        top: 80,
                        left: MediaQuery.of(context).size.width/2-30,
                        child:Image.asset("assets/image/tab/live.png"),
                    ),

                    Positioned(
                        top: 100,
                        left: MediaQuery.of(context).size.width/2-100,
                        child:Text("LIVE Streaming",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Krungthep",
                              fontSize: 20
                          ),
                        ))
                  ]
              )
          );
        }
        String caption = list[i].data['title'].toString();
        DateTime createTime = list[i].data['createTime'].toDate();
        DateTime liveTime = list[i].data['live_date'].toDate();
        String description = list[i].data['description'].toString();
        String postUrl = list[i].data['banner_image'].toString();
        caption=caption.replaceAll("*", "\n");
        description=description.replaceAll("*", "\n");

        String live_url = null;
        if (list[i].data['live_url'] != null)
          live_url = list[i].data['live_url'].toString();
        bool leftalign = false;
        if (i % 2 == 0)
          leftalign = true;
        return PostItem(
            leftalign:leftalign,
            img: postUrl,
            time: liveTime,
            caption: caption,
            description:description,
            live_url:  live_url,
        );
      },
    );
  }
}

class _B2ScoailFeedState extends State<B2ScoailFeed> {

  @override
  Widget build(BuildContext context) {
    double mediaQueryData = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body:
        StreamBuilder(
            stream: Firestore.instance
                .collection("livestream").orderBy('createTime', descending: true).limit(150)
                .snapshots(),
            builder: (BuildContext ctx,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data == null)
                return Text("");
              return snapshot.data.documents != null?new ListPost(
                list: snapshot.data.documents,rUserId: widget.userID,
              ):Text("loading");
            }),

    );
  }
}
