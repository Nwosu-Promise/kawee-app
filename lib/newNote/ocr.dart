import 'package:flutter/material.dart';

class CameraScan extends StatelessWidget {
  final value;
  CameraScan({this.value});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Text("${value[0].value}"),
      ),
    );
  }
}
