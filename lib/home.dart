import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'atted.dart';
import 'class_rooms.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
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
        // floatingActionButton: Column(
        //   children: [
        //     InkWell(
        //       onTap: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (BuildContext context) => SignIn(),
        //           ),
        //         );
        //       },
        //       child: Container(
        //         height: 20,
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(10),
        //           color: Colors.white,
        //           boxShadow: <BoxShadow>[
        //             BoxShadow(
        //               color: Colors.blue.withOpacity(0.1),
        //               blurRadius: 1,
        //               offset: Offset(0, 2),
        //             ),
        //           ],
        //         ),
        //         alignment: Alignment.center,
        //         padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        //         width: MediaQuery.of(context).size.width * 0.8,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Text(
        //               'LOGIN',
        //               style: TextStyle(color: Color(0xFF0F0BDB)),
        //             ),
        //             SizedBox(
        //               width: 10,
        //             ),
        //             Icon(Icons.login, color: Color(0xFF0F0BDB))
        //           ],
        //         ),
        //       ),
        //     ),
        //     SizedBox(
        //       height: 10,
        //     ),
        //     InkWell(
        //       onTap: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (BuildContext context) => SignUp(),
        //           ),
        //         );
        //       },
        //       child: Container(
        //         height: 20,
        //
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(10),
        //           color: Color(0xFF0F0BDB),
        //           boxShadow: <BoxShadow>[
        //             BoxShadow(
        //               color: Colors.blue.withOpacity(0.1),
        //               blurRadius: 1,
        //               offset: Offset(0, 2),
        //             ),
        //           ],
        //         ),
        //         alignment: Alignment.center,
        //         padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        //         width: MediaQuery.of(context).size.width * 0.8,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Text(
        //               'SIGN UP',
        //               style: TextStyle(color: Colors.white),
        //             ),
        //             SizedBox(
        //               width: 10,
        //             ),
        //             Icon(Icons.person_add, color: Colors.white)
        //           ],
        //         ),
        //       ),
        //     ),
        //     // SizedBox(
        //     //   height: 20,
        //     //   width: MediaQuery.of(context).size.width * 0.8,
        //     //   child: Divider(
        //     //     thickness: 2,
        //     //   ),
        //     // ),
        //     // InkWell(
        //     //   onTap: _launchURL,
        //     //   child: Container(
        //     //     decoration: BoxDecoration(
        //     //       borderRadius: BorderRadius.circular(10),
        //     //       color: Colors.black,
        //     //       boxShadow: <BoxShadow>[
        //     //         BoxShadow(
        //     //           color: Colors.blue.withOpacity(0.1),
        //     //           blurRadius: 1,
        //     //           offset: Offset(0, 2),
        //     //         ),
        //     //       ],
        //     //     ),
        //     //     // alignment: Alignment.center,
        //     //     // padding: EdgeInsets.symmetric(
        //     //     //     vertical: 14, horizontal: 16),
        //     //     // width: MediaQuery.of(context).size.width * 0.8,
        //     //     // child: Row(
        //     //     //   mainAxisAlignment: MainAxisAlignment.center,
        //     //     //   children: [
        //     //     //     Text(
        //     //     //       'CONTRIBUTE',
        //     //     //       style: TextStyle(color: Colors.white),
        //     //     //     ),
        //     //     //     SizedBox(
        //     //     //       width: 10,
        //     //     //     ),
        //     //     //     FaIcon(
        //     //     //       FontAwesomeIcons.github,
        //     //     //       color: Colors.white,
        //     //     //     )
        //     //     //   ],
        //     //     // ),
        //     //   ),
        //     // ),
        //   ],
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

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
                          builder: (BuildContext context) => Container(),
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
                      padding: EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      width: MediaQuery.of(context).size.width * 0.8,
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
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (BuildContext context) => Container(),
                  //       ),
                  //     );
                  //   },
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Colors.deepPurple,
                  //       boxShadow: <BoxShadow>[
                  //         BoxShadow(
                  //           color: Colors.blue.withOpacity(0.1),
                  //           blurRadius: 1,
                  //           offset: Offset(0, 2),
                  //         ),
                  //       ],
                  //     ),
                  //     alignment: Alignment.center,
                  //     padding: EdgeInsets.symmetric(
                  //         vertical: 14, horizontal: 16),
                  //     width: MediaQuery.of(context).size.width * 0.8,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(Icons.person_add, color: Colors.white),
                  //         SizedBox(
                  //           width: 10,
                  //         ),
                  //         Text(
                  //           'Add Student',
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                    // SizedBox(
                    //   height: 10,
                    //   width: MediaQuery.of(context).size.width * 0.8,
                    // ),
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
                      padding: EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      width: MediaQuery.of(context).size.width * 0.8,
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
                  // InkWell(
                  //   onTap: _launchURL,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Colors.black,
                  //       boxShadow: <BoxShadow>[
                  //         BoxShadow(
                  //           color: Colors.blue.withOpacity(0.1),
                  //           blurRadius: 1,
                  //           offset: Offset(0, 2),
                  //         ),
                  //       ],
                  //     ),
                  //     // alignment: Alignment.center,
                  //     // padding: EdgeInsets.symmetric(
                  //     //     vertical: 14, horizontal: 16),
                  //     // width: MediaQuery.of(context).size.width * 0.8,
                  //     // child: Row(
                  //     //   mainAxisAlignment: MainAxisAlignment.center,
                  //     //   children: [
                  //     //     Text(
                  //     //       'CONTRIBUTE',
                  //     //       style: TextStyle(color: Colors.white),
                  //     //     ),
                  //     //     SizedBox(
                  //     //       width: 10,
                  //     //     ),
                  //     //     FaIcon(
                  //     //       FontAwesomeIcons.github,
                  //     //       color: Colors.white,
                  //     //     )
                  //     //   ],
                  //     // ),
                  //   ),
                  // ),
                ],
              ),
            )
          ]),
        )

        ),
      );

  }
}
