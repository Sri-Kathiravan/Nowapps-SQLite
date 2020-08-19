import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UiScreenUtils {

  //This class contains some of the commonly used UI Widgets

  static void showToast(String str) {
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 15);
  }

}