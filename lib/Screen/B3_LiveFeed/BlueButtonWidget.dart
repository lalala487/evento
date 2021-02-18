import 'package:flutter/material.dart';

class BlueButtonWidget extends StatelessWidget {
  const BlueButtonWidget(
      {Key key,
        @required this.color1,
        @required this.color2,
        @required this.text,
        @required this.onPressed})
      : super(key: key);

  final Color color1;
  final Color color2;
  final Text text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: RaisedButton(
        onPressed: this.onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xffF8A127), Color(0xff7C5114)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(24.0)
          ),
          child: Container(
              constraints: BoxConstraints(maxWidth: 350.0, minHeight: 60.0),
              alignment: Alignment.center,
              child:  this.text
          ),
        ),
      ),
    );
  }
}


