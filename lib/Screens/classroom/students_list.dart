import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../../Config/api.dart';
import '../../l10n/language_constant.dart';

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
    if (pickedFile!.path.isNotEmpty) {
      AlertDialog alert1 = AlertDialog(
        title: Text(translation(context).loading,
            style: TextStyle(color: Colors.green)),
        content: Text(translation(context).child_registering),
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert1;
        },
      );
    }
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
        child: Text(translation(context).okay),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text(translation(context).registration_successfully,
            style: TextStyle(color: Colors.green)),
        content: Text(translation(context).press_ok_to_con),
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
          title: Text(translation(context).children),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: widget.Data.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    int ins = index + 1;
                    return Container(
                      margin: EdgeInsets.fromLTRB(10, 20, 20, 0),
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
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
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 50,
                                height: 50,
                                margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                // child: Icon(Icons.camera_alt)
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
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
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Image.network(
                                            'https://img.icons8.com/ios-glyphs/480/camera--v1.png',
                                            filterQuality: FilterQuality.medium,
                                            width: 20,
                                          ),
                                        ),
                                      );
                                    },
                                    fit: BoxFit.fitWidth,
                                  ),
                                )),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      widget.Data[index]["child_name"]
                                          .toString()
                                          .toUpperCase(),
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 6, 0, 0),
                                    child: Text(
                                      widget.Data[index]["child_iin"],
                                      style: TextStyle(
                                          color: Colors.grey,
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
