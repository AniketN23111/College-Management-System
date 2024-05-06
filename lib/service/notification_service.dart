import 'package:instattendance/models/notification.dart';
import 'package:instattendance/repository/notification_repository.dart';
import 'package:instattendance/widgets/toast.dart';

class NotificationService {
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  Future<Notification?> createNotification(Notification notification) async {
    Notification? note;
    try {
      note = await _notificationRepository.createNotification(notification);
      if (note != null) {
        return note;
      } else {
        DisplayMessage.showMsg('Unable to create notification');
      }
    } catch (e) {
      DisplayMessage.showMsg(e.toString());
    }
  }

  Future<List<Notification>?> getAllNotification(String email) async {
    try {
      List<Notification>? notificationList;

      notificationList =
          await _notificationRepository.getAllNotifications(email);
      if (notificationList != null) {
        return notificationList;
      }
    } catch (e) {
      DisplayMessage.showMsg(e.toString());
    }
  }

  Future deleteNotification(int id) async {
    try {
      return await _notificationRepository.deleteNotification(id);
    } catch (e) {
      DisplayMessage.showMsg(e.toString());
    }
  }
}
