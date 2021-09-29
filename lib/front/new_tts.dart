import 'dart:convert';
// import 'dart:math';
// import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:http/http.dart';
import 'package:kiwee/front/front.dart';
import 'package:kiwee/utility/api.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:kiwee/utility/colours.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';

ApiUtility apiUtility = ApiUtility();
SharedPreferences preferences;

class NewTts extends StatefulWidget {
  final String edit;
  final String title;
  final String content;
  final String id;
  NewTts({this.edit, this.title, this.content, this.id});
  @override
  _NewTtsState createState() => _NewTtsState();
}

class _NewTtsState extends State<NewTts> {
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  stt.SpeechToText _speech;
  bool _isListening = false;
  TextEditingController text;

  TextEditingController _title;

  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    text = TextEditingController();
    _title = TextEditingController();

    text.text = widget.edit == null ? "" : widget.content;

    _title.text = widget.edit == null ? "" : widget.title;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.edit == null ? "New Speech" : "Update Speech",
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
                                "Delete This Note",
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

                                    Response response = await delete(
                                        apiUtility.updateTts + widget.id,
                                        headers: {
                                          'Authorization': 'Bearer $token',
                                        });

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => Front(
                                                  index: 5,
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
      // floatingActionButtonLocation: FloatingActionButtonLocation,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          backgroundColor: primaryColour,
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        reverse: true,
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(
                  labelText: "Title", hintText: "Speech to text Title"),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: height * .65,
              child: TextField(
                controller: text,
                maxLines: 70,
                textAlignVertical: TextAlignVertical(y: .8),
                decoration: InputDecoration(
                    hintText: "Press the microphone button and start speaking",
                    labelText: "Content",
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
                  child: Text(widget.edit == null ? "Add Note" : "Update Note"),
                  onPressed: widget.edit == null
                      ? () async {
                          preferences = await SharedPreferences.getInstance();

                          String token = preferences.getString("token");
                          String success;
                          Map<String, dynamic> body = {
                            "title": _title.text,
                            "content": text.text,
                          };

                          Response response =
                              await post(apiUtility.tts, body: body, headers: {
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
                                            index: 5,
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
                                        index: 5,
                                      )));
                        }
                      : () async {
                          preferences = await SharedPreferences.getInstance();

                          String token = preferences.getString("token");
                          String success;
                          Map<String, dynamic> body = {
                            "title": _title.text,
                            "content": text.text,
                          };

                          Response response =
                              await patch(apiUtility.tts, body: body, headers: {
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
                                            index: 5,
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
                                        index: 5,
                                      )));
                        },
                ))
            // Container(
            //   padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
            //   child: TextHighlight(
            //     text: _text,
            //     words: _highlights,
            //     textStyle: const TextStyle(
            //       fontSize: 32.0,
            //       color: Colors.black,
            //       fontWeight: FontWeight.w400,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _listen() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val to record'),
        onError: (val) => print('onError: osi$val'),
      );

      print("_isListening: $_isListening, $available");

      String prev = text.text;

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            // text.value = text.value.copyWith(
            //     text: val.recognizedWords,
            //     selection: TextSelection(
            //         baseOffset: text.text.length - 1,
            //         extentOffset: val.recognizedWords.length));

            String vb = val.recognizedWords;
            String jk = prev + vb;

            text.clear();

            text.text = jk;

            // text.value = TextEditingValue(
            //   text: val.recognizedWords,
            //   selection: TextSelection.fromPosition(
            //     TextPosition(offset: val.recognizedWords.length),
            //   ),
            // );

            //_text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
        print("_isListening1: $_isListening");
      } else {
        setState(() => _isListening = false);
        // _speech.stop();
        print("_isListening2: $_isListening");
      }

      print("_isListening3: $_isListening");
    }else{

    }
  }
}
