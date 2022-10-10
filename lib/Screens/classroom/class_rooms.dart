import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:face_detaction_app/Screens/classroom/students_list.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../Config/api.dart';
import '../../l10n/language_constant.dart';

class ClassRooms extends StatefulWidget {
  const ClassRooms({Key? key}) : super(key: key);

  @override
  State<ClassRooms> createState() => _ClassRoomsState();
}

class _ClassRoomsState extends State<ClassRooms> {
  var data = [
    // {"title": "Class 12", "sub_title": "Chemistry 1ST", "suc": "12", "ap": "3"},
    // {"title": "Class 11", "sub_title": "Chemistry 2ND", "suc": "22", "ap": "12"}
  ];
  var orgId = "";

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
      data = response.data[0]["group_mass"];
      orgId = response.data[0]["org_ID"].toString();
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
              ? RefreshIndicator(
                  onRefresh: () async {
                    getDataa();
                  },
                  child: ListView.builder(
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      StudentList(
                                        orgId: orgId,
                                          groupId: data[index]["group_ID"].toString(),
                                          callRefresh: () {
                                            getDataa();
                                          },
                                          Data: data[index]["child_mass"]),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      data[index]["group_name"]
                                          .toString()
                                          .toUpperCase(),
                                      locale: Locale.fromSubtags(
                                          languageCode: 'ru'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),

                                      // padding: EdgeInsets.all(5),
                                      // decoration: BoxDecoration(
                                      //     borderRadius:
                                      //     BorderRadius.circular(30),
                                      //     color: Colors.redAccent),
                                      child: Text(
                                        (data[index]["child_mass"] as List)
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
                      itemCount: data.length),
                )
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
