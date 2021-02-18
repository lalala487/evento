import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:tasty_cookpad/Style/Style.dart';

class changePassword extends StatefulWidget {
  String password;
  String uid;
  changePassword(
      {this.password, this.uid});

  _changePasswordState createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  TextEditingController passwordController, newPasswordController, retryPasswordController;

  final GlobalKey<FormState> _changePasswordFormKey = GlobalKey<FormState>();

  @override
  void initState() {

    passwordController = TextEditingController(text: "");
    newPasswordController = TextEditingController(text: "");
    retryPasswordController = TextEditingController(text: "");

    // TODO: implement initState
    super.initState();
  }

  updateData() async {
    await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .updateData({
      "password": retryPasswordController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading:
        InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child:
            Image(
                image: AssetImage("assets/image/yellowback.png"),
            )
        )
            ,

        elevation: 0.0,
        title: Text("Change Password",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 17.0,
            )),
        centerTitle: true,
      ),
      body:
      SingleChildScrollView(
        child:
        Form(
          key: _changePasswordFormKey,
          child:   Column(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: EdgeInsets.only(left:20),
                child: Align(
                    alignment: Alignment.topLeft,
                    child:
                    Text("Current Password:")
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10.0,
                            color: Colors.black12.withOpacity(0.1)),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(40.0))),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Theme(
                        data: ThemeData(
                          highlightColor: Colors.white,
                          hintColor: Colors.white,
                        ),
                        child: TextFormField(
                          validator: (input) {
                            if (input != widget.password) {
                              return 'password is wrong';
                            }
                          },
                          //onSaved: (input) => _pass = input,
                          controller: passwordController,
                          style:
                          new TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          keyboardType:
                          TextInputType.emailAddress,
                          autocorrect: false,
                          autofocus: false,
                          obscureText: true,
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
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.only(left:20),
                child: Align(
                    alignment: Alignment.topLeft,
                    child:
                    Text("New Password:")
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10.0,
                            color: Colors.black12.withOpacity(0.1)),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(40.0))),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Theme(
                        data: ThemeData(
                          highlightColor: Colors.white,
                          hintColor: Colors.white,
                        ),
                        child: TextFormField(

                            style: TextStyle(
                                color: Colors.black87, fontFamily: "Sofia"),
                            controller: newPasswordController,
                            enableSuggestions: false,
                            autocorrect: false,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'password',
                              hintStyle: TextStyle(
                                  color: Colors.black54, fontFamily: "Sofia"),
                              enabledBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                    style: BorderStyle.none),
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left:20),
                child: Align(
                    alignment: Alignment.topLeft,
                    child:
                    Text("Retype Password:")
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10.0,
                            color: Colors.black12.withOpacity(0.1)),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(40.0))),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Theme(
                        data: ThemeData(
                          highlightColor: Colors.white,
                          hintColor: Colors.white,
                        ),
                        child:
                        TextFormField(
                          validator: (input) {
                            if (input != newPasswordController.text) {
                              return 'password is not same';
                            }
                            if (input.length < 6)
                              return 'password length  must be more than 6';
                          },
                          //onSaved: (input) => _pass = input,
                          controller: retryPasswordController,
                          style:
                          new TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          keyboardType:
                          TextInputType.emailAddress,
                          autocorrect: false,
                          autofocus: false,
                          obscureText: true,
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
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                child: InkWell(
                  onTap: () {
                    final formState =
                        _changePasswordFormKey.currentState;
                        if (formState.validate()) {
                          formState.save();
                          updateData();
                          _showDialog(context);
                        }
                    //updateData();
                    //  uploadImage();
                    //_showDialog(context);
                  },
                  child: Container(
                    height:45.0,
                    width: double.infinity,
                    child: Center(
                      child: Text("Change Password",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0,
                              fontFamily: "Sofia")),
                    ),
                    decoration: BoxDecoration(
                      color: colorStyle.yellowDark,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )

      ),
    );
  }
}

/// Card Popup if success payment
_showDialog(BuildContext ctx) {
  showDialog(
    context: ctx,
    barrierDismissible: true,
    child: SimpleDialog(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: InkWell(
                    onTap: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Icon(
                      Icons.close,
                      size: 30.0,
                    ))),
            SizedBox(
              width: 10.0,
            )
          ],
        ),
        Container(
            padding: EdgeInsets.only(top: 30.0, right: 60.0, left: 60.0),
            color: Colors.white,
            child: Icon(
              Icons.check_circle,
              size: 150.0,
              color: colorStyle.yellowDark,
            )),
        Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                "Succes",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22.0),
              ),
            )),
        Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 40.0),
              child: Text(
                "Update Profile Succes",
                style: TextStyle(fontSize: 17.0),
              ),
            )),
      ],
    ),
  );
}
