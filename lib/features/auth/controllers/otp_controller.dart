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

  // FIX 1: Changed 5 to 6 for both controllers and focusNodes
  final List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flowType'] != null) {
      flowType.value = Get.arguments['flowType'];
    }
  }

  void handleOtpTyping(String value, int index) {
    // FIX 2: Changed index < 4 to index < 5
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String get _otpCode => controllers.map((c) => c.text).join('');

  Future<void> verifyOtp() async {
    // FIX 3: Changed length < 5 to length < 6
    if (_otpCode.length < 6) {
      Get.snackbar("Error", "Please enter the complete 6-digit code", snackPosition: SnackPosition.BOTTOM);
      return;
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

        // TIP: Use offAll instead of to() so the user can't press the "Back" button
        // on the Login Screen and end up back on the OTP screen.
        Get.offAll(() => const LoginScreen());
      } else {
        // FORGOT PASSWORD FLOW: Pass code to ResetPasswordScreen
        Get.to(() => const ResetPasswordScreen(), arguments: {'code': _otpCode});
      }
    } on NetworkException catch (e) {
      // FIX 4: Added NetworkException catch (prevents silent failures on bad internet)
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } on HttpException catch (e) {
      Get.snackbar("Error", _extractMessage(e.body) ?? e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.", snackPosition: SnackPosition.BOTTOM);
      debugPrint("OtpController.verifyOtp unexpected error: $e");
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