import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StudentList extends StatefulWidget {
  final List Data;

  const StudentList({Key? key, required this.Data}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  // var data = [
  //   {"title": "Niloy", "ap": "P"},
  //   {"title": "Niloy", "ap": "P"},
  //   {"title": "Niloy", "ap": "P"},
  //   {"title": "Niloy", "ap": "P"},
  //   {"title": "Niloy", "ap": "P"},
  //   {"title": "Niloy", "ap": "P"},
  //   {"title": "Rana", "ap": "A"},
  //   {"title": "Rana", "ap": "A"},
  //   {"title": "Rana", "ap": "A"},
  //   {"title": "Rana", "ap": "A"},
  //   {"title": "Niloy", "ap": "P"},
  //   {"title": "Niloy", "ap": "P"},
  //   {"title": "Niloy", "ap": "P"},
  //   {"title": "Niloy", "ap": "P"},
  //   {"title": "Rana", "ap": "A"},
  //   {"title": "Rana", "ap": "A"},
  //   {"title": "Rana", "ap": "A"},
  //   {"title": "Rana", "ap": "A"},
  //   {"title": "Niloy", "ap": "P"},
  //   {"title": "Niloy", "ap": "P"},
  //   {"title": "Niloy", "ap": "P"},
  //   {"title": "Niloy", "ap": "P"},
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Students"),
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
                            Container(
                              width: 50,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(
                                "A",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10),
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
