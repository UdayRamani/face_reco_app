import 'package:face_detaction_app/Screens/attendance/group_list_atted.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/language_constant.dart';
import '../l10n/languagess.dart';
import '../main.dart';
import 'classroom/class_rooms.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getDataa();
    getLocaleName().then((localeName) => {Lng = localeName});
    super.initState();
  }

  String headerTitle = "";
  String Lng = "";

  void getDataa() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    headerTitle = pref.getString("org_name").toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(headerTitle),

          // title: Text(translation(context).dashboard),
          // centerTitle: true,
          actions: [
            // Container(
            //   // width: 30,
            //   // height: 10,
            //   margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //       color: Colors.white, borderRadius: BorderRadius.circular(50)),
            //   child: DropdownButton<Languages>(
            //     // value: dropdownvalue,
            //     underline: SizedBox(),
            //     icon: Icon(
            //       Icons.language,
            //       color: HexColor("#5519ff"),
            //     ),
            //     items: Languages.languageList()
            //         .map<DropdownMenuItem<Languages>>((items) {
            //       return DropdownMenuItem<Languages>(
            //         value: items,
            //         child: Text(items.name),
            //       );
            //     }).toList(),
            //     onChanged: (Languages? newValue) async {
            //       print(newValue!.languageCode.toString());
            //       Locale _locale = await setLocale(newValue.languageCode);
            //       MyApp.setLocale(context, _locale);
            //     },
            //   ),
            // ),
            // IconButton(
            //     onPressed: () {
            //       showDialog(
            //           context: context,
            //           builder: (BuildContext context) {
            //             return AlertDialog(
            //               title: Text(translation(context).logout),
            //               content: Text(translation(context).logout_q),
            //               actions: <Widget>[
            //                 FlatButton(
            //                   onPressed: () {
            //                     Navigator.of(context).pop(false);
            //                   },
            //                   child: Text(translation(context).not),
            //                 ),
            //                 FlatButton(
            //                   onPressed: () async {
            //                     SharedPreferences pref =
            //                         await SharedPreferences.getInstance();
            //                     pref.clear();
            //                     Navigator.pushNamedAndRemoveUntil(
            //                         context, "/login", (route) => false);
            //                   },
            //                   child: Text(translation(context).yes),
            //                 ),
            //               ],
            //             );
            //           });
            //     },
            //     icon: const Icon(Icons.logout))
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<Languages>(
                  // value: dropdownvalue,
                  underline: SizedBox(),
                  icon: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(Lng),
                  ),
                  items: Languages.languageList()
                      .map<DropdownMenuItem<Languages>>((items) {
                    return DropdownMenuItem<Languages>(
                      value: items,
                      child: Text(items.name),
                    );
                  }).toList(),
                  onChanged: (Languages? newValue) async {
                    Lng = newValue!.name.toString();

                    Locale _locale = await setLocale(newValue.languageCode);
                    MyApp.setLocale(context, _locale);
                    await setLocaleName(newValue!.name.toString());
                  },
                ),
              ),
            ),
          ],
        ),

        body: Container(
          color: Colors.white,
          child: Column(children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage("assets/dashboard.gif"))),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            // Text("Welcome!",
            //
            //   style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),
            //
            // ),
            // SizedBox(height: 5,),
            // Text("To get Started,register your child's photo in our system\nand enter a record of attendance each day",
            // textAlign: TextAlign.center,
            //   style: TextStyle(color: Colors.grey),
            //
            // ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(0, 50, 0, 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                GroupListAttend()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      padding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            translation(context).attendance_btn_home,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ClassRooms(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.lightBlue,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      padding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school_rounded, color: Colors.white),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            translation(context).class_room,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(translation(context).logout),
                              content: Text(translation(context).logout_q),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text(translation(context).not),
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    pref.clear();
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, "/login", (route) => false);
                                  },
                                  child: Text(translation(context).yes),
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            translation(context).logout,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ]),
        ));
  }
}

class TodoItem {
  String title;
  bool done;

  TodoItem({required this.title, required this.done});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['title'] = title;
    m['done'] = done;

    return m;
  }
}

class TodoList {
  List<TodoItem> items = [];

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}
