import 'package:http/http.dart' as http;
import 'package:instattendance/constants/api_service_constants.dart';
import 'dart:convert';

import 'package:instattendance/models/notification.dart';

class NotificationRepository {
  Future<Notification?> createNotification(Notification notification) async {
    var body = jsonEncode({
      "teacher": notification.teacher,
      "teacherEmail": notification.teacherEmail,
      "message": notification.message,
      "date": notification.date!.toIso8601String()
    });

    var response = await http.post(
      Uri.parse('${RepositoryConstants.baseUrl}/notification'),
      body: body,
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == RepositoryConstants.statusSuccessful &&
        response.body.isNotEmpty) {
      return notificationFromJson(response.body);
    }
    return null;
  }

  Future<List<Notification>?> getAllNotifications(String email) async {
    var response = await http.get(
      Uri.parse('${RepositoryConstants.baseUrl}/notification/$email'),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == RepositoryConstants.statusSuccessful &&
        response.body.isNotEmpty) {
      return notificationListFromJson(response.body);
    }
    RepositoryConstants.validateErrorCodes(response.statusCode);

    return null;
  }

  Future deleteNotification(int id) async {
    var response = await http.delete(
      Uri.parse('${RepositoryConstants.baseUrl}/notification/$id'),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    return response.body;
  }
}
