import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class DisplayMessage {
  static showSomethingWentWrong() {
    return Fluttertoast.showToast(
        msg: "Something went wrong", backgroundColor: Colors.red);
  }

  static showNotFound(String msg) {
    return Fluttertoast.showToast(msg: msg, backgroundColor: Colors.red);
  }

  static showClassNotSelected() {
    return Fluttertoast.showToast(
        msg: "Please Select Class First", backgroundColor: Colors.red);
  }

  static showSubmitted() {
    return Fluttertoast.showToast(
        msg: "Attendance Submited", backgroundColor: Colors.red);
  }

  static showMsg(String msg) {
    return Fluttertoast.showToast(msg: msg, backgroundColor: Colors.red);
  }

  static displaySuccessMotionToast(
      BuildContext context, String title, String des) {
    MotionToast.success(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(
        des,
        style: const TextStyle(fontSize: 12),
      ),
      //layoutOrientation: ORIENTATION.rtl,
      //animationType: ANIMATION.fromRight,
      position: MOTION_TOAST_POSITION.center,
      dismissable: true,
      width: 300,
    ).show(context);
  }

  static displayErrorMotionToast(
      BuildContext context, String title, String des) {
    MotionToast.error(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(des),
      animationType: ANIMATION.fromLeft,
      position: MOTION_TOAST_POSITION.top,
      width: 300,
      height: 300,
      toastDuration: Duration(seconds: 5),
    ).show(context);
  }

  static displayDeleteMotionToast(
      BuildContext context, String title, String des) {
    MotionToast.delete(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(des),
      animationType: ANIMATION.fromTop,
      position: MOTION_TOAST_POSITION.top,
    ).show(context);
  }

  static displayInfoMotionToast(
      BuildContext context, String title, String des) {
    MotionToast.info(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      position: MOTION_TOAST_POSITION.center,
      description: Text(des),
    ).show(context);
  }
}
