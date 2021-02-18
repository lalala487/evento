import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/BlueButtonWidget.dart';
import 'package:tasty_cookpad/Screen/BottomNavBar/BottomNavBar.dart';
import 'package:tasty_cookpad/Widget/loader_animation/dot.dart';
import 'package:tasty_cookpad/Widget/loader_animation/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'SignIn.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  String country = "";
  String countryCode = "";
  String _selectedDate = 'Tap to select date';
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  String _email, _pass, _pass2, _name;
  var profilePicUrl;
  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
  new TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ?

      ///
      /// Loading layout login
      ///
      Center(
          child: ColorLoader5(
            dotOneColor: Colors.lightGreen[400],
            dotTwoColor: Colors.yellow[700],
            dotThreeColor: Colors.lime[700],
            dotType: DotType.circle,
            dotIcon: Icon(Icons.adjust),
            duration: Duration(seconds: 1),
          ))
          : SingleChildScrollView(
        child: Stack(
          children: <Widget>[

            Container(
              height: _height,
              width: double.infinity,
              decoration:
              BoxDecoration(color: Colors.black12.withOpacity(0.05)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Container(
                height: 700,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                    color: Colors.white),
                child: Form(
                  key: _registerFormKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        "Create Account",
                        style: TextStyle(
                            fontFamily: "Sofia",
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 28.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 40.0),
                        child: Container(
                          height: 53.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 6.0,
                                  color: Colors.black12.withOpacity(0.05),
                                  spreadRadius: 1.0)
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 5.0),
                            child: Theme(
                              data: ThemeData(
                                  hintColor: Colors.transparent),
                              child: Padding(
                                padding:
                                const EdgeInsets.only(left: 10.0),
                                child: TextFormField(
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Please input your name';
                                    }
                                  },
                                  onSaved: (input) => _name = input,
                                  controller: signupNameController,
                                  style:
                                  new TextStyle(color: Colors.black),
                                  textAlign: TextAlign.start,
                                  keyboardType:
                                  TextInputType.emailAddress,
                                  autocorrect: false,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(0.0),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      labelText: 'Nickname',
                                      hintStyle: TextStyle(
                                          color: Colors.black38),
                                      labelStyle: TextStyle(
                                        fontFamily: "Sofia",
                                        color: Colors.black38,
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 15.0),
                        child: Container(
                          height: 53.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 6.0,
                                  color: Colors.black12.withOpacity(0.05),
                                  spreadRadius: 1.0)
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 5.0),
                            child: Theme(
                              data: ThemeData(
                                  hintColor: Colors.transparent),
                              child: Padding(
                                padding:
                                const EdgeInsets.only(left: 10.0),
                                child: TextFormField(
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Please input your email';
                                    }
                                  },
                                  onSaved: (input) => _email = input,
                                  controller: signupEmailController,
                                  style:
                                  new TextStyle(color: Colors.black),
                                  textAlign: TextAlign.start,
                                  keyboardType:
                                  TextInputType.emailAddress,
                                  autocorrect: false,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(0.0),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      labelText: 'Email',
                                      hintStyle: TextStyle(
                                          color: Colors.black38),
                                      labelStyle: TextStyle(
                                        fontFamily: "Sofia",
                                        color: Colors.black38,
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 15.0),
                        child: Container(
                          height: 53.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 6.0,
                                  color: Colors.black12.withOpacity(0.05),
                                  spreadRadius: 1.0)
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 5.0),
                            child: Theme(
                              data: ThemeData(
                                  hintColor: Colors.transparent),
                              child: Padding(
                                padding:
                                const EdgeInsets.only(left: 10.0),
                                child: TextFormField(
                                  controller: signupPasswordController,
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Please input your password';
                                    }
                                    if (input.length < 6) {
                                      return 'Password should be more than 8 characters';
                                    }
                                  },
                                  onSaved: (input) => _pass = input,
                                  style:
                                  new TextStyle(color: Colors.black),
                                  textAlign: TextAlign.start,
                                  keyboardType:
                                  TextInputType.emailAddress,
                                  autocorrect: false,
                                  obscureText: true,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(0.0),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      labelText: 'Password',
                                      hintStyle: TextStyle(
                                          color: Colors.black38),
                                      labelStyle: TextStyle(
                                        fontFamily: "Sofia",
                                        color: Colors.black38,
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child:
                          SizedBox(
                              width:double.infinity,
                              child: RaisedButton(
                                onPressed: () {
                                  showCountryPicker(
                                    context: context,
                                    //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                    countryFilter: <String>['US', 'CA'],
                                    //Optional. Shows phone code before the country name.
                                    showPhoneCode: true,
                                    onSelect: (Country c) {
                                      final g = c.name;
                                      countryCode = c.countryCode;

                                      setState(() {
                                        country = g;
                                      });
                                      print('Select country: ${c.countryCode}');
                                    },
                                  );
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),

                                child: country==""?const Text('Select Country'): Text(country),
                              ))

                      ),
                      Padding (
                        padding: EdgeInsets.only(left:20, right:20),
                        child: Container(

                          decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(width: 1.0, color: Colors.black),
                                left: BorderSide(width: 1.0, color: Colors.black),
                                right: BorderSide(width: 1.0, color: Colors.black),
                                bottom: BorderSide(width: 1.0, color: Colors.black),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(25))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left:20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                InkWell(
                                  child: Text(
                                      _selectedDate,
                                      textAlign: TextAlign.center,
                                      style:
                                      countryCode != ""?
                                      TextStyle(color: Color(0xFF000000))
                                          :TextStyle(color: Color(0xFF777777))
                                  ),
                                  onTap: (){
                                    _selectDate(context);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  tooltip: 'Tap to open to select Birthday',
                                  color: countryCode != ""?
                                  Color(0xFF000000)
                                      : Color(0xFF777777),
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:20,right: 20),
                        child: Text("by accessing this app, you accept the Terms of Use and Privacy Policy"),
                      ),

                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 24.0),
                          child:
                          Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                  width: 250,
                                  child:
                                  BlueButtonWidget(color1: Colors.blue,color2: Colors.blue, text: Text("SIGN UP",style: TextStyle(color: Colors.white,fontSize: 20),),onPressed: ()async {
                                    SharedPreferences prefs;
                                    prefs = await SharedPreferences.getInstance();
                                    final formState =
                                        _registerFormKey.currentState;
                                    if (formState.validate()) {
                                      formState.save();
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {

                                        prefs.setString("username", _name);
                                        prefs.setString("email", _email);
                                        prefs.setString(
                                            "photoURL", profilePicUrl.toString());
                                        FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                            email: signupEmailController.text
                                                .trim(),
                                            password:
                                            signupPasswordController.text)
                                            .then((currentUser) => Firestore
                                            .instance
                                            .collection("users")
                                            .document(currentUser.user.uid)
                                            .setData({
                                          "uid": currentUser.user.uid,
                                          "name":
                                          signupNameController.text,
                                          "email":
                                          signupEmailController.text,
                                          "password":
                                          signupPasswordController
                                              .text,
                                          "country": countryCode,
                                          "age":(_selectDate=="Tap to select date")?"":_selectedDate
                                        })
                                            .then((result) => {
                                          Navigator.of(context)
                                              .pushReplacement(
                                              PageRouteBuilder(
                                                  pageBuilder: (_,
                                                      __,
                                                      ___) =>
                                                  new BottomNavBar(
                                                    idUser:
                                                    currentUser
                                                        .user.uid,
                                                  ))),
                                        })
                                            .catchError((err) => print(err)))
                                            .catchError((err) => print(err));
                                      } catch (e) {
                                        print(e.message);
                                        print(_email);
                                        print(_pass);
                                      }
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Error"),
                                              content: Text("missing fields"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("Close"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    }
                                  })))
                      ),


                      SizedBox(
                        height: 18.0,
                      ),
                      //-----------
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Already a member?",
                              style: TextStyle(
                                  fontFamily: "Sofia",
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0),
                            ),
                            Text(" Sign In",
                                style: TextStyle(
                                    fontFamily: "Sofia",
                                    color: Color(0xFFF3B61F),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15.0))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    debugPrint("countrycode is :$countryCode");
    if (countryCode != "" && countryCode != null) {
      int miniumAge = 19;
      if (countryCode == "US")
        miniumAge = 21;
      final DateTime d = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year - miniumAge),
        firstDate: DateTime(DateTime.now().year - miniumAge- 100),
        lastDate: DateTime(DateTime.now().year - miniumAge),
      );
      if (d != null)
        setState(() {
          _selectedDate = new DateFormat.yMMMMd("en_US").format(d);
        });
    }
    else {

      showDialog(
          context: context,
          builder: (BuildContext context) =>
          new CupertinoAlertDialog(
              title: new Text("Alert"),
              content: new Text(
                  "Please select country first."),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]));
      debugPrint("hey!!!");
    }

  }
}
