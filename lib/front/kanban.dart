import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/material.dart';
import 'package:boardview/boardview.dart';
import 'package:http/http.dart';
import 'package:kiwee/newNote/add_note.dart';
import 'package:kiwee/utility/api.dart';
import 'package:kiwee/utility/exports/exports_utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiUtility apiUtility = ApiUtility();
SharedPreferences preferences;

class Kanban extends StatefulWidget {
  final String title;
  final String projectId;
  Kanban({@required this.title, this.projectId});
  @override
  _KanbanState createState() => _KanbanState();
}

class _KanbanState extends State<Kanban> {
  BoardViewController boardViewController = new BoardViewController();
  TextEditingController _title;
  TextEditingController _taskTitle;
  TextEditingController _listName;

  Future getBoard() async {
    preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");
    var column = [];
    Response response =
        await get(apiUtility.getOneBoard + "${widget.projectId}", headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      var result = responseBody["result"] as Map;
      column = result["columns"] as List;
      print("column:$column");
      return column;
    }
  }

  List<BoardList> _lists = List<BoardList>();
  List<BoardList> _columnList = List<BoardList>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _title = TextEditingController();
    _taskTitle = TextEditingController();
    _listName = TextEditingController();

    print("column:${widget.projectId}");
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getBoard,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.title}",
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
                            "Title",
                            textAlign: TextAlign.center,
                          ),
                          content: TextField(
                            controller: _title,
                            decoration: InputDecoration(
                                labelText: "BoardList Title",
                                hintText: "Type BoardList Title"),
                            onChanged: (_) {
                              setState(() {
                                _title.text = _;
                              });
                            },
                          ),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Dismiss")),
                            FlatButton(
                                onPressed: () async {
                                  print(_listName.text);
                                  preferences =
                                      await SharedPreferences.getInstance();
                                  String token = preferences.getString("token");

                                  Map<String, dynamic> body = {
                                    "title": _title.text,
                                  };

                                  Response response = await post(
                                      apiUtility.createColumn +
                                          "${widget.projectId}",
                                      body: body,
                                      headers: {
                                        'Authorization': 'Bearer $token',
                                      });

                                  print(response.body);
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => Kanban(
                                                title: widget.title,
                                                projectId: widget.projectId,
                                              )));
                                },
                                child: Text("Confirm"))
                          ],
                        ),
                      ));
            }),
        body: SafeArea(
          child: Container(
              padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
              // child: widget.columns.isEmpty
              //     ? BoardView(
              //         lists: _lists,
              //         boardViewController: boardViewController,
              //       )
              //     :
              child: FutureBuilder(
                  future: getBoard(),
                  builder: (_, snapshot) {
                    var data = snapshot.data as List;
                    if (snapshot.hasData) {
                      for (int i = 0; i < data.length; i++) {
                        print("columnId:${data[i]["_id"]}");
                        var fg = data[i]["tasks"] as List;
                        List<BoardItem> _columnItem = List<BoardItem>();

                        for (int j = 0; j < fg.length; j++) {
                          _columnItem.add(BoardItem(
                              onStartDragItem: (int listIndex, int itemIndex,
                                  BoardItemState state) {},
                              onDropItem: (int listIndex,
                                  int itemIndex,
                                  int oldListIndex,
                                  int oldItemIndex,
                                  BoardItemState state) async {
                                preferences =
                                    await SharedPreferences.getInstance();
                                String token = preferences.getString("token");
                                print(
                                    "oldListIndex:$oldListIndex, ${data[oldListIndex]["_id"]}");
                                print(
                                    "listIndex:$listIndex, ${data[listIndex]["_id"]}");

                                print(
                                  apiUtility.removeTAsKFromColumn +
                                      "${fg[j]["_id"]}/" +
                                      "from/" +
                                      "${data[oldListIndex]["_id"]}",
                                );

                                Response response = await post(
                                    apiUtility.removeTAsKFromColumn +
                                        "${fg[j]["_id"]}/" +
                                        "from/" +
                                        "${data[oldListIndex]["_id"]}",
                                    headers: {
                                      'Authorization': 'Bearer $token',
                                    });

                                print(response.statusCode);
                                print(response.body);

                                if (response.statusCode == 200) {
                                  Response response2 = await post(
                                      apiUtility.addTaskToColumn +
                                          "${fg[j]["_id"]}/" +
                                          "to/" +
                                          "${data[listIndex]["_id"]}",
                                      headers: {
                                        'Authorization': 'Bearer $token',
                                      });
                                  print(response2.statusCode);
                                  print(response2.body);
                                }

                                // print("state.width:${state.}");
                              },
                              onTapItem: (int listIndex, int itemIndex,
                                  BoardItemState state) async {},
                              item: GestureDetector(
                                onDoubleTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            content: Text(
                                              "Are you sure you  want to delete task.",
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text("Dismiss")),
                                              FlatButton(
                                                  onPressed: () async {
                                                    preferences =
                                                        await SharedPreferences
                                                            .getInstance();

                                                    String token = preferences
                                                        .getString("token");

                                                    Response response = await delete(
                                                        apiUtility.deleteTask +
                                                            "${fg[j]["_id"]}/" +
                                                            "column/" +
                                                            "${data[i]["_id"]}",
                                                        headers: {
                                                          'Authorization':
                                                              'Bearer $token',
                                                        });

                                                    print(response.statusCode);
                                                    print(response.body);

                                                    Navigator.pop(context);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                Kanban(
                                                                  title: widget
                                                                      .title,
                                                                  projectId: widget
                                                                      .projectId,
                                                                )));
                                                  },
                                                  child: Text("Yes"))
                                            ],
                                          ));
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("${fg[j]["title"]}"),
                                  ),
                                ),
                              )));
                        }

                        _columnList.add(
                          BoardList(
                            draggable: false,
                            footer: IconButton(
                              icon: Icon(
                                Icons.add,
                                color: primaryColour,
                              ),
                              onPressed: () {
                                // (context as Element).reassemble();
                                showDialog(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title: Text("Add Task"),
                                              content: TextField(
                                                controller: _taskTitle,
                                                decoration: InputDecoration(
                                                    labelText: "Task Name",
                                                    hintText: "Type task name"),
                                              ),
                                              actions: [
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Dismiss")),
                                                FlatButton(
                                                    onPressed: () async {
                                                      print(_taskTitle.text);
                                                      preferences =
                                                          await SharedPreferences
                                                              .getInstance();

                                                      String token = preferences
                                                          .getString("token");

                                                      Map<String, dynamic>
                                                          body = {
                                                        "title": _taskTitle.text
                                                      };
                                                      print(data[i]["_id"]);

                                                      Response response =
                                                          await post(
                                                              apiUtility
                                                                      .newTask +
                                                                  data[i]
                                                                      ["_id"],
                                                              body: body,
                                                              headers: {
                                                            'Authorization':
                                                                'Bearer $token',
                                                          });

                                                      Navigator.pop(context);
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (_) => Kanban(
                                                                        title: widget
                                                                            .title,
                                                                        projectId:
                                                                            widget.projectId,
                                                                      )));
                                                    },
                                                    child: Text("Confirm")),
                                              ],
                                            );
                                          },
                                        ));
                              },
                            ),
                            onStartDragList: (int listIndex) {},
                            onTapList: (int listIndex) async {},
                            onDropList: (int listIndex, int oldListIndex) {},
                            headerBackgroundColor:
                                Color.fromARGB(255, 235, 236, 240),
                            backgroundColor: Color.fromARGB(255, 235, 236, 240),
                            header: [
                              IconButton(
                                  color: primaryColour,
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => StatefulBuilder(
                                              builder: (_, setState) =>
                                                  AlertDialog(
                                                content: Text(
                                                  "Are you sure you want to delete ?",
                                                  textAlign: TextAlign.center,
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
                                                        String token =
                                                            preferences
                                                                .getString(
                                                                    "token");

                                                        Response response =
                                                            await delete(
                                                                apiUtility
                                                                        .deleteColumn +
                                                                    "${data[i]["_id"]}/board/${widget.projectId}",
                                                                headers: {
                                                              'Authorization':
                                                                  'Bearer $token',
                                                            });

                                                        //  print(response.body);
                                                        Navigator.pop(context);
                                                        Navigator
                                                            .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (_) =>
                                                                            Kanban(
                                                                              title: widget.title,
                                                                              projectId: widget.projectId,
                                                                            )));
                                                      },
                                                      child: Text("Delete"))
                                                ],
                                              ),
                                            ));
                                  }),
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        "${data[i]["title"]}",
                                        style: TextStyle(fontSize: 20),
                                      ))),
                              IconButton(
                                  color: primaryColour,
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => StatefulBuilder(
                                            builder: (_, setState) =>
                                                AlertDialog(
                                                  title: Text(
                                                    "Edit List Name",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  content: Container(
                                                    child: TextField(
                                                      controller: _listName,
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              "List Name",
                                                          hintText:
                                                              "Type List Name"),
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
                                                          print(_listName.text);
                                                          preferences =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          String token =
                                                              preferences
                                                                  .getString(
                                                                      "token");

                                                          Map<String, dynamic>
                                                              body = {
                                                            "title":
                                                                _listName.text,
                                                            "columnId": data[i]
                                                                ["_id"],
                                                            "projectId":
                                                                widget.projectId
                                                          };

                                                          Response response =
                                                              await put(
                                                                  apiUtility
                                                                      .deleteColumn,
                                                                  body: body,
                                                                  headers: {
                                                                'Authorization':
                                                                    'Bearer $token',
                                                              });

                                                          print(response.body);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator
                                                              .pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          Kanban(
                                                                            title:
                                                                                widget.title,
                                                                            projectId:
                                                                                widget.projectId,
                                                                          )));
                                                        },
                                                        child: Text("Edit"))
                                                  ],
                                                )));
                                  }),
                            ],
                            items: _columnItem,
                          ),
                        );
                      }
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                        backgroundColor: primaryColour,
                      ));
                    }

                    // broad=  BoardView(
                    //     lists: _columnList,
                    //     boardViewController: boardViewController,
                    //   );
                    return BoardView(
                      lists: _columnList,
                      boardViewController: boardViewController,
                      isSelecting: false,
                    );
                  })),
        ),
      ),
    );
  }
}
