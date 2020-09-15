import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kiwee/front/front.dart';
import 'package:kiwee/utility/api.dart';
import 'package:kiwee/utility/colours.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiUtility apiUtility = ApiUtility();
SharedPreferences preferences;

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _token = TextEditingController();
  TextEditingController _newP = TextEditingController();
  TextEditingController _confirmNP = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: TextStyle(
              color: white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              Text(
                "Enter token sent to email and enter a new password",
                textAlign: TextAlign.justify,
                style: TextStyle(color: grey, fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _token,
                decoration: InputDecoration(
                    labelText: "Token", hintText: "Enter Token sent to E-mail"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _newP,
                decoration: InputDecoration(
                    labelText: "New Password", hintText: "Enter new password"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _confirmNP,
                decoration: InputDecoration(
                    labelText: "Confirm New Password",
                    hintText: "Confirm new password"),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  padding: EdgeInsets.all(20),
                  child: Text("Confirm Password"),
                  onPressed: () async {
                    preferences = await SharedPreferences.getInstance();
                    String success;
                    String token;
                    Map<String, dynamic> body = {
                      "token": _token.text,
                      "password": _newP.text,
                      "passwordConfirm": _confirmNP.text
                    };

                    Response response = await patch(
                      apiUtility.resetPassword,
                      body: body,
                    );

                    if (response.statusCode == 200) {
                      var responseBody = json.decode(response.body);
                      success = responseBody["status"];

                      print(responseBody);
                      if (success == "success") {
                        token = responseBody["token"];

                        preferences.setString("token", token);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Front(index: 3)));
                      }
                    }
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Front(index: 3)));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
