import 'package:get/get.dart';

class ArchiveController extends GetxController{
  final status = "In Collection".obs;

  updateStatus(newStatus){
    status(newStatus);
  }
}