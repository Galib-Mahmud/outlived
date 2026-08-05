import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:outlive/core/endpoint/api_client.dart';
import 'package:outlive/core/endpoint/api_endpoint.dart';
import 'package:outlive/features/legacy/screens/social_post_screen.dart'; // Adjust import if needed

class PostDetailController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  final RxBool isLoading = false.obs;

  var postTitle = ''.obs;
  var mediaUrl = ''.obs;
  var scheduledTimeText = ''.obs;
  var savedCount = 0.obs;
  var sharedCount = 0.obs;
  var postContent = ''.obs;

  String? deedId;

  @override
  void onInit() {
    super.onInit();
    // Retrieve the deedId passed from the LegacyScreen
    if (Get.arguments != null && Get.arguments['deedId'] != null) {
      deedId = Get.arguments['deedId'];
      fetchDeedDetails();
    } else {
      Get.snackbar("Error", "No post ID provided", snackPosition: SnackPosition.BOTTOM);
      Get.back();
    }
  }

  Future<void> fetchDeedDetails() async {
    if (deedId == null) return;
    isLoading.value = true;

    try {
      // Call GET /deeds/{id}
      final response = await _apiClient.get('${ApiEndpoint.deeds}/$deedId');

      if (response != null) {
        postTitle.value = response['title'] ?? '';
        postContent.value = response['message_template'] ?? response['description'] ?? '';
        mediaUrl.value = response['media_url'] ?? '';

        // Map targets array length to "Shared by X people"
        final targets = response['targets'] as List?;
        sharedCount.value = targets?.length ?? 0;

        // Parse ISO-8601 next_run_at to readable text
        final nextRunStr = response['next_run_at'];
        if (nextRunStr != null) {
          final nextRun = DateTime.tryParse(nextRunStr);
          if (nextRun != null) {
            scheduledTimeText.value = 'Scheduled : ${DateFormat('d MMM, h:mm a').format(nextRun)}';
          }
        } else {
          // Fallback if next_run_at is null (e.g. paused or completed deeds)
          final status = response['status'];
          scheduledTimeText.value = status == 'active' ? 'Active' : 'Paused';
        }
      }
    } on NetworkException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } on HttpException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      debugPrint("Fetch deed details error: $e");
      Get.snackbar("Error", "Failed to load post details", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToEditPost() {
    // Pass the deedId and an editing flag to the creation/edit screen
    Get.to(() => const SocialPostScreen(), arguments: {
      'deedId': deedId,
      'isEditing': true,
    });
  }
}