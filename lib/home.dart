import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'atted.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
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
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (c) {
                return AttendPage();
              },
            ));
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.deepPurple,
            ),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(image: AssetImage("assets/back.png"))),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Container()]),
        ));
  }
}
