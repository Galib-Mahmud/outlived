import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  // 5 Focus nodes and text controllers for the 5 OTP boxes
  final List<TextEditingController> controllers = List.generate(5, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(5, (_) => FocusNode());

  var isLoading = false.obs;

  void handleOtpTyping(String value, int index) {
    // If a digit is entered, automatically move focus to the next field
    if (value.isNotEmpty && index < 4) {
      focusNodes[index + 1].requestFocus();
    }
    // Optional: Handle backspace auto-backtracking
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void verifyOtp() {
    String otpCode = controllers.map((c) => c.text).join();

    if (otpCode.length < 5) {
      Get.snackbar('Error', 'Please fill in all 5 digits',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    // Implement your verification API logic here
  }

  @override
  void onClose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}