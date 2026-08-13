import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:outlive/core/endpoint/api_client.dart';
import 'package:outlive/core/endpoint/api_endpoint.dart';

class CreateReminderController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);
  final messageController = TextEditingController();
  final benefitCircleController = TextEditingController();

  var selectedDateText = 'DD/MM/YY'.obs;
  var selectedTimeText = 'hh:mm'.obs;
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
      // KNOWN GAP — not fixed here, needs a product decision:
      // POST /reminders (per the API doc, §9) has no field for targeting
      // specific contacts at all — no contact_ids, nothing. That concept
      // only exists on /deeds. So whatever contacts get picked via the
      // "Benefit Circle" contact selector are used below only as a text
      // label for the title — they will NOT actually receive this
      // reminder through any documented mechanism. This screen may need
      // to create a Deed instead, or contact-targeting needs to be added
      // to /reminders, or contact selection should be dropped from this
      // screen if reminders are meant to be purely personal.
      String frequency = 'daily';
      if (selectedRewardInterval.value == 'Weekly') {
        frequency = 'weekly';
      } else if (selectedRewardInterval.value == 'Monthly') {
        frequency = 'monthly';
      } else if (selectedRewardInterval.value == 'Fridays') {
        // KNOWN GAP — not fixed here: unlike /deeds, /reminders has no
        // cron_expression field documented at all, so there is genuinely
        // no correct way to represent "every Friday" through this
        // endpoint as specified. Falling back to generic 'weekly' loses
        // which day — confirm with backend whether reminders secretly
        // also accept cron_expression, or whether this option should be
        // removed from the reminder-creation UI entirely.
        frequency = 'weekly';
      }

      final timeOfDay = "${_pickedTime!.hour.toString().padLeft(2, '0')}:${_pickedTime!.minute.toString().padLeft(2, '0')}:00";

      final payload = {
        "title": benefitCircleController.text.trim(),
        "body": messageController.text.trim(),
        "category": "custom",
        "frequency": frequency,
        "time_of_day": timeOfDay,
      };

      await _apiClient.post(ApiEndpoint.reminders, body: payload);

      // FIX: was Get.snackbar(...) immediately followed by Get.back() —
      // the pop transition frequently cut the snackbar off before it
      // rendered. Popping first, then showing the message (GetX's
      // snackbar is a global overlay, not tied to the route being
      // closed, so it still displays correctly after navigating back).
      Get.back();
      Get.snackbar("Success", "Reminder created successfully!", snackPosition: SnackPosition.BOTTOM);
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