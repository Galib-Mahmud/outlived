import 'package:get/get.dart';

class StatusController extends GetxController {
  void navigateToHome() {
    // Routes back to home or the main dashboard view
    Get.offAllNamed('/home');
  }
}