import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instattendance/controller/teacher_controller.dart';
import 'package:instattendance/models/attendance.dart';

import 'package:instattendance/repository/attendance_repository.dart';
import 'package:instattendance/widgets/toast.dart';

class AttendanceService {
  final AttendanceRepository _attendanceRepository = AttendanceRepository();
  final TeacherController _teacherController = Get.find();
  Future<Attendance?> takeAttendance(
      Attendance attendanceDetails, BuildContext context) async {
    _teacherController.isLoading(true);
    Attendance? attendance;
    try {
      attendance =
          await _attendanceRepository.takeAttendance(attendanceDetails);

      return attendance;
    } catch (e) {
      DisplayMessage.displayErrorMotionToast(context, 'Error', e.toString());
    } finally {
      _teacherController.isLoading(false);
    }
  }

  Future<List<Attendance>?> getAttendanceByTeacher(String teacherName) async {
    List<Attendance>? allAttendanceOfTeacher =
        await _attendanceRepository.getAttendanceByTeacherName(teacherName);

    return allAttendanceOfTeacher;
  }

  Future<List<Attendance>?> getAttendanceByClassSubDiv(
      String className, String div, String subject) async {
    List<Attendance>? fetchAttendanceList = await _attendanceRepository
        .getAttendanceBySubClassDiv(className, div, subject);
    if (fetchAttendanceList == null) {
      DisplayMessage.showMsg('No Attendance record found');
    } else {
      return fetchAttendanceList;
    }
  }

  Future<List<Attendance>?> getAttendanceByClassSubDivBatch(
      String className, String div, String subject, String batchName) async {
    List<Attendance>? fetchAttendanceList = await _attendanceRepository
        .getAttendanceBySubClassDivBatch(className, div, subject, batchName);
    if (fetchAttendanceList == null ) {
      DisplayMessage.showMsg('No Attendance record found');
    } else {
      return fetchAttendanceList;
    }
  }

  Future<String> deleteAttendance(int id) async {
    return await _attendanceRepository.deleteAttendance(id);
  }
}
