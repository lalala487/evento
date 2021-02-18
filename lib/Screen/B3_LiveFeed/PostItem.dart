import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/EnterLive.dart';
import 'package:intl/intl.dart';

class PostItem extends StatefulWidget {
  final String caption;
  final DateTime time;
  final String img;
  final String description;
  final bool leftalign;
  final String live_url;
  PostItem({
    Key key,
    @required this.time,
    @required this.caption,
    @required this.img,
    @required this.leftalign,
    @required this.live_url,
    @required this.description
  }) : super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('EE MMM d ,h a');
    //"FRIDAY AUG 24, 9PM"
    //String date = DateFormat.yMEd().add_jms().format(e.dtFrom);
    String date = f.format(widget.time);
    return InkWell(
      onTap: (){
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => new EnterLivePage(
              img: widget.img,
              caption: widget.caption,
              time: widget.time,
              live_url: widget.live_url,
              description:widget.description
            ),
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            }));
      },
      child:  Align(
        alignment: widget.leftalign?Alignment.centerLeft:Alignment.centerRight,
        child: Container(
          width: MediaQuery.of(context).size.width*0.6,
          height: MediaQuery.of(context).size.width*0.6,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 10.0,
                  spreadRadius: 3.0)
            ],
            color: Colors.black,
            border: Border.all(color: Colors.grey[300], width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.3)),
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
              image:  NetworkImage(widget.img),
              fit: BoxFit.cover,
            )
            ,
          ),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Text(widget.caption,
                      style:TextStyle(
                          color: Colors.white,
                          fontFamily: "Sofia",
                          fontSize: 17
                      ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  widget.live_url != null ?
                  Text("LIVE On",
                      style:TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "Sofia"
                      )) : Text(""),
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
        ),
      ),
    );


  }
}
