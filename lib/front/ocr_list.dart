import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kiwee/front/ocr.dart';
import 'package:kiwee/utility/api.dart';
import 'package:kiwee/utility/exports/exports_utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiUtility apiUtility = ApiUtility();
SharedPreferences preferences;

class OcrList extends StatefulWidget {
  @override
  _OcrListState createState() => _OcrListState();
}

class _OcrListState extends State<OcrList> {
  getOcr() async {
    preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");

    String status;
    var data;
    var responseBody;

    Response response = await get(apiUtility.getAllOcr, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      responseBody = json.decode(response.body);
      status = responseBody["status"];
    }
    if (status == "success") {
      data = responseBody["doc"] as List;
      print(responseBody);
      print(data);
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "OCR",
          style: TextStyle(
              color: white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColour,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => Ocr()));
          }),
      body: Container(
          child: FutureBuilder(
        future: getOcr(),
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
                            onTap: () {
                              print(snapshot.data[index]);
                              print(snapshot.data[index]["_id"]);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => Ocr(
                                    edit: "edit",
                                    title: snapshot.data[index]["title"],
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
