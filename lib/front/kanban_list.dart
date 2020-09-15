import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kiwee/front/front.dart';
import 'package:kiwee/front/kanban.dart';
import 'package:kiwee/utility/api.dart';
import 'package:kiwee/utility/exports/exports_utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences preferences;
ApiUtility apiUtility = ApiUtility();

class KanbanList extends StatefulWidget {
  @override
  _KanbanListState createState() => _KanbanListState();
}

class _KanbanListState extends State<KanbanList> {
  getAllBoard() async {
    preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");
    String status;
    var data;

    Response response = await get(apiUtility.getAllKanban, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      status = responseBody["status"];

      if (status == "success") {
        var data = responseBody["results"] as List;
        //  data = dd["columns"] as List;

        return data;
      } else {}
    } else {
      print(response.statusCode);
      print(response.body);
    }

    print(response.body);
  }

  TextEditingController _content;
  TextEditingController _editContent;

  String value;
  String value1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _content = TextEditingController();
    _editContent = TextEditingController();
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
              "Edit",
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
          "Kanban",
          style: TextStyle(
              color: white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
                          "Kanban Name",
                          textAlign: TextAlign.center,
                        ),
                        content: Container(
                          child: TextField(
                            controller: _content,
                            decoration: InputDecoration(
                                labelText: "Kanban Name",
                                hintText: "Type Kanban Name"),
                            onChanged: (value) {
                              setState(() {
                                this.value = value;
                              });
                            },
                          ),
                        ),
                        actions: [
                          FlatButton(
                            child: Text("Dismiss"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          value == null || value == ""
                              ? Center()
                              : FlatButton(
                                  child: Text("Continue"),
                                  onPressed: () async {
                                    preferences =
                                        await SharedPreferences.getInstance();

                                    String token =
                                        preferences.getString("token");

                                    String success;

                                    Map<String, dynamic> body = {
                                      "title": _content.text,
                                    };

                                    Response response = await post(
                                        apiUtility.createKanban,
                                        body: body,
                                        headers: {
                                          'Authorization': 'Bearer $token',
                                        });

                                    print(
                                        "Create Kanban:${response.statusCode}");
                                    if (response.statusCode == 201) {
                                      var responseBody =
                                          json.decode(response.body);
                                      success = responseBody["status"];
                                      if (success == "success") {
                                        var data = responseBody["data"] as Map;
                                        print(" data['_id']:${data["_id"]}");
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => Kanban(
                                                      title: data["title"],
                                                      projectId: data["_id"],
                                                    )));
                                        // Navigator.pushReplacement(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (_) => KanbanList()));
                                      } else {}
                                    } else {
                                      print(response.statusCode);
                                      print(response.body);
                                    }
                                  },
                                ),
                        ],
                      ),
                    ));
          }),
      body: Container(
        child: FutureBuilder(
            future: getAllBoard(),
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
                                  key: Key(item["_id"]),
                                  background: slideRightBackground(),
                                  secondaryBackground: slideLeftBackground(),
                                  confirmDismiss: (direction) async {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      final bool res = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (_, setState) =>
                                                  AlertDialog(
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
                                                      Navigator.of(context)
                                                          .pop();
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

                                                      Response response =
                                                          await delete(
                                                              apiUtility
                                                                      .deleteKanban +
                                                                  snapshot.data[
                                                                          index]
                                                                      ["_id"],
                                                              headers: {
                                                            'Authorization':
                                                                'Bearer $token',
                                                          });

                                                      print(
                                                          response.statusCode);
                                                      print(response.body);

                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  Front(
                                                                    index: 2,
                                                                  )));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                      return res;
                                    } else {
                                      // TODO: Navigate to edit page;

                                      final bool pes = await showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: Text(
                                                  "Edit Project Name",
                                                  textAlign: TextAlign.center,
                                                ),
                                                content: Container(
                                                  child: TextField(
                                                    controller: _editContent,
                                                    decoration: InputDecoration(
                                                        labelText:
                                                            "Kanban Name",
                                                        hintText:
                                                            "Change Kanban Name"),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        this.value1 = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                actions: [
                                                  FlatButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text("Dismiss")),
                                                  FlatButton(
                                                      onPressed: () async {
                                                        preferences =
                                                            await SharedPreferences
                                                                .getInstance();

                                                        print(value1);
                                                        String token =
                                                            preferences
                                                                .getString(
                                                                    "token");
                                                        String success;

                                                        Map<String, dynamic>
                                                            body = {
                                                          "title": value1
                                                        };

                                                        Response response = await put(
                                                            apiUtility
                                                                    .deleteKanban +
                                                                snapshot.data[
                                                                        index]
                                                                    ["_id"],
                                                            body: body,
                                                            headers: {
                                                              'Authorization':
                                                                  'Bearer $token',
                                                            });

                                                        print(response
                                                            .statusCode);
                                                        print(response.body);

                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator
                                                            .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (_) =>
                                                                            Front(
                                                                              index: 2,
                                                                            )));
                                                      },
                                                      child: Text("Edit"))
                                                ],
                                              ));

                                      //

                                      return false;
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
                                      title: Text(
                                          "${snapshot.data[index]["title"]}"),
                                      onTap: () {
                                        // print(snapshot.data[index]);
                                        // print(snapshot.data[index]["_id"]);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => Kanban(
                                                      title: snapshot
                                                          .data[index]["title"],
                                                      projectId: snapshot
                                                          .data[index]["_id"],
                                                    )));
                                      },
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Center(
                          child: Text("No Boards"),
                        )
                  : Center(
                      child: CircularProgressIndicator(
                        backgroundColor: primaryColour,
                      ),
                    );
            }),
      ),
    );
  }
}
