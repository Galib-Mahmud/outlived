import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Text Editing Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Reactive variables
  var selectedTab = 0.obs; // 0 for Login, 1 for Sign Up
  var obscurePassword = true.obs;
  var hasError = true.obs; // Toggle this based on backend validation results

  void changeTab(int index) {
    selectedTab.value = index;
    // You can handle clear or redirect actions here if necessary
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}