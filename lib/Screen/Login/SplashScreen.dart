import 'dart:async';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/details/size_config.dart';
import 'package:tasty_cookpad/Screen/BottomNavBar/BottomNavBar.dart';
import 'package:tasty_cookpad/Screen/Login/OnBoarding.dart';
import 'package:tasty_cookpad/Style/Style.dart';
import 'dart:io' show Platform;

import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  /// Create _themeBloc for double theme (Dark and White themse)

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_themeBloc = ThemeBloc();
  }

  @override
  Widget build(BuildContext context) {
    ///Set color status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));

    /// To set orientation always portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Recipes',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          primaryColorLight: Colors.white,
          primaryColorBrightness: Brightness.light,
          primaryColor: Colors.white),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  bool _connection = false;

  final FirebaseMessaging _messaging = FirebaseMessaging();

  @override
  void _Navigator() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BottomNavBar(
                  idUser: "non",
                )));
  }

  /// Set timer SplashScreen
  _timer() async {
    return Timer(Duration(milliseconds: 500), _Navigator);
  }

  @override
  void initState() {
    super.initState();

    ///
    /// Check connectivity
    ///
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      print(_connectionStatus);
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        setState(() {
          _timer();
          _connection = false;
        });
      } else {
        setState(() {
          _connection = true;
        });
      }
    });

    if (Platform.isAndroid) {
      // Android-specific code
    } else if (Platform.isIOS) {
      _timer();
      // iOS-specific code
    }

    ///
    /// Setting Message Notification from firebase to user
    ///
    _messaging.getToken().then((token) {
      print(token);
    });

    @override
    void dispose() {
      subscription.cancel();
      super.dispose();
    }
  }

  /// Check user
  bool _checkUser = true;

  bool loggedIn = false;

  @override
  SharedPreferences prefs;

  ///
  /// Checking user is logged in or not logged in
  ///
  Future<Null> _function() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      if (prefs.getString("username") != null) {
        print('false');
        _checkUser = false;
      } else {
        print('true');
        _checkUser = true;
      }
    });
  }

  Widget build(BuildContext context) {
    return _connection

        ///
        /// Layout if user not connect internet
        ///
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: <Widget>[
                SizedBox(
                  height: 150.0,
                ),
                Container(
                  height: 270.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/image/noInternet.png")),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "You are offline",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: "Sofia",
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w700,
                      color: colorStyle.primaryColor),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Text(
                    "No internet connection. Check your internet connection and try again",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: "Sofia",
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Positioned(
                  top: -MediaQuery.of(context).size.width * 0.1,
                  left:-MediaQuery.of(context).size.width * 0.1,
                  child: new Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    alignment: const Alignment(-1.0, -1.0),
                    decoration: new BoxDecoration(
                      color: Color.fromRGBO(152, 98, 0, 1.0),
                      shape: BoxShape.circle,
                    ),
                    child: null,
                  ) ,
                ),

                Positioned(
                  bottom: -MediaQuery.of(context).size.width * 0.1,
                  right:-MediaQuery.of(context).size.width * 0.1,
                  child: new Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    alignment: const Alignment(-1.0, -1.0),
                    decoration: new BoxDecoration(
                      color: Color.fromRGBO(152, 98, 0, 1.0),
                      shape: BoxShape.circle,
                    ),
                    child: null,
                  ) ,
                ),
                Center(
                  child:
                  SizedBox
                    (
                    height: 45,
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                      children: [
                        Text(
                          "EVENTS",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Krungthep",
                            fontSize: 45.0,
                          ),),
                        SizedBox(
                          width:10,
                        ),
                        Align(
                          alignment:  Alignment.bottomRight,
                          child:   new Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.bottomLeft,
                            decoration: new BoxDecoration(
                              color: Color(0xFFFFA500),
                              shape: BoxShape.circle,
                            ),
                            child: null,
                          )
                        ),

                      ],
                    ),
                  ),

                ),
              ],
            ),
          );
  }
}
