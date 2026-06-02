import 'package:get/get.dart';

class BottomNavController extends GetxController {
  // Track active tab index (0: Home, 1: Legacy, 2: Contacts, 3: Profile)
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void onFabPressed() {
    // Handle center '+' button action
    Get.toNamed('/create-content');
  }
}