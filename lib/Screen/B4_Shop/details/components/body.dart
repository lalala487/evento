import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasty_cookpad/Screen/B1_Home_Screen/Cart.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/BlueButtonWidget.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/details/default_button.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/details/size_config.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/models/Product.dart';
import 'package:tasty_cookpad/Screen/BottomNavBar/CartItemsBloc.dart';
import 'package:tasty_cookpad/Style/Style.dart';

import 'color_dots.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';


class Body extends StatefulWidget {
  final Product product;
  const Body({
    Key key,
    @required this.product,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();

}

class _BodyState extends State<Body>  {
  String selectedSize = "XL";
  int selectedColorIndex;
  int quantity;

  void updateColorIndex([int value]) {
    selectedColorIndex = value;
  }

  void updateQuantity([int value]) {
    quantity = value;
  }

  void initState()
  {
    selectedColorIndex = 0;
    quantity = 1;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProductImages(product: widget.product),
        TopRoundedContainer(
          color: Colors.white,

          child: Column(
            children: [
              ProductDescription(
                product: widget.product,
                pressOnSeeMore: () {},
              ),
             // TopRoundedContainer(
              //  color: Color(0xFFF6F7F9),
              //  child: Column(
              //    children: [
                    ColorDots(product: widget.product, selColorIndex:updateColorIndex, quantity:updateQuantity),
          Row(
            children: [
              ButtonTheme(
                minWidth: 10.0,
                height: 30.0,
                child:
                FlatButton(

                  onPressed: (){
                    selectedSize = "XL";
                    setState(() {

                    });                  },
                materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                  child:
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(  color: selectedSize=="XL"? Colors.black:Colors.black26, width: 1.0)
                    ),
                    child:
                  Text("XL" , style: TextStyle(color: Colors.black26),))
              )),
              ButtonTheme(
                  minWidth: 10.0,
                  height: 30.0,
                  child:
                  FlatButton(

                      onPressed: (){
                        selectedSize = "S";
                        setState(() {

                        });                      },
                      materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                      child:
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all( color: selectedSize=="S"? Colors.black:Colors.black26,width: 1.0)
                          ),
                          child:
                          Text("S", style: TextStyle(color: Colors.black26)))
                  )),
              ButtonTheme(
                  minWidth: 10.0,
                  height: 30.0,
                  child:
                  FlatButton(

                      onPressed: (){
                        selectedSize = "XXL";
                        setState(() {

                        });                      },
                      materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                      child:
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: selectedSize=="XXL"? Colors.black: Colors.black26, width: 1.0)
                          ),
                          child:
                          Text("XXL", style: TextStyle(color: Colors.black26)))
                  )),
              ButtonTheme(
                  minWidth: 10.0,
                  height: 30.0,
                  child:
                  FlatButton(

                      onPressed: (){
                        selectedSize = "M";
                        setState(() {

                        });
                        print("click");
                      },
                      materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                      child:
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: selectedSize=="M"? Colors.black: Colors.black26, width: 1.0)
                          ),
                          child:
                          Text("M" , style: TextStyle(color: Colors.black26)))
                  )),
              ButtonTheme(
                  minWidth: 10.0,
                  height: 30.0,
                  child:
                  FlatButton(

                      onPressed: (){
                        selectedSize = "L";
                        setState(() {

                        });                      },
                      materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                      child:
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: selectedSize=="L"? Colors.black: Colors.black26, width: 1.0)
                          ),
                          child:
                          Text("L", style: TextStyle(color: Colors.black26)))
                  )),
            ],
          ),
          RaisedButton(
            onPressed: (){
              print("size: $selectedSize");
              print("color:  ${widget.product.colors[selectedColorIndex]}");
              print("quantity: $quantity");
              CartItem item = new CartItem(id:Timestamp.now().microsecondsSinceEpoch , itemnum: quantity, img: widget.product.image,  price: widget.product.price, favorite: false, summary: "shop", name: widget.product.title, meta: {
                  "size":selectedSize,
                  "color":  widget.product.colorsString[selectedColorIndex]
              });
              bloc.addToCart(item);

            },
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            )),
            padding: EdgeInsets.all(0.0),
              child:
              Ink(
                //margin: EdgeInsets.only(top: getProportionateScreenWidth(20)),
                padding: EdgeInsets.only(top: getProportionateScreenWidth(20)),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorStyle.yellowDark,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2.0,
                        color: Colors.black12.withOpacity(0.1),
                        spreadRadius: 2.0)
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child:
                        Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.15,
                          right: SizeConfig.screenWidth * 0.15,
                          bottom: getProportionateScreenWidth(15),
                          top: getProportionateScreenWidth(0),
                        ),
                        child:
                            Align(
                              alignment: Alignment.center,
                              child:
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:[
                                    Image.asset("assets/image/icon_cart.png"),
                                    Text("  Add To Cart", textAlign : TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20 ,))
                                  ]
                              )
                              ,
                            )
                        //BlueButtonWidget(color1: Colors.black54,color2: Colors.black54, text: Text("Add To Cart",style: TextStyle(color: Colors.white,fontSize: 20),),onPressed: ()async {})

                      ),
                    )),
              //    ],
              //  ),
             // ),
            ],
          ),
        ),
      ],
    );
  }
}
