import 'package:flutter/material.dart';

import 'utility/exports/exports_utilities.dart';

import 'form/form.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: CustomSplash(
              duration: 5000,
              imagePath: ClipRect(
                child: Center(
                  child: Text(
                    "KAWEE",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColour),
                  ),
                ),
              ),
              animationEffect: 'fade-in',
              home: AppForm(
                val: 0,
              ),
            ),
          )
        ],
      ),
    ));
  }
}
