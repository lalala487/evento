import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
   String id;
   String title, description;
   List<dynamic> images;
   List<Color> colors;
   List<dynamic> colorsString;
   double rating, price;
   bool isFavourite, isPopular;
   String image;
   int selectedColorIndex;

  Product()
  {

  }

   Color fromHex(String hexString) {
     final buffer = StringBuffer();
     if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
     buffer.write(hexString.replaceFirst('#', ''));
     return Color(int.parse(buffer.toString(), radix: 16));
   }

  readFromList(DocumentSnapshot data)
  {
    selectedColorIndex = 0;
    id = data.documentID;
    images = List();
    if (data['images'] != null)
    {
      images = data['images'];
    }
    List<dynamic> colorsr = data['colors'];
    colorsString = colorsr;
    colors = List();
    if (colorsr != null)
    for (var color in colorsr)
    {
        colors.add(  fromHex(color));
    }
    price = double.parse(data["price"]);
    rating = 0.0;
    if (data["rating"]!= null)
      rating = double.parse(data["rating"]);
    isFavourite = false;
    isPopular = false;
    title = data['productName'];
    description =  data['description'];
    image = data["image"];
  }
}

// Our demo Products
/*
List<Product> demoProducts = [
  Product(
    id: 1,
    images: [
      "assets/image/shop/ps4_console_white_1.png",
      "assets/image/shop/ps4_console_white_2.png",
      "assets/image/shop/ps4_console_white_3.png",
      "assets/image/shop/ps4_console_white_4.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Wireless Controller for PS4™",
    price: 64.99,
    description: description,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 2,
    images: [
      "assets/image/shop/Image Popular Product 2.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Nike Sport White - Man Pant",
    price: 50.5,
    description: description,
    rating: 4.1,
    isPopular: true,
  ),
  Product(
    id: 3,
    images: [
      "assets/image/shop/glap.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Gloves XC Omega - Polygon",
    price: 36.55,
    description: description,
    rating: 4.1,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 4,
    images: [
      "assets/image/shop/wireless headset.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Logitech Head",
    price: 20.20,
    description: description,
    rating: 4.1,
    isFavourite: true,
  ),
];
*/
const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
