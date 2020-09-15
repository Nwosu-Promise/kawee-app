export 'dart:collection';
export 'dart:convert';
export 'dart:io';
export 'dart:async';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiwee/front/front.dart';
import 'package:kiwee/utility/api.dart';
import 'package:kiwee/utility/exports/exports_utilities.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiUtility apiUtility = ApiUtility();
SharedPreferences preferences;

class AddNote extends StatefulWidget {
  final String edit;
  final String title;
  final String content;
  final String id;
  AddNote({this.edit, this.title, this.content, this.id});
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController _title;
  TextEditingController _content;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _content = TextEditingController();
    _title = TextEditingController();
    _content.text = widget.edit == null ? "" : widget.content;
    _title.text = widget.edit == null ? "" : widget.title;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.62;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.edit == null ? "New Note" : "Update Note",
          style: TextStyle(
              color: white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          widget.edit == null
              ? Center()
              : IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text(
                                "Delete Note",
                                textAlign: TextAlign.center,
                              ),
                              content: Text(
                                "Are you sure you want to delete ${widget.title} from your note list?",
                                textAlign: TextAlign.justify,
                              ),
                              actions: [
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "No",
                                    style: TextStyle(color: primaryColour),
                                  ),
                                  splashColor: primaryColour.withOpacity(.6),
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    preferences =
                                        await SharedPreferences.getInstance();

                                    String token =
                                        preferences.getString("token");
                                    String success;

                                    print(apiUtility.updateNote);
                                    print(apiUtility.updateNote + widget.id);

                                    Response response = await delete(
                                        apiUtility.updateNote + widget.id,
                                        headers: {
                                          'Authorization': 'Bearer $token',
                                        });

                                    print(response.statusCode);
                                    print(response.body);

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => Front(
                                                  index: 0,
                                                )));
                                  },
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(color: primaryColour),
                                  ),
                                  splashColor: primaryColour.withOpacity(.6),
                                )
                              ],
                            ));
                  })
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _title,
                    decoration: InputDecoration(
                        labelText: "Title", hintText: "Note Title"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: height,
                    child: TextField(
                      controller: _content,
                      maxLines: 30,
                      textAlignVertical: TextAlignVertical(y: .8),
                      decoration: InputDecoration(
                          labelText: "Content",
                          hintText: "What's on your mind?",
                          alignLabelWithHint: true),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                          widget.edit == null ? "Add Note" : "Update Note"),
                      onPressed: widget.edit == null
                          ? () async {
                              preferences =
                                  await SharedPreferences.getInstance();

                              String token = preferences.getString("token");
                              String success;
                              Map<String, dynamic> body = {
                                "title": _title.text,
                                "content": _content.text,
                              };

                              Response response = await post(apiUtility.newNote,
                                  body: body,
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                  });

                              if (response.statusCode == 200) {
                                var responseBody = json.decode(response.body);
                                success = responseBody["status"];
                                if (success == "success") {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => Front(
                                                index: 0,
                                              )));
                                } else {}
                              } else {
                                print(response.statusCode);
                                print(response.body);
                              }

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Front(
                                            index: 0,
                                          )));
                            }
                          : () async {
                              preferences =
                                  await SharedPreferences.getInstance();

                              String token = preferences.getString("token");
                              String success;
                              Map<String, dynamic> body = {
                                "title": _title.text,
                                "content": _content.text,
                              };
                              print(apiUtility.updateNote + widget.id);

                              Response response = await patch(
                                  apiUtility.updateNote + widget.id,
                                  body: body,
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                  });

                              if (response.statusCode == 200) {
                                var responseBody = json.decode(response.body);
                                success = responseBody["status"];
                                if (success == "success") {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => Front(
                                                index: 0,
                                              )));
                                } else {}
                              } else {
                                print(response.statusCode);
                                print(response.body);
                              }

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Front(
                                            index: 0,
                                          )));
                            },
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
