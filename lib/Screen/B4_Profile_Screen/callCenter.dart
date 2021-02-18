import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasty_cookpad/Style/Style.dart';

class callCenter extends StatefulWidget {
  @override
  _callCenterState createState() => _callCenterState();
}

class _callCenterState extends State<callCenter> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String _name, _email, _problem;
  TextEditingController nama = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController problem = new TextEditingController();

  void addData() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      Firestore.instance.collection("Laporan").add({
        "Name": _name,
        "Email": _email,
        "Your message": _problem,
      });
    });
    _showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text("Contact Us"),
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 12.0, left: 12.0, top: 15.0),
        child: ListView(
          children: <Widget>[
            Text(
              "Contact Us",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xFFFFF8E1),
                  border: Border.all(width: 1.2, color: colorStyle.yellowDark )),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Contact our support team if you have any questions!",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2,
                      fontFamily: "Sans"),
                ),
              ),
            ),
            Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Name",
                    style:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please input your name';
                      }
                    },
                    onSaved: (input) => _name = input,
                    controller: nama,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 16.0,
                        color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.black12.withOpacity(0.01)))

                      ,focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      contentPadding: EdgeInsets.all(13.0),
                      hintText: "",
                      hintStyle: TextStyle(fontFamily: "Sans", fontSize: 15.0),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("Email",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.0)),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please input your email';
                      }
                    },
                    onSaved: (input) => _email = input,
                    controller: email,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 16.0,
                        color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.black12.withOpacity(0.01))),focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      contentPadding: EdgeInsets.all(13.0),
                      hintText: "",
                      hintStyle: TextStyle(fontFamily: "Sans", fontSize: 15.0),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("Message",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.0)),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Please input your problem';
                        }
                      },
                      maxLines: 6,
                      onSaved: (input) => _problem = input,
                      controller: problem,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                          fontFamily: "WorkSansSemiBold",
                          fontSize: 16.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 0.5,
                                color: Colors.black12.withOpacity(0.01))),
                        contentPadding: EdgeInsets.all(13.0),
                        hintText: "",
                        hintStyle:
                        TextStyle(fontFamily: "Sans", fontSize: 15.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  InkWell(
                    onTap: () {
                      final formState = _form.currentState;

                      if (formState.validate()) {
                        formState.save();
                        setState(() {});

                        addData();
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Error"),
                                content: Text("Please input your information"),
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
                    },
                    child: Container(
                      height: 52.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: colorStyle.yellowDark,
                          borderRadius:
                          BorderRadius.all(Radius.circular(40.0))),
                      child: Center(
                        child: Text(
                          "SEND",
                          style: TextStyle(
                              fontFamily: "Sofia",
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  )
                ],
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
    barrierDismissible: false,
    child: SimpleDialog(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: InkWell(
                    onTap: () {
                      var count = 0;
                      Navigator.popUntil(ctx, (route) {
                        print("call pop");
                        return count++ == 2;
                      });
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
                "Please Wait...",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22.0),
              ),
            )),
        Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 40.0, left:30, right:30),
              child: Text(
                "We will review it and return back to you!",
                style: TextStyle(fontSize: 17.0),
              ),
            )),
      ],
    ),
  );
}
