import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tasty_cookpad/Screen/B3_Favorite_Screen/B3_Favorite_Screen.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/BlueButtonWidget.dart';

import 'package:tasty_cookpad/Screen/B4_Profile_Screen/callCenter.dart';
import 'package:tasty_cookpad/Screen/B4_Profile_Screen/editProfile.dart';
import 'package:tasty_cookpad/Screen/B4_Profile_Screen/changePassword.dart';

import 'package:tasty_cookpad/Screen/BottomNavBar/NavBarItem.dart';
import 'package:tasty_cookpad/Screen/Login/ChosseLogin.dart';
import 'package:tasty_cookpad/Screen/Login/SignIn.dart';
import 'package:tasty_cookpad/Style/Style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'aboutApps.dart';

class B4ProfileScreen extends StatefulWidget {
  String idUser;
  B4ProfileScreen({this.idUser});

  @override
  _B4ProfileScreenState createState() => _B4ProfileScreenState();
}

class _B4ProfileScreenState extends State<B4ProfileScreen> {
  bool isLogined = false;
  bool isLoading = true;
  String idUser;
  bool isSwitched = false;
  @override
  void dispose() {
    super.dispose();
  }

  ///
  /// Function for if user logout all preferences can be deleted
  ///
  _delete() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
  Scaffold buildNone()
  {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Text("")
    );
  }
  Scaffold buildLogined()
  {
    print("build logined screen ${this.idUser}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(this.idUser)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||  snapshot.data["name"] == null) {
                    return new Stack(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                      width: 150.0,
                                      height: 150.0,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
                                              fit: BoxFit.cover),
                                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 7.0,
                                                color: Colors.black26)
                                          ])),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                    ]);
                  }
                  var userDocument = snapshot.data;
                  var string = userDocument["name"];

                  String getInitials({String string, int limitTo}) {
                    var buffer = StringBuffer();
                    var split = string.split(' ');
                    for (var i = 0; i < (limitTo ?? split.length); i++) {
                      buffer.write(split[i][0]);
                    }

                    return buffer.toString();
                  }

                  var output = getInitials(string: string);


                  isSwitched = userDocument["notification"];
                  return Stack(children: <Widget>[
                    Container(
                      height: 282.0,
                      width: double.infinity,
                      /* decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/image/background10.png",
                              ),
                              fit: BoxFit.cover)),

                      */
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 67.0, left: 0.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    width: 150.0,
                                    height: 150.0,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        image: DecorationImage(
                                            image: NetworkImage(userDocument[
                                            "photoProfile"] !=
                                                null
                                                ? userDocument["photoProfile"]
                                                : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 7.0,
                                              color: Colors.black26)
                                        ])),
                                Text(
                                  userDocument["name"] != null
                                      ? userDocument["name"]
                                      : "Name",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Sofia",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0),
                                ),
                                Text(
                                  userDocument["email"] != null
                                      ? userDocument["email"]
                                      : "Email",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: "Sofia",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                  overflow: TextOverflow.ellipsis,
                                ),

                              ]),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    /*
                    Positioned(
                      top: 40,
                      right:10,
                      child:
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (_, ___, ____) =>
                                new updateProfile(
                                  country: userDocument["country"],
                                  age: userDocument["age"],
                                  name: userDocument["name"],
                                  photoProfile: userDocument[
                                  "photoProfile"] !=
                                      null
                                      ? userDocument["photoProfile"]
                                      : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png",
                                  uid: idUser,
                                )));
                          },
                          child:  Row(
                              children:[
                                Text("Edit"),
                                SizedBox(
                                  width: 10,
                                ),
                                Image.asset("assets/image/edit-button.png")
                              ]
                          )
                      ),

                    ),

                     */
                    Padding(
                        padding: const EdgeInsets.only(top: 290.0),
                        child:
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              InkWell(
                                onTap: (){
                                  bottomNavBarBloc.pickItem(1);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(width:5,color: colorStyle.yellowDark),

                                  ),
                                  width:120,
                                  height:80,
                                  child:
                                  Column(
                                    children:[
                                      SizedBox( height: 10,),
                                      ImageIcon(AssetImage("assets/image/noticket.png"), size:30),
                                      SizedBox( height: 5,),
                                      Text("Ticket")
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                      new favoriteScreen(idUser: idUser,)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(width:5,color: colorStyle.yellowDark),

                                  ),
                                  width:120,
                                  height:80,
                                  child:
                                  Column(
                                    children:[
                                      SizedBox( height: 10,),
                                      Icon(  Icons.favorite ,size: 30, color: Colors.black12,),
                                      SizedBox( height: 5,),
                                      Text("Favorites")
                                    ],
                                  ),
                                ),
                              )
                            ]
                        )),
                        Padding(
                        padding: const EdgeInsets.only(top: 400.0),
                          child:
                          Column(
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(PageRouteBuilder(
                                          pageBuilder: (_, ___, ____) =>
                                          new updateProfile(
                                            country: userDocument["country"],
                                            age: userDocument["age"],
                                            name: userDocument["name"],
                                            photoProfile: userDocument[
                                            "photoProfile"] !=
                                                null
                                                ? userDocument["photoProfile"]
                                                : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png",
                                            uid: idUser,
                                          )));
                                    },
                                  child: Column(
                                    children: <Widget>[
                                      Divider(
                                        color: Colors.black12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 0.0, left: 30.0),
                                        child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 20.0),
                                                  child: Text(
                                                    "Edit Profile",
                                                    style: TextStyle(
                                                      fontSize: 14.5,
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: "Sofia",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 20.0),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.black26,
                                                size: 15.0,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                      Divider(
                                        color: Colors.black12,
                                      )
                                    ],
                                  )
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                          new changePassword(uid: idUser, password: userDocument["password"],)));

                                      /*
                                      Navigator.of(context).push(PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                          new callCenter()));

                                       */
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Divider(
                                          color: Colors.black12,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 0.0, left: 30.0),
                                          child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 20.0),
                                                    child: Text(
                                                      "Change Password",
                                                      style: TextStyle(
                                                        fontSize: 14.5,
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: "Sofia",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 20.0),
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.black26,
                                                  size: 15.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                        Divider(
                                          color: Colors.black12,
                                        )
                                      ],
                                    )
                                ),
                                InkWell(
                                    onTap: () {
//                                      Navigator.of(context).push(PageRouteBuilder(
//                                          pageBuilder: (_, __, ___) =>
//                                          new callCenter()));
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Divider(
                                          color: Colors.black12,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 0.0, left: 30.0),
                                          child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 20.0),
                                                    child: Text(
                                                      "Notification",
                                                      style: TextStyle(
                                                        fontSize: 14.5,
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: "Sofia",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 20.0),
                                                child:
                                                SizedBox(
                                                  height: 20,
                                                  child:
                                                  Switch(
                                                    value: isSwitched,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        isSwitched = value;
                                                        print(isSwitched);
                                                        Firestore.instance.collection("users").document(widget.idUser).updateData(
                                                            {
                                                              "notification": isSwitched
                                                            }
                                                        );
                                                      });
                                                    },
                                                    activeTrackColor: Colors.yellow,
                                                    activeColor: colorStyle.yellowDark,
                                                  ),

                                                )
                                              )
                                            ],
                                          ),
                                        ),

                                        Divider(
                                          color: Colors.black12,
                                        )
                                      ],
                                    )
                                ),
                                SizedBox(height: 30,),
                                Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 150,
                                    child:
                                    BlueButtonWidget(color1: Colors.blue,color2: Colors.blue, text: Text("LOG OUT",style: TextStyle(color: Colors.white,fontSize: 20),),onPressed: (){
                                      _delete();
                                      FirebaseAuth.instance.signOut().then((result) =>

                                          setState((){
                                            isLogined = false;
                                          })
                                      );
                                    },)
                                    ,
                                  ),
                                ),
                              SizedBox(height: 20,)
                            ]
                          )
                        ),
                    /*
                    Padding(
                      padding: const EdgeInsets.only(top: 290.0),
                      child:

                      Column(
                        children: <Widget>[


                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                  new callCenter()));
                            },
                            child: category(
                              txt: "Contact Us",
                              image: "assets/image/callCenter.png",
                              padding: 20.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                  new aboutApps()));
                            },
                            child: category(
                              txt: "About",
                              image: "assets/image/phone.png",
                              padding: 20.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _delete();
                              FirebaseAuth.instance.signOut().then((result) =>

                                  setState((){
                                    isLogined = false;
                                  })
                              );
                            },
                            child: category(
                              txt: "Log Out",
                              image: "assets/image/logout.png",
                              padding: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),*/
                  ]);
                }),
          ],
        ),
      ),
    );
  }

  void initState()
  {
    /*
    _delete();
    FirebaseAuth.instance.signOut().then((result) =>

        setState((){
          isLogined = false;
        })
    );*/
    print("call init");
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {

      if (currentUser == null)
        {
          isLogined = false,
          //Navigator.of(context).pushReplacement(PageRouteBuilder(
          //  pageBuilder: (_, __, ___) => OnboardingScreen(),
          //))
          print("this case!!!!!!!!!!!!!!!!!!")
        }
      else
        {
          isLoading = false,
          widget.idUser = currentUser.uid,
          idUser = currentUser.uid,
          print("debug-------------- ${ currentUser.uid}"),
          isLogined = true,
          Firestore.instance
              .collection("users")
              .document(currentUser.uid)
              .get()
              .then((DocumentSnapshot result) =>{})
              .catchError((err) => print(err))
        },
      isLoading = false,
      setState(() {
      }),


    })
        .catchError((err) => print(err));
    super.initState();
  }
  Widget build(BuildContext context) {

    return isLoading?buildNone():isLogined?buildLogined():SignIn();
  }
}

/// Component category class to set list
class category extends StatelessWidget {
  @override
  String txt, image;
  GestureTapCallback tap;
  double padding;

  category({this.txt, this.image, this.tap, this.padding});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: padding),
                      child: Image.asset(
                        image,
                        height: 25.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        txt,
                        style: TextStyle(
                          fontSize: 14.5,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Sofia",
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black26,
                    size: 15.0,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Divider(
            color: Colors.black12,
          )
        ],
      ),
    );
  }

}
