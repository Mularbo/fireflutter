import 'dart:async';

import 'package:fireflutter/UI/auth/login_screen.dart';
import 'package:flutter/material.dart';

class Splashservices {
  void isLogin(BuildContext context) {
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
