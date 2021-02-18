import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:tasty_cookpad/Screen/B1_Home_Screen/Detail/detail_recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tasty_cookpad/Style/Style.dart';
import 'TicketDetailFavorite.dart';
import 'package:tasty_cookpad/Screen/B1_Home_Screen/Event.dart';
import 'package:tasty_cookpad/Screen/B1_Home_Screen/Category/EventDetail.dart';

class favoriteScreen extends StatefulWidget {
  String idUser;
  favoriteScreen({this.idUser});

  @override
  _favoriteScreenState createState() => _favoriteScreenState();
}

class _favoriteScreenState extends State<favoriteScreen> {
  bool checkMail = true;
  String mail;

  SharedPreferences prefs;

  Future<Null> _function() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      mail = prefs.getString("username") ?? '';
    });
  }

  ///
  /// Get image data dummy from firebase server
  ///
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/beauty-look.appspot.com/o/Artboard%203.png?alt=media&token=dc7f4bf5-8f80-4f38-bb63-87aed9d59b95");

  ///
  /// check the condition is right or wrong for image loaded or no
  ///
  bool loadImage = true;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        loadImage = false;
      });
    });
    _function();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Column(
        children: [
          Container(
              height: 130,
              width: double.infinity,
              child:
              Stack(
                  children:[
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
                    Align(
                      alignment: Alignment.center,
                      child:
                      Container(
                        width: 120,
                        height: 120,
                        decoration: new BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: null,
                      ),

                    ),
                    Positioned(
                        top: 50,
                        left: MediaQuery.of(context).size.width/2 - 10,
                        child:Text("Favorites",
                          style: TextStyle(
                              color: colorStyle.yellowDark,
                              fontFamily: "",
                              fontSize: 40
                          ),
                        ))
                  ]
              )
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 30.0, bottom: 0.0),
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection("users")
                          .document(widget.idUser)
                          .collection('Bookmark')
                          .snapshots(),
                      builder: (
                          BuildContext ctx,
                          AsyncSnapshot<QuerySnapshot> snapshot,
                          ) {
                        if (!snapshot.hasData) {
                          return noItem();
                        } else {
                          if (snapshot.data.documents.isEmpty) {
                            return noItem();
                          } else {
                            if (loadImage) {
                              return _loadingDataList(
                                  ctx, snapshot.data.documents.length);
                            } else {
                              return new dataFirestore(
                                  userId: widget.idUser,
                                  list: snapshot.data.documents);
                            }

                            //  return  new noItem();
                          }
                        }
                      },
                    )),
                SizedBox(
                  height: 40.0,
                )
              ],
            ),
          ),
        ],
      )

    );
  }
}

Widget cardHeaderLoading(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 500.0,
      width: 275.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Color(0xFF2C3B4F),
      ),
      child: Shimmer.fromColors(
        baseColor: Color(0xFF3B4659),
        highlightColor: Color(0xFF606B78),
        child: Padding(
          padding: const EdgeInsets.only(top: 320.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 17.0,
                width: 70.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                height: 20.0,
                width: 150.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 20.0,
                width: 250.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 20.0,
                width: 150.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

///
///
/// Calling imageLoading animation for set a list layout
///
///
Widget _loadingDataList(BuildContext context, int panjang) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.only(top: 0.0),
      itemCount: panjang,
      itemBuilder: (ctx, i) {
        return loadingCard(ctx);
      },
    ),
  );
}

Widget loadingCard(BuildContext ctx) {
  return Padding(
    padding:
        const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 10.0),
    child: Shimmer.fromColors(
      baseColor: Colors.black38,
      highlightColor: Colors.white,
      child: Row(children: [
        Container(
          height: 100.0,
          width: 100.0,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0)),
          ),
          alignment: Alignment.topRight,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        width: 170.0,
                        height: 18.0,
                        color: Colors.black12,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Icon(
                        Icons.delete,
                        color: Colors.black12,
                        size: 30.0,
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 5.0)),
                  Container(
                    height: 15.0,
                    width: 100.0,
                    color: Colors.black12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.9),
                    child: Container(
                      height: 12.0,
                      width: 140.0,
                      color: Colors.black12,
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ]),
    ),
  );
}

class dataFirestore extends StatelessWidget {
  String userId;
  dataFirestore({this.list, this.userId});
  final List<DocumentSnapshot> list;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var imageOverlayGradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: [
            const Color(0xFF000000),
            const Color(0x00000000),
            Colors.black,
            Colors.black,
            Colors.black,
            Colors.black,
          ],
        ),
      ),
    );

    return SizedBox.fromSize(
//      size: const Size.fromHeight(410.0),
        child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      itemCount: list.length,
      itemBuilder: (context, i) {


        String title = list[i].data['title'].toString();
        String image = list[i].data['image'].toString();
        String id = list[i].data['event_id'].toString();
        String duration = list[i].data['duration'].toString();
        String duration1 = list[i].data['duration1'].toString();
        return InkWell(
          onTap: () async{
            // get event
            DocumentSnapshot snapshot = await  Firestore.instance
                .collection("events").document(id).get();
            Event e = new Event();
            e.readFromList(snapshot);
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
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0, top: 5.0, left: 15.0),
            child:
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: 'hero-tag-${id + title}',
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: Container(
                          height: 70.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(image), fit: BoxFit.cover),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 6.0,
                                  color: Colors.black12.withOpacity(0.05),
                                  spreadRadius: 1.0)
                              //BoxShadow(blurRadius: 0.0, color: Colors.black87)
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            gradient: LinearGradient(
                                colors: [Colors.white, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width -150,
                                child: Text(
                                  title,
                                  style: TextStyle(
                                      color: Colors.black87.withOpacity(1.0),
                                      fontFamily: "",
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w700),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => NetworkGiffyDialog(
                                          image: Image.network(
                                            "https://firebasestorage.googleapis.com/v0/b/cryptocanyon9.appspot.com/o/original.gif?alt=media&token=ee61ee91-1d4b-40c9-91a0-be9c8aef1767",
                                            fit: BoxFit.cover,
                                          ),
                                          title: Text('Delete this ticket?',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Gotik",
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.w600)),
                                          description: Text(
                                            "Are you sure you want to delete " +
                                                title,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Popins",
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black26),
                                          ),
                                          onOkButtonPressed: () {
                                            Navigator.pop(context);


                                            Firestore.instance.runTransaction(
                                                    (transaction) async {
                                                  DocumentSnapshot snapshot =
                                                  await transaction
                                                      .get(list[i].reference);
                                                  await transaction
                                                      .delete(snapshot.reference);
                                                  SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                                  prefs.remove(title);
                                                });
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Delete Event " + title),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 3),
                                            ));
                                          },
                                        ));
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          /*Padding(
                            padding: EdgeInsets.only(top: 5,bottom: 7),
                            child:
                            Text("Brightbike Adventure",
                            style:TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )
                            ),
                          ),*/

                          Padding(
                            padding: EdgeInsets.only(),
                            child:
                            Text(duration,
                                style: TextStyle( fontSize: 10)
                                ,),
                          ),
                          if ( duration1 != "null")
                          Padding(
                            padding: EdgeInsets.only(),
                            child:
                            Text(duration1,
                                style: TextStyle( fontSize: 10)),
                          ),
                          /*
                          Container(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                size: 20.0,
                                color: Colors.yellow,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  rating.toString(),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Sofia",
                                      fontSize: 14.0),
                                ),
                              ),
                              SizedBox(
                                width: 35.0,
                              ),
                            ],
                          ),
                          */
                        ],
                      ),
                    ),

                  ],
                ),
                SizedBox(height:30),
                Divider(
                  indent: 40,
                  endIndent: 40,
                )
              ],
            )

          ),
        );
      },
    ));
  }
}

///
///
/// If no item cart this class showing
///
class noItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: 500.0,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(top: mediaQueryData.padding.top + 0.0)),
            Icon(
              Icons.favorite,
              size: 250,
              color: Colors.black12,
            ),
            Text(
              "No Favorites",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 25.5,
                  color: Colors.black26.withOpacity(0.2),
                  fontFamily: ""),
            ),
          ],
        ),
      ),
    );
  }
}
