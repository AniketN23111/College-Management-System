import 'package:flutter/cupertino.dart';
import 'package:instattendance/models/dept_class.dart';
import 'package:instattendance/models/division.dart';
import 'package:instattendance/models/student.dart' as stud;
import 'package:instattendance/models/subject.dart' as sub;
import 'package:instattendance/models/teacher.dart';
import 'package:instattendance/repository/teacher_repository.dart';
import 'package:instattendance/utils/storage_util.dart';
import 'package:instattendance/widgets/toast.dart';

class TeacherService {
  final TeacherRepository _teacherRepository = TeacherRepository();

  Future<Teacher?> authenticateTeacher(
      String email, String password, BuildContext context) async {
    try {
      Teacher? teacher =
          await _teacherRepository.authenticateTeacher(email, password);
      if (teacher != null) {
        final StorageUtil storage = StorageUtil.storageInstance;
        if (storage.getPrefs('email')!.isEmpty &&
            storage.getPrefs('password')!.isEmpty) {
          storage.addStringtoSF('email', teacher.email!);
          storage.addStringtoSF('password', teacher.password!);
        }
        return teacher;
      } else {
        DisplayMessage.displayInfoMotionToast(
            context, 'Credentials', 'Invalid email & password');
      }
    } catch (e) {
      DisplayMessage.displayErrorMotionToast(context, 'Error', e.toString());
    }
  }

  Future<List<DeptClass>?> getAllClasses() async {
    List<DeptClass>? classes = await _teacherRepository.getAllClasses();

    if (classes == null) {
      DisplayMessage.showSomethingWentWrong();
    } else if (classes.isEmpty) {
      DisplayMessage.showNotFound('class not Found');
    } else {
      return classes;
    }
  }

  Future<List<Division>?> getAllDivision() async {
    List<Division>? divisions = await _teacherRepository.getAllDivisions();

    if (divisions == null) {
      DisplayMessage.showSomethingWentWrong();
    } else if (divisions.isEmpty) {
      DisplayMessage.showNotFound('Divisions Not Found');
    }

    return divisions;
  }

  Future<List<stud.Student>?> getStudentsByClassAndDiv(
      int className, int divName) async {
    List<stud.Student>? students =
        await _teacherRepository.getStudentsByClassAndDiv(className, divName);

    if (students == null) {
      return DisplayMessage.showSomethingWentWrong();
    }

    return students;
  }

  Future<List<sub.Subject>?> getSubjectsByClass(String className) async {
    List<sub.Subject>? subjects =
        await _teacherRepository.getAllSubjectsByClass(className);

    if (subjects == null) {
      DisplayMessage.showSomethingWentWrong();
    } else if (subjects.isEmpty) {
      DisplayMessage.showNotFound('Subject Not Found');
    }

    return subjects;
  }

  Future<DeptClass?> findClassByName(String name) async {
    DeptClass? deptClass = await _teacherRepository.findClassByName(name);
    if (deptClass != null) {
      return deptClass;
    }
  }

  Future<Division?> findDivisionByName(String name) async {
    Division? division = await _teacherRepository.findDivByName(name);
    if (division != null) {
      return division;
    }
  }

  Future<List<sub.Subject>?> getPracicalsByClass(String className) async {
    if (className != null) {
      try {
        return await _teacherRepository.getAllPracticalsByClass(className);
      } catch (e) {
        DisplayMessage.showMsg(e.toString());
      }
    }
    return null;
  }

  Future<List<stud.Student>?> getStudentsByBatch(String batchName) async {
  
    try {
      return await _teacherRepository.getStudentsByBatch(batchName);
    } catch (e) {
      DisplayMessage.showMsg(e.toString());
    }
  }
}
