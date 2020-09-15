import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kiwee/utility/api.dart';
import 'package:kiwee/utility/exports/exports_utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';


ApiUtility apiUtility = ApiUtility();
SharedPreferences preferences;
class DoneTodo extends StatelessWidget {


  getTodo() async {
    preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");

    String status;
    var data;

    Response response = await get(apiUtility.getTodo+"true", headers: {
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
          "Done ToDos",
          style: TextStyle(
              color: white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
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


                      return Card(
                        child: ListTile(
                          title:
                          Text("${snapshot.data[index]["task"]}"),
                          subtitle: Text(
                              "Created At: ${snapshot.data[index]["createdAt"]}"),
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
                      );
                    }),
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
