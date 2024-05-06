import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:instattendance/controller/notification_controller.dart';
import 'package:instattendance/controller/teacher_controller.dart';
import 'package:instattendance/models/notification.dart' as notification;
import 'package:instattendance/widgets/custom_button.dart';
import 'package:instattendance/widgets/toast.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController _notificationController =
      Get.put(NotificationController());

  final TeacherController _teacherController = Get.find();

  final TextEditingController messageController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  getNotifications() async {
    await _notificationController
        .getAllNotification(_teacherController.teacher.value.email.toString());
  }

  DateTime? formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return dt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Notification Page'),
          backgroundColor: Theme.of(context).primaryColor),
      body: RefreshIndicator(
        onRefresh: () async {
          await _notificationController.getAllNotification(
              _teacherController.teacher.value.email.toString());
        },
        child: ListView(children: [
          Column(children: [
            const SizedBox(
              height: 35,
            ),
            const Text('Notification View'),
            const Divider(
              color: Colors.grey,
              thickness: 1.3,
            ),
            const SizedBox(
              height: 25,
            ),
            Obx(
              () => _notificationController.notificationsList.isEmpty
                  ? const Center(
                      child: Text('No Notifications At Moment'),
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          _notificationController.notificationsList.length,
                      itemBuilder: (context, index) {
                        return ExpansionTile(
                          childrenPadding: const EdgeInsets.all(12),
                          title: Text(DateFormat('yyyy-MM-dd – kk:mm aa')
                              .format(_notificationController
                                  .notificationsList[index].date!)),
                          children: [
                            Text(
                                "send by :  ${_notificationController.notificationsList[index].teacher}"),
                            Text(
                                "sender email: ${_notificationController.notificationsList[index].teacherEmail}"),
                            Text(
                              "      message :\n ${_notificationController.notificationsList[index].message}",
                              textAlign: TextAlign.center,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                  onPressed: () async {
                                    var deleted = await _notificationController
                                        .deleteNotification(
                                            _notificationController
                                                .notificationsList[index].id!);
                                    DisplayMessage.showMsg(deleted.toString());

                                    _notificationController.notificationsList
                                        .remove(_notificationController
                                            .notificationsList[index]);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                    size: 15,
                                  )),
                            )
                          ],
                        );
                      }),
            )
          ])
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          _showAlertDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Enter Your Message',
                  enabledBorder: InputBorder.none),
              controller: messageController,
            ),
            Obx(() => _notificationController.isLoading.value
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : CustomButton(
                    msg: 'Send Notification',
                    icon: Icons.send,
                    onTap: () async {
                      Navigator.of(context).pop();
                      _notificationController.isLoading(true);
                      if (messageController.text.isNotEmpty) {
                        await createNotification();
                      } else {
                        DisplayMessage.displayErrorMotionToast(
                            context, 'Error', 'Please Enter Your Message');
                      }
                      _notificationController.isLoading(false);
                    },
                  ))
          ],
        );
      },
    );
  }

  createNotification() async {
    DateTime? date = formatTimeOfDay(TimeOfDay.now());
    notification.Notification notifi = notification.Notification(
        date: date,
        teacher: _teacherController.teacher.value.name.toString(),
        teacherEmail: _teacherController.teacher.value.email.toString(),
        message: messageController.text);
    notification.Notification? noti =
        await _notificationController.createNotification(notifi);
    if (noti != null) {
      DisplayMessage.displaySuccessMotionToast(
          context, "Success", 'Your Notifiaction was sent to admin');

      _notificationController.notificationsList.add(noti);
    }
  }
}
