import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiwee/form/form.dart';
import 'package:kiwee/onboarding/dots_decorator.dart';
import 'package:kiwee/onboarding/intoduction_screen.dart';
import 'package:kiwee/onboarding/page_view_model.dart';
import 'package:kiwee/utility/colours.dart';

//import 'onboarding/intoduction_screen.dart';
//import '../../utility/exports/export_packages.dart';
//import '../../utility/exports/export_android_widgets.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int page = 0;

//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//      new FlutterLocalNotificationsPlugin();
//  var initializationSettingsAndroid;
//  var initializationSettingsIOS;
//  var initializationSettings;
//
//  void _showNotification() async {
//    await _demoNotification();
//  }

//  Future<void> _demoNotification() async {
//    AndroidNotificationSound sd;
//    try {
//      print("note");
//      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//          'channel_ID', 'channel name', 'channel description',
//          importance: Importance.Max,
//          playSound: true,
//          sound: sd,
//          priority: Priority.High,
//          ticker: 'test ticker');
//
//      var iOSChannelSpecifics = IOSNotificationDetails();
//      var platformChannelSpecifics = NotificationDetails(
//          androidPlatformChannelSpecifics, iOSChannelSpecifics);
//
//      await flutterLocalNotificationsPlugin.show(0, 'Hello, buddy',
//          'A message from flutter buddy', platformChannelSpecifics,
//          payload: 'test payload');
//    } catch (e) {
//      print("object Error: $e");
//    }
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    initializationSettingsAndroid =
//        new AndroidInitializationSettings('app_icon');
//    initializationSettingsIOS = new IOSInitializationSettings(
//        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//    initializationSettings = new InitializationSettings(
//        initializationSettingsAndroid, initializationSettingsIOS);
////    flutterLocalNotificationsPlugin.initialize(initializationSettings,
////        onSelectNotification: onSelectNotification);
//
//    flutterLocalNotificationsPlugin.initialize(initializationSettings,
//        onSelectNotification: onSelectNotification);
  }

//  Future onSelectNotification(String payload) async {
//    if (payload != null) {
//      debugPrint('Notification payload: $payload');
//    }
//    await Navigator.push(context,
//        new MaterialPageRoute(builder: (context) => new SecondRoute()));
//  }
//
//  Future onDidReceiveLocalNotification(
//      int id, String title, String body, String payload) async {
//    await showDialog(
//        context: context,
//        builder: (BuildContext context) => CupertinoAlertDialog(
//              title: Text(title),
//              content: Text(body),
//              actions: <Widget>[
//                CupertinoDialogAction(
//                  isDefaultAction: true,
//                  child: Text('Ok'),
//                  onPressed: () async {
//                    Navigator.of(context, rootNavigator: true).pop();
//                    await Navigator.push(context,
//                        MaterialPageRoute(builder: (context) => SecondRoute()));
//                  },
//                )
//              ],
//            ));
//  }

  var listPagesViewModel = [
    PageViewModel(
      title: "",
      body: "Record notes on the go",
      image: Image.asset(
        "assets/image1.jpeg",
        fit: BoxFit.contain,
      ),
    ),
    PageViewModel(
      title: "",
      body: "Organise your daily task with a ToDo list",
      image: Image.asset(
        "assets/image2.png",
        fit: BoxFit.cover,
      ),
    ),
    // PageViewModel(
    //   title: "",
    //   body: "Get notified of Sales, Low-Stock and Expiration",
    //   image: Image.asset(
    //     "assets/image3.jpeg",
    //     fit: BoxFit.fitWidth,
    //   ),
    // ),
    // PageViewModel(
    //   title: "",
    //   body: "Manage multiple Stores, Warehouses and Sales Agents",
    //   image: Image.asset(
    //     "assets/image4.png",
    //     fit: BoxFit.cover,
    //   ),
    // ),
    PageViewModel(
      title: "",
      body: "Take important notes",
      image: Image.asset(
        "assets/image5.jpeg",
        fit: BoxFit.contain,
      ),
    ),
    PageViewModel(
      title: "",
      body: "Organise project using a Kanban",
      image: Image.asset(
        "assets/image6.jpeg",
        fit: BoxFit.contain,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Align(
            alignment: Alignment.center,
            child: IntroductionScreen(
              pages: listPagesViewModel,
              onDone: () {
                // When done button is press

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AppForm(
                              val: 0,
                            )));
                //  _showNotification();
              },
              onSkip: () {
                // You can also override onSkip callback
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AppForm(
                              val: 1,
                            )));

                //   _showNotification();
              },
              showSkipButton: true,
              skip: const Text(
                "Skip",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: primaryColour),
              ),
              next: const Text(
                "Next",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: primaryColour),
              ),
              done: const Text("Continue",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColour)),
              //     dotsDecorator: DotsDecorator(),
              dotsDecorator: DotsDecorator(
                  size: const Size.square(10.0),
                  activeSize: const Size(20.0, 10.0),
                  activeColor: primaryColour,
                  color: Colors.black26,
                  spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0))),
            )),
      ],
    ));
  }
}

//class SecondRoute extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('AlertPage'),
//      ),
//      body: Center(
//        child: RaisedButton(
//          child: Text('go Back ...'),
//          onPressed: () {
//            Navigator.pop(context);
//          },
//        ),
//      ),
//    );
//  }
//}
