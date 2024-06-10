// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/firestore/firestore_list_screen.dart';
import 'package:firebase/ui/posts/post_screen.dart';
import 'package:firebase/ui/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => UploadImageScreen())));
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen())));
    }
  }
}
