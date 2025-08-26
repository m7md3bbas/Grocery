import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groceryapp/core/styles/app_color_styles.dart';

abstract class ShowToast {
  static showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
