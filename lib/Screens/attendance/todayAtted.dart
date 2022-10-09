import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import "package:http/http.dart" as http;
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../Config/api.dart';
import '../../l10n/language_constant.dart';
import '../home.dart';

class TodayAtted extends StatefulWidget {
  final String title;
  final String org_ID;
  final String group_ID;
  final List students;
  final Function callBack;

  const TodayAtted(
      {Key? key,
      required this.title,
      required this.org_ID,
      required this.group_ID,
      required this.students,
      required this.callBack})
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

  var FinalData = [];
  var FinalDataCountGreen = [];
  double progress = 0.0;
  double progressText = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    getDatas();

    super.initState();
  }

  void getDatas() {
    for (var d in widget.students) {
      //   final response = await http.get(Uri.parse(
      //       "https://fas.qazna24.kz/static/students/${d["child_iin"]}.png"));
      //   print(response.statusCode);
      //   if (response.statusCode == 200) {
      if (d["child_present"] == "true") {
        FinalData.add({
          "child_name": d["child_name"].toString(),
          "child_iin": d["child_iin"].toString(),
          "child_present": d["child_present"].toString(),
          "color": "green"
        });
        setState(() {});
      } else {
        FinalData.add({
          "child_name": d["child_name"].toString(),
          "child_iin": d["child_iin"].toString(),
          "child_present": d["child_present"].toString(),
          "color": "red"
        });
        setState(() {});
      }
      // } else {
      //   FinalData.add({
      //     "child_name": d["child_name"].toString(),
      //     "child_iin": d["child_iin"].toString(),
      //     "child_present": d["child_present"].toString(),
      //     "color": "gray"
      //   });
      //   setState(() {});
      // }
    }
  }

  Timer? _timer;
  int _start = 10;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start++;
          });
        }
      },
    );
  }

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
      imageQuality: 20,
    );
    print(pickedFile!.length());
    // _onLoading(true);
    var url = Uri.parse("${Api.mRUrl}attendanceapi");
    print(url);
    String fileName = pickedFile.path.split('/').last;

    FormData formData = FormData.fromMap({
      "imagefile":
          await MultipartFile.fromFile(pickedFile.path, filename: fileName),
    });

    Dio dio = Dio();
    await dio.post(
      url.toString(),
      data: formData,
      onSendProgress: (int sent, int total) {
        print(
            'progress: ${(sent / total * 100).toStringAsFixed(0)} ($sent/$total)');
        progress = (sent / total * 100) / 100;
        progressText = (sent / total * 100);
        setState(() {});
      },
    );
    var request = http.MultipartRequest("POST", url);
    if (File(pickedFile.path).exists() != null) {
      request.files.add(http.MultipartFile(
          'imagefile',
          pickedFile.readAsBytes().asStream(),
          File(pickedFile.path).lengthSync(),
          filename:
              DateTime.now().toString() + pickedFile.path.split("/").last));
    }

    var responses = await request.send();
    var responseBody = await http.Response.fromStream(responses);
    var jsonMap = json.decode(responseBody.body);
    // responses.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    // });

    // Dio dio = Dio();
    // var responseDio = await dio.post(
    //   url.toString(),
    //   data: formData,
    //   onSendProgress: (int sent, int total) {
    //     print(
    //         'progress: ${(sent / total * 100).toStringAsFixed(0)} ($sent/$total)');
    //     progress = (sent / total * 100) / 100;
    //     progressText = (sent / total * 100);
    //     setState(() {});
    //   },
    // );
    // print(json.decode(responseDio.data));

    print(jsonMap["Status"].toString());

    if (jsonMap["Status"] == 200) {
      // _onLoading(false);

      progress = 0.0;
      progressText = 0.0;

      checkLoaderForAttend = false;
      _save((jsonMap["St_ids"] as List));

      Widget okButton = TextButton(
        child: Text(translation(context).okay),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      Widget okButton1 = TextButton(
        child: Text(
          translation(context).saveatted,
        ),
        onPressed: () {
          Attendnce();

          // _onImageButtonPressed(ImageSource.camera,
          //     context: context, imageQuality: 85);
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text(
          translation(context).successfully,
          style: TextStyle(color: Colors.green),
          textAlign: TextAlign.center,
        ),
        content: Text(translation(context).we_got_to_know_the_children),
        actions: [
          okButton,
          okButton1,
        ],
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CustomeDailog(
            callback: () => Attendnce(),
          );
        },
      );
    } else {
      setState(() {
        progress = 0.0;
      });
      // _onLoading(false);
      setState(() {
        checkLoaderForAttend = false;
      });
      Widget okButton = TextButton(
        child: Text(translation(context).okay),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget okButton1 = TextButton(
        child: Text(
          translation(context).again,
        ),
        onPressed: () {
          _onImageButtonPressed(ImageSource.camera,
              context: context, imageQuality: 85);
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text(translation(context).not_recognized,
            style: TextStyle(color: Colors.red)),
        content: Text(translation(context).we_can_not_recognize),
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
    image = pickedFile;
    setState(() {});
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
                      new Text(translation(context).loading),
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
    print(data);
    // FinalData.clear();
    Datass.addAll(data);
    setState(() {
      progress = 0.0;
      progressText = 0.0;
    });
    for (var d = 0; d < FinalData.length; d++) {
      for (var e in data) {
        print(d);
        if (e.toString() == FinalData[d]["child_iin"].toString()) {
          print(FinalData[d]);
          FinalData[d] = {
            "child_name": FinalData[d]["child_name"].toString(),
            "child_iin": FinalData[d]["child_iin"].toString(),
            "child_present": FinalData[d]["child_present"].toString(),
            "color": "green"
          };
          // FinalDataCountGreen[d] = {"color": "green"};
        }
        // if (e.toString() != d["child_iin"].toString()) {
        //   FinalData.add({
        //     "child_name": d["child_name"],
        //     "child_iin": d["child_iin"],
        //     "child_present": d["child_present"],
        //     "color": "red"
        //   });
        // }
        // }
        // else {
        //   FinalData.add({
        //     "child_name": d["child_name"],
        //     "child_iin": d["child_iin"],
        //     "child_present": d["child_present"],
        //     "color": "red"
        //   });
      }
    }
    setState(() {});

    print(FinalData);
    // }
    // setState(() {});
    // storage.setItem(widget.title, data);
    // displayData.addAll(widget.students);
    // print(data);
    // Datass.addAll(data.where((element) => element["child_present"] != true));
    // Datass.addAll(data);
    // for (var d in displayData) {
    //   for (var e in data) {
    //     print(d);
    //     if (e.toString() == d["child_iin"].toString()) {
    //       finaldisplayDataWithName.add(d);
    //     }
    //   }
    // }
    // print(finaldisplayDataWithName);
    // setState(() {});
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

    String gropId = widget.group_ID.toString();
    var data = {
      "org_ID": widget.org_ID,
      "group_mass": [
        {"group_ID": gropId, "visited": Datass}
      ]
    };
    print(data);
    // print({
    //   "org_ID": widget.org_ID,
    //   "group_mass": [
    //     {"group_ID": gropId, "visited": Datass}
    //   ]
    // });
    var request = http.Request(
        'POST', Uri.parse(Api.visited));
    request.body = json.encode([
      {
        "org_ID": int.parse(widget.org_ID),
        "group_mass": [
          {"group_ID": gropId, "visited": Datass}
        ]
      }
    ]);


    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var responseBody = await http.Response.fromStream(response);
    // var ress=json.decode(responseBody.body);
    // print(Api().getBody(responseBody));
    if (response.statusCode == 200) {
      _onLoading(false);
      Widget okButton = TextButton(
        child: Text(translation(context).okay),
        onPressed: () {
          widget.callBack();
          // FinalData.clear();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));

          // Navigator.pop(context);
          Datass.clear();
          finaldisplayDataWithName.clear();
          setState(() {});
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text(translation(context).successfully_submitted,
            style: TextStyle(color: Colors.green)),
        content: Text(translation(context).okay),
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
      print(response.statusCode);
      _onLoading(false);
    }
  }

  Future<bool> checkURLs(url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            // GestureDetector(
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (BuildContext context) => AttendList(
            //                     Data: widget.students,
            //                   )));
            //     },
            //     child: const Padding(
            //       padding: EdgeInsets.all(8.0),
            //       child: Icon(Icons.list_alt_rounded),
            //     )),
            // GestureDetector(
            //     onTap: () {
            //       // if (Datass.isEmpty) {
            //       //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //       //       backgroundColor: Colors.red,
            //       //       content: Text(
            //       //         translation(context).atten_empty,
            //       //       )));
            //       // } else {
            //       Attendnce();
            //       // }
            //     },
            //     child: const Padding(
            //       padding: EdgeInsets.all(8.0),
            //       child: Icon(Icons.save),
            //     ))
          ],
        ),
        floatingActionButton: checkLoaderForAttend
            ? Container(
                decoration: BoxDecoration(
                    // color: data[index]["ap"].toString() == "P"
                    //     ? Colors.green[200]
                    //     : Colors.red[200],
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
        body: Stack(
          children: [
            Container(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: FinalData.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () async {
                        widget.callBack();
                      },
                      child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                              decoration: BoxDecoration(
                                  // color: data[index]["ap"].toString() == "P"
                                  //     ? Colors.green[200]
                                  //     : Colors.red[200],
                                  color: FinalData[index]["color"] == "green"
                                      ? Colors.green.shade100
                                      : FinalData[index]["color"] == "red"
                                          ? Colors.red.shade100
                                          : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 0.2,
                                        offset: Offset.fromDirection(1),
                                        color: Colors.black12,
                                        spreadRadius: 1)
                                  ],
                                  border: Border.all(
                                      color: FinalData[index]["color"] ==
                                              "green"
                                          ? Colors.green
                                          : FinalData[index]["color"] == "red"
                                              ? Colors.red
                                              : Colors.grey),
                                  borderRadius: BorderRadius.circular(5)),
                              // decoration: FinalData[index]["color"] == "gray"
                              //     ? BoxDecoration(
                              //         border: Border.all(color: Colors.grey.shade300),
                              //         borderRadius: BorderRadius.circular(5))
                              //     : BoxDecoration(
                              //         // color: data[index]["ap"].toString() == "P"
                              //         //     ? Colors.green[200]
                              //         //     : Colors.red[200],
                              //         color: FinalData[index]["color"] == "green"
                              //             ? Colors.green.shade100
                              //             : FinalData[index]["color"] == "red"
                              //                 ? Colors.red.shade100
                              //                 : Colors.white,
                              //         boxShadow: [
                              //           BoxShadow(
                              //               blurRadius: 0.2,
                              //               offset: Offset.fromDirection(1),
                              //               color: Colors.black12,
                              //               spreadRadius: 1)
                              //         ],
                              //         border: Border.all(
                              //             color: FinalData[index]["color"] == "green"
                              //                 ? Colors.green
                              //                 : FinalData[index]["color"] == "red"
                              //                     ? Colors.red
                              //                     : Colors.grey),
                              //         borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 10, 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Container(
                                    //     width: 50,
                                    //     height: 50,
                                    //     margin: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                                    //     decoration: BoxDecoration(
                                    //         color: Colors.white,
                                    //         borderRadius: BorderRadius.circular(10)),
                                    //     // child: Icon(Icons.camera_alt)
                                    //     child: ClipRRect(
                                    //       borderRadius: BorderRadius.circular(8.0),
                                    //       child: FadeInImage(
                                    //         image: NetworkImage(
                                    //           "https://fas.qazna24.kz/static/students/${FinalData[index]["child_iin"]}.png",
                                    //         ),
                                    //         placeholder: const NetworkImage(
                                    //           "https://i.gifer.com/origin/d3/d3f472b06590a25cb4372ff289d81711_w200.gif",
                                    //         ),
                                    //         imageErrorBuilder:
                                    //             (context, error, stackTrace) {
                                    //           return GestureDetector(
                                    //             onTap: () {
                                    //               // _onImageButtonPressed(
                                    //               //     ImageSource.camera,
                                    //               //     widget.Data[index]["child_iin"]
                                    //               //         .toString(),
                                    //               //     context: context,
                                    //               //     imageQuality: 85);
                                    //             },
                                    //             child: Container(
                                    //               width: 20,
                                    //               height: 20,
                                    //               padding: EdgeInsets.all(5),
                                    //               decoration: BoxDecoration(
                                    //                   color: Colors.white,
                                    //                   border: Border.all(
                                    //                       color: Colors.grey.shade300),
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(50)),
                                    //               child: Image.network(
                                    //                 'https://img.icons8.com/ios-glyphs/480/camera--v1.png',
                                    //                 filterQuality: FilterQuality.medium,
                                    //                 color: Colors.grey,
                                    //                 width: 20,
                                    //               ),
                                    //             ),
                                    //           );
                                    //         },
                                    //         fit: BoxFit.fitWidth,
                                    //       ),
                                    //     )),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            FinalData[index]["child_name"]
                                                .toString()
                                                .toUpperCase(),
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                // color: FinalData[index]["color"] ==
                                                //         "gray"
                                                //     ? Colors.grey.shade400
                                                //     : Colors.black,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                          Container(
                                            margin:
                                                EdgeInsets.fromLTRB(0, 6, 0, 0),
                                            child: Text(
                                              FinalData[index]["child_iin"],
                                              style: TextStyle(
                                                  // color: FinalData[index]["color"] ==
                                                  //         "gray"
                                                  //     ? Colors.grey.shade300
                                                  //     : Colors.black,
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: FinalData.length),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey.shade400,
                            highlightColor: Colors.black12,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
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
            ),
            progress != 0.0
                ? Container(
                    color: Colors.black12,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        height: 70,
                        margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(translation(context).loading),
                            const SizedBox(
                              height: 10,
                            ),
                            LinearPercentIndicator(
                              lineHeight: 14.0,
                              percent: progress,
                              center: Text(progressText.toString()),
                              backgroundColor: Colors.grey,
                              progressColor: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ))
                : Container(),
          ],
        ));
  }
}

class CustomeDailog extends StatelessWidget {
  final Function callback;

  const CustomeDailog({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: 170,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(children: [
          SizedBox(
            height: 25,
          ),
          Text(translation(context).success_text,
              style: TextStyle(color: Colors.green, fontSize: 20)),
          SizedBox(
            height: 10,
          ),
          Text(
            translation(context).success_text_subtitle,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 5, 10),
                      height: 40,
                      child: Center(
                          child: Text(translation(context).okay,
                              style: TextStyle(color: Colors.white))),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey)),
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    callback();
                  },
                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 30, 10),
                      height: 40,
                      child: Center(
                          child: Text(
                        translation(context).save_record_btn,
                        style: TextStyle(color: Colors.white),
                      )),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: HexColor("#2760ff"))),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}

//   body: Container(
//       padding: EdgeInsets.all(10.0),
//       constraints: BoxConstraints.expand(),
//       child: FutureBuilder(
//         future: storage.ready,
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.data == null) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           // if (!initialized) {
//           //   var items = storage.getItem('todos');
//           //
//           //   if (items != null) {
//           //     Datass = List.from(
//           //       (items as List).map((item) => Datass.add(item)),
//           //     );
//           //   }
//           //
//           //   initialized = true;
//           // }
//
//           List<Widget> widgets = finaldisplayDataWithName.map((item) {
//             return Container(
//                 margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
//                 padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
//                 decoration: BoxDecoration(
//                     // color: data[index]["ap"].toString() == "P"
//                     //     ? Colors.green[200]
//                     //     : Colors.red[200],
//                     color: item["child_present"] == true
//                         ? Colors.deepPurple[200]
//                         : Colors.grey,
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: 0.2,
//                           offset: Offset.fromDirection(1),
//                           color: Colors.black12,
//                           spreadRadius: 1)
//                     ],
//                     borderRadius: BorderRadius.circular(5)),
//                 child: Column(
//                   children: [
//                     Text(item["child_name"].toString()),
//                     Text(item["child_present"] == true
//                         ? ""
//                         : "already Registered"),
//                   ],
//                 ));
//           }).toList();
//
//           return Column(
//             children: <Widget>[
//               const SizedBox(
//                 height: 15,
//               ),
//               Expanded(
//                 flex: 1,
//                 child: ListView(
//                   itemExtent: 50.0,
//                   children: widgets,
//                 ),
//               ),
//               // Container(
//               //   margin: EdgeInsets.fromLTRB(5, 5, 5, 40),
//               //   decoration: BoxDecoration(
//               //       // color: data[index]["ap"].toString() == "P"
//               //       //     ? Colors.green[200]
//               //       //     : Colors.red[200],
//               //       color: Colors.blue,
//               //       boxShadow: [
//               //         BoxShadow(
//               //             blurRadius: 0.2,
//               //             offset: Offset.fromDirection(1),
//               //             color: Colors.black12,
//               //             spreadRadius: 1)
//               //       ],
//               //       borderRadius: BorderRadius.circular(5)),
//               //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//               //   child: const Text("Make Attendance"),
//               // )
//             ],
//           );
//         },
//       )),
// );

// return FutureBuilder<bool>(
//   future: checkURLs(
//       "https://fas.qazna24.kz/static/students/${widget.students[index]["child_iin"]}.png"),
//   // a previously-obtained Future<String> or null
//   builder: (context, snapshot) {
//     if (snapshot.data == true) {
//       return Container(
//         margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
//         padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
//         decoration: BoxDecoration(
//             // color: data[index]["ap"].toString() == "P"
//             //     ? Colors.green[200]
//             //     : Colors.red[200],
//             color: widget.students[index]
//                         ["child_present"] ==
//                     true
//                 ? Colors.green.shade100
//                 : Colors.red.shade100,
//             boxShadow: [
//               BoxShadow(
//                   blurRadius: 0.2,
//                   offset: Offset.fromDirection(1),
//                   color: Colors.black12,
//                   spreadRadius: 1)
//             ],
//             border: Border.all(
//                 color: widget.students[index]
//                             ["child_present"] ==
//                         true
//                     ? Colors.green
//                     : Colors.red),
//             borderRadius: BorderRadius.circular(5)),
//         child: Container(
//           padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
//           child: Row(
//             mainAxisAlignment:
//                 MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                   width: 50,
//                   height: 50,
//                   margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius:
//                           BorderRadius.circular(10)),
//                   // child: Icon(Icons.camera_alt)
//                   child: ClipRRect(
//                     borderRadius:
//                         BorderRadius.circular(8.0),
//                     child: FadeInImage(
//                       image: NetworkImage(
//                         "https://fas.qazna24.kz/static/students/${widget.students[index]["child_iin"]}.png",
//                       ),
//                       placeholder: const NetworkImage(
//                         "https://i.gifer.com/origin/d3/d3f472b06590a25cb4372ff289d81711_w200.gif",
//                       ),
//                       imageErrorBuilder:
//                           (context, error, stackTrace) {
//                         return GestureDetector(
//                           onTap: () {
//                             // _onImageButtonPressed(
//                             //     ImageSource.camera,
//                             //     widget.Data[index]["child_iin"]
//                             //         .toString(),
//                             //     context: context,
//                             //     imageQuality: 85);
//                           },
//                           child: Container(
//                             width: 20,
//                             height: 20,
//                             padding: EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 border: Border.all(
//                                     color: Colors.black),
//                                 borderRadius:
//                                     BorderRadius.circular(
//                                         50)),
//                             child: Image.network(
//                               'https://img.icons8.com/ios-glyphs/480/camera--v1.png',
//                               filterQuality:
//                                   FilterQuality.medium,
//                               width: 20,
//                             ),
//                           ),
//                         );
//                       },
//                       fit: BoxFit.fitWidth,
//                     ),
//                   )),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       child: Text(
//                         widget.students[index]["child_name"]
//                             .toString()
//                             .toUpperCase(),
//                         overflow: TextOverflow.fade,
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 13),
//                       ),
//                     ),
//                     Container(
//                       margin:
//                           EdgeInsets.fromLTRB(0, 6, 0, 0),
//                       child: Text(
//                         widget.students[index]["child_iin"],
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else {
//       return Container(
//         height: 20,
//         width: 200,
//         color: Colors.red,
//       );
//     }
//   },
// );
