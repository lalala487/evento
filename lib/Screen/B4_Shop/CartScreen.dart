
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasty_cookpad/Screen/B1_Home_Screen/Cart.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/BlueButtonWidget.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/PostItem.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/TimeAgo.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/Live.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/ProductDetail.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/details/details_screen.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/models/Product.dart';
import 'package:tasty_cookpad/Screen/BottomNavBar/CartItemsBloc.dart';
import 'package:tasty_cookpad/Screen/BottomNavBar/NavBarItem.dart';
import 'package:tasty_cookpad/Style/Style.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart' as mfr;

class CartScreen extends StatefulWidget {

  CartScreen();

  @override
  _CartScreenState createState() => _CartScreenState();
}
enum PaymentType { KNET } //, VISA, AMERICANEXPRESS }

// Base Url
String baseUrl = "https://apitest.myfatoorah.com";

// Token for regular payment
String regularPaymentToken = "bearer gqtDGpuJQkrzmxCcslg8RY8OnY0dSiHV65r5q-1kjt2lWDpvhtQRy712gF9AMdHwIiNUBwLWL8kMSvsIsrSxVJgrLTUXxBfiP4lCnMxe1KqOwKI5_C21UQjwJ-aHhVA93FDkWeuXoRFFfTDoUroeOXg9yoBWI9hjFndypdpjPI4_2PGLgwGzGRIy7bj_P_GzfpPODqRaZyn1bT-kjNoGF5fKkRopmdIlU2OeLV6lqDKF__smfyauGVTixIJKpmtxTa_p_YjRanbWBnWd13aBxTJSIVGBYszmK3pev1POgXDLO9K6b4pP8jT8Lodkl7f60osRDjLSiLKzt93ztrR0ERuu8sfpVa-eg-v3dBi870ZSPDNI7esQ7cQ9pe9OTj4JT8Hwef1zZuXCsBO7HzL2JQGYPyrx-iVQsv_0Bc7rhv1fHfLtsN3FrsQEq-aLzGtH-qRMq3S_M6T2-I-fQdgsbuHqDG6VKc2TXnId2SrAKX26kGSZfOH7rDYtb86Nu3iI-EMzztt8RnbpkBr9fKEtqOuJ0SNMhN716FgJKFei2mbOxMxVrZtTqu38fSh1m6WYWOy_48f6P2TYplMdo5S-G_J9PtkrUMs6eqzqhhjPWsppwtAJhb6rKhoBQkSHKpbKIWvzOOi826_ryUyNvMCmMlesgoWcWcQJEcob4RzB3OZjAgWQ";

// Token for direct payment and recurring
String directPaymentToken = "fVysyHHk25iQP4clu6_wb9qjV3kEq_DTc1LBVvIwL9kXo9ncZhB8iuAMqUHsw-vRyxr3_jcq5-bFy8IN-C1YlEVCe5TR2iCju75AeO-aSm1ymhs3NQPSQuh6gweBUlm0nhiACCBZT09XIXi1rX30No0T4eHWPMLo8gDfCwhwkbLlqxBHtS26Yb-9sx2WxHH-2imFsVHKXO0axxCNjTbo4xAHNyScC9GyroSnoz9Jm9iueC16ecWPjs4XrEoVROfk335mS33PJh7ZteJv9OXYvHnsGDL58NXM8lT7fqyGpQ8KKnfDIGx-R_t9Q9285_A4yL0J9lWKj_7x3NAhXvBvmrOclWvKaiI0_scPtISDuZLjLGls7x9WWtnpyQPNJSoN7lmQuouqa2uCrZRlveChQYTJmOr0OP4JNd58dtS8ar_8rSqEPChQtukEZGO3urUfMVughCd9kcwx5CtUg2EpeP878SWIUdXPEYDL1eaRDw-xF5yPUz-G0IaLH5oVCTpfC0HKxW-nGhp3XudBf3Tc7FFq4gOeiHDDfS_I8q2vUEqHI1NviZY_ts7M97tN2rdt1yhxwMSQiXRmSQterwZWiICuQ64PQjj3z40uQF-VHZC38QG0BVtl-bkn0P3IjPTsTsl7WBaaOSilp4Qhe12T0SRnv8abXcRwW3_HyVnuxQly_OsZzZry4ElxuXCSfFP2b4D2-Q";


class _CartScreenState extends State<CartScreen> {
  PaymentType paymentType = PaymentType.KNET;
  List<CartItem> items;
  double total_price;
  int pageState = 0;
  String _response = '';

  void initState()
  {
    mfr.MFSDK.init(baseUrl, regularPaymentToken);

    getCartItems();
    super.initState();
  }

  void getCartItems() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    items =  getCartItem(prefs);
    setState(() {

    });
  }
  List<Widget> buildCheckOutPage()
  {
    total_price = 0.0;
    List <String> titles = [];
    List <double> prices = [];
    String shop_item;
    double shop_price;
    List<Card> ticket = [];
    for (CartItem item in items)
    {
      if (item.summary == "ticket") {
        total_price += item.price;
        titles.add( item.name);
        prices.add(item.price);
      }
      if (item.summary == "shop"){

      }
    }
    ticket.add(
      Card(
        margin: EdgeInsets.only( left: 0, right: 0, bottom: 10),
        child:
        Padding(
          padding: EdgeInsets.only(left: 10,right: 10),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              Text("Payment method",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Divider(),
              Column(
                children: <Widget>[
                  Row(
                    children: [
                      Radio(
                        value: PaymentType.KNET,
                        groupValue: paymentType,
                        onChanged: (PaymentType value) {
                          setState(() {
                            paymentType = value;
                          });
                        },
                      ),
                      const Text('KNET')
                    ],
                  ),/*
                  Row(
                    children: [
                      Radio(
                        value: PaymentType.VISA,
                        groupValue: paymentType,
                        onChanged: (PaymentType value) {
                          setState(() {
                            paymentType = value;
                          });
                        },
                      ),
                      const Text('Visa/Master Card')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: PaymentType.AMERICANEXPRESS,
                        groupValue: paymentType,
                        onChanged: (PaymentType value) {
                          setState(() {
                            paymentType = value;
                          });
                        },
                      ),
                      const Text('American Express')
                    ],
                  ),*/
                ],
              )
            ],
          ), 
        )
      )

    );

    ticket.add(buildSumary(total_price,titles,prices,shop_item,shop_price));
    total_price = total_price;
    return ticket;
  }
  List<Widget> buildPages()
  {
    total_price = 0.0;
    List <String> titles = [];
    List <double> prices = [];
    String shop_item;
    double shop_price;
    List<Card> ticket = [];
    for (CartItem item in items)
    {
        if (item.summary == "ticket") {
          ticket.add(buildRegistrationTicket(item));
          total_price += item.price;
          titles.add( item.name);
          prices.add(item.price);
        }

    }
    for (CartItem item in items)
    {
      if (item.summary == "shop") {
        ticket.add(buildShopItems(item));
        total_price += item.price * item.itemnum;
      }
    }

    ticket.add(buildSumary(total_price,titles,prices,shop_item,shop_price));
    total_price = total_price;
    return ticket;

  }
  Widget buildRegistrationTicket(CartItem item)
  {
    String event_category ="";
    if (item.meta!=null)
      event_category = item.meta["event_category"];
    return
      Card(
        margin: EdgeInsets.only(top: 0,bottom: 10,left: 0,right: 0),

        child:     ListTile(

            title:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( item.meta["first_name"] +  " " + item.meta["last_name"]),
                Text(item.meta["email"] + "-" + item.meta["gender"] + "-" + item.meta["nationality"],
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54
                  ),
                ),
                Text(item.name),
                Text(event_category,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54
                  ),

                ),
              ],
            ),
            subtitle: Text( item.price.toString() + "\$",
              textAlign: TextAlign.right,
            ),
            trailing: Column(
              children: [
                IconButton(
                  icon:      Icon(
                      Icons.close
                  ),
                  onPressed: ()
                  {
                    showDialog(
                        context: context,
                        builder: (_) => NetworkGiffyDialog(
                          image: Image.network(
                            "https://firebasestorage.googleapis.com/v0/b/cryptocanyon9.appspot.com/o/original.gif?alt=media&token=ee61ee91-1d4b-40c9-91a0-be9c8aef1767",
                            fit: BoxFit.cover,
                          ),
                          title: Text('Delete this?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Gotik",
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600)),
                          description: Text(
                            "Are you sure you want to delete " +
                                item.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Popins",
                                fontWeight: FontWeight.w300,
                                color: Colors.black26),
                          ),
                          onOkButtonPressed: () {
                            Navigator.pop(context);
                            bloc.removeFromCart(item);
                            getCartItems();

                            setState(() {
                            });
                          },
                        ));
                  },
                )
              ],
            )

        ),
      );
  }
  Widget _incrementButton(CartItem item) {
    return
      ButtonTheme(
        minWidth: 30,
        height: 30,
        child: RaisedButton(
          onPressed: () {
            setState(() {
              item.itemnum++;
            });
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xffF8A127), Color(0xff7C5114)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(3.0)
            ),
            child: Container(
                constraints: BoxConstraints(maxWidth: 30.0, minHeight: 30.0),
                alignment: Alignment.center,
                child:  Text("+")
            ),
          ),
        ),
      )
    ;
  }

  Widget _decrementButton(CartItem item) {
    return
      ButtonTheme(
        minWidth: 30,
        height: 30,
        child: RaisedButton(
          onPressed: () {
            if (item.itemnum == 0)
              return;
            setState(() {
              item.itemnum--;
            });
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xffF8A127), Color(0xff7C5114)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(3.0)
            ),
            child: Container(
                constraints: BoxConstraints(maxWidth: 30.0, minHeight: 30.0),
                alignment: Alignment.center,
                child:  Text("-")
            ),
          ),
        ),
      )
    ;
  }
  Widget buildShopItems(CartItem item)
  {
    return
      Card(
          margin: EdgeInsets.only(top: 10,bottom: 10),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                child:            Text("Shop Items",
                ),
              ),
              ListTile(
                  leading: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                      maxWidth: 64,
                      maxHeight: 64,
                    ),
                    child: Image.network(item.img, fit: BoxFit.cover),
                  ),
                  title:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( item.name),
                      Row(
                        children: [
                          Text("Item Size : ${item.meta["size"]} | Item Color :",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54
                              )),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: item.fromHex(item.meta["color"]),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey[300], width: 1.0),
                            )
                            ,
                          )
                        ],
                      )
                      ,
                      Row(
                        children: [
                          Text("QTY"),
                          _decrementButton(item),
                          Text(
                            '${item.itemnum}',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          _incrementButton(item),
                        ],
                      ),

                    ],
                  ),
                  subtitle: Text( "${item.price}\$",
                    textAlign: TextAlign.right,
                  ),
                  trailing: Column(
                    children: [
                      IconButton(
                        icon:      Icon(
                            Icons.close
                        ),
                        onPressed: ()
                        {
                          showDialog(
                              context: context,
                              builder: (_) => NetworkGiffyDialog(
                                image: Image.network(
                                  "https://firebasestorage.googleapis.com/v0/b/cryptocanyon9.appspot.com/o/original.gif?alt=media&token=ee61ee91-1d4b-40c9-91a0-be9c8aef1767",
                                  fit: BoxFit.cover,
                                ),
                                title: Text('Delete this?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Gotik",
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w600)),
                                description: Text(
                                  "Are you sure you want to delete " +
                                      item.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Popins",
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black26),
                                ),
                                onOkButtonPressed: () {
                                  Navigator.pop(context);
                                  bloc.removeFromCart(item);
                                  getCartItems();

                                  setState(() {
                                  });
                                },
                              ));
                        },
                      )
                    ],
                  )
              )
            ],
          )
      );
  }
  Widget buildSumary(double total_price, List<String> titles, List <double> prices, String shop_item, double shop_price)
  {
    /*
     double total_price = 0.0;
    List <String> titles = [];
    List <double> prices = [];
    String shop_item;
    double shop_price;
     */
    String summary;
    return Card(
      margin: EdgeInsets.only(left: 0,right: 0),
      child:
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Padding(
              padding: EdgeInsets.only(left: 10,top: 10,bottom: 10),
              child:
              Text("Summary",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  )
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(left: 10,top: 5,bottom: 5),
              child:
              Text("Registration",
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  )
              ),
            ),
            Divider(),
            for (int i = 0; i<titles.length; i++)
              Padding(
                  padding: EdgeInsets.only(left: 10,right: 10),

                  child:
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Text(titles[i]),
                        new Text(prices[i].toString() + "\$")
                      ]
                  )
              ),
            Divider(),
            if (shop_item!=null)
            Padding(
              padding: EdgeInsets.only(left: 10,top: 5,bottom: 5),
              child:
              Text("Shop Items",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            if (shop_item!=null)
            Divider(),
            if (shop_item!=null)
            Padding(
                padding: EdgeInsets.only(left: 10,right: 10),

                child:
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Text(shop_item),
                      new Text(shop_price.toString())
                    ]
                )
            ),
            if (shop_item!=null)
            Divider(),
            Padding(
                padding: EdgeInsets.only(left: 10,right: 10),

                child:
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Text("Total Price",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      new Text(total_price.toString() + "\$",
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ))
                    ]
                )
            ),
            Divider()
          ]
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    double mediaQueryData = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        body:
        Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 70 , left: 10, right: 10,bottom:50),
                child:
                    items == null? Text(""):
                pageState==0?
                ListView(
                  children:
                    buildPages(),
                ):
                ListView(
                  children:
                  buildCheckOutPage(),
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
                          print("pop");
                          Navigator.of(context).pop();
                        },
                        child:
                        Image(
                          image: AssetImage("assets/image/yellowback.png"),
                        )
                    ),
                  )

              ),
              Positioned(
                  bottom: 3,
                  left: (MediaQuery.of(context).size.width-300)/2,
                  child:
                  SizedBox(
                    width: 300,
                    child:
                    pageState==0?
                    BlueButtonWidget(color1: Colors.blue,color2: Colors.blue, text: Text("PROCEED TO CHECKOUT",style: TextStyle(color: Colors.white,fontSize: 20),),onPressed: ()async {
                      if (total_price != 0.0 )
                      {
                          this.pageState = 1;
                          setState(() {

                          });
                      }
                    }):BlueButtonWidget(color1: Colors.blue,color2: Colors.blue, text: Text("Continue",style: TextStyle(color: Colors.white,fontSize: 20),),onPressed: ()async {
                      var request = new  mfr.MFInitiatePaymentRequest(5.5, mfr.MFCurrencyISO.KUWAIT_KWD);

                      mfr.MFSDK.initiatePayment(
                          request,
                          mfr.MFAPILanguage.EN,
                              (mfr.MFResult<mfr.MFInitiatePaymentResponse> result) => {
                            if (result.isSuccess())
                              {
                                setState(() {
                                  print(result.response.toJson());
                                  _response = result.response.toJson().toString();
                                })
                              }
                            else
                              {
                                setState(() {
                                  print(result.error.toJson());
                                  _response = result.error.message;
                                })
                              }
                          });

                      setState(() {
                        _response = "loading";
                      });
                      print("payment response is $_response");
                      return;
                      // process transaction
                      // get user
                      FirebaseUser curUser = await FirebaseAuth.instance.currentUser();
                      if (curUser != null)
                      {

                        print("$total_price ----------- we have user");

                        {
                          //create transaction
                          Firestore.instance.collection("transaction").add({
                            "name": "ticket",
                            "createdAt":DateTime.now(),
                            "price":total_price.toString(),
                            "payment_method":"KNET",
                            "status":"complete",
                            "userId":curUser.uid,
                            "summary":"this will be summary"
                          }
                          ).then((value)
                          {
                            // create ticket
                            for (CartItem item in items)
                            {
                              if (item.summary == "ticket") {
                                Firestore.instance.collection("tickets").add({
                                  "name": item.name,
                                  "category":item.meta["event_category"],
                                  "createdAt":DateTime.now(),
                                  "price":item.price.toString(),
                                  "userId":curUser.uid,
                                  "eventId":item.meta["event_id"],
                                  "eventImage":item.meta["event_image"],
                                  "eventFrom":DateTime.parse(item.meta["event_from"]),
                                  "eventTo":DateTime.parse(item.meta["event_to"]),
                                  "event_type":item.meta["event_type"],
                                  "ticket_id":value.documentID
                                }
                                );
                              }

                            }
                            bloc.reomveAllCart();
                            Navigator.of(context).pop();

                          });

                        }
                        /*
                        {
                          // create ticket
                          for (CartItem item in items)
                          {
                            if (item.summary == "ticket") {
                              Firestore.instance.collection("tickets").add({
                                "name": item.name,
                                "category":item.meta["event_category"],
                                "createdAt":DateTime.now(),
                                "price":item.price.toString(),
                                "userId":curUser.uid,
                                "eventId":item.meta["event_id"],
                                "eventImage":item.meta["event_image"],
                                "eventFrom":DateTime.parse(item.meta["event_from"]),
                                "eventTo":DateTime.parse(item.meta["event_to"]),
                                "event_type":item.meta["event_type"]
                              }
                              );
                            }

                          }
                          // remove all cart
                          bloc.reomveAllCart();
                        }
                        Navigator.of(context).pop();

                        */
                      }
                      else{
                        // get to login screen
                        Navigator.of(context).pop();
                        bottomNavBarBloc.pickItem(4);
                      }

                    })
                    ,
                  )

              )

            ]
        )


    );
  }

  void makeTransaction()
  {

  }
}


