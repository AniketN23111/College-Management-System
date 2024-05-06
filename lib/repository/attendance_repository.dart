import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:instattendance/constants/api_service_constants.dart';
import 'package:instattendance/models/attendance.dart';

class AttendanceRepository {
  Future<Attendance?> takeAttendance(Attendance attendanceDeatils) async {
    var body = jsonEncode({
      "attendanceDate": attendanceDeatils.attendanceDate!.toIso8601String(),
      "attendanceTime": attendanceDeatils.attendanceTime,
      "className": attendanceDeatils.className,
      "divisionName": attendanceDeatils.divisionName,
      "faculty": attendanceDeatils.faculty,
      "subject": attendanceDeatils.subject,
      "batchName": attendanceDeatils.batchName == null
          ? null
          : attendanceDeatils.batchName,
      "presentStudents": attendanceDeatils.presentStudents,
      "absentStudents": attendanceDeatils.absentStudents
    });

    var response = await http.post(
      Uri.parse('${RepositoryConstants.baseUrl}/attendance'),
      body: body,
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return attendanceFromJson(response.body);
    }

    return null;
  }

  Future<List<Attendance>?> getAttendanceByTeacherName(
      String teacherName) async {
    var response = await http.get(
        Uri.parse('${RepositoryConstants.baseUrl}/attendance/$teacherName'));

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return attendanceListFromJson(response.body);
    }
    return null;
  }

  Future<String> deleteAttendance(int id) async {
    var response = await http
        .delete(Uri.parse('${RepositoryConstants.baseUrl}/attendance/$id'));

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return response.body;
    }
    return "Error";
  }

  Future<List<Attendance>?> getAttendanceBySubClassDiv(
      String className, String div, String subject) async {
    var body = {
      "className": className,
      "divisionName": div,
      "subjectName": subject
    };

    var response = await http.post(
      Uri.parse('${RepositoryConstants.baseUrl}/getAttendanceByClassSubDiv'),
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return attendanceListFromJson(response.body);
    }
    return null;
  }

  Future<List<Attendance>?> getAttendanceBySubClassDivBatch(
      String className, String div, String subject, String batchName) async {
    var body = {
      "className": className,
      "divisionName": div,
      "subjectName": subject,
      "batchName": batchName == null ? null : batchName
    };

    var response = await http.post(
      Uri.parse(
          '${RepositoryConstants.baseUrl}/getAttendanceByClassSubDivBatch'),
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return attendanceListFromJson(response.body);
    }
    return null;
  }
}
