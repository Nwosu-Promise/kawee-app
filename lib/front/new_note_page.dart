//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kiwee/front/front.dart';
import 'package:kiwee/newNote/add_note.dart';
//import 'package:kiwee/newNote/ocr.dart';
import 'package:kiwee/utility/api.dart';
import 'package:kiwee/utility/colours.dart';
import 'package:kiwee/widgets/kawe_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences preferences;
ApiUtility apiUtility = ApiUtility();

class NewNote extends StatefulWidget {
  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
//  var _textValue;
//  int _cameraOcr = 0;

  String lastName = "";
  String firstName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetail();
  }

  getDetail() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      firstName = preferences.getString("firstName");
      lastName = preferences.getString("lastName");
    });
  }

  dashBoard() async {
    preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");
    print(token);

    String status;
    var note;
    var ocrs;
    var todo;
    var kanban;
    var vrecs;

    List<Map> dashBoard = [];

    Response response = await get(apiUtility.dashBoard, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      status = responseBody["status"];
      if (status == "success") {
        note = responseBody["note"] as Map;
        dashBoard.add(note);
        ocrs = responseBody["ocr"] as Map;
        dashBoard.add(ocrs);
        todo = responseBody["todo"] as Map;
        dashBoard.add(todo);
        kanban = responseBody['kanban'] as Map;
        dashBoard.add(kanban);
        vrecs = responseBody["tts"] as Map;
        dashBoard.add(vrecs);

        return dashBoard;
      } else {}
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: white,
      appBar: KaweAppbar(
        title: Text(
          "Hi $firstName",
          style: TextStyle(
              color: white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: FutureBuilder(
            future: dashBoard(),
            builder: (_, snapshot) {
              var data = snapshot.data as List;
              return snapshot.hasData
                  ? data.isNotEmpty
                      ? Container(
                          height: height,
                          padding: const EdgeInsets.all(10),
                          child: ListView(
                            children: [
                              Container(
                                height: height * .15,
                                margin: EdgeInsets.all(10),
                                child: Card(
                                  elevation: 8,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.note,
                                      size: 90,
                                      color: primaryColour,
                                    ),
                                    title: Text(
                                      "Notes",
                                      style: TextStyle(color: primaryColour),
                                    ),
                                    subtitle: Text(
                                      "Total: ${data[0]["lenght"]}",
                                      style: TextStyle(color: primaryColour),
                                    ),
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Front(
                                                    index: 0,
                                                  )));
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                height: height * .15,
                                margin: EdgeInsets.all(10),
                                child: Card(
                                  elevation: 8,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.camera_alt,
                                      size: 90,
                                      color: primaryColour,
                                    ),
                                    title: Text(
                                      "OCRs",
                                      style: TextStyle(color: primaryColour),
                                    ),
                                    subtitle: Text(
                                      "Total: ${data[1]["lenght"]}",
                                      style: TextStyle(color: primaryColour),
                                    ),
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Front(
                                                    index: 4,
                                                  )));
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                height: height * .15,
                                margin: EdgeInsets.all(10),
                                child: Card(
                                  elevation: 8,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.today,
                                      size: 90,
                                      color: primaryColour,
                                    ),
                                    title: Text(
                                      "ToDos",
                                      style: TextStyle(color: primaryColour),
                                    ),
                                    subtitle: Text(
                                      "Total: ${data[2]["lenght"]}",
                                      style: TextStyle(color: primaryColour),
                                    ),
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Front(
                                                    index: 1,
                                                  )));
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                height: height * .15,
                                margin: EdgeInsets.all(10),
                                child: Card(
                                  elevation: 8,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.calendar_today,
                                      size: 90,
                                      color: primaryColour,
                                    ),
                                    title: Text(
                                      "Kanban",
                                      style: TextStyle(color: primaryColour),
                                    ),
                                    subtitle: Text(
                                      "Total: ${data[3]["lenght"]}",
                                      style: TextStyle(color: primaryColour),
                                    ),
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Front(
                                                    index: 2,
                                                  )));
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                height: height * .15,
                                margin: EdgeInsets.all(10),
                                child: Card(
                                  elevation: 8,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.mic,
                                      size: 90,
                                      color: primaryColour,
                                    ),
                                    title: Text(
                                      "Text to Speech",
                                      style: TextStyle(color: primaryColour),
                                    ),
                                    subtitle: Text(
                                      "Total: ${data[4]["lenght"]}",
                                      style: TextStyle(color: primaryColour),
                                    ),
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Front(
                                                    index: 5,
                                                  )));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text("No data")
                  : CircularProgressIndicator(
                      backgroundColor: primaryColour,
                    );
            }),
//          child: Container(
//        height: height,
//        padding: const EdgeInsets.all(10),
//        child: ListView(
//          children: <Widget>[
//            Container(
//              margin: EdgeInsets.all(20),
//              height: height * .20,
//              child: Card(
//                elevation: 8,
//                child: ListTile(
//                  isThreeLine: true,
//                  leading: Icon(
//                    Icons.mic,
//                    size: 90,
//                    color: primaryColour,
//                  ),
//                  title: Text(
//                    "Voice Recordings",
//                    style: TextStyle(color: primaryColour),
//                  ),
//                  subtitle: Text(
//                    "Total:20",
//                    style: TextStyle(color: primaryColour),
//                  ),
//                  onTap: () {},
//                ),
//              ),
//            ),
//            Container(
//              height: height * .20,
//              margin: EdgeInsets.all(20),
//              child: Card(
//                elevation: 8,
//                child: ListTile(
//                  leading: Icon(
//                    Icons.note,
//                    size: 90,
//                    color: primaryColour,
//                  ),
//                  title: Text(
//                    "Notes",
//                    style: TextStyle(color: primaryColour),
//                  ),
//                  subtitle: Text(
//                    "Total:20",
//                    style: TextStyle(color: primaryColour),
//                  ),
//                  onTap: () {
//                    Navigator.pushReplacement(
//                        context,
//                        MaterialPageRoute(
//                            builder: (_) => Front(
//                                  index: 0,
//                                )));
//                  },
//                ),
//              ),
//            ),
//            Container(
//              height: height * .20,
//              margin: EdgeInsets.all(20),
//              child: Card(
//                  elevation: 8,
//                  child: ListTile(
//                    leading: Icon(
//                      Icons.today,
//                      size: 90,
//                      color: primaryColour,
//                    ),
//                    title: Text(
//                      "ToDo",
//                      style: TextStyle(color: primaryColour),
//                    ),
//                    subtitle: Text(
//                      "Total:20",
//                      style: TextStyle(color: primaryColour),
//                    ),
//                  )),
//            ),
//            Container(
//              margin: EdgeInsets.all(20),
//              height: height * .20,
//              child: Card(
//                  elevation: 8,
//                  child: ListTile(
//                    leading: Icon(
//                      Icons.camera_alt,
//                      size: 90,
//                      color: primaryColour,
//                    ),
//                    title: Text(
//                      "OCR",
//                      style: TextStyle(color: primaryColour),
//                    ),
//                    subtitle: Text(
//                      "Total:20",
//                      style: TextStyle(color: primaryColour),
//                    ),
//                  )),
//            ),
////            Container(
////              height: height*.25,
////              child: Card(
////                  child: ListTile(
////                title: Text("Voice Recordings"),
////                subtitle: Text("Total:20"),
////              )),
////            ),
//          ],
//        ),
//      )
      ),
    );
  }
}
