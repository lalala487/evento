import 'dart:async';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasty_cookpad/Screen/B1_Home_Screen/Event.dart';
import 'package:tasty_cookpad/Style/Style.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import 'Category/EventDetail.dart';
import 'Detail/detail_recipe.dart';

class HomeScreenB1 extends StatefulWidget {
  String userID;
  HomeScreenB1({this.userID});

  @override
  _HomeScreenB1State createState() => _HomeScreenB1State();
}

class _HomeScreenB1State extends State<HomeScreenB1> {
  @override
  int selTab = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light));
    Widget logo()
    {
      return  SizedBox
        (
        height:30,
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
          crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
          children: [
            Text(
              "EVENTS",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Krungthep",
                fontSize: 30.0,
              ),),
            SizedBox(
              width:10,
            ),
            Align(
                alignment:  Alignment.bottomRight,
                child:   new Container(
                  width: 15,
                  height: 15,
                  alignment: Alignment.bottomLeft,
                  decoration: new BoxDecoration(
                    color: colorStyle.yellowFloatButton,
                    shape: BoxShape.circle,
                  ),
                  child: null,
                )
            ),

          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Column(
                children: <Widget>[
                  logo(),

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 50.0,
                    ),
                    child: Container(
                        height: 30.0,
                        child: Row(
                          children: [
                            SizedBox(
                              width:MediaQuery.of(context).size.width/4,
                              child:
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      selTab = 0;
                                    });
                                  },
                                  child:  Center(child:
                                  Text ("All",
                                    style: TextStyle(
                                        fontFamily: "Barlow-Medium",
                                        color: selTab == 0?Colors.black:Colors.black38),
                                  ),
                                  )),
                            ),
                            SizedBox(
                              width:MediaQuery.of(context).size.width/4,
                              child:
                              InkWell(
                                onTap: () {
                                  print("seltab clicked");
                                  setState(() {
                                    selTab = 1;
                                  });
                                },
                                child:
                                Center(child:
                                Text ("Sport", style: TextStyle(
                                    fontFamily: "Barlow-Medium",
                                    color: selTab == 1?Colors.black:Colors.black38),
                                )
                                ),
                              ),
                            ),
                            SizedBox(
                              width:MediaQuery.of(context).size.width/4,
                              child:
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selTab = 2;
                                  });
                                },
                                child:  Center(child:Text ("Games",style: TextStyle(
                                    fontFamily: "Barlow-Medium",
                                    color: selTab == 2?Colors.black:Colors.black38)),
                                ),
                              ),
                            ),
                            SizedBox(
                                width:MediaQuery.of(context).size.width/4,
                                child:
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      selTab = 3;
                                    });
                                  },
                                  child:  Center(child:Text ("Tech",style: TextStyle(
                                      fontFamily: "Barlow-Medium",
                                      color: selTab == 3?Colors.black:Colors.black38)),
                                  ),
                                )
                            ),
                          ],
                        )
                    ),

                  ),
                  Container(
                    height: 250,
                    child:
                        selTab == 0?
                    StreamBuilder(
                        stream:
                        Firestore.instance
                            .collection("events").where("time.from", isGreaterThanOrEqualTo:new DateTime.now())
                            .where("time.from", isLessThan: new DateTime.now().add(new Duration(days: 30)))
                            .snapshots(),
                        builder: (BuildContext ctx,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          return (snapshot.hasData&&snapshot.data.documents != null)? new cardEvents(
                            list: snapshot.data.documents,
                          ):Text("");
                        })
                    :selTab == 1?
                        StreamBuilder(
                            stream:
                            Firestore.instance
                                .collection("events")
                                .where("category", isEqualTo: "sport")
                                .where("time.from", isGreaterThanOrEqualTo:new DateTime.now())
                                .where("time.from", isLessThan: new DateTime.now().add(new Duration(days: 30)))
                                .snapshots(),
                            builder: (BuildContext ctx,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              return (snapshot.hasData&&snapshot.data.documents != null)? new cardEvents(
                                list: snapshot.data.documents,
                              ):Text("");
                            })
                    :selTab == 2?
                        StreamBuilder(
                            stream:
                            Firestore.instance
                                .collection("events")
                                .where("category", isEqualTo: "games")
                                .where("time.from", isGreaterThanOrEqualTo:new DateTime.now())
                                .where("time.from", isLessThan: new DateTime.now().add(new Duration(days: 30)))
                                .snapshots(),
                            builder: (BuildContext ctx,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              return (snapshot.hasData&&snapshot.data.documents != null)? new cardEvents(
                                list: snapshot.data.documents,
                              ):Text("");
                            })
                    :StreamBuilder(
                            stream:
                            Firestore.instance
                                .collection("events")
                                .where("category", isEqualTo: "tech")
                                .where("time.from", isGreaterThanOrEqualTo:new DateTime.now())
                                .where("time.from", isLessThan: new DateTime.now().add(new Duration(days: 30)))
                                .snapshots(),
                            builder: (BuildContext ctx,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              return (snapshot.hasData&&snapshot.data.documents != null)? new cardEvents(
                                list: snapshot.data.documents,
                              ):Text("");
                            }),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 2.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0),
                        child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Comming Soon",
                                style: TextStyle(
                                    fontFamily: "Gilroy-ExtraBold",
                                    fontSize: 14.5,
                                    color: Colors.black.withOpacity(0.9),
                                    ),
                              ),
                            ]),
                      ),
                      StreamBuilder(
                          stream: Firestore.instance
                              .collection("events")
                              .where("time.from", isGreaterThanOrEqualTo: new DateTime.now().add(new Duration(days: 30)))
                              .snapshots(),
                          builder: (BuildContext ctx,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            return (snapshot.hasData&&snapshot.data.documents != null)? new cardComming(
                              list: snapshot.data.documents,
                            ):Text("");
                          }),
                    ],
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class cardEvents extends StatelessWidget {

  final List<DocumentSnapshot> list;

  cardEvents({ this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      primary: false,
      itemCount: list.length,
      itemBuilder: (context, i) {
        Event e = new Event();
        e.readFromList(list[i]);


        //e.dtFrom = e.dtFrom.toLocal();
        return Padding(
          padding:
          const EdgeInsets.only(left: 25.0, right: 5.0, bottom: 4.0, top: 3.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new eventDetail(
                      event:e),
                  transitionDuration: Duration(milliseconds: 1000),
                  transitionsBuilder:
                      (_, Animation<double> animation, __, Widget child) {
                    return Opacity(
                      opacity: animation.value,
                      child: child,
                    );
                  }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 243.0,
                  width: MediaQuery.of(context).size.width-50,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 10.0,
                          spreadRadius: 3.0)
                    ],
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300], width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    image: DecorationImage(
                      image:  e.event_image=="null" ? AssetImage(
                          "assets/image/dinner.png"):NetworkImage(e.event_image),
                      fit: BoxFit.cover,
                    )
                    ,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width:double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 13.0,
                                offset: Offset(0,-10),
                                spreadRadius: 10.0)
                          ],
                          color: Colors.transparent,
                        ),
                        child:
                        Padding(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child:  Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text(
                                  e.date
                                  , //+ e.dtFrom.timeZoneOffset.toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Sofia",
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w400),
                                ),
                                e.timeType != "onetime"?

                                Text(
                                  e.date1
                                  , //+ e.dtFrom.timeZoneOffset.toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Sofia",
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w400),
                                ):Text("")
                                ,
                                Text(
                                  e.title,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Sofia",
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.w400),
                                ),

                                SizedBox(
                                  height: 12,
                                )
                              ]
                          ),
                        )
                       ,),


                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class cardComming extends StatelessWidget {

  final List<DocumentSnapshot> list;

  cardComming({ this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      itemCount: list.length,
      itemBuilder: (context, i) {
        Event e = new Event();
        e.readFromList(list[i]);

        return Padding(
          padding:
          const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 4.0, top: 3.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new eventDetail(
                      event:e),
                  transitionDuration: Duration(milliseconds: 1000),
                  transitionsBuilder:
                      (_, Animation<double> animation, __, Widget child) {
                    return Opacity(
                      opacity: animation.value,
                      child: child,
                    );
                  }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 100.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12.withOpacity(0.04),
                          blurRadius: 13.0,
                          spreadRadius: 1.0)
                    ],
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300], width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                      image:  e.event_image=="null" ? AssetImage(
                          "assets/image/dinner.png"):NetworkImage(e.event_image),
                      fit: BoxFit.cover,
                    )
                    ,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: image_banner=="null"?Image.asset(
                              "assets/image/dinner.png",
                              height: 37,
                              width: 37,
                              colorBlendMode: BlendMode.darken,
                            ):Image.network(
                              image_banner,
                              height: 37,
                              width: 37,
                              colorBlendMode: BlendMode.darken,
                            )),
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Center(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black54,
                              fontFamily: "Sofia",
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                       */
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
