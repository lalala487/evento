import 'dart:typed_data';
import 'package:badges/badges.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tasty_cookpad/Screen/B1_Home_Screen/B1_HomeScreen2.dart';
import 'package:tasty_cookpad/Screen/B1_Home_Screen/Cart.dart';
import 'package:tasty_cookpad/Screen/B2_Ticket/B2_Ticket.dart';
import 'package:tasty_cookpad/Screen/B3_Favorite_Screen/B3_Favorite_Screen.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/B3_SocialFeed.dart';
import 'package:tasty_cookpad/Screen/B4_Profile_Screen/B4_Profile_Screen.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/B4_ShopHome.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/CartScreen.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/details/size_config.dart';
import 'package:tasty_cookpad/Screen/BottomNavBar/CartItemsBloc.dart';
import 'package:tasty_cookpad/Screen/BottomNavBar/NavBarItem.dart';
import 'package:tasty_cookpad/Style/Style.dart';
import 'package:tasty_cookpad/Screen/B4_Profile_Screen/callCenter.dart';


class BottomNavBar extends StatefulWidget {
  String idUser;
  BottomNavBar({
    this.idUser,
  });
  createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin  {
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  int _selectedIndex = 0;
  final _selectedItemColor = colorStyle.tabSel;
  final _unselectedItemColor = Colors.white;
  final _selectedBgColor = Colors.black38;
  final _unselectedBgColor = Colors.transparent;
  bool isExpandMenu = false;
  AnimationController rotationController;
  Animation<double> _animation;

  AnimationController enlargeController;
  Animation<double> _enlargeAnimation;
  final _sizeMixTween =
  SizeTween(begin: Size(150.0, 150.0), end: Size(50.0, 50.0));

  @override
  void initState() {
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
        value: 0.0,
        lowerBound: 0.0,
        upperBound: 0.25
    );

    enlargeController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    double d = 500;
    _animation = CurvedAnimation(parent: rotationController, curve: Curves.linear);
    //_enlargeAnimation = CurvedAnimation(parent: enlargeController, curve: Curves.easeIn);
    _enlargeAnimation = Tween<double>(begin: 150, end: d).animate(enlargeController)
      ..addListener(() {

        setState(() {});
      });

    //enlargeController.forward();

    barcode = '';
    super.initState();
  }

  @override
  void dispose() {
    //bottomNavBarBloc.close();
    super.dispose();
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    bottomNavBarBloc.pickItem(index);
  }

  Color _getBgColor(int index) =>
      _selectedIndex == index ? _selectedBgColor : _unselectedBgColor;

  Color _getItemColor(int index) =>
      _selectedIndex == index ? _selectedItemColor : _unselectedItemColor;

  Widget _buildIcon(String urlSel,String url, String text, int index) => Container(
    width: double.infinity,
    height: kBottomNavigationBarHeight,
    child: Material(
      color: _getBgColor(index),
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _selectedIndex == index ?Image.asset(url):Image.asset(urlSel),
            Text(text,
                style: TextStyle(fontSize: 12, color: _getItemColor(index))),
          ],
        ),
        onTap: () => _onItemTapped(index),
      ),
    ),
  );
  void expandMenu()
  {
    rotationController.forward(from: 0.0).then((value) =>
    isExpandMenu = true
    );
    enlargeController.forward(from: 0.0);
  }
  void unExpandMenu()
  {
    rotationController.reverse().then((value) => isExpandMenu = false);
    enlargeController.reverse();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    //final animation = _enlargeAnimation as Animation<double>;

    //final circleSize  = _sizeMixTween.evaluate(animation);
    // print("call! ${circleSize.width}");
    return Scaffold(
      backgroundColor: colorStyle.yellowDark,
      body:
      Stack(
        children: [
          StreamBuilder<NavBarItem>(
            stream: bottomNavBarBloc.itemStream,
            initialData: bottomNavBarBloc.defaultItem,
            builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
              print("change screeen!");
              switch (snapshot.data) {
                case NavBarItem.HOME:
                  _selectedIndex = 0;
                  return HomeScreenB1(
                    userID: widget.idUser,
                  );
                case NavBarItem.LEAF:
                  _selectedIndex = 1;
                  /*Future.delayed(const Duration(milliseconds: 1000), () {
                    setState(() {
                    });
                  });*/
                  return B2PTicket(
                    userID: widget.idUser,
                  );
                case NavBarItem.SOCIALFEED:
                  _selectedIndex = 2;
                  return B2ScoailFeed(
                    userID: widget.idUser,
                  );
                case NavBarItem.SHOP:
                  _selectedIndex = 3;
                  return B3ShopHome(
                    userID: widget.idUser,
                  );
                case NavBarItem.USERS:
                  _selectedIndex = 4;
                  return B4ProfileScreen(
                    idUser: widget.idUser,
                  );
              }
              return Container();
            },
          ),
          if (_enlargeAnimation.value > 160)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: new BoxDecoration(
              color: Color(0xFF000000).withOpacity(0.0 + 0.5* (_enlargeAnimation.value-150)/350.0),
            ),
            child: null,
          ),
          Positioned(
            top: -MediaQuery.of(context).size.width * 0.6 +  MediaQuery.of(context).size.width * 0.6 * ((_enlargeAnimation.value)/500.0),
            left: -MediaQuery.of(context).size.width * 0.1 - (_enlargeAnimation.value/2 -MediaQuery.of(context).size.width * 0.1) * (_enlargeAnimation.value-150)/350.0,
            child: new Container(
              width: _enlargeAnimation.value,//MediaQuery.of(context).size.width * 0.4,
              height: _enlargeAnimation.value, //MediaQuery.of(context).size.width * 0.4,
              alignment: const Alignment(-1.0, -1.0),
              decoration: new BoxDecoration(
                color: Color(0xFFFFA500).withOpacity(0.5 + 0.5* (_enlargeAnimation.value-150)/350.0),
                shape: BoxShape.circle,
              ),
              child: null,
            ) ,
          ),
          Positioned(
              top: 10 ,
              left: 10,
              child:  RotationTransition(
                turns: _animation,
                child: IconButton(
                  icon: Icon(Icons.menu, size: 45),
                  tooltip: 'menu',
                  onPressed: () {
                    if (!isExpandMenu) {
                     expandMenu();
                    }
                    else{
                      unExpandMenu();
                    }

                    //  rotationController.forward(from: 0.0);
                  },
                ),
              )
          ),
          Positioned(
            right: -MediaQuery.of(context).size.width * 0.25,
            top: -MediaQuery.of(context).size.width * 0.25,

            //left: -MediaQuery.of(context).size.width * 0.1 - (_enlargeAnimation.value/2 -MediaQuery.of(context).size.width * 0.1) * (_enlargeAnimation.value-150)/350.0,
            child: new Container(
              width: MediaQuery.of(context).size.width * 0.5,//MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.5, //MediaQuery.of(context).size.width * 0.4,
              alignment: const Alignment(-1.0, -1.0),
              decoration: new BoxDecoration(
                color: Color(0xFFFFA500).withOpacity(0.5 + 0.5* (_enlargeAnimation.value-150)/350.0),
                shape: BoxShape.circle,
              ),
              child: null,
            ) ,
          ),
          Positioned(
              right: 20 ,
              top: 20,
              child:
                StreamBuilder(
                  initialData: bloc.items,
                stream: bloc.getStream,
                builder: (context, snapshot) {
                  List<CartItem> items = snapshot.data;
                  int num = 0;
                  if (items != null)
                    num = items.length;
                  return InkWell(
                    onTap: (){
                      print("test");
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new CartScreen(

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
                    child:Badge(
                      badgeContent: Text(num.toString()),
                      child: Icon(Icons.shopping_cart, size: 35, color: Colors.white,),

                    ) ,
                  );
                }
                )/*
                  InkWell(
                    onTap: (){
                        print("test");
                    },
                    child:Badge(
                      badgeContent: Text('2'),
                      child: Icon(Icons.shopping_cart, size: 35, color: Colors.white,),

                    ) ,
                  )
*/

          ),
          Positioned(
              top: 80,
              left: -150 + (160*  (_enlargeAnimation.value-150)/350.0 ),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only( top:20),
                    child:
                      InkWell(
    child: Text(
                          "Events",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Krungthep",
                            fontSize: 25.0,
                          ),),
                        onTap:() { unExpandMenu(); _onItemTapped(0);},
                      ),
                  ),
                  Padding(
                    padding: EdgeInsets.only( top:20),
                    child:
                      InkWell(
                        child: Text(
                          "Live",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Krungthep",
                            fontSize: 25.0,
                          ),),
                        onTap:() { unExpandMenu(); _onItemTapped(2); },
                      ),
                  ),
                  Padding(
                    padding: EdgeInsets.only( top:20),
                    child:
                      InkWell(
                        child: Text(
                          "Store",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Krungthep",
                            fontSize: 25.0,
                          ),),
                          onTap:() { unExpandMenu(); _onItemTapped(3); },
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.only( top:20),
                    child:
                      InkWell(
                        child: Text(
                          "My Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Krungthep",
                            fontSize: 25.0,
                          ),),
                        onTap:() { unExpandMenu(); _onItemTapped(4); },
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.only( top:20),
                    child: InkWell(
                      child: Text(
                        "Contact Us",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Krungthep",
                          fontSize: 25.0,
                        ),),
                      onTap:() { unExpandMenu();
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                          new callCenter()));
                      },
                    )
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  SizedBox
                    (
                    height: 20,
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                      children: [
                        Text(
                          "EVENTS",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Krungthep",
                            fontSize: 20.0,
                          ),),
                        SizedBox(
                          width:10,
                        ),
                        Align(
                            alignment:  Alignment.bottomRight,
                            child:   new Container(
                              width: 10,
                              height: 10,
                              alignment: Alignment.bottomLeft,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: null,
                            )
                        ),

                      ],
                    ),
                  ),
                ],
              )
          )
        ],
      ),

//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          // Add your onPressed code here!
//        },
//        child: Icon(Icons.menu),
//        backgroundColor: Colors.transparent,//colorStyle.yellowFloatButton,
//      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      bottomNavigationBar: StreamBuilder(
        stream: bottomNavBarBloc.itemStream,
        initialData: bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return BottomNavigationBar(
            selectedFontSize: 10.0,
            unselectedFontSize: 10.0,
            selectedItemColor: colorStyle.tabSelDark,
            unselectedItemColor: colorStyle.whiteBackground,
            backgroundColor: colorStyle.yellowDark,
            type: BottomNavigationBarType.fixed,
            iconSize: 50.0,
            currentIndex: snapshot.data.index,
            onTap: bottomNavBarBloc.pickItem,
            items: [
              BottomNavigationBarItem(
                icon: _buildIcon('assets/image/tab/event.png', 'assets/image/tab/event_sel.png', 'Event', 0),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon('assets/image/tab/ticket.png', 'assets/image/tab/ticket_sel.png', 'Ticket', 1),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon('assets/image/tab/live.png', 'assets/image/tab/live_sel.png', 'Live', 2),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon('assets/image/tab/cart.png', 'assets/image/tab/cart_sel.png', 'Store', 3),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon('assets/image/tab/group.png', 'assets/image/tab/group_sel.png', 'My Account', 4),
                title: SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }
}
