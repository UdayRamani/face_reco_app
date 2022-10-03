import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/api.dart';
import '../l10n/language_constant.dart';

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
      if (textFieldFocusNode.hasPrimaryFocus) {
        return;
      } // If focus is on text field, dont unfocus
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
    // String basicAuth =
    //     'Basic ' + base64.encode(utf8.encode('$username:$password'));
    // var url = Api.login;
    // print(url);
    // var response = await http.get(Uri.parse(url),
    //     // body: jsonEncode({'username': username, 'password': password}),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Authorization': basicAuth
    //     });
    // var requestRes;

    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    var url = Api.attend;
    print(url);
    Dio dio = Dio();
    dio.options.headers['Authorization'] = basicAuth;
    var response = await dio.get(url);

    if (response.statusCode == 200) {
      setState(() {
        visibilityB = false;
      });
      // var jsonMap = json.decode(response.data);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("loginScreen", true);
      pref.setString("username", username);
      pref.setString("password", password);
      pref.setString("org_name", response.data[0]["org_name"]);
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
              content: Text(response.data["message"].toString())),
        );
      });
    } else {
      setState(() {
        visibilityB = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            content: Text('Пользователь не найден!')),
      );

      // print(jsonMap);
    }
  }
  @override
  Widget build(BuildContext context) {
    // final _controller = TextEditingController(text: "hlw kaushal");

    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#EDF4F8"),
        body: Container(
          color: HexColor("#EDF4F8"),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   alignment: Alignment.centerRight,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: DropdownButton<Languages>(
                  //       // value: dropdownvalue,
                  //       underline: SizedBox(),
                  //       icon: Icon(
                  //         Icons.language,
                  //         color: HexColor("#5519ff"),
                  //       ),
                  //       items: Languages.languageList()
                  //           .map<DropdownMenuItem<Languages>>((items) {
                  //         return DropdownMenuItem<Languages>(
                  //           value: items,
                  //           child: Text(items.name),
                  //         );
                  //       }).toList(),
                  //       onChanged: (Languages? newValue) async {
                  //         print(newValue!.languageCode.toString());
                  //         Locale _locale =
                  //             await setLocale(newValue.languageCode);
                  //         MyApp.setLocale(context, _locale);
                  //       },
                  //     ),
                  //   ),
                  // ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.fromLTRB(20, 100, 20, 0),
                    child: Center(child: Image.asset("assets/logingif.gif")),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(0))),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                            child: Text(
                              translation(context).login_title,
                              // "Login",
                              style: TextStyle(
                                  color: HexColor("#5519ff"),
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text(
                              translation(context).login_subtitle,
                              style: TextStyle(
                                  color: HexColor("#7c7c7c"), fontSize: 13),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: HexColor("#e8e8e8"),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(0),
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(0))),
                                  margin:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(fontSize: 15),
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return translation(context)
                                            .username_required;
                                      } else {
                                        setState(() {
                                          username = value.toString();
                                        });
                                      }
                                      return null;
                                    },
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        // fillColor: Colors.blue,
                                        border: InputBorder.none,

                                        // focusColor: Colors.blueAccent,
                                        // hoverColor: Colors.blueAccent,
                                        // border: OutlineInputBorder(
                                        //   borderRadius: BorderRadius.only(
                                        //       bottomLeft: Radius.circular(0),
                                        //       topRight: Radius.circular(10),
                                        //       topLeft: Radius.circular(10),
                                        //       bottomRight: Radius.circular(0)),
                                        //   borderSide: BorderSide(
                                        //       color: Colors.blueAccent, width: 2),
                                        // ),
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        hintStyle: TextStyle(fontSize: 12),
                                        hintText: translation(context)
                                            .username_login_hint),
                                  )),
                              Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                color: Colors.grey,
                                height: 1,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: HexColor("#e8e8e8"),
                                    border:
                                        Border.all(color: HexColor("#e8e8e8")),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        topRight: Radius.circular(0),
                                        topLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(10))),
                                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return translation(context)
                                          .password_required;
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
                                    // focusColor: Colors.blueAccent,
                                    hoverColor: HexColor("#e8e8e8"),
                                    border: InputBorder.none,
                                    // contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    // fillColor: HexColor("#e8e8e8"),
                                    // border: OutlineInputBorder(
                                    //   borderRadius: BorderRadius.only(
                                    //       bottomLeft: Radius.circular(10),
                                    //       topRight: Radius.circular(0),
                                    //       topLeft: Radius.circular(0),
                                    //       bottomRight: Radius.circular(10)),
                                    //   borderSide:  BorderSide(
                                    //       color: HexColor("#e8e8e8"),
                                    //       width: 2), // Apply corner radius
                                    // ),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    hintText: translation(context)
                                        .password_login_hint,
                                    // filled: true,
                                    hintStyle: TextStyle(fontSize: 12),
                                    isDense: true,

                                    suffixIcon: GestureDetector(
                                      onTap: _toggleObscured,
                                      child: Icon(
                                        _obscured
                                            ? Icons.visibility_off_rounded
                                            : Icons.visibility_rounded,
                                        size: 18,
                                        color: HexColor("#000000"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                              height: 45,
                              width: double.infinity,
                              margin: const EdgeInsets.fromLTRB(20, 20, 20, 60),
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              decoration: BoxDecoration(
                                  color: HexColor("#6ddb8c"),
                                  border: Border.all(
                                      width: 1, color: HexColor("#6ddb8c")),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: TextButton(
                                onPressed: visibilityB
                                    ? () {}
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          login(username, password, context);
                                        }
                                      },
                                child: visibilityB
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        translation(context).submit_btn,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
