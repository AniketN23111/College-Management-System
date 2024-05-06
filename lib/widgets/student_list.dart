import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instattendance/controller/teacher_controller.dart';
import 'package:instattendance/models/student.dart';

class StudentListView extends StatelessWidget {
  StudentListView({Key? key, required this.students}) : super(key: key);
  final List<Student> students;
  //static final columns = ["Sr.no", "Roll.no", "Student"];
  final TeacherController _teacherController = Get.find();

  /*List<DataColumn> getColumns(List<String> columns) =>
      columns.map((String column) => DataColumn(label: Text(column))).toList();*/

  List<DataRow> getRows(List<Student> students) => students.map(
        (Student student) {
          return DataRow(
              selected:
                  _teacherController.presentStudents.contains(student.rollNo),
              onSelectChanged: (isSelected) {
                if (isSelected!) {
                  _teacherController.presentStudents.add(student.rollNo);
                } else {
                  _teacherController.presentStudents.remove(student.rollNo);
                }
              },
              cells: [
                DataCell(Text('${students.indexOf(student) + 1}')),
                DataCell(Text('${student.rollNo}')),
                DataCell(Text('${student.name}'))
              ]);
        },
      ).toList();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() => DataTable(
          columnSpacing: 2,
          horizontalMargin: 25,
          columns: const [
            DataColumn(label: SizedBox(width: 50, child: Text('Sr.No'))),
            DataColumn(label: SizedBox(width: 90, child: Text('Roll.No'))),
            DataColumn(label: SizedBox(width: 190, child: Text('Student')))
          ],
          rows: getRows(students))),
    );
  }
}
