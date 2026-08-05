import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:outlive/core/endpoint/api_client.dart';
import 'package:outlive/core/endpoint/api_endpoint.dart';

class CreateReminderController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  final messageController = TextEditingController();
  final benefitCircleController = TextEditingController();

  // Date and Time tracking state variables
  var selectedDateText = 'DD/MM/YY'.obs;
  var selectedTimeText = 'hh:mm'.obs;

  // Store actual DateTime objects for API formatting
  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;

  // Selected interval option ('Daily', 'Fridays', 'Weekly', 'Monthly')
  var selectedRewardInterval = 'Daily'.obs;

  final RxBool isLoading = false.obs;

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      _pickedDate = picked;
      selectedDateText.value = DateFormat('dd/MM/yy').format(picked);
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _pickedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      _pickedTime = picked;
      selectedTimeText.value = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
    }
  }

  Future<void> saveReminder() async {
    // 1. Validation
    if (benefitCircleController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter a title / benefit circle", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (messageController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter a message", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (_pickedTime == null) {
      Get.snackbar("Error", "Please select a time", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      // 2. Map UI Interval to API Frequency
      String frequency = 'daily';
      if (selectedRewardInterval.value == 'Weekly' || selectedRewardInterval.value == 'Fridays') {
        frequency = 'weekly';
      } else if (selectedRewardInterval.value == 'Monthly') {
        frequency = 'monthly';
      }

      // 3. Format time_of_day as HH:mm:ss (Required by API)
      final timeOfDay = "${_pickedTime!.hour.toString().padLeft(2, '0')}:${_pickedTime!.minute.toString().padLeft(2, '0')}:00";

      // 4. Build Payload
      final payload = {
        "title": benefitCircleController.text.trim(),
        "body": messageController.text.trim(),
        "category": "custom", // Defaulting to custom based on API docs
        "frequency": frequency,
        "time_of_day": timeOfDay,
      };

      // 5. API Call
      await _apiClient.post(ApiEndpoint.reminders, body: payload);

      Get.snackbar("Success", "Reminder created successfully!", snackPosition: SnackPosition.BOTTOM);
      Get.back(); // Return to previous screen

    } on NetworkException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } on HttpException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      debugPrint("Save reminder error: $e");
      Get.snackbar("Error", "Failed to create reminder", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    benefitCircleController.dispose();
    super.onClose();
  }
}