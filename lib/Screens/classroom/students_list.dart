
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../../Config/api.dart';
import '../../l10n/language_constant.dart';

class StudentList extends StatefulWidget {
  final List Data;
  final Function callRefresh;

  const StudentList({Key? key, required this.Data, required this.callRefresh})
      : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  XFile? image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  double _progress = 0;

  get downloadProgress => _progress;
  double progress = 0.0;
  double progressText = 0.0;

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
    String fileName = pickedFile!.path.split('/').last;
    FormData formData = FormData.fromMap({
      "imagefile":
          await MultipartFile.fromFile(pickedFile.path, filename: fileName),
      "student": name.toString()
    });
    Dio dio = Dio();
    var response = await dio.post(
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
    print(progress);
    // if (progress != "0") {
    //   showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Dialog(
    //         child: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               new CircularProgressIndicator(),
    //               SizedBox(
    //                 width: 21,
    //               ),
    //               new Text(translation(context).loading),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // }
    // var request = http.MultipartRequest("POST", url);
    // request.fields['student'] = name.toString();
    //
    // if (File(pickedFile.path).exists() != null) {
    //   request.files.add(http.MultipartFile(
    //       'imagefile',
    //       pickedFile.readAsBytes().asStream(),
    //       File(pickedFile.path).lengthSync(),
    //       filename:
    //           DateTime.now().toString() + pickedFile.path.split("/").last));
    // }

    // var responses = await request.send();
    //
    // // responses.stream.transform(utf8.decoder).listen((value) {
    // //   print(value);
    // // });
    // // print(downloadProgress);
    // var responseBody = await http.Response.fromStream(responses);
    // var jsonMap = json.decode(responseBody.body);
    // print(jsonMap);
    print(response.data);

    if (response.data["Status"] == 200) {
      setState(() {
        progress = 0.0;
      });
      Widget okButton = TextButton(
        child: Text(translation(context).okay),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
          Navigator.pop(context);
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
      print(response.data);
      setState(() {
        progress = 0.0;
      });
      // Navigator.pop(context);
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
        body: Stack(children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: widget.Data.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      widget.callRefresh();
                    },
                    child: ListView.builder(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 50,
                                      height: 50,
                                      margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      // child: Icon(Icons.camera_alt)
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: FadeInImage(
                                          image: NetworkImage(
                                            "https://fas.qazna24.kz/static/students/${widget.Data[index]["child_iin"]}.png",
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
                                                    widget.Data[index]
                                                            ["child_iin"]
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
                                                        BorderRadius.circular(
                                                            50)),
                                                child: Image.network(
                                                  'https://img.icons8.com/ios-glyphs/480/camera--v1.png',
                                                  filterQuality:
                                                      FilterQuality.medium,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          margin:
                                              EdgeInsets.fromLTRB(0, 6, 0, 0),
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
                        itemCount: widget.Data.length),
                  )
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
                          SizedBox(
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
        ]));
  }
}
