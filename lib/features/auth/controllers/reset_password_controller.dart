// lib/features/auth/controllers/reset_password_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outlive/features/auth/screens/login_screen.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/storage/local_storage.dart';

class ResetPasswordController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = false.obs;
  final RxBool obscureReTypePassword = false.obs;

  final passwordController = TextEditingController();
  final reTypePasswordController = TextEditingController();
  final codeController = TextEditingController(); // For the reset code

  String _resetCode = '';

  @override
  void onInit() {
    super.onInit();
    // Pre-fill code if passed from OtpScreen
    if (Get.arguments != null && Get.arguments['code'] != null) {
      _resetCode = Get.arguments['code'];
      codeController.text = _resetCode;
    }
  }

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void toggleReTypePasswordVisibility() => obscureReTypePassword.value = !obscureReTypePassword.value;

  Future<void> handlePasswordConfirm() async {
    final code = codeController.text.isNotEmpty ? codeController.text : _resetCode;

    if (code.isEmpty) { Get.snackbar("Error", "Please enter the reset code", snackPosition: SnackPosition.BOTTOM); return; }
    if (passwordController.text != reTypePasswordController.text) {
      Get.snackbar("Error", "Passwords do not match", snackPosition: SnackPosition.BOTTOM); return;
    }

    isLoading.value = true;
    try {
      final email = await UserInfo.getForgotPasswordEmail();

      await _apiClient.post(
        ApiEndpoint.resetPassword,
        body: {
          'email': email,
          'code': code,
          'new_password': passwordController.text,
          'confirm': reTypePasswordController.text, // OUTLIVED requires 'confirm'
        },
        requiresAuth: false,
      );

      await UserInfo.clearForgotPasswordEmail();
      Get.snackbar("Success", "Password reset successfully!", snackPosition: SnackPosition.BOTTOM);
      Get.to(LoginScreen());
    } on HttpException catch (e) {
      Get.snackbar("Error", _extractMessage(e.body) ?? e.message, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  String? _extractMessage(String? body) {
    if (body == null) return null;
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('detail')) return decoded['detail'].toString();
        if (decoded.containsKey('new_password')) return decoded['new_password'].first.toString();
      }
    } catch (_) {}
    return null;
  }

  @override
  void onClose() {
    [passwordController, reTypePasswordController, codeController].forEach((c) => c.dispose());
    super.onClose();
  }
}