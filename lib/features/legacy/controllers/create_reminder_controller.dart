import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateReminderController extends GetxController {
  final messageController = TextEditingController();
  final benefitCircleController = TextEditingController();

  // Date and Time tracking state variables
  var selectedDateText = 'DD/MM/YY'.obs;
  var selectedTimeText = 'hh:mm'.obs;

  // Selected interval option ('Daily', 'Fridays', 'Weekly', 'Monthly')
  var selectedRewardInterval = 'Daily'.obs;

  // Functional picker helper actions
  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      selectedDateText.value = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year.toString().substring(2)}";
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      selectedTimeText.value = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    benefitCircleController.dispose();
    super.onClose();
  }
}