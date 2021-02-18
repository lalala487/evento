import 'dart:async' show Future;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:tasty_cookpad/Style/Style.dart';
import 'package:intl/intl.dart';

class B2PTicket extends StatefulWidget {
  String userID;
  B2PTicket({this.userID});

  @override
  _B2PTicketState createState() => _B2PTicketState();
}



class _B2PTicketState extends State<B2PTicket> {
  int selTab = 0;

  Widget showList(List<DocumentSnapshot> list)
  {
    print( "call showList -- ${list.length}");
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: list.length,
      itemBuilder: (context, i) {
        String eventImage = list[i]["eventImage"];
        String eventTitle = list[i]["name"];
        String eventCategory = list[i]["category"];

        DateTime dtFrom =  list[i]['eventFrom'].toDate();
        dtFrom = dtFrom.toLocal();

        final f = new DateFormat('EEEE d y MMMM h:mm a');
        //String date = DateFormat.yMEd().add_jms().format(e.dtFrom);
        String date = f.format(dtFrom);

        return listTicket(image: eventImage, title: eventTitle, subTitle: eventCategory, date: date,);
      },
    );
  }
  Widget showNoTicket()
  {
    return SingleChildScrollView(
        child:  Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                SizedBox(height:30),
                Image(
                  image: AssetImage( "assets/image/noticket.png"),
                ),
                Text("No tickets bought",
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: "WorkSans",
                      fontWeight: FontWeight.w800,
                      color: Colors.black38
                  ),
                ),
              ]
          ),
        ));
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      Scaffold(
          backgroundColor: Colors.white,
          body:
          Column(
              children:[
                Container(
                    height: 130,
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
                                color: Color.fromRGBO(0, 0, 0, 0.6),
                                shape: BoxShape.circle,
                              ),
                              child: null,
                            ),

                          ),
                          Positioned(
                              top: 40,
                              left: MediaQuery.of(context).size.width/2 - 40,
                              child:Text("Tickets",
                                style: TextStyle(
                                    color: colorStyle.yellowDark,
                                    fontFamily: "Krungthep",
                                    fontSize: 40
                                ),
                              ))
                        ]
                    )
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow:[
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 7,
                            offset: Offset(0, 5), // changes position of shadow
                          ),
                        ]
                    ),
                    height: 40.0,
                    child: Row(
                      children: [
                        SizedBox(
                          width:MediaQuery.of(context).size.width/2-10,
                          child:
                          InkWell(
                              onTap: () {
                                setState(() {
                                  selTab = 0;
                                });
                              },
                              child:  Center(child:
                              Text ("Upcoming",
                                style: TextStyle(
                                    fontFamily: "WorkSans",
                                    fontWeight: FontWeight.bold,
                                    color: selTab == 0?Colors.black:Colors.black38),
                              ),
                              )),
                        ),
                        VerticalDivider (
                          indent: 5,
                          color: Colors.black,
                          endIndent: 5,
                        )
                        ,
                        SizedBox(
                          width:MediaQuery.of(context).size.width/2-10,
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
                            Text ("Past", style: TextStyle(
                                fontFamily: "WorkSans",
                                fontWeight: FontWeight.bold,
                                color: selTab == 1?Colors.black:Colors.black38
                            ),
                            )
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                Expanded(
                    flex: 1,
                    child:
                    selTab==0?
                    StreamBuilder(
                        stream:
                        Firestore.instance
                            .collection("tickets").where("eventFrom", isGreaterThanOrEqualTo:new DateTime.now())
                            .snapshots(),
                        builder: (BuildContext ctx,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          return (snapshot.hasData&&snapshot.data.documents != null)?  snapshot.data.documents.length==0? showNoTicket(): showList(snapshot.data.documents):showNoTicket();
                        })
                    :
                    StreamBuilder(
                        stream:
                        Firestore.instance
                            .collection("tickets").where("eventFrom", isLessThan:new DateTime.now())
                            .snapshots(),
                        builder: (BuildContext ctx,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          return (snapshot.hasData&&snapshot.data.documents != null)? snapshot.data.documents.length ==0? showNoTicket():  showList(snapshot.data.documents):showNoTicket();
                        })

                )

              ]
          )
      );
  }
}

class listTicket extends StatelessWidget
{
  String image;
  String title;
  String subTitle;
  String date;

  listTicket({this.image,this.title,this.subTitle,this.date});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        InkWell(
          onTap: (){
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topRight,
                              child : InkWell(
                                child:Icon( Icons.close,color: colorStyle.yellowDark, size: 50,),
                                onTap: (){
                                  Navigator.of(context).pop();
                                },

                              )
                          ),
                          Expanded(
                            child:
                            Column(
                              children: [
                                Container(
                                  height:MediaQuery.of(context).size.width *0.5,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          topRight: Radius.circular(25.0)),
                                      image: DecorationImage(
                                        colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
                                        image:  NetworkImage(image),
                                        fit: BoxFit.cover,
                                      )
                                  ),
                                  width: double.infinity,
                                  child:null ,
                                ),
                                Container(
                                    height:270,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    width: double.infinity,
                                    child:Column(
                                      children: [
                                        Text( title,
                                            style:TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                            )
                                        ),
                                        SizedBox( height: 10,),
                                        Text(date,
                                            style:TextStyle(
                                              color: Colors.black,
                                            )
                                        ),
                                        SizedBox( height: 10,),
                                        Image.asset("assets/image/sample/bar_code.png"),
                                        SizedBox( height: 10,),
                                        Align(
                                            alignment: Alignment.bottomCenter,
                                            child:
                                            SizedBox(
                                                width: 100,
                                                child:
                                                ButtonTheme(
                                                  minWidth: 200.0,
                                                  height: 24.0,
                                                  child: RaisedButton(
                                                    onPressed: (){

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
                                                          child:  Text("Share")
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                        )
                                      ],
                                    )
                                ),

                              ],
                            )
                            ,

                          )
                        ],
                      )
                  );
                }
            );
          },
          child:  ListTile(
            title: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(subTitle,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child:  Text(title,),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(date,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 8
                    ),
                  ),
                ),
              ],
            ),
            leading: ClipRRect (
                borderRadius: BorderRadius.circular(12),
                child: image!=null? Image(image: NetworkImage(image),):null
            ),
            trailing: Image.asset("assets/image/noticket.png",color: colorStyle.yellowFloatButton,),
          ),
        ),

        Divider(
          indent: 50,
          endIndent: 50,
          color: Colors.black,
        )
      ],
    );
  }
}