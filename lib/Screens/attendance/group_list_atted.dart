import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:face_detaction_app/Screens/attendance/todayAtted.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../Config/api.dart';
import '../../l10n/language_constant.dart';



class GroupListAttend extends StatefulWidget {
  const GroupListAttend({Key? key}) : super(key: key);

  @override
  State<GroupListAttend> createState() => _GroupListAttendState();
}

class _GroupListAttendState extends State<GroupListAttend> {
  var data = [
    // {"title": "Class 12", "sub_title": "Chemistry 1ST", "suc": "12", "ap": "3"},
    // {"title": "Class 11", "sub_title": "Chemistry 2ND", "suc": "22", "ap": "12"}
  ];

  @override
  void initState() {
    // TODO: implement initState
    // GetData("050140008433", "8759");
    super.initState();
    getDataa();
  }

  void getDataa() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String username = pref.getString("username").toString();
    String password = pref.getString("password").toString();
    GetData(username, password);
  }

  void GetData(username, password) async {
    print(username);
    print(password);
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    var url = Api.login;
    print(url);
    Dio dio = Dio();
    dio.options.headers['Authorization'] = basicAuth;
    var response = await dio.get(url);

    if (response.statusCode == 200) {
      // var jsonMap = json.decode(response.data);
      // data = jsonMap[0]["group_mass"];
      data = response.data;
      setState(() {});
    } else {
      // print(jsonMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(translation(context).class_room),
          centerTitle: true,
        ),
        body: Container(
          child: data.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => TodayAtted(
                                students:data[0]["group_mass"][index]["child_mass"],
                                group_ID:
                                    data[0]["org_ID"].toString().toUpperCase(),
                                org_ID: data[0]["group_mass"][index]["group_ID"]
                                    .toString()
                                    .toUpperCase(),
                                title: data[0]["group_mass"][index]
                                        ["group_name"]
                                    .toString()
                                    .toUpperCase(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 0.2,
                                    offset: Offset.fromDirection(1),
                                    color: Colors.black12,
                                    spreadRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data[0]["group_mass"][index]["group_name"]
                                      .toString()
                                      .toUpperCase(),
                                  locale:
                                      Locale.fromSubtags(languageCode: 'ru'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text(
                                    (data[0]["group_mass"][index]["child_mass"]
                                            as List)
                                        .length
                                        .toString(),
                                    style: TextStyle(
                                        color: HexColor("#2760ff"),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  itemCount: data[0]["group_mass"].length)
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                        baseColor: Colors.grey.shade400,
                        highlightColor: Colors.black12,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          height: 70,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 0.2,
                                    offset: Offset.fromDirection(1),
                                    color: Colors.black12,
                                    spreadRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(5)),
                          width: double.infinity,
                        ));
                  },
                  itemCount: 20),
        ));
  }
}
