// import 'dart:io';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';
// import 'dart:ui' as ui;
//
// class AttendPage extends StatefulWidget {
//   const AttendPage({Key? key}) : super(key: key);
//
//   @override
//   State<AttendPage> createState() => _AttendPageState();
// }
//
// class _AttendPageState extends State<AttendPage> {
//   File? _imageFile;
//   List<Face>? _faces;
//   bool isLoading = false;
//   ui.Image? _image;
//   final picker = ImagePicker();
//   var imageFile;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     initFire();
//   }
//
//   void initFire() async {
//     await Firebase.initializeApp();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         // title of the appbar
//         title: Text('Face Detection'),
//       ),
//       // foating button for picking image
//       floatingActionButton: FloatingActionButton(
//         onPressed: _getImagegallery,
//         tooltip: 'camera',
//         child: Icon(Icons.add_a_photo),
//       ),
//       // if file is null print no image
//       // selected others wise show image
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : (_imageFile == null)
//               ? Center(child: Text('no image selected'))
//               : Center(
//                   child: FittedBox(
//                     child: SizedBox(
//                       width: _image?.width.toDouble(),
//                       height: _image?.height.toDouble(),
//                       child: CustomPaint(
//                         painter: FacePainter(_image!, _faces!),
//                       ),
//                     ),
//                   ),
//                 ),
//     );
//   }
//
//   // function for pick the image
//   // and detect faces in the image
//   _getImagegallery() async {
//     imageFile = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       isLoading = true;
//     });
//     print(imageFile);
//     final image = FirebaseVisionImage.fromFilePath(imageFile.path);
//     final faceDetector = FirebaseVision.instance.faceDetector();
//     print(image);
//
//     print("saddest");
//     List<Face> faces = await faceDetector.processImage(image);
//
//     if (mounted) {
//       setState(() {
//         _imageFile = File(imageFile.path);
//         _faces = faces;
//         _loadImage(File(imageFile.path));
//       });
//     }
//   }
//
//   _loadImage(File file) async {
//     final data = await file.readAsBytes();
//     await decodeImageFromList(data).then((value) => setState(() {
//           _image = value;
//           isLoading = false;
//         }));
//   }
// }
//
// // paint the face
// class FacePainter extends CustomPainter {
//   final ui.Image image;
//   final List<Face> faces;
//   final List<Rect> rects = [];
//
//   FacePainter(this.image, this.faces) {
//     for (var i = 0; i < faces.length; i++) {
//       rects.add(faces[i].boundingBox);
//     }
//   }
//
//   @override
//   void paint(ui.Canvas canvas, ui.Size size) {
//     final Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0
//       ..color = Colors.red;
//
//     canvas.drawImage(image, Offset.zero, Paint());
//     for (var i = 0; i < faces.length; i++) {
//       canvas.drawRect(rects[i], paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(FacePainter old) {
//     return image != old.image || faces != old.faces;
//   }
// }
// // import 'package:flutter/material.dart';
// //
// // class AttendPage extends StatefulWidget {
// //   const AttendPage({Key? key}) : super(key: key);
// //
// //   @override
// //   State<AttendPage> createState() => _AttendPageState();
// // }
// //
// //
// // class _AttendPageState extends State<AttendPage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container();
// //   }
// // }
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:face_detaction_app/Screens/student_liist_for%20_atten.dart';
import 'package:face_detaction_app/Screens/students_list.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;
import 'package:shimmer/shimmer.dart';

import '../Config/api.dart';
import 'package:flutter/cupertino.dart';

import 'home.dart';

class Atted extends StatefulWidget {
  const Atted({Key? key}) : super(key: key);

  @override
  State<Atted> createState() => _AttedState();
}

class _AttedState extends State<Atted> {
  var data = [
    // {"title": "Class 12", "sub_title": "Chemistry 1ST", "suc": "12", "ap": "3"},
    // {"title": "Class 11", "sub_title": "Chemistry 2ND", "suc": "22", "ap": "12"}
  ];
  final LocalStorage storage = LocalStorage('todo_app');
  TodoList list = TodoList();

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  void getData() {
    var data = storage.getItem('todos');
    print(data);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Classrooms"),
          centerTitle: true,
        ),
        body: Container(
          child: list.items.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) => const Text("as"),
                  itemCount: list.items.length)
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
