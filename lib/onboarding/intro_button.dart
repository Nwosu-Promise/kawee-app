import 'package:flutter/material.dart';

class IntroButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const IntroButton({Key key, this.onPressed, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding:const EdgeInsets.all(0),
      onPressed: onPressed,
      child: child,
      splashColor: Colors.deepOrangeAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }
}
