import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kiwee/form/forget_password.dart';
import 'package:kiwee/front/front.dart';
import 'package:kiwee/utility/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiUtility apiUtility = ApiUtility();
SharedPreferences preferences;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email;
  TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _email,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "Type your E-Mail",
                    labelText: "E-Mail"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _password,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    hintText: "Type your Password",
                    labelText: "Password"),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                    padding: const EdgeInsets.all(20),
                    child: Text("Sign In"),
                    onPressed: () async {
                      preferences = await SharedPreferences.getInstance();
                      Directory suspendedSaleDirectory =
                          await getApplicationDocumentsDirectory();
                      File suspendedSaleFile =
                          File("${suspendedSaleDirectory.path}/note.json");
                      suspendedSaleFile.createSync();
                      Map<String, dynamic> notes = {"notes": []};
                      suspendedSaleFile.writeAsStringSync(json.encode(notes));

                      Map<String, dynamic> body = {
                        "email": _email.text,
                        "password": _password.text,
                      };

                      String token;
                      String status;
                      var data;
                      var user;

                      Response response =
                          await post(apiUtility.login, body: body);
                      if (response.statusCode == 200) {
                        var responseBody = json.decode(response.body);

                        status = responseBody["status"];

                        if (status == "success") {
                          token = responseBody["token"];
                          data = responseBody["data"] as Map;
                          user = data["user"] as Map;

                          preferences.setString("token", token);
                          preferences.setString("firstName", user["firstName"]);
                          preferences.setString("lastName", user["lastName"]);
                          preferences.setString("email", user["email"]);
                          preferences.setString("id", user["_id"]);

                          print(responseBody);
                          print(token);
                          print(data);
                          print(user);
                          print(user["firstName"]);

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Front(index: 3)));
                        } else {}
                      } else {
                        print(response.statusCode);
                        print(response.body);
                      }
                      //
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => Front(index: 3)));
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  alignment: Alignment.center,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgetPassword()));
                      },
                      child: Text("Forgot Password?")))
            ],
          ),
        ),
      ),
    );
  }
}
