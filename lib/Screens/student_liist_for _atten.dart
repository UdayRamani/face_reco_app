import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../Components/custome_photo_view.dart';

class StudentListForAttend extends StatefulWidget {
  final List Data;

  const StudentListForAttend({Key? key, required this.Data}) : super(key: key);

  @override
  State<StudentListForAttend> createState() => _StudentListForAttendState();
}

class _StudentListForAttendState extends State<StudentListForAttend> {
  XFile? image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

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
          child: widget.Data.length != 0
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
                                width: 200,
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
                        GestureDetector(
                          onTap: () {
                            print("sdds");
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                                  return CustomePhotoView(
                                    ImageUrl:
                                    "https://udayramani.com/assets/img/profile.jpeg",
                                  );
                                }));
                          },
                          child: Container(
                            width: 50,
                            height: 30,
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            // child: Icon(Icons.camera_alt)
                            child: Image.network(
                              "https://udayramani.com/assets/img/profile.jpeg",
                              fit: BoxFit.contain,
                            ),
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
