import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:kiwee/form/login.dart';
import 'package:kiwee/front/kanban.dart';
import 'package:kiwee/front/kanban_list.dart';

import 'package:kiwee/front/my_notes.dart';
import 'package:kiwee/front/new_note_page.dart';
import 'package:kiwee/front/ocr.dart';
import 'package:kiwee/front/ocr_list.dart';
import 'package:kiwee/front/profile.dart';
import 'package:kiwee/front/text_to_speech_list.dart';
import 'package:kiwee/front/todo.dart';
import 'package:kiwee/utility/colours.dart';


class Front extends StatefulWidget {
  final int index;
  Front({this.index = 3});
  @override
  _FrontState createState() => _FrontState();
}

class _FrontState extends State<Front> {
  int _currentIndex;

  GlobalKey<CircularMenuState> crKey = GlobalKey<CircularMenuState>();

  double pi = 3.142;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentIndex = widget.index;
  }

  List<Widget> _widgetOptions = <Widget>[
    MyNotes(),
    Todo(),
    KanbanList(),
    NewNote(),
    OcrList(),
    RecordNote(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      bottomNavigationBar: CurvedNavigationBar(
        index: widget.index,
        height: 50,
        animationDuration: Duration(milliseconds: 600),
        backgroundColor: white,
        color: primaryColour,
        buttonBackgroundColor: primaryColour,
        items: <Widget>[
          Icon(
            Icons.note,
            color: white,
          ),
          Icon(
            Icons.calendar_today,
            color: white,
          ),
          Icon(
            Icons.today,
            color: white,
          ),
          Icon(
            Icons.add,
            color: white,
          ),
          Icon(
            Icons.camera,
            color: white,
          ),
          Icon(
            Icons.record_voice_over,
            color: white,
          ),
          Icon(
            Icons.person,
            color: white,
          ),
        ],
        onTap: (int i) {
          setState(() {
            _currentIndex = i;
          });
        },
      ),
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),
    );
  }
}
