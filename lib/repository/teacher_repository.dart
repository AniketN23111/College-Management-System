import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instattendance/constants/api_service_constants.dart';
import 'package:instattendance/models/dept_class.dart';
import 'package:instattendance/models/division.dart';
import 'package:instattendance/models/student.dart' as stud;
import 'package:instattendance/models/student.dart';
import 'package:instattendance/models/subject.dart' as sub;
import 'package:instattendance/models/teacher.dart';

class TeacherRepository {
  Future<Teacher?> authenticateTeacher(String email, String password) async {
    var body = jsonEncode({"teacherEmail": email, "teacherPassword": password});
    var response = await http.post(
      Uri.parse("${RepositoryConstants.baseUrl}/teachers/authenticate"),
      body: body,
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == RepositoryConstants.statusSuccessful &&
        response.body.isNotEmpty) {
      return teacherFromJson(response.body);
    }
    return null;
  }

  Future<List<DeptClass>?> getAllClasses() async {
    var response = await http.get(
      Uri.parse('${RepositoryConstants.baseUrl}/classes'),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return deptClassListFromJson(response.body);
    }

    return null;
  }

  Future<List<Division>?> getAllDivisions() async {
    var response = await http.get(
      Uri.parse('${RepositoryConstants.baseUrl}/divisions'),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return divisionListFromJson(response.body);
    }

    return null;
  }

  Future<List<stud.Student>?> getStudentsByClassAndDiv(
      int classId, int divId) async {
    var body = jsonEncode({"classId": classId, "divId": divId});
    var response = await http.post(
      Uri.parse('${RepositoryConstants.baseUrl}/studentsByClassAndDiv'),
      body: body,
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return studentFromJson(response.body);
    }
    return null;
  }

  Future<List<sub.Subject>?> getAllSubjectsByClass(String className) async {
    var response = await http.get(
        Uri.parse('${RepositoryConstants.baseUrl}/subjects/class/$className'));

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return sub.subjectFromJson(response.body);
    }
    return null;
  }

  Future<DeptClass?> findClassByName(String className) async {
    var response = await http.get(
        Uri.parse('${RepositoryConstants.baseUrl}/findClassByName/$className'));
    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return deptClassFromJson(response.body);
    }
  }

  Future<Division?> findDivByName(String divName) async {
    var response = await http.get(Uri.parse(
        '${RepositoryConstants.baseUrl}/findDivisionByName/$divName'));
    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return divisionFromJson(response.body);
    }
  }

  Future<List<sub.Subject>?> getAllPracticalsByClass(String className) async {
    var response = await http.get(Uri.parse(
        '${RepositoryConstants.baseUrl}/subjects/practical/$className'));

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return sub.subjectFromJson(response.body);
    }
    return null;
  }

  Future<List<Student>?> getStudentsByBatch(String batchName) async {
    var response = await http.get(
      Uri.parse('${RepositoryConstants.baseUrl}/students/batch/$batchName'),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == RepositoryConstants.statusSuccessful &&
        response.body.isNotEmpty) {
      return studentFromJson(response.body);
    }
    RepositoryConstants.validateErrorCodes(response.statusCode);
    return null;
  }
}
