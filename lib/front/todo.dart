import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kiwee/front/done_todo.dart';
import 'package:kiwee/front/front.dart';
import 'package:kiwee/newNote/add_note.dart';
import 'package:kiwee/utility/api.dart';
import 'package:kiwee/utility/exports/exports_utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiUtility apiUtility = ApiUtility();
SharedPreferences preferences;

class Todo extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  TextEditingController _title;
  Key key;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _title = TextEditingController();
  }

  getTodo() async {
    preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");

    String status;
    var data;

    Response response = await get(apiUtility.getTodo + "false", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      status = responseBody["status"];

      if (status == "success") {
        var dd = responseBody["data"] as Map;
        data = dd["data"] as List;

        return data;
      } else {}
    } else {
      print(response.statusCode);
      print(response.body);
    }

    print(response.body);
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.check,
              color: Colors.white,
            ),
            Text(
              "Done",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ToDos",
          style: TextStyle(
              color: white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => DoneTodo()));
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColour,
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => StatefulBuilder(
                      builder: (_, setState) => AlertDialog(
                        title: Text(
                          "Task Name",
                          textAlign: TextAlign.center,
                        ),
                        content: TextField(
                          controller: _title,
                          decoration: InputDecoration(
                              labelText: "Task", hintText: "Type task name"),
                        ),
                        actions: [
                          FlatButton(
                            child: Text("Dismiss"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("Add"),
                            onPressed: () async {
                              await SharedPreferences.getInstance();

                              String token = preferences.getString("token");
                              String success;
                              Map<String, dynamic> body = {
                                "task": _title.text,
                                "description": "_content.text",
                              };

                              Response response = await post(apiUtility.newTodo,
                                  body: body,
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                  });

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Front(
                                            index: 1,
                                          )));
                            },
                          )
                        ],
                      ),
                    ));
          }),
      body: Container(
          child: FutureBuilder(
        future: getTodo(),
        builder: (_, snapshot) {
          var data = snapshot.data as List;

          return snapshot.hasData
              ? data.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.all(10),
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (_, index) {
                            final item = data[index];

                            return Dismissible(
                              key:Key(item["_id"]),
                              background: slideRightBackground(),
                              secondaryBackground: slideLeftBackground(),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  final bool res = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(
                                              "Are you sure you want to delete ?"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            FlatButton(
                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onPressed: () async {
                                                // TODO: Delete the item from DB etc..

                                                preferences =
                                                    await SharedPreferences
                                                        .getInstance();

                                                String token = preferences
                                                    .getString("token");
                                                String success;

                                                print(apiUtility.deleteTodo +
                                                    data[index]["_id"]);
                                                Response response =
                                                    await delete(
                                                        apiUtility.deleteTodo +
                                                            data[index]["_id"],
                                                        headers: {
                                                      'Authorization':
                                                          'Bearer $token',
                                                    });

                                                print(response.statusCode);
                                                print(response.body);

                                                Navigator.of(context).pop();
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) => Front(
                                                              index: 1,
                                                            )));
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                  return res;
                                } else {
                                  // TODO: Navigate to edit page;
                                  preferences =
                                      await SharedPreferences.getInstance();

                                  String token = preferences.getString("token");
                                  String success;

                                  Map<String, dynamic> body = {
                                    "status": "true"
                                  };

                                  print(apiUtility.deleteTodo +
                                      data[index]["_id"]);
                                  Response response = await patch(
                                      apiUtility.deleteTodo +
                                          data[index]["_id"],
                                      body: body,
                                      headers: {
                                        'Authorization': 'Bearer $token',
                                      });

                                  print(response.statusCode);
                                  print(response.body);

                                  setState(() {
                                    data.removeAt(index);
                                  });
                                //

                                  //  Navigator.of(context).pop();
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (_) => Front(
                                  //           index: 1,
                                  //         )));
                                  return true;
                                }
                              },
                              onDismissed: (direction) {
                               setState(() {
                                 direction == DismissDirection.startToEnd
                                     ? data.removeAt(index)
                                     : print("osi");
                               });
                              },
                              child: Card(
                                child: ListTile(
                                  title:
                                      Text("${snapshot.data[index]["task"]}"),
                                  onTap: () {
                                    // print(snapshot.data[index]);
                                    // print(snapshot.data[index]["_id"]);
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (_) => AddNote(
                                    //           edit: "edit",
                                    //           title: snapshot.data[index]
                                    //           ["title"],
                                    //           content: snapshot.data[index]
                                    //           ["content"],
                                    //           id: snapshot.data[index]["_id"],
                                    //         )));
                                  },
                                ),
                              ),
                            );
                          }),
                    )
                  : Center(
                      child: Text("No Task"),
                    )
              : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: primaryColour,
                  ),
                );
        },
      )),
    );
  }
}
