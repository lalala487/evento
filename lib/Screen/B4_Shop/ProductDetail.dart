import 'package:flutter/material.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/details/components/body.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/details/components/custom_app_bar.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/details/size_config.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/models/Product.dart';



class DetailsScreen1 extends StatelessWidget {
  static String routeName = "/details";
  Product product;
  DetailsScreen1({
      this.product
  });
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,//Color(0xFFF5F6F9),
        appBar: CustomAppBar(rating: product.rating),
        body:
        SingleChildScrollView(
          child: Body(product: product),
        )

    );
  }
}

class ProductDetailsArguments {
  final Product product;

  ProductDetailsArguments({@required this.product});
}
