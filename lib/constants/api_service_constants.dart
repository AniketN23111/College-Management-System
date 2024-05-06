import 'package:instattendance/widgets/toast.dart';

class RepositoryConstants {
  static const int statusSuccessful = 200;

  static const int internalServerError = 500;
  static const int badRequest = 400;
  static const int timeout = 408;
  static const String baseUrl = 'https://instattendance-backend.herokuapp.com';

  static validateErrorCodes(int statusCode) {
    if (statusCode == RepositoryConstants.timeout) {
      DisplayMessage.showMsg('Request Time Out ..check your connection');
    }
    if (statusCode == RepositoryConstants.internalServerError) {
      DisplayMessage.showMsg('Internal Server Error');
    }
  }
}
