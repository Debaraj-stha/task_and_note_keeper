import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void message(String msg, {isSuccess = true}) {
  Fluttertoast.showToast(
      msg: msg,
      textColor: Colors.white,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      fontSize: 16,
      gravity: ToastGravity.BOTTOM);
}
