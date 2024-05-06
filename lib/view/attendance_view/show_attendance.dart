import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instattendance/models/practical_batch.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:instattendance/constants/gsheets_constans.dart';
import 'package:instattendance/controller/attendance_controller.dart';
import 'package:instattendance/controller/attendance_filter_controller.dart';
import 'package:instattendance/controller/teacher_controller.dart';
import 'package:instattendance/models/attendance.dart';
import 'package:instattendance/models/subject.dart' as sub;
import 'package:instattendance/widgets/custom_button.dart';
import 'package:instattendance/widgets/toast.dart';

class ShowAttendance extends StatelessWidget {
  ShowAttendance({Key? key}) : super(key: key);
  final AttendanceController _attendanceController = Get.find();
  final TeacherController _teacherController = Get.find();
  final AttendanceFilterController _attendanceFilterController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Attendance Record'),
            backgroundColor: Colors.indigoAccent,
            actions: [
              IconButton(
                  onPressed: () {
                    _modalBottomSheetForFilters(context);
                  },
                  icon: const Icon(Icons.filter_alt))
            ]),
        body: Obx(() => Container(
              child: FutureBuilder(
                future: _attendanceFilterController
                            .selectedClassName.value.isNotEmpty &&
                        _attendanceFilterController
                            .selectedDivision.value.isNotEmpty &&
                        _attendanceFilterController
                            .selectedSub.value.isNotEmpty &&
                        _attendanceFilterController.selectedBatch.value.isEmpty
                    ? _attendanceFilterController.getAttendanceByClassSubDiv(
                        _attendanceFilterController.selectedClassName.value,
                        _attendanceFilterController.selectedDivision.value,
                        _attendanceFilterController.selectedSub.value,
                      )
                    : _attendanceFilterController.selectedClassName.value.isNotEmpty &&
                            _attendanceFilterController
                                .selectedDivision.value.isNotEmpty &&
                            _attendanceFilterController
                                .selectedSub.value.isNotEmpty &&
                            _attendanceFilterController
                                .selectedBatch.value.isNotEmpty
                        ? _attendanceFilterController
                            .getAttendanceByClassSubDivBatch(
                                _attendanceFilterController
                                    .selectedClassName.value,
                                _attendanceFilterController
                                    .selectedDivision.value,
                                _attendanceFilterController.selectedSub.value,
                                _attendanceFilterController.selectedBatch.value)
                        : _attendanceController.getAttendanceByTeacher(
                            _teacherController.teacher.value.name),
                builder: (context, AsyncSnapshot<List<Attendance>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.indigo,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return DisplayMessage.displayErrorMotionToast(context,
                        'Ooops', 'Something Goes Wrong!! Try Again.. ');
                  } else {
                    return snapshot.data == null
                        ? const Center(
                            child: Text('No Attendance records found'))
                        : Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return ExpansionTile(
                                        collapsedIconColor: Colors.indigo,
                                        backgroundColor: Colors.indigo[50],
                                        title: Row(
                                          children: [
                                            Text(DateFormat.yMEd('en_US')
                                                .format(snapshot.data![index]
                                                    .attendanceDate!)),
                                            const SizedBox(width: 7),
                                            Text(
                                                '-  ${snapshot.data![index].attendanceTime}'),
                                          ],
                                        ),
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  'Class: ${snapshot.data![index].className} , ${snapshot.data![index].divisionName}'),
                                              const SizedBox(width: 8),
                                              Text(
                                                  'Subject: ${snapshot.data![index].subject}'),
                                            ],
                                          ),
                                          snapshot.data![index].batchName ==
                                                  null
                                              ? Container()
                                              : Text(
                                                  'Batch : ${snapshot.data![index].batchName}',
                                                  textAlign: TextAlign.center,
                                                ),
                                          const SizedBox(height: 12),
                                          Column(
                                            children: [
                                              const Text('Absent Student :'),
                                              Text(
                                                  '${snapshot.data![index].absentStudents}'),
                                            ],
                                          ),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                  onPressed: () async {
                                                    String res =
                                                        await _attendanceController
                                                            .deleteattendance(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .id!);

                                                    DisplayMessage
                                                        .displayDeleteMotionToast(
                                                            context,
                                                            'Deleted',
                                                            res);
                                                  },
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.black45,
                                                      size: 18)))
                                        ],
                                      );
                                    }),
                              ),
                              _attendanceFilterController
                                          .selectedClassName.value.isNotEmpty &&
                                      _attendanceFilterController
                                          .selectedDivision.value.isNotEmpty &&
                                      _attendanceFilterController
                                          .selectedSub.value.isNotEmpty
                                  ? CustomButton(
                                      onTap: () async {
                                        _attendanceFilterController
                                            .isLoading(true);
                                        await _attendanceFilterController
                                            .fillAttendanceSheet(
                                                snapshot.data!, context);
                                        _attendanceFilterController
                                            .isLoading(false);

                                        //lauchSheet();
                                      },
                                      msg: 'Generate Report',
                                      icon: Icons.receipt_long_rounded)
                                  : Container(),
                            ],
                          );
                  }
                },
              ),
            )));
  }

  lauchSheet() async {
    if (!await launch(GsheetConstants.sheetUrl)) {
      throw DisplayMessage.showMsg('could not lauch report');
    }
  }

  void _modalBottomSheetForFilters(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (builder) {
          return Obx(() =>
              SingleChildScrollView(
                child: Container(
                    height: height * 0.66,
                    padding: const EdgeInsets.all(2.5),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                              onPressed: () {
                                _attendanceFilterController
                                    .selectedClassName('');
                                _attendanceFilterController
                                    .selectedDivision('');
                                _attendanceFilterController.selectedSub('');
                                _attendanceFilterController
                                    .divRadioButtonVal(999);
                                _attendanceFilterController
                                    .classRadioButtonVal(999);
                                _attendanceFilterController.selectedBatch('');
                                Navigator.of(context).pop();
                              },
                              child: const Text('clear filters',
                                  style: TextStyle(
                                      color: Colors.redAccent, fontSize: 12))),
                        ),
                      ),
                      const Text('Select Class'),
                      // Text(_teacherController.deptClasses.length.toString()),
                      const SizedBox(height: 12),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              _teacherController.deptClasses.length,
                                  (index) =>
                                  Row(
                                    children: [
                                      Text(_teacherController
                                          .deptClasses[index].className
                                          .toString()),
                                      Radio(
                                          activeColor: Colors.indigoAccent,
                                          value: index,
                                          groupValue:
                                          _attendanceFilterController
                                              .classRadioButtonVal.value,
                                          onChanged: (int? val) async {
                                            _attendanceFilterController
                                                .classRadioButtonVal(val);
                                            await _attendanceFilterController
                                                .getSubjectsByClass(
                                                _teacherController
                                                    .deptClasses[index]
                                                    .className
                                                    .toString());
                                            _attendanceFilterController
                                                .selectedClassName(
                                                _teacherController
                                                    .deptClasses[index]
                                                    .className
                                                    .toString());
                                          }),
                                      const SizedBox(width: 14)
                                    ],
                                  ))),
                      const SizedBox(height: 18),

                      const Text('Select Division'),
                      const SizedBox(height: 12),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              _teacherController.divisions.length,
                                  (index) =>
                                  Row(
                                    children: [
                                      Text(_teacherController
                                          .divisions[index].divisionName
                                          .toString()),
                                      Radio(
                                          activeColor: Colors.indigoAccent,
                                          value: index,
                                          groupValue:
                                          _attendanceFilterController
                                              .divRadioButtonVal.value,
                                          onChanged: (int? val) {
                                            _attendanceFilterController
                                                .divRadioButtonVal(val);
                                            _attendanceFilterController
                                                .selectedDivision(
                                                _teacherController
                                                    .divisions[index]
                                                    .divisionName
                                                    .toString());
                                          }),
                                      const SizedBox(width: 14)
                                    ],
                                  ))),
                      const SizedBox(height: 18),

                      const Text('Select Subject & Batch'),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: height * 0.067,
                              width: width * 0.34,
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: DropdownButton<sub.Subject>(
                                  hint: _attendanceFilterController
                                      .selectedSub.value.isEmpty
                                      ? const Text('select subject',
                                      style: TextStyle(fontSize: 12))
                                      : Text(
                                      _attendanceFilterController
                                          .selectedSub.value
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  items: _attendanceFilterController
                                      .subjectsByclass.isEmpty
                                      ? null
                                      : _attendanceFilterController
                                      .subjectsByclass
                                      .map((sub.Subject value) {
                                    return DropdownMenuItem<sub.Subject>(
                                      value: value,
                                      child: Text(value.name.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (subject) async {
                                    _attendanceFilterController
                                        .selectedSub(subject!.name.toString());
                                    await _attendanceFilterController
                                        .getAllPracticalBatches();
                                  },
                                ),
                              )),
                          Container(
                              height: height * 0.07,
                              width: width * 0.34,
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5), //color of shadow
                                    spreadRadius: 5, //spread radius
                                    blurRadius: 7, // blur radius
                                    offset: const Offset(
                                        0, 2), // changes position of shadow
                                    //first paramerter of offset is left-right
                                    //second parameter is top to down
                                  ),
                                  //you can set more BoxShadow() here
                                ],
                              ),
                              child: Center(
                                child: DropdownButton<PracticalBatch>(
                                  hint: _attendanceFilterController
                                      .selectedBatch.value.isEmpty
                                      ? const Text('select batch',
                                      style: TextStyle(fontSize: 12))
                                      : Text(
                                      _attendanceFilterController
                                          .selectedBatch.value
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  items: _attendanceFilterController
                                      .practicalBatch.isEmpty
                                      ? null
                                      : _attendanceFilterController
                                      .practicalBatch
                                      .map((PracticalBatch value) {
                                    return DropdownMenuItem<
                                        PracticalBatch>(
                                      value: value,
                                      child: Text(
                                          value.batchName.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (batch) {
                                    _attendanceFilterController.selectedBatch(
                                        batch!.batchName.toString());
                                  },
                                ),
                              )),
                        ],
                      ),
                    ])),
              ));
        });
  }
}



/*  */