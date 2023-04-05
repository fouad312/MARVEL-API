import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_apk/constant.dart';


class Toast {
  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 15,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        backgroundColor: secondColor);
  }
}
