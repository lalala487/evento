
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/BlueButtonWidget.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/Live.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/PostItem.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/TimeAgo.dart';
import 'package:tasty_cookpad/Widget/loader_animation/dot.dart';
import 'package:tasty_cookpad/Widget/loader_animation/loader.dart';
import 'package:tasty_cookpad/model/comment.dart';
import 'package:intl/intl.dart';


class EnterLivePage extends StatefulWidget {
  String img;
  String caption;
  final DateTime time;
  final String live_url;
  final String description;
  EnterLivePage( { this.img ,this.caption , this.time, this.live_url , this.description});

  @override
  _EnterLivePageState createState() => _EnterLivePageState();
}



class _EnterLivePageState extends State<EnterLivePage> {


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mediaQueryData = MediaQuery.of(context).size.height;
    String hour, minute, day;
    if (widget.live_url == null)
    {
      Duration diff = widget.time.difference(DateTime.now());
      day = diff.inDays.toString();
      diff = diff - Duration(days: diff.inDays);
      hour = diff.inHours.toString();
      diff = diff - Duration(hours: diff.inHours);
      minute = diff.inMinutes.toString();

    }
    final f = new DateFormat('EE MMM d ,h a');
    //"FRIDAY AUG 24, 9PM"
    //String date = DateFormat.yMEd().add_jms().format(e.dtFrom);
    String date = f.format(widget.time);
    return Scaffold(

        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(0)),
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
              image:  NetworkImage(widget.img),
              fit: BoxFit.cover,
            )
            ,
          ),
          child:
          Stack(
            children: [
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


              Positioned(
                  bottom: -70,
                  right:  -50,
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new LivePage(
                          ),
                          transitionDuration: Duration(milliseconds: 500),
                          transitionsBuilder:
                              (_, Animation<double> animation, __, Widget child) {
                            return Opacity(
                              opacity: animation.value,
                              child: child,
                            );
                          }));                    },
                    child:
                    Container(
                      width: 200,
                      height: 200,
                      decoration: new BoxDecoration(
                        border: Border.all(color: Colors.white, width: 12),
                        color: Color.fromRGBO(248, 161, 39, 1.0),
                        shape: BoxShape.circle,
                      ),
                      child:
                      widget.live_url!=null?Stack(
                        children: [
                          Positioned(
                              top: 50,
                              left: 50,
                              child:Text("JOIN\nLIVE",
                                  style:TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: "Sofia"
                                  ))),
                          Positioned(
                              top: 60,
                              left: 90,
                              child:ColorLoader5(
                                dotOneColor: Colors.white,
                                dotTwoColor: Colors.white,
                                dotThreeColor: Colors.white,
                                dotType: DotType.icon,
                                radius: 8,
                                padding: 1,
                                dotIcon: Icon(Icons.arrow_forward_ios),
                                duration: Duration(seconds: 1),
                              )),
                        ],
                      ):
                      Stack(
                        children: [
                          Positioned(
                              top: 80,
                              left: 10,
                              child:Text( minute+"\nMinute",
                                  style:TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: "Sofia"
                                  ))),
                          Positioned(
                              top: 50,
                              left: 50,
                              child:Text( hour+ "\nHours",
                                  style:TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: "Sofia"
                                  ))),
                          Positioned(
                              top: 20,
                              left: 80,
                              child:Text(day+"\nDays",
                                  style:TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: "Sofia"
                                  ))),
                        ],
                      )

                    )
                    ,
                  )
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child:  Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(widget.caption,
                            //textAlign: TextAlign.center,
                            style:TextStyle(
                                color: Colors.white,
                                fontFamily: "Sofia",
                                fontSize: 30
                            )
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Text(widget.description,
                            style:TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Sofia"
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Text(date,
                            style:TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: "Sofia"
                            )),
                      ]
                  ),
                ),
              )

            ],
          )
          ,
        )
    );
  }
}
