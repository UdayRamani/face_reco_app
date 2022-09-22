import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/api.dart';
import 'home.dart';

class TodayAtted extends StatefulWidget {
  final String title;
  final String org_ID;
  final String group_ID;
  final List students;

  const TodayAtted(
      {Key? key,
      required this.title,
      required this.org_ID,
      required this.group_ID,
      required this.students})
      : super(key: key);

  @override
  State<TodayAtted> createState() => _TodayAttedState();
}

class _TodayAttedState extends State<TodayAtted> {
  XFile? image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  bool checkLoaderForAttend = false;

  Future<void> _onImageButtonPressed(
    ImageSource source, {
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
    _onLoading(true);
    var url = Uri.parse("${Api.mRUrl}attendanceapi");
    print(url);
    var request = http.MultipartRequest("POST", url);
    if (File(pickedFile!.path).exists() != null) {
      request.files.add(http.MultipartFile(
          'imagefile',
          pickedFile!.readAsBytes().asStream(),
          File(pickedFile!.path).lengthSync(),
          filename:
              DateTime.now().toString() + pickedFile!.path.split("/").last));
    }
    var responses = await request.send();
    var responseBody = await http.Response.fromStream(responses);
    var jsonMap = json.decode(responseBody.body);

    if (jsonMap["Status"] == 200) {
      _onLoading(false);

      setState(() {
        checkLoaderForAttend = false;
      });
      _save(jsonMap["St_ids"] as List);
      setState(() {});

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
      _onLoading(false);
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
        title: const Text("Attend Fail", style: TextStyle(color: Colors.red)),
        content: const Text(
            "We can't attend this student this is not available to our Record"),
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
    }
    setState(() {
      image = pickedFile;
    });
    // _upload();
  }

  final TodoList list = new TodoList();
  var Datass = [];
  var finaldisplayDataWithName = [];
  var displayData = [];
  final LocalStorage storage = new LocalStorage('todo_app');
  bool initialized = false;
  TextEditingController controller = new TextEditingController();

  _toggleItem(TodoItem item) {
    setState(() {
      item.done = !item.done;
      _saveToStorage();
    });
  }

  void _onLoading(value) {
    value
        ? showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      new CircularProgressIndicator(),
                      SizedBox(
                        width: 21,
                      ),
                      new Text("Loading..."),
                    ],
                  ),
                ),
              );
            },
          )
        : Navigator.pop(context);
  }

  _addItem(String title) {
    setState(() {
      final item = TodoItem(title: title, done: false);
      list.items.add(item);
      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem('todos', list.toJSONEncodable());
  }

  void _save(List data) {
    storage.setItem(widget.title, data);
    displayData.addAll(widget.students);
    Datass.addAll(data);
    for (var d in displayData) {
      for (var e in data) {
        if (e.toString() == d["child_iin"].toString()) {
          finaldisplayDataWithName.add(d);
        }
      }
    }
    print(finaldisplayDataWithName);
    setState(() {});
  }

  _clearStorage() async {
    await storage.clear();

    setState(() {
      list.items = storage.getItem('todos') ?? [];
    });
  }

  void Attendnce() async {
    _onLoading(true);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String username = pref.getString("username").toString();
    String password = pref.getString("password").toString();
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    var headers = {
      'Authorization': basicAuth,
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('https://kzo.qaznaonline.kz/kzo/hs/DDO/visited'));
    request.body = json.encode([
      {
        "org_ID": 10867,
        "group_mass": [
          {"group_ID": "ява000112", "visited": Datass}
        ]
      }
    ]);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      _onLoading(false);
      Widget okButton = TextButton(
        child: const Text("OKay"),
        onPressed: () {
          Navigator.pop(context);
          Datass.clear();
          finaldisplayDataWithName.clear();
          setState(() {});
        },
      );
      AlertDialog alert = AlertDialog(
        title: const Text("Attendance Submitted Successfully",
            style: TextStyle(color: Colors.green)),
        content: const Text("Click Okay to Back "),
        actions: [
          okButton,
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
      _onLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          GestureDetector(
              onTap: () {
                if (finaldisplayDataWithName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                            "Warning! Without Add Students You can not submit Attendance")),
                  );
                } else {
                  Attendnce();
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.save),
              ))
        ],
      ),
      floatingActionButton: checkLoaderForAttend
          ? Container(
              decoration: BoxDecoration(
                  // color: data[index]["ap"].toString() == "P"
                  //     ? Colors.green[200]
                  //     : Colors.red[200],
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 0.2,
                        offset: Offset.fromDirection(1),
                        color: Colors.black12,
                        spreadRadius: 1)
                  ],
                  borderRadius: BorderRadius.circular(5)),
              child: Container(
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: CircularProgressIndicator()),
            )
          : GestureDetector(
              onTap: () {
                _onImageButtonPressed(ImageSource.camera,
                    context: context, imageQuality: 85);
              },
              child: Container(
                  decoration: BoxDecoration(
                      // color: data[index]["ap"].toString() == "P"
                      //     ? Colors.green[200]
                      //     : Colors.red[200],
                      color: Colors.deepPurple,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 0.2,
                            offset: Offset.fromDirection(1),
                            color: Colors.black12,
                            spreadRadius: 1)
                      ],
                      borderRadius: BorderRadius.circular(50)),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 35,
                    ),
                  ))),
      body: Container(
          padding: EdgeInsets.all(10.0),
          constraints: BoxConstraints.expand(),
          child: FutureBuilder(
            future: storage.ready,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              // if (!initialized) {
              //   var items = storage.getItem('todos');
              //
              //   if (items != null) {
              //     Datass = List.from(
              //       (items as List).map((item) => Datass.add(item)),
              //     );
              //   }
              //
              //   initialized = true;
              // }

              List<Widget> widgets = finaldisplayDataWithName.map((item) {
                return Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    decoration: BoxDecoration(
                        // color: data[index]["ap"].toString() == "P"
                        //     ? Colors.green[200]
                        //     : Colors.red[200],
                        color: Colors.deepPurple[200],
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 0.2,
                              offset: Offset.fromDirection(1),
                              color: Colors.black12,
                              spreadRadius: 1)
                        ],
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(item["child_name"].toString()));
              }).toList();

              return Column(
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView(
                      itemExtent: 50.0,
                      children: widgets,
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(5, 5, 5, 40),
                  //   decoration: BoxDecoration(
                  //       // color: data[index]["ap"].toString() == "P"
                  //       //     ? Colors.green[200]
                  //       //     : Colors.red[200],
                  //       color: Colors.blue,
                  //       boxShadow: [
                  //         BoxShadow(
                  //             blurRadius: 0.2,
                  //             offset: Offset.fromDirection(1),
                  //             color: Colors.black12,
                  //             spreadRadius: 1)
                  //       ],
                  //       borderRadius: BorderRadius.circular(5)),
                  //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  //   child: const Text("Make Attendance"),
                  // )
                ],
              );
            },
          )),
    );
  }
}
