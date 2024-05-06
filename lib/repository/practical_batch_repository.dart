import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:instattendance/constants/api_service_constants.dart';
import 'package:instattendance/models/practical_batch.dart';

class PracticalBatchRepository {
  
  Future<List<PracticalBatch>?> getBatchesByClassAndDiv(
      String className, String division) async {
    var body = jsonEncode({"className": className, "divName": division});
    var response = await http.post(
      Uri.parse('${RepositoryConstants.baseUrl}/batch/classDiv'),
      body: body,
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return practicalBatchListFromJson(response.body);
    }
    RepositoryConstants.validateErrorCodes(response.statusCode);
    return null;
  }

  
}
