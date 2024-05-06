import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instattendance/controller/teacher_controller.dart';
import 'package:instattendance/models/attendance.dart';
import 'package:instattendance/service/attendance_service.dart';

class AttendanceController extends GetxController {
  final AttendanceService _attendanceService = AttendanceService();
  var attendance = Attendance().obs;
  Attendance? _attendance;
  var attendanceByTeacher = List<Attendance>.empty(growable: true).obs;
  var loading = false.obs;
  //final TeacherController _teacherController = Get.find();

  /*@override
  void onInit() async {
    await getAttendanceByTeacher(_teacherController.teacher.value.name);
    super.onInit();
  }*/

  Future<Attendance?> takeAttendance(Attendance attendanceDetails,BuildContext context) async {
    _attendance = await _attendanceService.takeAttendance(attendanceDetails,context);

    return _attendance;
  }

  //saving _attendance to observable to access all over application
  void onSave() {
    attendance.value = _attendance!;
  }

  Future<List<Attendance>?> getAttendanceByTeacher(String? teacherName) async {
    var attendanceList =
        await _attendanceService.getAttendanceByTeacher(teacherName!);

    if (attendanceList != null) {
      attendanceByTeacher.assignAll(attendanceList);
      return attendanceList;
    }
  }

  Attendance submitAttendance(
      String? className,
      String? divName,
      DateTime? date,
      String? time,
      String? subject,
      String? facultyName,
      String? present,
      String? absent) {
    Attendance attendance = Attendance();
    attendance.className = className;
    attendance.divisionName = divName;
    attendance.attendanceDate = date;
    attendance.attendanceTime = time;
    attendance.faculty = facultyName;
    attendance.absentStudents = absent;
    attendance.presentStudents = present;
    attendance.subject = subject;

    return attendance;
  }

  Future<String> deleteattendance(int id) async {
    
    return await _attendanceService.deleteAttendance(id);
    
  }
}
