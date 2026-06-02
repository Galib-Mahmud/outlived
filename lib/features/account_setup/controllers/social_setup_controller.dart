import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocialSetupController extends GetxController {
  final whatsappController = TextEditingController();

  // Reactive state values to track account connection state
  var isFacebookConnected = false.obs;
  var isInstagramConnected = false.obs;
  var isWhatsAppConnected = false.obs;

  void connectFacebook() {
    isFacebookConnected.value = !isFacebookConnected.value;
  }

  void connectInstagram() {
    isInstagramConnected.value = !isInstagramConnected.value;
  }

  void connectWhatsApp() {
    if (whatsappController.text.trim().isEmpty) {
      Get.snackbar('Required', 'Please enter your WhatsApp number first',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isWhatsAppConnected.value = !isWhatsAppConnected.value;
  }

  @override
  void onClose() {
    whatsappController.dispose();
    super.onClose();
  }
}