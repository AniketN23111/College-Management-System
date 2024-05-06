import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';
import 'package:instattendance/controller/teacher_controller.dart';

class AttendanceSheet {
  /*static final TeacherController _teacherController = Get.find();
  static const _spreadsheetIdBE =
      '1rAxIE-wvA5BakT2-8XvedjF3LpOv5FOQTRXN7nBb0oU';
  static const _spreadsheetIdTE =
      '1FKSRm_LCQ-GZKmjXGWFtpJUctmW83JaZCNk-Tx2rOvs';
  static const _spreadsheetIdSE =
      '1PjpDYB5ulsmnxhvGhvBJao4SHcayQ7aEPXpi12cEYBo';
  static const _credentials = r'''{ 
  "type": "service_account",
  "project_id": "instattendance",
  "private_key_id": "adbe3c3f26cb90d413daded543eb43e642ba92ff",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDLraCcYTe1mVmY\n0h8+O96w8HZTbZHwQyphDDY932+6z/GwG40Sgh5uagkXDPVTx/Fb8TEJ+WT63Cr9\n21HxXyTIIdIf4FEdzsP6LEJPw+0+WWq9JkwBMCnopeVJYpVZY4zdQeXV2yJF5/wY\nT4R8UiHvMhuNJfMrkSaUevDcy06R2gJwcsJEa8EI/MNxP7R6pxro8xiWuizMMSns\nfkQ3LjmrevJRlGKA10daCqWxz6xaWu93ml4TgVxAJflBVsQ+XSe4EtQN+bby8Vw+\ncgw7Ie8v5UlJ7RggMOOLNxXpSN5mH4VOHPmQ/Bho1UY5ocL1+UViotuHLZNImDPR\nAIw/gjdbAgMBAAECggEAFzvzOmOMq1aW9eviTIMf4CdOGC5Dm5jN2Mw/08cNQ848\nz84Uxau6NPY7mzmLMsd4LPjSk0Sz1DoRXWwLaPFljL7u7Vv1ZOUVThCGb/r1sUsZ\n9gHMYcZQwY1LHpf0WYIVq5e81CxvOHJCO7O2dUgZPuQEaJGPr8SbFg0ANO+sQs7b\nontbvYM/FB1dW5vmLh4e7ATOUlXKypCuKGBNWWSJepT8bBkZaZG6l8NUOAFH0z9h\n4EM3wWNetNug1QpTug51RIU1MSR3HmN32WOKR+gwZ0Dciu09XxcYVWu261PE0DjM\nITnhbL7kYlVG8GopFmxUF+H2WgTptNAxIbIYBaDRYQKBgQDqvq8BKPtumJPW4AYx\nMctAxoepDOgATRoApjmW5PtGfW8wGlZ1f995O0FoDk5R7Q+rYbPmjPyww0MkwVlg\nI1b8iq8rFiS1a6hlLbnq+bQW8aub+F2haLEjXEo2EBa1thfULJ2XdE+i7s410dm+\ne9JdeayT0R7eysudlSG0WG6TfwKBgQDeHtQdZXAqMPoQSJYubhrSzTuNbXbGcLn+\n6gCLBSgH5ItzSHK+wMH4QaXnGG1/hzVy8SeHHpYy8eq3cGdhfW6QbzAZnYLQZRcq\n8r5OEHIUh5lKS5wODyUYYBixlba+H75maXnQSMSG95LeWlIIkPpNz0cnYvDayMts\nqrUCGXQaJQKBgEvg1zDIzn0xVJhgUaAVOF33zmIWieePBJixImxkF9TxNr+Vw9y3\nOMU3Ii1AcpCI0EfVjRE5AXUhqNJ4rSsmQTfgnD6RKcx6wDP0U+RgUpYYCCCiZ6GE\n9b04V8Sh7rVN5uXuhgIu1o8UIhPDgV7RJ26Ppfkh35ikdKy7R+nDq/qBAoGAc/dU\ndySGswBvDiFXh1Yk2vobpXMJGAGymcxCDFLc24IO7FlezwiEPMDJhSXTxUkqNqCB\nKqJleKOlD7C3yMZb+zyRuE3sBjFBL0Mc6FTduqow9gETsKNnkppZSh4IEqswFPfs\niTn0oSKQo1Y0jhRjGkylsYKOjStYSZu2dSok26ECgYEArGBy1MM75uJGu6EV4PjC\n4f/a20PcAe4WJPOzO1wyUg0bjhUtNHY1X3mK/hl4UgTn9hT708z9PfUz58i16xh3\nn245S7uoJjBKdt8Wy5Q7qcDXtccjnzrIICoqmbBNG5GHLi1NPWRIqUbKW1FQM2Cf\nVOXHGbhcWONY0hTksdjnt20=\n-----END PRIVATE KEY-----\n",
  "client_email": "instattendance@instattendance.iam.gserviceaccount.com",
  "client_id": "108129639399067800881",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/instattendance%40instattendance.iam.gserviceaccount.com"
}''';*/


  //to access spreadsheet
  static final _gsheets = GSheets(_credentials);

  static Worksheet? _attendanceSheet;
  static Future init(
      String className, String div, String sub, String batch, int colNo) async {
    var spreadsheet;
    if (className == 'BE') {
      spreadsheet = await _gsheets.spreadsheet(_spreadsheetIdBE);
    } else if (className == 'TE') {
      spreadsheet = await _gsheets.spreadsheet(_spreadsheetIdTE);
    } else if (className == 'SE') {
      spreadsheet = await _gsheets.spreadsheet(_spreadsheetIdSE);
    }

    _attendanceSheet =
        await _getWorkSheet(spreadsheet, title: '$className-$div-$sub');

    if (_attendanceSheet != null) {
      await _attendanceSheet!.clear();
    }

    await _attendanceSheet!.values.insertValue(
        'Dr.D.Y.Patil Institute of Technology Pimpri,Pune',
        column: 5,
        row: 1);

    await _attendanceSheet!.values
        .insertValue('Department of Computer Engineering', column: 5, row: 2);

    await _attendanceSheet!.values
        .insertValue('$className computer $div division', column: 5, row: 3);

    await _attendanceSheet!.values.insertValue(
        'Subject : $sub  Batch : ${batch == null ? '' : batch}',
        column: 1,
        row: 4);
    await _attendanceSheet!.values.insertValue(
        'Faculty :${_teacherController.teacher.value.name} ',
        column: 1,
        row: 5);

    await _attendanceSheet!.values
        .insertValue('Total presenti', column: colNo, row: 8);
    await _attendanceSheet!.values
        .insertValue('Avg presenti', column: colNo + 1, row: 8);

    final firstRow = ['SrNo', 'RollNo', 'Student Name'];
    await _attendanceSheet!.values.insertRow(8, firstRow);
  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insertDatesInColumn(
    int column,
    String date,
  ) async {
    if (_attendanceSheet == null) return;

    await _attendanceSheet!.values.insertValue(date, column: column, row: 8);
  }

  static Future insertTitleInColumn(int column, String data) async {
    if (_attendanceSheet == null) return;

    await _attendanceSheet!.values.insertValue(data, column: column, row: 8);
  }

  static Future insertRows(List row, int rowNo) async {
    if (_attendanceSheet == null) return;
    await _attendanceSheet!.values.insertRow(rowNo, row);
  }

  static Future insertpresenti(String value, int colNo, int rowNo) async {
    if (_attendanceSheet == null) return;
    try {
      await _attendanceSheet!.values
          .insertValue(value, column: colNo, row: rowNo);
    } catch (e) {}
  }

  static Future insertTotalAvgpresenti(int value, int colNo, int rowNo) async {
    if (_attendanceSheet == null) return;
    try {
      await _attendanceSheet!.values
          .insertValue(value, column: colNo, row: rowNo);
    } catch (e) {}
  }

  static Future<String> getCellValue(int colNo, int rowNo) async {
    if (_attendanceSheet == null) return '';
    String res =
        await _attendanceSheet!.values.value(column: colNo, row: rowNo);
    return res;
  }
}
