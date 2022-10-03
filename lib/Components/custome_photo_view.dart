import 'dart:io';

import 'package:flutter/material.dart';

class CustomePhotoView extends StatelessWidget {
  final String ImageUrl;

  const CustomePhotoView({Key? key, required this.ImageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "PreviewImage",
          style: TextStyle(
            color: Colors.purple,
          ),
        ),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child:const Icon(
            Icons.arrow_back_ios,
            color: Colors.deepPurple,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              ImageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
