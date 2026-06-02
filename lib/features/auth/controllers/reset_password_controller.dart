import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController(text: 'password123');
  final reTypePasswordController = TextEditingController(text: 'password123');

  // Individual observable visibility states for both input fields
  var obscurePassword = true.obs;
  var obscureReTypePassword = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleReTypePasswordVisibility() {
    obscureReTypePassword.value = !obscureReTypePassword.value;
  }

  void handlePasswordConfirm() {
    String password = passwordController.text;
    String confirmPassword = reTypePasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    // Implement password submission/API update flow here
  }

  @override
  void onClose() {
    passwordController.dispose();
    reTypePasswordController.dispose();
    super.onClose();
  }
}