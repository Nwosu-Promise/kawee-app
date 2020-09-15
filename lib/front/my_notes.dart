import 'package:flutter/material.dart';
import 'package:kiwee/newNote/add_note.dart';
import 'package:http/http.dart';
import 'package:kiwee/utility/api.dart';

import 'package:kiwee/utility/colours.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences preferences;
ApiUtility apiUtility = ApiUtility();


class MyNotes extends StatelessWidget {
  getNotes() async {
    preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");

    String status;
    var data;

    Response response = await get(apiUtility.newNote, headers: {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Notes",
          style: TextStyle(
              color: white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColour,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => AddNote()));
          }),
      body: Container(
          child: FutureBuilder(
        future: getNotes(),
        builder: (_, snapshot) {
          var data = snapshot.data as List;

          return snapshot.hasData
              ? data.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (_, index) => Card(
                          child: ListTile(
                            title: Text("${snapshot.data[index]["title"]}"),
                            // subtitle:
                            //     Text("Created At: ${snapshot.data[index]["createdAt"]}"),
                            onTap: () {
                              print(snapshot.data[index]);
                              print(snapshot.data[index]["_id"]);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AddNote(
                                            edit: "edit",
                                            title: snapshot.data[index]
                                                ["title"],
                                            content: snapshot.data[index]
                                                ["content"],
                                            id: snapshot.data[index]["_id"],
                                          )));
                            },
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text("No Notes"),
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
