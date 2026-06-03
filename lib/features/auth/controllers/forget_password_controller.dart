import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outlive/features/auth/screens/otp_screen.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  var isLoading = false.obs;

  void sendOtp() {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your email address',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    // Add your actual password reset/OTP request logic here
    Get.to(OtpScreen());
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}