// lib/features/auth/controllers/otp_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outlive/features/auth/screens/login_screen.dart';
import 'package:outlive/features/auth/screens/reset_password_screen.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/storage/local_storage.dart';


class OtpController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);
  final RxBool isLoading = false.obs;

  // 'register' or 'forgot_password'
  final RxString flowType = 'register'.obs;

  final List<TextEditingController> controllers = List.generate(5, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(5, (_) => FocusNode());

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flowType'] != null) {
      flowType.value = Get.arguments['flowType'];
    }
  }

  void handleOtpTyping(String value, int index) {
    if (value.isNotEmpty && index < 4) focusNodes[index + 1].requestFocus();
    else if (value.isEmpty && index > 0) focusNodes[index - 1].requestFocus();
  }

  String get _otpCode => controllers.map((c) => c.text).join('');

  Future<void> verifyOtp() async {
    if (_otpCode.length < 5) {
      Get.snackbar("Error", "Please enter the complete code", snackPosition: SnackPosition.BOTTOM); return;
    }

    isLoading.value = true;
    try {
      if (flowType.value == 'register') {
        // OUTLIVED API: Verify Registration OTP
        final email = await UserInfo.getUserEmail();
        await _apiClient.post(
          ApiEndpoint.verifyOtp,
          body: {'email': email, 'code': _otpCode},
          requiresAuth: false,
        );

        Get.snackbar("Success", "Account verified! Please login.", snackPosition: SnackPosition.BOTTOM);
        Get.to(LoginScreen());
      } else {
        // FORGOT PASSWORD FLOW: Pass code to ResetPasswordScreen
        Get.to(ResetPasswordScreen(), arguments: {'code': _otpCode});
      }
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
      if (decoded is Map<String, dynamic> && decoded.containsKey('detail')) return decoded['detail'].toString();
    } catch (_) {}
    return null;
  }

  @override
  void onClose() {
    controllers.forEach((c) => c.dispose());
    focusNodes.forEach((f) => f.dispose());
    super.onClose();
  }
}