import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/BlueButtonWidget.dart';
import 'package:tasty_cookpad/Screen/BottomNavBar/BottomNavBar.dart';
import 'package:tasty_cookpad/Widget/loader_animation/dot.dart';
import 'package:tasty_cookpad/Widget/loader_animation/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasty_cookpad/model/user.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'dart:io' show Platform;
import 'package:tasty_cookpad/Style/Style.dart';

import 'SignUp.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  _SignInState();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignInAccount _currentUser;

  bool isLoading = false;

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  String _email, _pass, _email2, _pass2, _name, _id;

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _loginGoogle();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _loginGoogle() async {
    setState(() {
      isLoading = true;
    });
    GoogleSignInAuthentication googleAuth;
    try {
      googleAuth = await _currentUser.authentication;
    } catch (e) {
      print('Error: $e');
    }
    if (googleAuth.accessToken != null && googleAuth.idToken != null) {
      final AuthResult authResult = await _firebaseAuth
          .signInWithCredential(GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ))
          .then(
            (authResult) => Firestore.instance
                .collection("users")
                .document(authResult.user.uid)
                .setData({
              "photoProfile": authResult.user.photoUrl,
              "uid": authResult.user.uid,
              "name": authResult.user.displayName,
              "email": authResult.user.email,
              "password": "",
              "type": "gmail",
            }).then((value) =>
                    Navigator.of(context).pushReplacement(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new BottomNavBar(
                              idUser: authResult.user.uid,
                            )))),
          );
    } else {
      throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token');
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> applePressed() async{
    FirebaseUser user = await signInWithApple()
        .then((currentUser) => Firestore
        .instance
        .collection("users")
        .document(currentUser.uid)
        .setData({
      "photoProfile":
      currentUser.photoUrl,
      "uid": currentUser.uid,
      "name": currentUser.displayName,
      "email": currentUser.email,
      "password": "",
      "type": "apple",
    }).then((value) => Navigator.of(
        context)
        .pushReplacement(
        PageRouteBuilder(
            pageBuilder: (_, __,
                ___) =>
            new BottomNavBar(
              idUser:
              currentUser
                  .uid,
            )))));

  }
  Future<FirebaseUser> signInWithApple({List<Scope> scopes = const []}) async {
    final AuthorizationResult result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider(providerId: 'apple.com');
        final credential = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );

        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        if (scopes.contains(Scope.fullName)) {
          final updateUser = UserUpdateInfo();
          updateUser.displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await firebaseUser.updateProfile(updateUser);
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );
      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
    }
    return null;
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Future<FirebaseUser> signInWithGoogle() async {
    try {
      _currentUser =  await _googleSignIn.signIn();
      _loginGoogle();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: ColorLoader5(
              dotOneColor: Colors.lightGreen[400],
              dotTwoColor: Colors.yellow[700],
              dotThreeColor: Colors.lime[700],
              dotType: DotType.circle,
              dotIcon: Icon(Icons.adjust),
              duration: Duration(seconds: 1),
            ))

          ////
          /// Layout loading
          ///
          : SingleChildScrollView(
              child: Stack(
                children: <Widget>[
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
                                left: MediaQuery.of(context).size.width/2 - 10,
                                child:Text("     My   \nAccount",
                                  style: TextStyle(
                                      color: colorStyle.yellowDark,
                                      fontFamily: "",
                                      fontSize: 30
                                  ),
                                ))
                          ]
                      )
                  ),
                  Container(
                    height: _height,
                    width: double.infinity,
                    decoration:
                        BoxDecoration(color: Colors.black12.withOpacity(0.01)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 150.0),
                    child: Container(
                      height: _height,
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
                              height: 0.0,
                            ),
                            Text(
                              "Login",
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
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 6.0,
                                        color: Colors.black12.withOpacity(0.05),
                                        spreadRadius: 1.0)
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
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
                                            return 'email is missing';
                                          }

                                        },
                                        onSaved: (input) => _email = input,
                                        controller: loginEmailController,
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
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 6.0,
                                        color: Colors.black12.withOpacity(0.05),
                                        spreadRadius: 1.0)
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 0.15,
                                  ),
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
                                            return 'password is missing';
                                          }
                                        },
                                        onSaved: (input) => _pass = input,
                                        controller: loginPasswordController,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 64.0),

                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 250,
                                    child:
                                    BlueButtonWidget(color1: Colors.blue,color2: Colors.blue, text: Text("SIGN IN",style: TextStyle(color: Colors.white,fontSize: 20),),onPressed: ()async {
                                      SharedPreferences prefs;
                                      prefs = await SharedPreferences.getInstance();
                                      final formState =
                                          _registerFormKey.currentState;
                                      AuthResult authResult;
                                      FirebaseUser user;
                                      if (formState.validate()) {
                                        formState.save();
                                        try {
                                          prefs.setString("Name", _email);
                                          prefs.setString("id", _id);
                                          authResult = await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                            email: _email,
                                            password: _pass,
                                          );
                                          user = authResult.user;

                                          setState(() {
                                            isLoading = true;
                                          });
                                          // user.sendEmailVerification();

                                        } catch (e) {
                                          print('Error: $e');
                                          CircularProgressIndicator();
                                          print(e.message);
                                          print(_email);

                                          print(_pass);
                                        } finally {
                                          if (user != null) {
                                            authResult = await FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                              email: _email,
                                              password: _pass,
                                            )
                                                .then((currentUser) => Firestore
                                                .instance
                                                .collection("users")
                                                .document(currentUser.user.uid)
                                                .get()
                                                .then((DocumentSnapshot
                                            result) =>
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                    PageRouteBuilder(
                                                        pageBuilder: (_,
                                                            __,
                                                            ___) =>
                                                        new BottomNavBar(
                                                          idUser: authResult
                                                              .user
                                                              .uid,
                                                        ))))
                                                .catchError(
                                                    (err) => print(err)))
                                                .catchError((err) => print(err));
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Login Failed"),
                                                    content: Text(
                                                        "Please check your email and password"),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text("Close"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      )
                                                    ],
                                                  );
                                                });
                                          }
                                        }
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Error"),
                                                content: Text(
                                                    "Please check your email and password"),
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
                                      ;
                                    },)
                                    ,
                                  ),
                                )

                              ),
                            SizedBox(
                              height: 18.0,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => new SignUp(
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Don’t have an account?",
                                    style: TextStyle(
                                        fontFamily: "Sofia",
                                        color: Colors.black38,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0),
                                  ),
                                  Text(" Sign Up",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          color: Color(0xFFF3B61F),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15.0))
                                ],
                              ),
                            ),
                            /*
                            SignInButton(
                              Buttons.GoogleDark,
                              onPressed: () {
                                signInWithGoogle();
                              },
                            ),
                            //if (Platform.isIOS)
                            SignInButton(
                              Buttons.Apple,
                              onPressed: () {
                                applePressed();
                              },
                            ),

                             */
                          ],
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
