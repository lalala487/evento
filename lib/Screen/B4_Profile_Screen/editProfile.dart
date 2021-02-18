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

class updateProfile extends StatefulWidget {
  String name, password, country, photoProfile, uid, age;
  updateProfile(
      {this.country, this.name, this.photoProfile, this.uid, this.age});

  _updateProfileState createState() => _updateProfileState();
}

class _updateProfileState extends State<updateProfile> {
  TextEditingController nameController, countryController, cityController;
  String name = "";
  String country = "";
  String countryCode = "";
  String city = "Empty City";
  var profilePicUrl;
  String _selectedDate = 'Tap to select date';

  File _image;
  String filename;

  @override
  void initState() {
    if (profilePicUrl == null) {
      setState(() {
        profilePicUrl = widget.photoProfile;
      });
    }
    debugPrint("country:${widget.country}");
    nameController = TextEditingController(text: widget.name);
    countryController = TextEditingController(text: widget.country);
    countryCode = widget.country;

    if (countryCode == "US")
    {
      country = "United States";
    }
    if (countryCode == "CA")
    {
      country = "Canana";
    }
    if (widget.age != null && widget.age !="")
    {
      _selectedDate = widget.age;
    }
    // TODO: implement initState
    super.initState();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    profilePicUrl = dowurl.toString();
    setState(() {
      print("Profile Picture uploaded");
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

  Future selectPhoto() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
        filename = basename(_image.path);
        uploadImage();
      });
    });
  }

  Future uploadImage() async {
    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('profileimage/$filename');

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    await uploadTask.onComplete;
    print('File Uploaded');
    profilePicUrl = dowurl.toString();
    setState(() {
      profilePicUrl = dowurl.toString();
    });
    print("download url = $profilePicUrl");
    return profilePicUrl;
  }

  updateData() async {
    await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .updateData({
      "name": nameController.text,
      "country": countryCode,
      "age":(_selectDate=="Tap to select date")?"":_selectedDate,
      'photoProfile': profilePicUrl.toString(),
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading:
            /*
        FlatButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child:
            Image(
              image: AssetImage("assets/image/yellowback.png"),
              size
            )
        ),*/
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
        title: Text("Edit Profile",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 17.0,
            )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 140.0,
                    width: 140.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        color: Colors.blueAccent,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12.withOpacity(0.1),
                              blurRadius: 10.0,
                              spreadRadius: 4.0)
                        ]),
                    child: _image == null
                        ? new Stack(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 170.0,
                          backgroundImage:
                          NetworkImage(widget.photoProfile),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              selectPhoto();
                            },
                            child: Container(
                              height: 45.0,
                              width: 45.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(50.0)),
                                color: Colors.blueAccent,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                        : new CircleAvatar(
                      backgroundImage: new FileImage(_image),
                      radius: 220.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.only(left:20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child:
                  Text("Name:")
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
                          style: TextStyle(
                              color: Colors.black87, fontFamily: "Sofia"),
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Name',
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
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.only(left:20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child:
                  Text("Country:")
              ),
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
            Padding(
              padding: EdgeInsets.only(left:20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child:
                  Text("Age:")
              ),
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

            /*Padding(
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
                          controller: countryController,
                          decoration: InputDecoration(
                            hintText: 'Where your country?',
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
            SizedBox(
              height: 30.0,
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
                          controller: cityController,
                          decoration: InputDecoration(
                            hintText: 'Where your city?',
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
            ),*/
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 35.0),
              child: InkWell(
                onTap: () {
                  updateData();
                  //  uploadImage();
                  _showDialog(context);
                },
                child: Container(
                  height:45.0,
                  width: double.infinity,
                  child: Center(
                    child: Text("Update Profile",
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
