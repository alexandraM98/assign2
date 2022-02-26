import 'package:flutter/material.dart';
import 'package:world_time/pages/home.dart';
import 'package:world_time/pages/upload_image.dart';
import 'package:camera/camera.dart';
import 'dart:async';

void main() async {

  runApp(MaterialApp(
    routes: {
      '/' : (context) => Home(),
      '/home' : (context) => Home(),
      '/photos' : (context) => TakePhoto()
    },
  ));
}


