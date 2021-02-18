import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tasty_cookpad/Screen/B1_Home_Screen/Cart.dart';
import 'package:tasty_cookpad/Screen/B1_Home_Screen/Event.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/BlueButtonWidget.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/CartScreen.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/details/default_button.dart';
import 'package:tasty_cookpad/Screen/BottomNavBar/BottomNavBar.dart';
import 'package:tasty_cookpad/Screen/BottomNavBar/CartItemsBloc.dart';
import 'package:tasty_cookpad/Style/Style.dart';
import 'package:tasty_cookpad/Widget/loader_animation/dot.dart';
import 'package:tasty_cookpad/Widget/loader_animation/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';


class BuyTicket extends StatefulWidget {
  Event event;

  BuyTicket( { this.event});

  @override
  _BuyTicketState createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  String event;
  TextEditingController eventController;
  TextEditingController categoryController;
  TextEditingController genderController;
  TextEditingController nationalityController;
  TextEditingController countryResidentController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  //TextEditingController phoneNumbercontroller;
  String phoneText;
  TextEditingController emailController;
  final GlobalKey<FormState> _buyTicketKey = GlobalKey<FormState>();

  int selectedValue;
  bool isLogin = false;
  FocusNode myFocusNode = new FocusNode();

  showEvent() {
    List<dynamic> event = ['Rora Event','Simson Evnet'];
    showPicker(event,eventController);
  }

  showCategory() {
    //List<String> list = ['RODENT VIRTUAL:24KM','RODENT VIRTUAL:12KM','RODENT VIRTUAL:7KM','RODENT VIRTUAL:2KM'];
    showPicker(widget.event.ticket_category,categoryController);
  }

  showGender(){
    List<String> list = ['Male','Female'];
    showPicker(list,genderController);
  }
  void initState()
  {
    super.initState();
    //bloc.setCatEmpty();
    eventController = new TextEditingController( text: widget.event.title);
    categoryController = new TextEditingController();
    genderController  = new TextEditingController();
    nationalityController = new TextEditingController();
    countryResidentController = new TextEditingController();
    firstNameController = new TextEditingController();
    lastNameController = new TextEditingController();
    //phoneNumbercontroller = new TextEditingController();
    emailController = new TextEditingController();
  }
  void showCPicker(BuildContext context, TextEditingController controller){
    showCountryPicker(
      context: context,
      //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
      //countryFilter: <String>['US', 'CA'],
      //Optional. Shows phone code before the country name.
      //showPhoneCode: true,
      onSelect: (Country c) {

        final g = c.name;
        controller.text = g;
        //countryCode = c.countryCode;

        //setState(() {
        //  country = g;
        //});
        //print('Select country: ${c.countryCode}');

      },
    );
  }
  showPicker(List<dynamic> list,TextEditingController controller) {
    selectedValue = 0;
    List<Widget> listWidget = new List<Widget>();
    for(var i = 0; i < list.length; i++){
      listWidget.add(new Text(list[i]));
    }
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return
            Column(
                children:[
                  Row(
                    children: [
                      FlatButton(
                        child: Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      new Expanded(
                        child:                     Align(
                          alignment: Alignment.centerRight,
                          child:
                          FlatButton(
                            child: Text("Done"),
                            onPressed: () {
                              controller.text = list[selectedValue];
                              Navigator.of(context).pop();
                            },
                          )
                          ,
                        )
                        ,
                      ),
                    ],
                  ),
                  Expanded(
                    child:
                    CupertinoPicker(
                        backgroundColor: Colors.white,
                        onSelectedItemChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                        itemExtent: 32.0,
                        children:listWidget
                    )
                    ,
                  )
                ]

            );
        });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          Stack(
            children: [
               SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left:20,right: 20),
                  child:
                  Form(
                    key: _buyTicketKey,
                    child:
                  Column(
                    children: [
                      Container(
                          height: 120,
                          width: double.infinity,
                          child:
                          Stack(
                              children:[
                                Positioned(
                                  top: 70,
                                  left: MediaQuery.of(context).size.width/2+80,
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
                                    top: 50,
                                    left: MediaQuery.of(context).size.width/2-80,
                                    child:Text("Buy Tickets",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30
                                      ),
                                    ))

                              ]
                          )
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 10.0),
                        child: new TextFormField(
                          onTap: (){
                           // showEvent();
                          },
                          validator: (input)
                          {
                            if (input.isEmpty)
                              return 'Event Required';
                          },
                          cursorColor: colorStyle.yellowDark,
                          readOnly: true,
                          controller: eventController,
                          decoration: new InputDecoration(
                              suffixIcon: Icon(Icons.keyboard_arrow_down),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintText: "Select Your Event",
                              labelText: "Event",
                              labelStyle: new TextStyle(color: const Color(0xFF424242)),
                              border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.red
                                  )
                              ),
                              focusedBorder:
                              new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: colorStyle.yellowDark
                                  )
                              ),
                              hoverColor: colorStyle.yellowDark,
                              focusColor: colorStyle.yellowDark
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 10.0),
                        child: new TextFormField(
                          onTap: (){
                            showCategory();
                          },
                          validator: (input)
                          {
                            if (input.isEmpty)
                              return 'Category Required';
                          },
                          cursorColor: colorStyle.yellowDark,
                          readOnly: true,
                          controller: categoryController,
                          decoration: new InputDecoration(
                              suffixIcon: Icon(Icons.keyboard_arrow_down),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintText: "Select Category",
                              labelText: "Category",
                              labelStyle: new TextStyle(color: const Color(0xFF424242)),
                              border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.red
                                  )
                              ),
                              focusedBorder:
                              new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: colorStyle.yellowDark
                                  )
                              ),
                              hoverColor: colorStyle.yellowDark,
                              focusColor: colorStyle.yellowDark
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 10.0),
                        child: new TextFormField(
                          validator: (input)
                          {
                            if (input.isEmpty)
                              return 'First Name Required';
                          },
                          controller: firstNameController,
                          cursorColor: colorStyle.yellowDark,
                          decoration: new InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintText: "First Name",
                              labelText: "First Name",
                              labelStyle: new TextStyle(color: const Color(0xFF424242)),
                              border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.red
                                  )
                              ),
                              focusedBorder:
                              new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: colorStyle.yellowDark
                                  )
                              ),
                              hoverColor: colorStyle.yellowDark,
                              focusColor: colorStyle.yellowDark
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 10.0),
                        child: new TextFormField(
                          validator: (input)
                          {
                            if (input.isEmpty)
                              return 'Last Name Required';
                          },
                          controller: lastNameController,
                          cursorColor: colorStyle.yellowDark,
                          decoration: new InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintText: "Last Name",
                              labelText: "Last Name",
                              labelStyle: new TextStyle(color: const Color(0xFF424242)),
                              border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.red
                                  )
                              ),
                              focusedBorder:
                              new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: colorStyle.yellowDark
                                  )
                              ),
                              hoverColor: colorStyle.yellowDark,
                              focusColor: colorStyle.yellowDark
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 10.0),
                        child: new TextFormField(
                          onTap: (){
                            showGender();
                          },
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Gender Required';
                            }
                          },
                          controller: genderController,
                          cursorColor: colorStyle.yellowDark,
                          readOnly: true,
                          decoration: new InputDecoration(
                              suffixIcon: Icon(Icons.keyboard_arrow_down),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintText: "Gender",
                              labelText: "Gender",
                              labelStyle: new TextStyle(color: const Color(0xFF424242)),
                              border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.red
                                  )
                              ),
                              focusedBorder:
                              new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: colorStyle.yellowDark
                                  )
                              ),
                              hoverColor: colorStyle.yellowDark,
                              focusColor: colorStyle.yellowDark
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 10.0),
                        child: new TextFormField(
                          validator: (input)
                          {
                            if (input.isEmpty)
                              return 'Please select nationality';
                          },
                          onTap: (){
                            showCPicker(context,nationalityController);
                            //showPicker();
                          },
                          controller: nationalityController,
                          cursorColor: colorStyle.yellowDark,
                          readOnly: true,
                          decoration: new InputDecoration(
                              suffixIcon: Icon(Icons.keyboard_arrow_down),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintText: "Select Country",
                              labelText: "Nationaltiy",
                              labelStyle: new TextStyle(color: const Color(0xFF424242)),
                              border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.red
                                  )
                              ),
                              focusedBorder:
                              new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: colorStyle.yellowDark
                                  )
                              ),
                              hoverColor: colorStyle.yellowDark,
                              focusColor: colorStyle.yellowDark
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 10.0),
                        child: new TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Email is Missing';
                            }
                            bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input);
                            if (!emailValid)
                              return 'Email is not Valid';
                          },
                          controller: emailController,
                          cursorColor: colorStyle.yellowDark,
                          decoration: new InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintText: "Enter email address",
                              labelText: "Email",
                              labelStyle: new TextStyle(color: const Color(0xFF424242)),
                              border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.red
                                  )
                              ),
                              focusedBorder:
                              new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: colorStyle.yellowDark
                                  )
                              ),
                              hoverColor: colorStyle.yellowDark,
                              focusColor: colorStyle.yellowDark
                          ),
                          keyboardType:
                          TextInputType.emailAddress,
                        ),
                      ), Padding(
                        padding:
                        const EdgeInsets.only(left: 10.0),
                        child: new TextFormField(
                          onTap: (){
                            showCPicker(context,countryResidentController);
                          },
                          validator: (input)
                          {
                            if (input.isEmpty)
                              return 'Required';
                          },
                          controller: countryResidentController,
                          cursorColor: colorStyle.yellowDark,
                          readOnly: true,
                          decoration: new InputDecoration(
                              suffixIcon: Icon(Icons.keyboard_arrow_down),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintText: "Select Country",
                              labelText: "Country of Residence",
                              labelStyle: new TextStyle(color: const Color(0xFF424242)),
                              border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.red
                                  )
                              ),
                              focusedBorder:
                              new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: colorStyle.yellowDark
                                  )
                              ),
                              hoverColor: colorStyle.yellowDark,
                              focusColor: colorStyle.yellowDark
                          ),
                        ),
                      ),
                      Padding(
                          padding:
                          const EdgeInsets.only(left: 10.0),
                          child: IntlPhoneField(
                            decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                hintText: "Phone",
                                labelText: "Mobile",
                                labelStyle: new TextStyle(color: const Color(0xFF424242)),
                                border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Colors.red
                                    )
                                ),
                                focusedBorder:
                                new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: colorStyle.yellowDark
                                    )
                                ),
                                hoverColor: colorStyle.yellowDark,
                                focusColor: colorStyle.yellowDark
                            ),
                            initialCountryCode: 'US',
                            onChanged: (phone) {
                              //phoneNumbercontroller.text = phone.completeNumber;
                              phoneText = phone.completeNumber;
                              //print(phone.completeNumber);
                            },
                          )
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        onPressed: (){

                        },
                        child:
                        Row(
                            children:[
                              Text("Add more people",
                                  style:TextStyle(
                                      color:colorStyle.yellowDark
                                  )
                              ),
                              Icon(Icons.add,color: colorStyle.yellowDark,)
                            ]
                        )

                        ,
                      ),
                       BlueButtonWidget(color1: Colors.black54,color2: Colors.black54, text: Text("Send To Cart",style: TextStyle(color: Colors.white,fontSize: 20),),onPressed: ()async {
                         final formState =
                             _buyTicketKey.currentState;
                         if (formState.validate()) {
                           formState.save();
                           final FirebaseAuth auth = FirebaseAuth.instance;
                           final FirebaseUser user = await auth.currentUser();
                          // final uid = user.uid;


                           CartItem item = new CartItem(id:Timestamp.now().microsecondsSinceEpoch , img: "",  price: 15.0, favorite: false, summary: "ticket", name: eventController.text, meta: {
                             "event_id" : widget.event.id,
                             "event_image": widget.event.event_image,
                             "event_name" : eventController.text,
                             "event_category" : categoryController.text,
                             "first_name": firstNameController.text,
                             "last_name":lastNameController.text,
                             "gender":genderController.text,
                             "nationality":nationalityController.text,
                             "email":emailController.text,
                             "country_residence":countryResidentController.text,
                             "phone":phoneText,
                             "event_from":widget.event.dtFrom.toUtc().toIso8601String(),
                             "event_to":widget.event.dtTo.toUtc().toIso8601String(),
                             "event_type":widget.event.timeType.toString()
                           });
                           bloc.addToCart(item);
                           final act = CupertinoActionSheet(
                               title: Text('Participant added'),
                               actions: <Widget>[
                                 CupertinoActionSheetAction(
                                   child: Text('+Add more participant'),
                                   onPressed: () {
                                     Navigator.pop(context);
                                   },
                                 ),
                                 CupertinoActionSheetAction(
                                   child: Text('Go  to cart'),
                                   onPressed: () {
                                     int count = 0;
                                     Navigator.of(context).popUntil((_) => count++ >= 2);
                                     Navigator.of(context)
                                         .pushReplacement(
                                         PageRouteBuilder(
                                             pageBuilder: (_,
                                                 __,
                                                 ___) =>
                                             new CartScreen(

                                             )));
                                     //Navigator.pop(context);
                                   },
                                 )
                               ],
                               cancelButton: CupertinoActionSheetAction(
                                 child: Text('Cancel'),
                                 onPressed: () {
                                   Navigator.pop(context);
                                 },
                               ));
                           showCupertinoModalPopup(
                               context: context,
                               builder: (BuildContext context) => act);
                           /*Firestore.instance.collection("cart").document().setData(
                              {
                                "user":uid,
                                "summary":"buy ticket",
                                "price":"5.6",
                                "meta" :
                                {
                                  "event_name" : eventController.text,
                                  "event_category" : categoryController.text,
                                  "first_name": firstNameController.text,
                                  "last_name":lastNameController.text,
                                  "gender":genderController.text,
                                  "nationality":nationalityController.text,
                                  "email":emailController.text,
                                  "country_residence":countryResidentController.text,
                                  "phone":phoneText
                                }
                              }
                            ).then((value) =>
                              Navigator.of(context).pop()
                            );
                            */
                         }
                       }
                       )
                     ,
                      SizedBox(height: 10,)
                    ],
                  ),
                )
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

              )
            ],
          )



    );
  }

}
