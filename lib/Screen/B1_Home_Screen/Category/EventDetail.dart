import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:tasty_cookpad/Screen/B1_Home_Screen/Detail/detail_recipe.dart';
import 'package:tasty_cookpad/Screen/B1_Home_Screen/Event.dart';
import 'package:tasty_cookpad/Screen/B1_Home_Screen/RegisterTicket.dart';
import 'package:tasty_cookpad/Style/Style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class eventDetail extends StatefulWidget {
  Event event;
  eventDetail({this.event});

  @override
  _eventDetailState createState() => _eventDetailState();
}

class _eventDetailState extends State<eventDetail> {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  bool isLogin = false;
  bool isFavorite = false;
  @override
  void initState() {
    getIsLogined();
    super.initState();
  }


  void getIsLogined() async{
    FirebaseUser user  = await FirebaseAuth.instance.currentUser();
    if (user  != null) {
      // check if favorite.
      QuerySnapshot list =  await Firestore.instance
          .collection("users")
          .document(user.uid)
          .collection("Bookmark")
          .where("event_id", isEqualTo:widget.event.id)
          .getDocuments();
      print("get lists : ${list.documents}");
      if (list.documents != null && list.documents.length > 0) {
        print("found favorite");
        isFavorite = true;
      }
      setState(() {
        isLogin = true;
      });

    }
  }
  Widget _about()
  {
    return
      Container(
          color: Colors.white,
          child:
          Column(

            children: [
              new Expanded(
                  flex: 2,

                  child:
                  Padding(
                    padding: EdgeInsets.only(left: 10,right: 10, top: 10, bottom: 10),
                    child:           Scrollbar(
                        child:new SingleChildScrollView(
                          scrollDirection: Axis.vertical,//.horizontal
                          child: new Text(
                             widget.event.about,
                            style: new TextStyle(
                              fontSize: 16.0, color: Colors.black54,
                            ),
                          ),
                        )),

                  )

              ),
              if (widget.event.speaker != null)
                Padding(
                padding: EdgeInsets.only( left: 10, right: 10),
                child:
                SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child:
                          Text("Speakers",style: TextStyle(
                            color: Colors.black,
                          ), textAlign: TextAlign.left,
                          ),
                        ),
                          Expanded(
                            child:
                            ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for ( Map<dynamic, dynamic> data in widget.event
                                    .speaker)
                                  cardSpeaker(title: data["name"],
                                    image: data["image"],),
                                //cardSpeaker(title:"Terry Meyer",image: "assets/image/leaficon/joy.png"),
                                //cardSpeaker(title:"Terry Meyer",image: "assets/image/leaficon/joy.png"),
                                //cardSpeaker(title:"Terry Meyer",image: "assets/image/leaficon/joy.png"),
                              ],
                            ),
                          )
                      ],
                    )

                ),
              )


            ],
          )
      );
  }

  Widget _fee()
  {
    return
      Container(
          color: Colors.white,
          child:
          Scrollbar(
            child:
            ListView(
              scrollDirection: Axis.vertical,
              children: [
                for ( Map<dynamic, dynamic> data in widget.event
                    .tiket)
                  listTicket( r1: data["title"],r2: data["seat"],r3: data["detail"]),
              ],
            ),
          )
      );
  }

  Widget _qa()
  {
    return
      Container(
          color: Colors.white,
          child:
            Scrollbar(
                child:
                    SingleChildScrollView(
                      child:
                      Column(
                        children: [
                          for ( Map<dynamic, dynamic> data in widget.event
                              .q_a)
                            questionList( question: data["question"],answer: data["answer"]),
                        ],
                      )
                      ,
                    )
            )
            ,

      );
  }

  Widget _location()
  {
    return
      Container(
          color: Colors.white,
          child:
              Padding(
                padding: EdgeInsets.all(15),
                child:
                SingleChildScrollView(
                  child:Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child:
                        Text(
                            widget.event.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                            ),
                        ),
                      ),
                      if (widget.event.groupName!=null)
                      Row(
                        children: [
                          Icon(Icons.people,color: Colors.black54,),
                          Text("  by ", style: TextStyle(color: Colors.black54,fontSize: 14),),
                          Text(widget.event.groupName)
                        ],
                      ),
                      Divider(

                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Icon(EvaIcons.bookmark,color: Colors.black54,),
                          Text( widget.event.contact["address"].toString())
                        ],
                      ),
                      /*
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,color: Colors.black54,),
                          Text(" Sun,09 Oct - Start 5:00 am")
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 28,),
                        Text("5 days from now", style: TextStyle(color: Colors.black54,fontSize: 14),),
                      ]),

                       */
                      SizedBox(height: 15,),
                      Container(
                    height: 150,
                        child:  GoogleMap(
                        //onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target:  LatLng( widget.event.latitude,  widget.event.longitude),
                          zoom: 15,
                        ),
                        // markers: _markers.values.toSet(),
                      ),
                  ),


                      Wrap(
                        children:[
                          FlatButton.icon(onPressed: null, icon:Icon(Icons.phone), label:Text(widget.event.contact["phone".toString()])),
                          FlatButton.icon(onPressed: null, icon: Icon(Icons.message), label: Text(widget.event.contact["skype".toString()])),
                          FlatButton.icon(onPressed: null, icon: Icon(Icons.email), label: Text(widget.event.contact["email".toString()])),
                          FlatButton.icon(onPressed: null, icon: Icon(Icons.http), label: Text(widget.event.contact["web".toString()])),
                          //FlatButton.icon(onPressed: null, icon: Icon(Icons.pages), label: Text(" watercyc")),

                        ]
                      )
                    ],
                  ),
                )
                ,
              )
      );
  }
  Widget build(BuildContext context) {
    final f = new DateFormat('d MMMM y  h a');
    //String date = DateFormat.yMEd().add_jms().format(e.dtFrom);
    String date = f.format(widget.event.dtFrom);
    String dateRange = "";
    dateRange = 'FROM ' + date;
    if (widget.event.timeType != "onetime") {
      String date1 = f.format(widget.event.dtTo);
      dateRange += '\nTO ' + date1;
    }
    return
      Stack(
        children: [

          Container(
              width:double.infinity,
              height:MediaQuery.of(context).size.width*0.6,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(0.04),
                      blurRadius: 3.0,
                      spreadRadius: 1.0)
                ],
                color: Color(0xffaaaaaa),
                image: DecorationImage(
                  image:NetworkImage(widget.event.event_image),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: Colors.grey[300], width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child:
              Stack(
                children: [
                  Positioned(
                      left: 0,
                      top:10,
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
                              image: AssetImage("assets/image/back.png"),
                            )
                        ),
                      )

                  ),
                  Positioned(
                      right: 10,
                      top:10,
                      child:
                      ButtonTheme(
                        minWidth: 10.0,
                        height: 10.0,
                        child:FlatButton(
                            onPressed: () async{
                              print("click love!!!");
                              final FirebaseAuth auth = FirebaseAuth.instance;
                              final FirebaseUser user = await auth.currentUser();
                              if ( user == null)
                              {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(""),
                                        content: Text("You can save favorite when you login"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("Ok"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              }
                              else {
                                Firestore.instance
                                    .collection("users")
                                    .document(user.uid)
                                    .collection('Bookmark')
                                    .add({
                                  "event_id": widget.event.id,
                                  "title": widget.event.title,
                                  "duration":widget.event.date,
                                  "duration1":widget.event.date1,
                                  "type":widget.event.timeType,
                                  "image": widget.event.event_image,
                                });
                              }
                            },
                            child:
                            Image(
                              color: isFavorite?Colors.red:Colors.white,
                              image: AssetImage("assets/image/love.png", ),
                            )
                        ),
                      )

                  ),
                  Positioned(
                      right: 10,
                      top:50,
                      child:
                      ButtonTheme(
                        minWidth: 10.0,
                        height: 10.0,
                        child:FlatButton(
                            onPressed: (){
                              print("click share!!");
                              Share.share('Doing this event!!!');
                              },
                            child:
                            Image(
                              image: AssetImage("assets/image/share.png"),
                            )
                        ),
                      )

                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child:
                    Card(
                      color: Color(0xFF0D5C74),
                      child: ListTile(
                        title: Text(widget.event.title,
                            style:TextStyle( color: Colors.white, fontSize: 20)
                        ),
                        subtitle: Text(dateRange, style: TextStyle(color: Colors.white),),

                        trailing:
                            widget.event.icon!=null?
                        ImageIcon(
                          NetworkImage(widget.event.icon),
                          color: Color(0xFF88CAD8),
                          size: 40,
                        ):null,
                      ),
                    )
                    ,
                  ),

                ],
              )

          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.width*0.6),
            child: DefaultTabController(
              length: 4,
              child: Scaffold(
                backgroundColor: Colors.black,
                appBar:
                TabBar(
                  labelColor: Colors.white,
                  indicatorColor:colorStyle.yellowDark,
                  tabs: [
                    Tab(text: 'About'  ),
                    Tab(text: 'Fee'),
                    Tab(text: 'Q&A'),
                    Tab(text: 'Location'),
                  ],
                ),
                body: TabBarView(
                  children: [
                    _about(),
                    _fee(),
                    _qa(),
                    _location(),
                  ],
                ),
              ),
            )
            ,
          ),
        //  (isLogin == true)?
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child:
            Align(
                alignment: Alignment.bottomCenter,
                child:
                SizedBox(
                    height: 44,
                    width: 150,
                    child:
                    ButtonTheme(
                      minWidth: 200.0,
                      height: 24.0,
                      child: RaisedButton(
                        onPressed: (){
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => new BuyTicket( event: widget.event,),
                              transitionDuration: Duration(milliseconds: 1000),
                              transitionsBuilder:
                                  (_, Animation<double> animation, __, Widget child) {
                                return Opacity(
                                  opacity: animation.value,
                                  child: child,
                                );
                              }));
                        },

                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(24.0)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Color(0xffF8A127), Color(0xff7C5114)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(24.0)
                          ),
                          child: Container(
                              constraints: BoxConstraints(maxWidth: 350.0, minHeight: 25.0),
                              alignment: Alignment.center,
                              child:  Text("Buy Ticket")
                          ),
                        ),
                      ),
                    ))
            )
            ,
          )//:Text("")
        ],
      );
  }
}
class questionList extends StatelessWidget{
  String question;
  String answer;
  questionList({this.question, this.answer});
  Widget build(BuildContext context)
  {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            SizedBox(height:20.0),
            ExpansionTile(
              //trailing: SizedBox.shrink(),
              title:
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black54,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child:
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Q: " + question,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black54
                      ),
                    ),
                  )
              )
              ,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(25),
                    child:
                    Text(
                      "Q: "+ question + "\n\n" +
                          "A: " + answer ,
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black54
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class listTicket extends StatelessWidget {
  String r1;
  String r2;
  String r3;
  listTicket ( { this.r1,this.r2,this.r3});
  Widget build(BuildContext context)
  {
    return Column(
      children: [
        ListTile(
            title: Padding(
                padding: EdgeInsets.only(top:15,),
                child:Text(r1 + "\n" + r2,
                    style:TextStyle( color: Colors.black, fontSize: 20)
                )),
            subtitle:
            Padding(
              padding: EdgeInsets.only(top:10,bottom: 10),
              child:
              Text(r3, style: TextStyle(color: Colors.black54),),
            )
        ),
        Divider()
      ],
    );
  }
}

class cardSpeaker extends StatelessWidget {
  String image, title, userId, category;
  cardSpeaker({this.title, this.image, this.userId, this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 4.0, top: 3.0),
      child: InkWell(
        onTap: () {

        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(this.image),
            ),
            Text(
              this.title,
              style: TextStyle(
                  color: Colors.black54
              ),
            )
          ],
        ),
      ),
    );
  }
}
