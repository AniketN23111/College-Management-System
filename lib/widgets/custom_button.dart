import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instattendance/controller/attendance_filter_controller.dart';
import 'package:instattendance/controller/teacher_controller.dart';

class CustomButton extends StatelessWidget {
  CustomButton({Key? key, this.onTap, required this.msg, required this.icon})
      : super(key: key);
  final Function()? onTap;
  final String msg;
  final IconData icon;
  final TeacherController _teacherController = Get.find();
  final AttendanceFilterController _attendanceFilterController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.indigoAccent),
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Obx(() => Container(
                alignment: Alignment.center,
                child: _teacherController.isLoading.value ||
                        _attendanceFilterController.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            msg,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            icon,
                            color: Colors.white,
                          )
                        ],
                      ),
              )),
        ),
      ),
    );
  }
}
