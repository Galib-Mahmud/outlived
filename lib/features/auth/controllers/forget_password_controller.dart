// lib/features/auth/controllers/forget_password_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outlive/features/auth/screens/otp_screen.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/storage/local_storage.dart';

class ForgotPasswordController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);
  final RxBool isLoading = false.obs;
  final emailController = TextEditingController();

  Future<void> sendOtp() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter your email", snackPosition: SnackPosition.BOTTOM); return;
    }

    isLoading.value = true;
    try {
      await _apiClient.post(
        ApiEndpoint.forgotPassword,
        body: {'email': emailController.text.trim()},
        requiresAuth: false,
      );

      await UserInfo.setForgotPasswordEmail(emailController.text.trim());
      Get.snackbar("Success", "Reset code sent to your email!", snackPosition: SnackPosition.BOTTOM);

      // Navigate to OTP screen to enter the code, passing the flow type
      Get.to(OtpScreen(), arguments: {'flowType': 'forgot_password'});
    } on HttpException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() { emailController.dispose(); super.onClose(); }
}