import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _ratingController;
  bool visibilityP = true; // password
  bool visibilityW = true; // password button
  bool visibilityO = false; // OTG button
  bool visibilityS = true; // Submit button
  bool visibilityG = false; // Get OTG button
  bool visibilityB = false; // Loding....
  final textFieldFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _obscured = false;
  String username = "";
  String password = "";

  // String email = "";

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  void login(username, password,context) async {
    setState(() {
      visibilityB = true;
    });
    // String username = 'test';
    // String password = '123£';
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    var url = Api.login;
    print(url);
    var response = await http.get(Uri.parse(url),
        // body: jsonEncode({'username': username, 'password': password}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuth
        });
    // var requestRes;

    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        visibilityB = false;
      });
      var jsonMap = json.decode(response.body);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("loginScreen", true);
      pref.setString("username", username);
      pref.setString("password", password);
      // pref.setString("username", jsonMap["username"].toString());
      // pref.setString("email", jsonMap["email"].toString());
      // pref.setString("user_id", jsonMap["id"].toString());
      // pref.setString("token", jsonMap["api_token"].toString());
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
              content: Text(jsonMap["message"].toString())),
        );
      });
      print(response.body);
    } else {
      setState(() {
        visibilityB = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            content: Text('User Does Not Exist.')),
      );

      // print(jsonMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final _controller = TextEditingController(text: "hlw kaushal");

    return Scaffold(
      backgroundColor: HexColor("#EDF4F8"),
      body: Container(
        color: HexColor("#EDF4F8"),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 100, 20, 50),
                  child: Image.asset("assets/logingif.gif"),
                ),
                Container(
                  height: 40,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 40,
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                      ),
                      Text(
                        "Login",
                        style:
                            TextStyle(color: HexColor("#000000"), fontSize: 25),
                      )
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontSize: 15),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'User Name is Required';
                        } else {
                          setState(() {
                            username = value.toString();
                          });
                        }
                      },
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          fillColor: Colors.blue,
                          focusColor: Colors.blueAccent,
                          hoverColor: Colors.blueAccent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.blueAccent, width: 2),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          hintStyle: TextStyle(fontSize: 12),
                          hintText: "User Name"),
                    )),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextFormField(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Password is Required';
                      } else {
                        setState(() {
                          password = value.toString();
                        });
                      }
                    },
                    keyboardType: TextInputType.visiblePassword,
                    cursorColor: Colors.black,
                    obscureText: _obscured,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      focusColor: Colors.blueAccent,
                      hoverColor: Colors.blueAccent,
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Colors.blueAccent,
                            width: 2), // Apply corner radius
                      ),
                      hintText: "Password",
                      // filled: true,
                      hintStyle: TextStyle(fontSize: 12),
                      isDense: true,

                      suffixIcon: GestureDetector(
                        onTap: _toggleObscured,
                        child: Icon(
                          _obscured
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          size: 20,
                          color: HexColor("#000000"),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    height: 45,
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        border:
                            Border.all(width: 1, color: HexColor("#000598")),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: TextButton(
                      onPressed: visibilityB
                          ? () {}
                          : () {
                              if (_formKey.currentState!.validate()) {
                                login(username, password,context);
                              }
                            },
                      child: visibilityB
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Submit",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
