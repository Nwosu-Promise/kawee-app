import 'dart:convert';
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiwee/front/front.dart';
import 'package:kiwee/ocr/ml_vision_service.dart';
import 'package:kiwee/ocr/note_view_model.dart';
import 'package:kiwee/utility/api.dart';

import 'package:kiwee/utility/colours.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiUtility apiUtility = ApiUtility();
SharedPreferences preferences;

class Ocr extends StatefulWidget {
  final String edit;
  final String title;
  final String content;
  final String id;
  Ocr({this.edit, this.title, this.content, this.id});
  @override
  _OcrState createState() => _OcrState();
}

class _OcrState extends State<Ocr> {
  TextEditingController _title;
  TextEditingController _content;

  var text = "Osi";

  final _noteController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
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
          widget.edit == null ? "New OCR" : "Update OCR",
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
                                        apiUtility.updateOcr + widget.id,
                                        headers: {
                                          'Authorization': 'Bearer $token',
                                        });

                                    print(response.statusCode);
                                    print(response.body);

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => Front(
                                                  index: 4,
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
      floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColour,
          child: Icon(Icons.camera_alt),
          onPressed: () {
            onStartTextRecognitionFromCamera();
          }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _title,
                    decoration: InputDecoration(
                        labelText: "Title", hintText: "OCR Title"),
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
                          widget.edit == null ? "Add OCR" : "Update OCR"),
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

                              Response response = await post(
                                  apiUtility.updateOcr,
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
                                                index: 4,
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
                                            index: 4,
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
                              print(apiUtility.updateOcr + widget.id);

                              Response response = await patch(
                                  apiUtility.updateOcr + widget.id,
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
                                                index: 4,
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
                                            index: 4,
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

  Future<void> onStartTextRecognitionFromCamera() async {
    // final imageFile = await _cameraService.takePhoto();

    final imageFile = await ImagePicker.pickImage(source: ImageSource.camera);


    if (imageFile != null) {
      final FirebaseVisionImage visionImage =
          FirebaseVisionImage.fromFile(imageFile);

      final TextRecognizer textRecognizer =
          FirebaseVision.instance.textRecognizer();
      final VisionText visionText =
          await textRecognizer.processImage(visionImage);

      print(visionText.text);

      setState(() {
        _content.text = _content.text + visionText.text;
      });

      textRecognizer.close();

      await imageFile.delete();
    }
  }
}
