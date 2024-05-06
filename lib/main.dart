import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instattendance/constants/api_service_constants.dart';
import 'package:instattendance/controller/attendance_controller.dart';
import 'package:instattendance/controller/attendance_filter_controller.dart';
import 'package:instattendance/controller/teacher_controller.dart';
import 'package:instattendance/utils/storage_util.dart';
import 'package:instattendance/view/authentication_view/authentication.dart';
import 'package:instattendance/view/splash_view/splash_screen.dart';

void main()  {
 
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final TeacherController _teacherController = Get.put(TeacherController());
  final AttendanceController _attendanceController =
      Get.put(AttendanceController());
  final AttendanceFilterController _attendanceFilterController =
      Get.put(AttendanceFilterController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: GoogleFonts.titilliumWeb().fontFamily,
            //primarySwatch: Colors.indigo,
            primaryColor: Colors.indigoAccent),
        home: showScreen());
    // home: const TeacherHome());
  }

  showScreen() {
    StorageUtil storage = StorageUtil.storageInstance;
    String? email = storage.getPrefs('email');
    String? password = storage.getPrefs('password');

    if (email!.isEmpty && password!.isEmpty) {
      return AuthenticationView();
    } else {
      return AppSplashScreen();
    }
  }
}
