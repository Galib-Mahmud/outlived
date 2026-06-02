import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController(text: 'Rhebhek@gmail.com');
  var isLoading = false.obs;

  void sendOtp() {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your email address',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    // Add your actual password reset/OTP request logic here
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}