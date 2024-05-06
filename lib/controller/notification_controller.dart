import 'package:get/get.dart';
import 'package:instattendance/models/notification.dart';
import 'package:instattendance/service/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService = NotificationService();
  var notificationsList = List<Notification>.empty(growable: true).obs;
  var isLoading = false.obs;
  Future<Notification?> createNotification(Notification notification) async {
    return await _notificationService.createNotification(notification);
  }

  Future<List<Notification>?> getAllNotification(String email) async {
    var list;

    list = await _notificationService.getAllNotification(email);
    if (list != null) {
      notificationsList.assignAll(list);
    }
  }

  Future deleteNotification(int id) async {
    return _notificationService.deleteNotification(id);
  }
}
