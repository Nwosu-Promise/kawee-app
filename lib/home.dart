import 'package:flutter/material.dart';
import 'package:kiwee/front/front.dart';
import 'package:kiwee/onboarding/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utility/exports/exports_utilities.dart';

import 'form/form.dart';

SharedPreferences preferences;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool oldUser = false;
  duringSplash() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var phone = pref.get('token');
    setState(() {});

    phone == null
        ? setState(() {
            oldUser = false;
          })
        : setState(() {
            oldUser = true;
          });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    duringSplash();
  }

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
              home: oldUser ? Front() : WelcomePage(),
              // home: AppForm(
              //   val: 0,
              // ),
            ),
          )
        ],
      ),
    ));
  }
}
