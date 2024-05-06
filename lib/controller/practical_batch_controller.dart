import 'package:get/get.dart';
import 'package:instattendance/models/practical_batch.dart';
import 'package:instattendance/service/practical_batch_service.dart';

class PracticalBatchController extends GetxController {
  final PracticalBatchService _practicalBatchService = PracticalBatchService();
  var batchList = List<PracticalBatch>.empty(growable: true).obs;
  var isLoading = false.obs;
  Future<List<PracticalBatch>?> getPracticalBatches(
      String className, String divName) async {
    List<PracticalBatch>? btList;

    btList = await _practicalBatchService.getBatches(className, divName);
    if (btList != null) {
      batchList.assignAll(btList);
      return btList;
    }
  }
}
