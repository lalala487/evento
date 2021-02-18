import 'dart:convert';
import 'dart:ui';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
List<CartItem> getCartItem(SharedPreferences prefs)
{
    String decodeS = prefs.get('cart');
    if (decodeS == null)
      return List<CartItem>();
    List<CartItem> saved = CartItem.decode(decodeS);
    return saved;
}

List<CartItem> addCartItem(SharedPreferences prefs, CartItem cart)
{
  List<CartItem> items = getCartItem(prefs);
  items.add(cart);
  String test = CartItem.encode(items);
  prefs.setString('cart', test);
  print(test);
  return items;

}
class CartItem {
  final int id;
  final String name, img;
  double price;
  int itemnum;
  String summary;
  bool favorite;
  Map<dynamic,dynamic> meta;
  CartItem({
    this.id,
    this.name,
    this.price,
    this.itemnum,
    this.summary,
    this.meta,
    this.img,
    this.favorite,
  });

  Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  factory CartItem.fromJson(Map<String, dynamic> jsonData) {
    //print( jsonData);
    return CartItem(
      id: jsonData['id'],
      name: jsonData['name'],
      price: jsonData['price'],
      summary: jsonData['summary'],
      itemnum: jsonData['itemnum'],
      meta: jsonData['meta'],
      img: jsonData['img'],
      favorite: jsonData['favorite'],
    );
  }

  static Map<String, dynamic> toMap(CartItem item) => {
    'id': item.id,
    'name': item.name,
    'price': item.price,
    'summary': item.summary,
    'meta': item.meta,
    'img': item.img,
    'itemnum':item.itemnum,
    'favorite': item.favorite,
  };

  static String encode(List<CartItem> items) => json.encode(
    items
        .map<Map<String, dynamic>>((music) => CartItem.toMap(music))
        .toList(),
  );

  static List<CartItem> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<CartItem>((item) => CartItem.fromJson(item))
          .toList();
}