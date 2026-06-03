import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:outlive/features/contacts/screens/contacts_screen.dart';
import 'package:outlive/features/home/screens/home_screen.dart';
import 'package:outlive/features/legacy/screens/legacy_screen.dart';
import 'package:outlive/features/profile/screens/profile_screen.dart';

class BottomNavController extends GetxController {
  // Track active tab index (0: Home, 1: Legacy, 2: Contacts, 3: Profile)
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }


  final List<Widget> tab = [
    HomeScreen(),
    LegacyScreen(),
    ContactsScreen(),
    ProfileScreen()
  ];

  void onFabPressed() {
    // Handle center '+' button action
    Get.toNamed('/create-content');
  }
}