import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instattendance/controller/attendance_controller.dart';
import 'package:instattendance/controller/practical_batch_controller.dart';
import 'package:instattendance/controller/teacher_controller.dart';
import 'package:instattendance/models/attendance.dart';
import 'package:instattendance/models/dept_class.dart';
import 'package:instattendance/models/division.dart';
import 'package:instattendance/models/practical_batch.dart';
import 'package:instattendance/models/subject.dart' as sub;
import 'package:instattendance/utils/storage_util.dart';
import 'package:instattendance/view/authentication_view/authentication.dart';
import 'package:instattendance/view/notification_view/notification_page.dart';
import 'package:instattendance/widgets/custom_button.dart';
import 'package:instattendance/widgets/student_list.dart';
import 'package:instattendance/widgets/toast.dart';

class TeacherHome extends StatefulWidget {
  const TeacherHome({Key? key}) : super(key: key);

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  final TeacherController _teacherController = Get.find();
  final AttendanceController _attendanceController = Get.find();
  final PracticalBatchController _practicalBatchController =
      Get.put(PracticalBatchController());
  final TextEditingController timeController = TextEditingController();
  var now = DateTime.now();

  String? _selectedClass;
  String? _selectedDivision;
  String? _selectedSubject;
  String? _selectedBatch;

  bool _showStudentList = false;
  bool isSwitched = false;
  int _selectedClassId = 0;
  int _selectedDivId = 0;
  @override
  initState() {
    super.initState();
    callAllMethods();
  }

  callAllMethods() async {
    await getAllClasses();
    await getAllDivisions();

    if (this.mounted) {
      setState(() {
        // Your state change code goes here
      });
    }
  }

  getAllClasses() async {
    await _teacherController.getAllClasses();
  }

  getAllDivisions() async {
    await _teacherController.getAllDivisions();
  }

  getAllSubjects() async {
    if (_selectedClass != null) {
      isSwitched
          ? await _teacherController
              .getPracticalByClass(_selectedClass.toString())
          : await _teacherController
              .getAllSubjectsByClass(_selectedClass.toString());
    } else {
      DisplayMessage.showClassNotSelected();
    }
    if (this.mounted) {
      setState(() {
        // Your state change code goes here
      });
    }
  }

  getAllPracticalBatches() async {
    if (_selectedClass != null && _selectedDivision != null) {
      await _practicalBatchController.getPracticalBatches(
          _selectedClass.toString(), _selectedDivision.toString());
    } else {
      DisplayMessage.displayInfoMotionToast(
          context, 'Required', 'Please Select Class & Div');
    }
    if (this.mounted) {
      setState(() {
        // Your state change code goes here
      });
    }
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 1));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Take Attendance'),
          backgroundColor: Colors.indigoAccent,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const NotificationPage()),
                  );
                },
                icon: const Icon(Icons.notifications_active_outlined)),
            IconButton(
                onPressed: () {
                  StorageUtil storage = StorageUtil.storageInstance;
                  storage.clearPrefs();

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => AuthenticationView()),
                      (Route<dynamic> route) => false);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Material(
            child: SingleChildScrollView(
                child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Row(
              children: [
                Flexible(
                  child: Row(
                    children: [
                      // const Text('Date: '),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          height: height * 0.07,
                          width: width * 0.33,
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5, //spread radius
                                blurRadius: 7, // blur radius
                                offset: const Offset(
                                    0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                              child: Text(
                                  "${selectedDate.toLocal()}".split(' ')[0])),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      //const Text('Time:'),
                      Container(
                          height: height * 0.07,
                          width: width * 0.33,
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
                              ),
                            ],
                          ),
                          child: Center(
                            child: TextField(
                                controller: timeController,
                                decoration: const InputDecoration(
                                    hintText: '    time: 9 to 10',
                                    hintStyle: TextStyle(fontSize: 12))),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: Row(
                    children: [
                      // const Text('Class:'),
                      Container(
                        height: height * 0.07,
                        width: width * 0.33,
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
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: DropdownButton<DeptClass>(
                            hint: _selectedClass == null
                                ? const Text(
                                    'select class',
                                    style: TextStyle(fontSize: 12),
                                  )
                                : Text(_selectedClass.toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                            items: _teacherController.deptClasses.isEmpty
                                ? null
                                : _teacherController.deptClasses
                                    .map((DeptClass value) {
                                    return DropdownMenuItem<DeptClass>(
                                      value: value,
                                      child: Text(value.className.toString()),
                                    );
                                  }).toList(),
                            onChanged: (deptClass) async {
                              setState(() {
                                _selectedClass =
                                    deptClass!.className.toString();
                                _selectedClassId = deptClass.id!;
                                _selectedSubject = null;
                              });
                              if (_selectedClass != null &&
                                  _selectedDivision != null) {
                                await getAllPracticalBatches();
                              }
                              await getAllSubjects();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      //const Text('Div:   '),
                      Container(
                          height: height * 0.07,
                          width: width * 0.33,
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
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: DropdownButton<Division>(
                              hint: _selectedDivision == null
                                  ? const Text(
                                      'select div',
                                      style: TextStyle(fontSize: 12),
                                    )
                                  : Text(_selectedDivision.toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                              items: _teacherController.divisions.isEmpty
                                  ? null
                                  : _teacherController.divisions
                                      .map((Division value) {
                                      return DropdownMenuItem<Division>(
                                        value: value,
                                        child:
                                            Text(value.divisionName.toString()),
                                      );
                                    }).toList(),
                              onChanged: (division) async {
                                setState(() {
                                  _selectedDivision =
                                      division!.divisionName.toString();
                                  _selectedDivId = division.id!;
                                });
                                if (_selectedClass != null &&
                                    _selectedDivision != null) {
                                  await getAllPracticalBatches();
                                }
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Is It Practical?'),
                Checkbox(
                  value: isSwitched,
                  onChanged: (bool? value) async {
                    setState(() {
                      isSwitched = value!;
                    });
                    await getAllSubjects();
                    isSwitched ? await getAllPracticalBatches() : null;
                    setState(() {});
                  },
                ),
              ],
            ), //Check
            const SizedBox(height: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const Text('Subject:'),
                Row(
                  children: [
                    Visibility(
                      visible: !isSwitched ? true : false,
                      child: Container(
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
                            child: DropdownButton<sub.Subject>(
                              hint: _selectedSubject == null
                                  ? const Text('select subject',
                                      style: TextStyle(fontSize: 12))
                                  : Text(_selectedSubject.toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                              items: _teacherController.subjects.isEmpty
                                  ? null
                                  : _teacherController.subjects
                                      .map((sub.Subject value) {
                                      return DropdownMenuItem<sub.Subject>(
                                        value: value,
                                        child: Text(value.name.toString()),
                                      );
                                    }).toList(),
                              onChanged: (subject) {
                                setState(() {
                                  _selectedSubject = subject!.name.toString();
                                });
                              },
                            ),
                          )),
                    ),
                    Visibility(
                      visible: isSwitched ? true : false,
                      child: Container(
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
                            child: DropdownButton<sub.Subject>(
                              hint: _selectedSubject == null
                                  ? const Text('select practical',
                                      style: TextStyle(fontSize: 12))
                                  : Text(_selectedSubject.toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                              items: _teacherController.practicalList.isEmpty
                                  ? null
                                  : _teacherController.practicalList
                                      .map((sub.Subject value) {
                                      return DropdownMenuItem<sub.Subject>(
                                        value: value,
                                        child: Text(value.name.toString()),
                                      );
                                    }).toList(),
                              onChanged: (subject) {
                                setState(() {
                                  _selectedSubject = subject!.name.toString();
                                });
                              },
                            ),
                          )),
                    ),
                    Visibility(
                      visible: isSwitched,
                      child: Container(
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
                              hint: _selectedBatch == null
                                  ? const Text('select batch',
                                      style: TextStyle(fontSize: 12))
                                  : Text(_selectedBatch.toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                              items: _practicalBatchController.batchList.isEmpty
                                  ? null
                                  : _practicalBatchController.batchList
                                      .map((PracticalBatch value) {
                                      return DropdownMenuItem<PracticalBatch>(
                                        value: value,
                                        child: Text(value.batchName.toString()),
                                      );
                                    }).toList(),
                              onChanged: (batch) {
                                setState(() {
                                  _selectedBatch = batch!.batchName.toString();
                                });
                              },
                            ),
                          )),
                    ),
                  ],
                ),
                TextButton.icon(
                    onPressed: () async {
                      isSwitched
                          ? await getStudentsByPracticalBatch()
                          : await getStudentsByClassAndDiv();

                      setState(() {});
                    },
                    icon: const Icon(Icons.done),
                    label: const Text('Submit')),
              ],
            ),
            _showStudentList
                ? StudentListView(
                    students: isSwitched
                        ? _teacherController.studentsByBatch
                        : _teacherController.studentsByClassAndDiv)
                : Container(),
            const SizedBox(
              height: 20,
            ),
            _showStudentList
                ? CustomButton(
                    msg: 'Submit Attendance',
                    icon: Icons.done,
                    onTap: () {
                      if (_teacherController.studentsByClassAndDiv.isNotEmpty ||
                          _teacherController.studentsByBatch.isNotEmpty) {
                        submitAttendance();
                        setState(() {});
                      } else {
                        DisplayMessage.displayInfoMotionToast(context, 'Info',
                            'This Class does\'nt belongs to any students yet!!');
                      }
                    })
                : Container()
          ]),
        ))));
  }

  getStudentsByClassAndDiv() async {
    if (_selectedClass != null &&
        _selectedDivision != null &&
        _selectedSubject != null &&
        timeController.text.isNotEmpty) {
      await _teacherController.getAllStudentsByClassAndDiv(
          _selectedClassId, _selectedDivId);
      setState(() {
        _showStudentList = true;
      });
    } else {
      DisplayMessage.displayInfoMotionToast(
          context, 'Info', 'All Fields Are Required!!');
    }
  }

  getStudentsByPracticalBatch() async {
    if (_selectedClass != null &&
        _selectedDivision != null &&
        _selectedSubject != null &&
        timeController.text.isNotEmpty &&
        _selectedBatch != null &&
        selectedDate != null) {
      await _teacherController.getStudentsByBatch(_selectedBatch.toString());
      setState(() {
        _showStudentList = true;
      });
    } else {
      DisplayMessage.displayInfoMotionToast(
          context, 'Info', 'All Fields Are Required!!');
    }
  }

  submitAttendance() async {
    isSwitched
        ? _teacherController.getAbsentStudentsOfPracticalBatch()
        : _teacherController.getAbsentStudents();
    String presentStud = _teacherController.presentStudents.join(',');
    String absentStud = _teacherController.absentStudents.join(',');

    print(presentStud);
    print(absentStud);

    Attendance attendance = _attendanceController.submitAttendance(
        _selectedClass,
        _selectedDivision,
        now,
        timeController.text,
        _selectedSubject,
        _teacherController.teacher.value.name,
        presentStud,
        absentStud);

    Attendance? a =
        await _attendanceController.takeAttendance(attendance, context);
    if (a != null) {
      DisplayMessage.displaySuccessMotionToast(
          context, 'Success', 'Great , Your Attendace is now Submitted!!');
      _teacherController.presentStudents.clear();
      _teacherController.absentStudents.clear();
    } else {
      DisplayMessage.displayErrorMotionToast(
          context, 'Error', 'OOPS!! Your Attendace is not submitted try again');
    }
  }
}
