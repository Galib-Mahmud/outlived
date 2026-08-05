import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:outlive/core/endpoint/api_client.dart';
import 'package:outlive/core/endpoint/api_endpoint.dart';

class SocialPostController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  final contentController = TextEditingController();

  // Dropdown States
  var selectedCategory = 'Islamic'.obs;
  var selectedPlatform = 'Facebook'.obs;

  // Schedule States
  var selectedDateText = 'DD/MM/YY'.obs;
  var selectedTimeText = 'hh:mm'.obs;
  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;

  // Segment Selector State
  var selectedRewardInterval = 'Daily'.obs;

  // Media State
  final Rx<File?> mediaFile = Rx<File?>(null);
  final RxString mediaUrl = ''.obs;

  final List<String> categories = ['Islamic', 'General', 'Reminders'];
  final List<String> platforms = ['Facebook', 'Instagram'];

  final RxBool isLoading = false.obs;

  // Edit mode states
  final RxBool isEditing = false.obs;
  String? deedId;

  @override
  void onInit() {
    super.onInit();
    // Check if we are in Edit Mode (passed from PostDetailScreen)
    if (Get.arguments != null) {
      deedId = Get.arguments['deedId'];
      isEditing.value = Get.arguments['isEditing'] ?? false;
      if (isEditing.value && deedId != null) {
        _fetchDeedDetails();
      }
    }
  }

  Future<void> _fetchDeedDetails() async {
    isLoading.value = true;
    try {
      final res = await _apiClient.get('${ApiEndpoint.deeds}/$deedId');
      if (res != null) {
        contentController.text = res['message_template'] ?? '';
        mediaUrl.value = res['media_url'] ?? '';

        // Parse Date
        final startDateStr = res['start_date'];
        if (startDateStr != null) {
          _pickedDate = DateTime.tryParse(startDateStr);
          if (_pickedDate != null) {
            selectedDateText.value = DateFormat('dd/MM/yy').format(_pickedDate!);
          }
        }

        // Parse Frequency
        final freq = res['frequency'];
        if (freq == 'daily') selectedRewardInterval.value = 'Daily';
        else if (freq == 'weekly') selectedRewardInterval.value = 'Weekly';
        else if (freq == 'monthly') selectedRewardInterval.value = 'Monthly';
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load post details", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      mediaFile.value = File(pickedFile.path);
    }
  }

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

  Future<void> savePost() async {
    if (contentController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter post content", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (_pickedDate == null) {
      Get.snackbar("Error", "Please select a date", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      // 1. Handle Media Upload (Placeholder logic)
      // Note: The API expects a `media_url` string. If your backend has a generic
      // media upload endpoint, you would call _apiClient.multipart() here to get the URL.
      String? uploadedMediaUrl = mediaUrl.value;
      if (mediaFile.value != null) {
        // Mocking the uploaded URL for now since a specific deed media upload endpoint
        // isn't defined in the docs. Replace this with your actual upload logic.
        uploadedMediaUrl = "https://api.outlived.ai/media/uploaded_image_placeholder.jpg";
      }

      // 2. Map UI Interval to API Frequency
      String frequency = 'daily';
      if (selectedRewardInterval.value == 'Weekly' || selectedRewardInterval.value == 'Fridays') {
        frequency = 'weekly';
      } else if (selectedRewardInterval.value == 'Monthly') {
        frequency = 'monthly';
      }

      // 3. Build API Payload (Section 8: Deeds)
      final payload = {
        "title": "Social Media Post",
        "description": "Auto-generated social post",
        "deed_type": "content_share",
        "frequency": frequency,
        "start_date": DateFormat('yyyy-MM-dd').format(_pickedDate!), // API requires YYYY-MM-DD
        "message_template": contentController.text.trim(),
        "media_url": uploadedMediaUrl,
        "auto_generate": false,
      };

      // 4. API Call (POST for Create, PATCH for Edit)
      if (isEditing.value && deedId != null) {
        await _apiClient.patch('${ApiEndpoint.deeds}/$deedId', body: payload);
        Get.snackbar("Success", "Post updated successfully!", snackPosition: SnackPosition.BOTTOM);
      } else {
        await _apiClient.post(ApiEndpoint.deeds, body: payload);
        Get.snackbar("Success", "Post created successfully!", snackPosition: SnackPosition.BOTTOM);
      }

      Get.back(); // Return to previous screen

    } on NetworkException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } on HttpException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      debugPrint("Save post error: $e");
      Get.snackbar("Error", "Failed to save post", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    contentController.dispose();
    super.onClose();
  }
}