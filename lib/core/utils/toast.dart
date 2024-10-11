import 'package:adoptme/shared/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


void showToast({required String message}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: AppColor.primary,
    textColor: Colors.white,
    fontSize: 16.0,
    webBgColor: "linear-gradient(to right, #4285F4, #4285F4)",
    webPosition: "center",
    webShowClose: true,
  );
}
