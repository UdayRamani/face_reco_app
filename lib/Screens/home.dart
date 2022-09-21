import 'dart:convert';
import 'dart:io';

import 'package:face_detaction_app/Config/api.dart';
import 'package:face_detaction_app/Screens/atted.dart';
import 'package:face_detaction_app/Screens/group_list_atted.dart';
import 'package:face_detaction_app/Screens/todayAtted.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'class_rooms.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  XFile? image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  bool checkLoaderForAttend = false;

  Future<void> _onImageButtonPressed(ImageSource source, {
    required BuildContext context,
    required int imageQuality,
  }) async {
    final double? width = maxWidthController.text.isNotEmpty
        ? double.parse(maxWidthController.text)
        : null;
    final double? height = maxHeightController.text.isNotEmpty
        ? double.parse(maxHeightController.text)
        : null;
    final int? quality = qualityController.text.isNotEmpty
        ? int.parse(qualityController.text)
        : null;
    setState(() {
      checkLoaderForAttend = true;
    });
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: width,
      maxHeight: height,
      // imageQuality: quality,
    );

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => Container(),
    //   ),
    // );

    var url = Uri.parse("${Api.mRUrl}attendanceapi");
    print(url);
    var request = http.MultipartRequest("POST", url);
    if (File(pickedFile!.path).exists() != null) {
      request.files.add(http.MultipartFile(
          'imagefile',
          pickedFile!.readAsBytes().asStream(),
          File(pickedFile!.path).lengthSync(),
          filename:
          DateTime.now().toString() + pickedFile!
              .path
              .split("/")
              .last));
    }

    var responses = await request.send();
    var responseBody = await http.Response.fromStream(responses);
    var jsonMap = json.decode(responseBody.body);
    print(jsonMap);

    if (jsonMap["Status"] == 200) {
      setState(() {
        checkLoaderForAttend = false;
      });
      Widget okButton = TextButton(
        child: const Text("OKay"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget okButton1 = TextButton(
        child: const Text(
          "New attendance",
        ),
        onPressed: () {
          _onImageButtonPressed(ImageSource.camera,
              context: context, imageQuality: 85);
        },
      );
      AlertDialog alert = AlertDialog(
        title: const Text("Attendance Submitted",
            style: TextStyle(color: Colors.green)),
        content: const Text("Click Okay to Back "),
        actions: [
          okButton,
          okButton1,
        ],
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      setState(() {
        checkLoaderForAttend = false;
      });
    }
    setState(() {
      image = pickedFile;
    });
    // _upload();
  }

  final TodoList list = new TodoList();
  final LocalStorage storage = new LocalStorage('todo_app');
  bool initialized = false;
  TextEditingController controller = new TextEditingController();

  _toggleItem(TodoItem item) {
    setState(() {
      item.done = !item.done;
      _saveToStorage();
    });
  }

  _addItem(String title) {
    setState(() {
      final item = TodoItem(title: "title", done: false);
      list.items.add(item);
      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem('todos', list.toJSONEncodable());
  }

  void _save() {
    _addItem(controller.value.text);
    controller.clear();
  }

  _clearStorage() async {
    await storage.clear();

    setState(() {
      list.items = storage.getItem('todos') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Logout?'),
                          content:
                          Text('Do you want to logout this application?'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                print("you choose no");
                                Navigator.of(context).pop(false);
                              },
                              child: Text('No'),
                            ),
                            FlatButton(
                              onPressed: () async {
                                SharedPreferences pref =
                                await SharedPreferences.getInstance();
                                pref.clear();
                                Navigator.pushNamedAndRemoveUntil(
                                    context, "/login", (route) => false);
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.logout))
          ],
        ),

        body: Container(
          child: Column(children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage("assets/dashboard.gif"))),
              ),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => GroupListAttend()
                        ),
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
                        children: const [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            "Make Attendance",
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
                            'Classrooms',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (BuildContext context) => Atted(),
                  //       ),
                  //     );
                  //   },
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Colors.lightBlue,
                  //       boxShadow: <BoxShadow>[
                  //         BoxShadow(
                  //           color: Colors.blue.withOpacity(0.1),
                  //           blurRadius: 1,
                  //           offset: Offset(0, 2),
                  //         ),
                  //       ],
                  //     ),
                  //     alignment: Alignment.center,
                  //     padding:
                  //     EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  //     width: MediaQuery
                  //         .of(context)
                  //         .size
                  //         .width * 0.8,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: const [
                  //         Icon(Icons.school_rounded, color: Colors.white),
                  //         SizedBox(
                  //           width: 10,
                  //         ),
                  //         Text(
                  //           'Today Attendance',
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
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
