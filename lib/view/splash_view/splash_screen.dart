import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instattendance/controller/teacher_controller.dart';
import 'package:instattendance/helper/bottom_navigation/bottom_navigation.dart';
import 'package:instattendance/models/teacher.dart';
import 'package:instattendance/utils/storage_util.dart';
import 'package:instattendance/view/authentication_view/authentication.dart';
import 'package:instattendance/widgets/custom_heading_text.dart';
import 'package:instattendance/widgets/toast.dart';

class AppSplashScreen extends StatelessWidget {
  AppSplashScreen({Key? key}) : super(key: key);
  final TeacherController _teacherController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Material(
      child: Container(
          // decoration: BoxDecoration(),
          height: MediaQuery.of(context).size.height,
          child: Obx(() => Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    const HeadingText(
                        headingText: "Instattendance",
                        color: Colors.indigoAccent),
                    const Text(
                      'Automated way to take and manage attendance..',
                      style: TextStyle(fontSize: 14),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    _teacherController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.indigo)
                        : IconButton(
                            onPressed: () {
                              getTeacherBySharedPrefValues(context);
                            },
                            icon: const Center(
                              child: Icon(Icons.keyboard_arrow_right,
                                  size: 60, color: Colors.indigo),
                            ))
                  ])))),
    ));
  }

  getTeacherBySharedPrefValues(BuildContext context) async {
    final StorageUtil storage = StorageUtil.storageInstance;
    String? teacherEmail = storage.getPrefs('email');
    String? teacherPass = storage.getPrefs('password');
    Teacher? _teacher = await _teacherController.authenticateTeacher(
        teacherEmail!, teacherPass!, context);
    if (_teacher != null) {
      _teacherController.onSave();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BottomNavigation()),
          (Route<dynamic> route) => false);
    } else {
      DisplayMessage.showMsg('Teacher Not Found');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AuthenticationView()),
          (Route<dynamic> route) => false);
    }
  }
}
