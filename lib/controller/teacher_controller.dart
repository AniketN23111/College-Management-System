import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instattendance/models/dept_class.dart';
import 'package:instattendance/models/division.dart';
import 'package:instattendance/models/student.dart' as stud;
import 'package:instattendance/models/subject.dart' as sub;
import 'package:instattendance/models/teacher.dart';
import 'package:instattendance/service/teacher_service.dart';

class TeacherController extends GetxController {
  var deptClasses = List<DeptClass>.empty(growable: true).obs;
  var divisions = List<Division>.empty(growable: true).obs;
  var subjects = List<sub.Subject>.empty(growable: true).obs;
  var studentsByClassAndDiv = List<stud.Student>.empty(growable: true).obs;
  var presentStudents = List<String?>.empty().obs;
  var absentStudents = List<String?>.empty().obs;
  var practicalList = List<sub.Subject>.empty(growable: true).obs;
  var studentsByBatch = List<stud.Student>.empty(growable: true).obs;
  var teacher = Teacher().obs;
  var isLoading = false.obs;
  Teacher? _t1;

  final TeacherService _teacherService = TeacherService();

  Future<Teacher?> authenticateTeacher(
      String email, String password, BuildContext context) async {
    isLoading(true);
    _t1 = await _teacherService.authenticateTeacher(email, password, context);
    isLoading(false);
    return _t1;
  }

  //saving teacher to observable to access all over application
  void onSave() {
    teacher.value = _t1!;
  }

  Future getAllClasses() async {
    var classes = await _teacherService.getAllClasses();
    if (classes != null) {
      deptClasses.assignAll(classes);
    }
  }

  Future getAllDivisions() async {
    var divisionList = await _teacherService.getAllDivision();
    if (divisionList != null) {
      divisions.assignAll(divisionList);
    }
  }

  Future getAllSubjectsByClass(String className) async {
    var subjectList = await _teacherService.getSubjectsByClass(className);
    subjects.clear();

    if (subjectList != null) {
      subjects.assignAll(subjectList);
    }
  }

  Future getAllStudentsByClassAndDiv(int classId, int divId) async {
    print(classId);
    print(divId);
    var studentList =
        await _teacherService.getStudentsByClassAndDiv(classId, divId);

    if (studentList != null) {
      studentsByClassAndDiv.assignAll(studentList);
    }
  }

  Future<DeptClass?> findClassByClassName(String name) async {
    DeptClass? deptClass = await _teacherService.findClassByName(name);
    return deptClass;
  }

  getAbsentStudents() {
    for (var i = 0; i < studentsByClassAndDiv.length; i++) {
      if (!presentStudents.contains(studentsByClassAndDiv[i].rollNo)) {
        absentStudents.add(studentsByClassAndDiv[i].rollNo);
      }
    }
  }

  getAbsentStudentsOfPracticalBatch() {
    for (var i = 0; i < studentsByBatch.length; i++) {
      if (!presentStudents.contains(studentsByBatch[i].rollNo)) {
        absentStudents.add(studentsByBatch[i].rollNo);
      }
    }
  }

  Future<List<sub.Subject>?> getPracticalByClass(String className) async {
    List<sub.Subject>? praList;
    practicalList.clear();
    praList = await _teacherService.getPracicalsByClass(className);

    if (praList != null) {
      practicalList.assignAll(praList);
    }
  }

  Future<List<stud.Student>?> getStudentsByBatch(String batchName) async {
    List<stud.Student>? stList;

    stList = await _teacherService.getStudentsByBatch(batchName);

    if (stList != null) {
      studentsByBatch.assignAll(stList);
      return stList;
    }
    return null;
  }
}
