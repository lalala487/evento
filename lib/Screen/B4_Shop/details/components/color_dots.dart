import 'package:flutter/material.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/details/constants.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/details/size_config.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/models/Product.dart';
import 'package:tasty_cookpad/Screen/B4_Shop/rounded_icon_btn.dart';
class ColorDots extends StatefulWidget {
  Product product;
  final ValueChanged<int> selColorIndex;
  final ValueChanged<int> quantity;
  ColorDots({
    Key key,
    @required this.product,
    this.quantity,
    this.selColorIndex
  }) : super(key: key);

  @override
  _ColorDotsState createState() => _ColorDotsState();

}

class _ColorDotsState extends State<ColorDots> {
  int selectedColor = 0;
  int itemnum = 1;


  @override
  Widget build(BuildContext context) {
    // Now this is fixed and only for demo
    print("color length is :------------- ${widget.product.colors.length}");

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        children: [
          ...List.generate(
            widget.product.colors.length,
            (index) =>
                InkWell(
                  onTap: (){
                    selectedColor = index;
                    widget.selColorIndex(selectedColor);
                    setState(() {

                    });
                  },
                  child:
                  ColorDot(
                      color: widget.product.colors[index],
                      isSelected: index == selectedColor,
                  )
                      ,
                )
            ,
          ),
          Spacer(),
          _decrementButton(),
          /*
          SizedBox(width: getProportionateScreenWidth(20),
          child:

          ),
          )*/
          Text(
              '${itemnum}',
              style: TextStyle(fontSize: 18.0),
          )
          ,
          _incrementButton()
        ],
      ),
    );
  }

  Widget _incrementButton() {
    return
      ButtonTheme(
        minWidth: 30,
        height: 30,
        child: RaisedButton(
          onPressed: () {
            setState(() {
              itemnum++;
            });
            widget.quantity (itemnum);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xffBECBD4), Color(0xffBECBD4)],
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

  Widget _decrementButton() {
    return
      ButtonTheme(
        minWidth: 30,
        height: 30,
        child: RaisedButton(
          onPressed: () {
            if (itemnum == 1)
              return;
            setState(() {
              itemnum--;
            });
            widget.quantity (itemnum);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xffBECBD4), Color(0xffBECBD4)],
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
}

class ColorDot extends StatelessWidget {
  const ColorDot({
    Key key,
    @required this.color,
    this.isSelected = false,
  }) : super(key: key);

  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2),
      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
      height: getProportionateScreenWidth(40),
      width: getProportionateScreenWidth(40),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border:
            Border.all(color: isSelected ? kPrimaryColor : Colors.transparent),
        shape: BoxShape.circle,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
