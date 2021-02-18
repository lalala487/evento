import 'package:flutter/material.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/details/constants.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/details/size_config.dart';
import 'package:tasty_cookpad/Style/Style.dart';

class CustomAppBar extends PreferredSize {
  final double rating;

  CustomAppBar({@required this.rating});

  @override
  // AppBar().preferredSize.height provide us the height that appy on our app bar
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Row(
          children: [
            ButtonTheme(
              minWidth: 50.0,
              height: 0.0,
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
            /*
            SizedBox(
              height: getProportionateScreenWidth(40),
              width: getProportionateScreenWidth(40),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
                color: Colors.white,
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
                child:  Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: kPrimaryColor,
                )
              ),
            )*/,
            Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Text(
                    "$rating",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.star,
                    size: 20,
                    color: colorStyle.yellowDark,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
