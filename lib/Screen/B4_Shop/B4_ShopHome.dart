
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/PostItem.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/TimeAgo.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/Live.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/ProductDetail.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/details/details_screen.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/models/Product.dart';
import 'package:tasty_cookpad/Style/Style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

class B3ShopHome extends StatefulWidget {
  String userID;
  B3ShopHome({this.userID});

  @override
  _B3ShopHomeState createState() => _B3ShopHomeState();
}

/*
List Category = [
  "Sportstyle",
  "Training",
  "Outdoor",
];*/


class _B3ShopHomeState extends State<B3ShopHome> {
  int state = 0;
  String categoryName ="";
  String categroyId = "";
  List<DocumentSnapshot> list;
  String rUserId;
  List<String> favourites = List();
  SharedPreferences prefs;

  static String encode(List<String> favorites) => json.encode(
    favorites
  );

  static List<String> decode(String favorites) => (json.decode(favorites) as List<dynamic>)
      .map<String>((item) => item)
      .toList();
  void initState()
  {
    super.initState();
    loadFavorite();
  }
  void loadFavorite() async{
    prefs = await SharedPreferences.getInstance();
    String fav = "";
    fav = prefs.getString("fav_shop");
    if (fav == null)
      fav = "[]";
    print("favorites is $fav");
    favourites = decode(fav);
  }
  void saveFavorite(String id ){
    favourites.add(id);
    String en = encode(favourites);
    print("en:$en");
    prefs.setString("fav_shop", en);
    setState(() {

    });
  }
  void removeFavorite(String id){
    favourites.removeWhere((element) => element == id);
    String en = encode(favourites);
    print("en:$en");
    prefs.setString("fav_shop", en);
    setState(() {

    });
  }
  Widget buildTile(DocumentSnapshot snapshot)
  {
    Product product = new Product();
    product.readFromList(snapshot);
    bool isFavorite = false;
    if (favourites.indexOf( product.id ) >= 0 )
      isFavorite = true;
    product.isFavourite = isFavorite;
    return Expanded(
        child: Padding(
          padding: EdgeInsets.all(20),
          child:  InkWell(
            onTap: (){
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new DetailsScreen1(
                    product:product,
                  ),
                  transitionDuration: Duration(milliseconds: 1000),
                  transitionsBuilder:
                      (_, Animation<double> animation, __, Widget child) {
                    return Opacity(
                      opacity: animation.value,
                      child: child,
                    );
                  }));
            },
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 180,
                    width: double.infinity,

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 0.5,
                              offset: Offset(0.0,1.0),
                              spreadRadius: 1.0)
                        ],
                        image: DecorationImage(
                          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
                          image:  NetworkImage(snapshot["image"]),
                          fit: BoxFit.contain,
                        )
                    ),
                    child: Align(
                        alignment: Alignment.topRight,
                        child:
                        IconButton(
                          icon:Icon(Icons.favorite,
                            color:
                            isFavorite? Colors.redAccent:
                            Colors.black26,),
                          onPressed: () async{
                            // save favorite list.
                            if (isFavorite)
                              removeFavorite(product.id);
                            else
                              saveFavorite(product.id);
                          },
                        )
                    )) ,
                Padding(
                  padding: EdgeInsets.only(left:29, top: 5),
                  child:
                  Text(snapshot["productName"],
                    style: TextStyle(
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:29,top: 5),
                  child:
                  Text("\$"+ snapshot["price"],
                    style: TextStyle(
                        color: Colors.black54
                    ),
                  ),
                )

              ],

            ) ,
          )

        )
    );
  }
  Widget buildByCategory()
  {
    return
    SingleChildScrollView(
      child:
      Column
        (
        children: [
          Container(
              height: 120,
              width: double.infinity,
              child:
              Stack(
                  children:[
                    Positioned(
                      top: 70,
                      left: MediaQuery.of(context).size.width/2+50,
                      child:
                      Container(
                        width: 15,
                        height: 15,
                        decoration: new BoxDecoration(
                          color: Color.fromRGBO(248, 161, 39, 1.0),
                          shape: BoxShape.circle,
                        ),
                        child: null,
                      ),

                    ),
                    Positioned(
                      top: 40,
                      left: MediaQuery.of(context).size.width/2+45,
                      child:Image.asset("assets/image/cart.png" , scale: 1.0,),
                    ),

                    Positioned(
                        top: 50,
                        left: MediaQuery.of(context).size.width/2-50,
                        child:Text("STORE",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Krungthep",
                              fontSize: 30
                          ),
                        ))

                  ]
              )
          ),
          Align(
            alignment: Alignment.centerLeft,
            child:ButtonTheme(
              minWidth: 10.0,
              height: 10.0,
              child:
              FlatButton(
                  onPressed: (){
                    setState(() {
                      state = 0;
                    });

                  },
                  child:
                  Image(
                    image: AssetImage("assets/image/yellowback.png"),
                    width: 15,
                    height: 15,
                  )
              ),
            ) ,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child:
              IntrinsicHeight(
                child: Row(
                    children:[
                      SizedBox(
                        width:15,
                      ),
                      Text("Store", style: TextStyle(color:  Colors.black54),),

                      VerticalDivider(
                        color: Colors.black,
                        indent: 0,
                        endIndent: 0,
                      ),

                      Text(categoryName)
                    ]
                ),
              )

          ),
        StreamBuilder(
            stream:   Firestore.instance
                .collection("StoreItems").where("shopCategory", isEqualTo: categroyId)
                .snapshots(),
            builder: (BuildContext ctx,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData){
                return Text("");
              }
              List<DocumentSnapshot> list = snapshot.data.documents;
              for (int i=0; i < snapshot.data.documents.length; i+=2)
              {
                if (i == snapshot.data.documents.length-1)
                {
                  return Row(
                      children: [
                        buildTile(list[i]),
                        Expanded(
                            child: Text(""),
                        )
                      ]);
                }
                return Row(
                  children: [
                    buildTile(list[i]),
                    buildTile(list[i+1])
                  ],
                );
              }
              return Text("");
            }
        )
          /*
          for (int i =0; i<5; i++)
            Row(
                children:[
                  buildTile(),
                  buildTile()
                ]
            )

           */
        ],
      )
    );

  }
  Widget buildHome() {
    return
      state==0?
      ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 0),
        itemCount: 3+1,
        itemBuilder: (context, i) {
          i = i-1;
          if (i == -1)
          {
            return Container(
                height: 120,
                width: double.infinity,
                child:
                Stack(
                    children:[
                      Positioned(
                        top: 70,
                        left: MediaQuery.of(context).size.width/2+50,
                        child:
                        Container(
                          width: 15,
                          height: 15,
                          decoration: new BoxDecoration(
                            color: Color.fromRGBO(248, 161, 39, 1.0),
                            shape: BoxShape.circle,
                          ),
                          child: null,
                        ),

                      ),
                      Positioned(
                        top: 40,
                        left: MediaQuery.of(context).size.width/2+45,
                        child:Image.asset("assets/image/cart.png" , scale: 1.0,),
                      ),

                      Positioned(
                          top: 50,
                          left: MediaQuery.of(context).size.width/2-50,
                          child:Text("STORE",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Krungthep",
                                fontSize: 30
                            ),
                          ))
                    ]
                )
            );
          }

          String title = list[i].data['title'].toString();
          String value = list[i].data['value'].toString();
          String postId = list[i].documentID;
          String postUrl = list[i].data['image'].toString();

          return  InkWell(
              onTap: (){
                categoryName = title;
                categroyId = value;
                setState(() {
                  state = 1;
                });
              },
              child:
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20) ,
                child: Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  height: MediaQuery.of(context).size.width*0.4,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 10.0,
                          spreadRadius: 3.0)
                    ],
                    color: Colors.black,
                    border: Border.all(color: Colors.grey[300], width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.2)),
                    image: DecorationImage(
                      colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
                      image:  NetworkImage(postUrl),
                      fit: BoxFit.cover,
                    )
                    ,
                  ),
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          SizedBox(
                            height: 10,
                          ),
                          Text(title,
                              style:TextStyle(
                                  shadows:[
                                    Shadow(
                                      blurRadius: 3.0,
                                      color: Colors.black,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                  color: Colors.white,
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "DINPro"
                              )),
                        ]
                    ),
                  ),
                ),
              )

          );
        },
      )
          :buildByCategory();
  }
  @override
  Widget build(BuildContext context) {
    double mediaQueryData = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body:
      StreamBuilder(
          stream: Firestore.instance
              .collection("shopcategory")
              .snapshots(),
          builder: (BuildContext ctx,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data == null)
              return Text("");
            list = snapshot.data.documents;
            return snapshot.data.documents != null?buildHome(
            ):Text("loading");
          }),

    );
  }
}


