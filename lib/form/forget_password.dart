import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kiwee/form/update_password.dart';
import 'package:kiwee/utility/api.dart';
import 'package:kiwee/utility/colours.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiUtility apiUtility = ApiUtility();
SharedPreferences preferences;

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Forgot Password",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: primaryColour),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Enter the Email address you used to Log In and we will send you a link to reset your password ",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: grey, fontSize: 16),
                ),
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
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                      padding: const EdgeInsets.all(20),
                      child: Text("Reset Password"),
                      onPressed: () async {
                        preferences = await SharedPreferences.getInstance();

                        String token = preferences.getString("token");
                        String success;
                        Map<String, dynamic> body = {"email": _email.text};

                        Response response = await post(
                            apiUtility.forgetPassword,
                            body: body,
                            headers: {
                              'Authorization': 'Bearer $token',
                            });
                        if (response.statusCode == 200) {
                          var responseBody = json.decode(response.body);

                          print(responseBody);
                          success = responseBody["status"];
                          if (success == "success") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ResetPassword()));
                          }
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
