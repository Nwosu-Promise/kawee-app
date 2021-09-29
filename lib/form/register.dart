import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:kiwee/front/front.dart';
import 'package:kiwee/newNote/add_note.dart';
import 'package:kiwee/provider/loading_provider.dart';
import 'package:kiwee/utility/api.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiUtility apiUtility = ApiUtility();
SharedPreferences preferences;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _firstName;
  TextEditingController _lastName;
  TextEditingController _email;
  TextEditingController _password;
  TextEditingController _cPassword;

  @override
  // ignore: must_call_super
  void initState() {
    // TODO: implement initState

    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _cPassword = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(
      builder: (_, lp, child) => Opacity(
        opacity: lp.opacity,
        child: IgnorePointer(
          ignoring: lp.ignoreTouch,
          child: Scaffold(
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
                      controller: _firstName,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "Type your Fisrt Name",
                          labelText: "First Name"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _lastName,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "Type your Last Name",
                          labelText: "Last Name"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _email,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: "Type your E-Mail",
                          labelText: "E-Mail"),
                      keyboardType: TextInputType.emailAddress,
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
                      height: 10,
                    ),
                    TextField(
                      controller: _cPassword,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: "Type your Password again",
                          labelText: "Confirm-Password"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                          padding: const EdgeInsets.all(20),
                          child: Text("Sign Up"),
                          onPressed: () async {
                            lp.setOpacity(.3);
                            lp.setVisibility(true);
                            lp.setIgnoreTouch(true);
                            FocusScope.of(context).requestFocus(FocusNode());
                            preferences = await SharedPreferences.getInstance();
                            Map<String, dynamic> body = {
                              "firstName": _firstName.text,
                              "lastName": _lastName.text,
                              "email": _email.text,
                              "password": _password.text,
                              "passwordConfirm": _cPassword.text,
                              "role": "user"
                            };

                            var encodedBody = json.encode(body);
                            print(encodedBody);

                            String token;
                            String status;
                            var data;
                            var user;
                            var message;
                            Response response =
                                await post(apiUtility.register, body: body);

                            if (response.statusCode == 201) {
                              var responseBody = json.decode(response.body);

                              status = responseBody["status"];
                              if (status == "success") {
                                token = responseBody["token"];
                                data = responseBody["data"] as Map;
                                user = data["user"] as Map;

                                preferences.setString("token", token);
                                preferences.setString(
                                    "firstName", user["firstName"]);
                                preferences.setString(
                                    "lastName", user["lastName"]);
                                preferences.setString("email", user["email"]);

                                print(responseBody);
                                print(token);
                                print(data);
                                print(user);
                                print(user["firstName"]);
                                lp.setOpacity(1);
                                lp.setVisibility(false);
                                lp.setIgnoreTouch(false);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Front(index: 3)));
                              } else {
                                lp.setOpacity(1);
                                lp.setVisibility(false);
                                lp.setIgnoreTouch(false);
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text(
                                            "Login Failed",
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Text(
                                            "Could not Login",
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: [
                                            FlatButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("Dismiss"))
                                          ],
                                        ));
                              }
                            } else {
                              var responseBody = json.decode(response.body);

                              status = responseBody["status"];
                              message = responseBody["message"];
                              lp.setOpacity(1);
                              lp.setVisibility(false);
                              lp.setIgnoreTouch(false);

                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Text(
                                          "Login Failed",
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Text(
                                          "$message",
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: [
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text("Dismiss"))
                                        ],
                                      ));
                              print(response.statusCode);
                              print(response.body);
                            }
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
