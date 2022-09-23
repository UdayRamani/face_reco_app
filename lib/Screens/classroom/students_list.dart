import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../../Config/api.dart';

class StudentList extends StatefulWidget {
  final List Data;

  const StudentList({Key? key, required this.Data}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  XFile? image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _onImageButtonPressed(
    ImageSource source,
    String name, {
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

    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: width,
      maxHeight: height,
      imageQuality: 50,
    );
    var url = Uri.parse("${Api.mRUrl}registerapi");
    print(url);
    AlertDialog alert1 = const AlertDialog(
      title: Text("Waiting.....", style: TextStyle(color: Colors.green)),
      content: Text("We are registering Student."),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert1;
      },
    );
    var request = http.MultipartRequest("POST", url);
    request.fields['student'] = name.toString();
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
    print(jsonMap);
    if (jsonMap["Status"] == 200) {
      Navigator.pop(context);
      Widget okButton = TextButton(
        child: const Text("OKay"),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
        },
      );

      AlertDialog alert = AlertDialog(
        title: const Text("Student Registered",
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
      Navigator.pop(context);
    }
    setState(() {
      image = pickedFile;
    });
    // _upload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Students"),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: widget.Data.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    int ins = index + 1;
                    return Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      decoration: BoxDecoration(
                          // color: data[index]["ap"].toString() == "P"
                          //     ? Colors.green[200]
                          //     : Colors.red[200],
                          color: Colors.red[200],
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 0.2,
                                offset: Offset.fromDirection(1),
                                color: Colors.black12,
                                spreadRadius: 1)
                          ],
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: 30,
                                    child: Text(
                                      ins.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    child: Text(
                                      widget.Data[index]["child_name"]
                                          .toString()
                                          .toUpperCase(),
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                width: 50,
                                height: 30,
                                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                // child: Icon(Icons.camera_alt)
                                child: FadeInImage(
                                  image: NetworkImage(
                                    "http://157.245.107.107/static/students/${widget.Data[index]["child_iin"]}.png",
                                  ),
                                  placeholder: const NetworkImage(
                                      "https://i.gifer.com/origin/d3/d3f472b06590a25cb4372ff289d81711_w200.gif",
                                  ),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return GestureDetector(
                                      onTap: () {
                                        _onImageButtonPressed(
                                            ImageSource.camera,
                                            widget.Data[index]["child_iin"]
                                                .toString(),
                                            context: context,
                                            imageQuality: 85);
                                      },
                                      child: Image.network(
                                        'https://img.icons8.com/ios-glyphs/480/camera--v1.png',
                                        filterQuality: FilterQuality.medium,
                                      ),
                                    );
                                  },
                                  fit: BoxFit.fitWidth,
                                )),

                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: widget.Data.length)
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                        baseColor: Colors.grey.shade400,
                        highlightColor: Colors.black12,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          height: 40,
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
