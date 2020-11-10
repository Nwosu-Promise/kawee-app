import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kiwee/form/form.dart';
import 'package:kiwee/front/front.dart';
import 'package:kiwee/utility/api.dart';
import 'package:kiwee/utility/colours.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences preferences;
ApiUtility apiUtility = ApiUtility();

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _firstName;
  TextEditingController _lastname;
  TextEditingController _email;

  TextEditingController _currentP;
  TextEditingController _newP;
  TextEditingController _confirmNP;

  String _fn = "";
  String _ln = "";
  String _em = "";

  bool fn = false;
  bool ln = false;
  bool em = false;

  bool f = false;
  bool l = false;
  bool e = false;
  getDetails() async {
    preferences = await SharedPreferences.getInstance();

    setState(() {
      _firstName.text = preferences.getString("firstName");
      _lastname.text = preferences.getString("lastName");
      _email.text = preferences.getString("email");

      _fn = preferences.getString("firstName");
      _ln = preferences.getString("lastName");
      _em = preferences.getString("email");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstName = TextEditingController();
    _lastname = TextEditingController();
    _email = TextEditingController();

    _currentP = TextEditingController();
    _newP = TextEditingController();
    _confirmNP = TextEditingController();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: TextStyle(
              color: white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: fn,
                      controller: _firstName,
                      decoration: InputDecoration(
                          labelText: "First Name", hintText: "Type first name"),
                      onChanged: (value) {
                        value == _fn
                            ? setState(() {
                                f = false;
                              })
                            : setState(() {
                                f = true;
                              });
                      },
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      f ? "Update" : "Edit",
                      style: TextStyle(
                          color: fn ? f ? primaryColour : grey : primaryColour),
                    ),
                    onPressed: f
                        ? () async {
                            String token = preferences.getString("token");
                            String success;
                            var user;
                            Map<String, dynamic> body = {
                              "firstName": _firstName.text
                            };

                            Response response = await patch(
                                apiUtility.updateUser,
                                body: body,
                                headers: {
                                  'Authorization': 'Bearer $token',
                                });
                            if (response.statusCode == 200) {
                              var responseBody = json.decode(response.body);
                              success = responseBody["status"];

                              if (success == "success") {
                                user = responseBody["user"] as Map;
                                preferences.setString(
                                    "firstName", user["firstName"]);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Front(index: 6)));
                              }
                            }
                          }
                        : () {
                            setState(() {
                              fn = !fn;
                            });
                          },
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: ln,
                      controller: _lastname,
                      decoration: InputDecoration(
                          labelText: "Last Name", hintText: "Type last name"),
                      onChanged: (value) {
                        value == _ln
                            ? setState(() {
                                l = false;
                              })
                            : setState(() {
                                l = true;
                              });
                      },
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      l ? "Update" : "Edit",
                      style: TextStyle(
                          color: ln ? l ? primaryColour : grey : primaryColour),
                    ),
                    onPressed: l
                        ? () async {
                            String token = preferences.getString("token");
                            String success;
                            var user;
                            Map<String, dynamic> body = {
                              "lastName": _lastname.text
                            };

                            Response response = await patch(
                                apiUtility.updateUser,
                                body: body,
                                headers: {
                                  'Authorization': 'Bearer $token',
                                });
                            if (response.statusCode == 200) {
                              var responseBody = json.decode(response.body);
                              success = responseBody["status"];

                              if (success == "success") {
                                user = responseBody["user"] as Map;
                                preferences.setString(
                                    "lastName", user["lastName"]);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Front(index: 6)));
                              }
                            }
                          }
                        : () {
                            setState(() {
                              ln = !ln;
                            });
                          },
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: em,
                      controller: _email,
                      decoration: InputDecoration(
                          labelText: "E-Mail", hintText: "Type e-mail"),
                      onChanged: (value) {
                        value == _em
                            ? setState(() {
                                e = false;
                              })
                            : setState(() {
                                e = true;
                              });
                      },
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      e ? "Update" : "Edit",
                      style: TextStyle(
                          color: em ? e ? primaryColour : grey : primaryColour),
                    ),
                    onPressed: e
                        ? () async {
                            String token = preferences.getString("token");
                            String success;
                            var user;
                            Map<String, dynamic> body = {"email": _email.text};

                            Response response = await patch(
                                apiUtility.updateUser,
                                body: body,
                                headers: {
                                  'Authorization': 'Bearer $token',
                                });
                            if (response.statusCode == 200) {
                              var responseBody = json.decode(response.body);
                              success = responseBody["status"];

                              if (success == "success") {
                                user = responseBody["user"] as Map;
                                preferences.setString("email", user["email"]);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Front(index: 6)));
                              }
                            }
                          }
                        : () {
                            setState(() {
                              em = !em;
                            });
                          },
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 2,
              ),
              Text(
                "Password",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _currentP,
                decoration: InputDecoration(
                    labelText: "Current Password",
                    hintText: "Type old password"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _newP,
                decoration: InputDecoration(
                    labelText: "New Password", hintText: "Type new password"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _confirmNP,
                decoration: InputDecoration(
                    labelText: "Confirm New Password",
                    hintText: "Type new password again"),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  width: double.infinity,
                  child: RaisedButton(
                      padding: EdgeInsets.all(20),
                      child: Text("Change Password"),
                      onPressed: () async {
                        preferences = await SharedPreferences.getInstance();
                        String token = preferences.getString("token");
                        String success;
                        Map<String, dynamic> body = {
                          "passwordCurrent": _currentP,
                          "password": _newP,
                          "passwordConfirm ": _confirmNP
                        };

                        Response response = await patch(
                            apiUtility.updatePassword,
                            body: body,
                            headers: {
                              'Authorization': 'Bearer $token',
                            });

                        if (response.statusCode == 200) {
                          var responseBody = json.decode(response.body);
                          success = responseBody["status"];

                          if (success == "success") {
                            String t = responseBody["token"];

                            preferences.setString("token", t);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Front(index: 3)));
                          }
                        }
                      })),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              content: Text("Are you sure you want to logout?"),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Dismiss")),
                                FlatButton(
                                    onPressed: () async {
                                      preferences =
                                          await SharedPreferences.getInstance();
                                      String token =
                                          preferences.getString("token");
                                      String status;

                                      Response response = await get(
                                          apiUtility.logOut,
                                          headers: {
                                            'Content-Type': 'application/json',
                                            'Accept': 'application/json',
                                            'Authorization': 'Bearer $token',
                                          });
                                      if (response.statusCode == 200) {
                                        var responseBody =
                                            json.decode(response.body);
                                        status = responseBody["status"];
                                        if (status == "success") {
                                          preferences.remove("token");
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      AppForm(val: 1)));
                                        }
                                      }
                                    },
                                    child: Text("Yes"))
                              ],
                            ));
                  },
                  child: Text("Log Out")),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
