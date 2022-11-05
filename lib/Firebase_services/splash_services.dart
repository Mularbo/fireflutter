import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/UI/auth/login_screen.dart';
import 'package:fireflutter/UI/fireStore/firestore_list_screen.dart';
import 'package:fireflutter/UI/posts/post_screen.dart';
import 'package:fireflutter/UI/posts/upload_image.dart';
import 'package:flutter/material.dart';

class Splashservices {
  void isLogin(BuildContext context) {
    final _auth = FirebaseAuth.instance;

    final user = _auth.currentUser;
    if (user != null) {
      Timer(
        const Duration(seconds: 3),
        (() => Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => UploadImageScreen()),
              ),
            )),
      );
    } else {
      Timer(
        const Duration(seconds: 3),
        (() => Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => LoginScreen()),
              ),
            )),
      );
    }
  }
}
