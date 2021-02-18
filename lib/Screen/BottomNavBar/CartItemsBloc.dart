import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasty_cookpad/Screen/B1_Home_Screen/Cart.dart';

class CartItemsBloc {
  /// The [cartStreamController] is an object of the StreamController class
  /// .broadcast enables the stream to be read in multiple screens of our app
  final cartStreamController = StreamController.broadcast();

  /// The [getStream] getter would be used to expose our stream to other classes
  Stream get getStream => cartStreamController.stream;

   List<CartItem> items;

  CartItemsBloc() {
    getAllItems();
  }
  void getAllItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    items =  getCartItem(prefs);
    cartStreamController.sink.add(items);
  }
  void setCatEmpty() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cart');
  }
  void addToCart(item) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    items =  addCartItem(prefs, item);
    cartStreamController.sink.add(items);
  }

  void reomveAllCart() async{
    items = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String test = CartItem.encode(items);
    prefs.setString('cart', test);

    cartStreamController.sink.add(items);
  }

  void removeFromCart(item) async {
    //items.remove(item);
    items.removeWhere((element) => element.id == item.id);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String test = CartItem.encode(items);
    prefs.setString('cart', test);

    cartStreamController.sink.add(items);

  }

  /// The [dispose] method is used
  /// to automatically close the stream when the widget is removed from the widget tree
  void dispose() {
    cartStreamController.close(); // close our StreamController
  }
}

final bloc = CartItemsBloc();
