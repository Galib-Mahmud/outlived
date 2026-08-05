import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outlive/core/endpoint/api_client.dart';
import 'package:outlive/core/endpoint/api_endpoint.dart';
import 'package:outlive/core/storage/local_storage.dart';
import 'package:outlive/features/auth/screens/login_screen.dart';

class ProfileController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  // ─── USER DATA ─────────────────────────────────────────────────────
  final RxString fullName = ''.obs;
  final RxString email = ''.obs;
  final RxString avatarUrl = ''.obs;
  final RxBool isSubscriptionActive = false.obs; // Controls the "Active" tag

  // ─── SETTINGS TOGGLES ──────────────────────────────────────────────
  final RxBool isPrayerReminderEnabled = false.obs;
  final RxBool isPushNotificationEnabled = false.obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    isLoading.value = true;
    await Future.wait([
      fetchProfileData(),
      // fetchSubscriptionStatus(),
    ]);
    isLoading.value = false;
  }

  // GET /me
  Future<void> fetchProfileData() async {
    try {
      final response = await _apiClient.get(ApiEndpoint.me);

      if (response != null) {
        fullName.value = response['full_name'] ?? '';
        email.value = response['email'] ?? '';

        final profile = response['profile'];
        if (profile != null) {
          avatarUrl.value = profile['avatar'] ?? '';
        }

        final settings = response['settings'];
        if (settings != null) {
          isPrayerReminderEnabled.value = settings['daily_prayer_reminder'] ?? false;
          isPushNotificationEnabled.value = settings['notifications_push'] ?? false;
        }
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
      Get.snackbar("Error", "Failed to load profile data", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // GET /me/subscription
  // Future<void> fetchSubscriptionStatus() async {
  //   try {
  //     final response = await _apiClient.get(ApiEndpoint.mySubscription);
  //     if (response != null) {
  //       // Mark as active if they have an active subscription OR are entitled to premium features
  //       isSubscriptionActive.value = response['status'] == 'active' || response['is_entitled'] == true;
  //     }
  //   } catch (e) {
  //     debugPrint("Error fetching subscription: $e");
  //     // Fallback: If subscription check fails, we just won't show the "Active" tag
  //   }
  // }

  // ─── SETTINGS UPDATES ──────────────────────────────────────────────

  // Future<void> togglePrayerReminder(bool value) async {
  //   isPrayerReminderEnabled.value = value;
  //   await _updateSettings({'daily_prayer_reminder': value});
  // }
  //
  // Future<void> togglePushNotifications(bool value) async {
  //   isPushNotificationEnabled.value = value;
  //   await _updateSettings({'notifications_push': value});
  // }

  // PATCH /me/settings
  // Future<void> _updateSettings(Map<String, dynamic> body) async {
  //   try {
  //     await _apiClient.patch(ApiEndpoint.updateSettings, body: body);
  //     Get.snackbar("Success", "Settings updated", snackPosition: SnackPosition.BOTTOM);
  //   } catch (e) {
  //     // Revert the toggle in the UI if the API call fails
  //     if (body.containsKey('daily_prayer_reminder')) {
  //       isPrayerReminderEnabled.value = !body['daily_prayer_reminder'];
  //     } else if (body.containsKey('notifications_push')) {
  //       isPushNotificationEnabled.value = !body['notifications_push'];
  //     }
  //     Get.snackbar("Error", "Failed to update settings", snackPosition: SnackPosition.BOTTOM);
  //   }
  // }

  // ─── ACCOUNT ACTIONS ───────────────────────────────────────────────

  // POST /auth/logout
  Future<void> logout() async {
    isLoading.value = true;
    try {
      final refreshToken = await UserInfo.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _apiClient.post(
          ApiEndpoint.logout,
          body: {'refresh': refreshToken},
          requiresAuth: true,
        );
      }
    } catch (e) {
      debugPrint("Logout API error: $e");
      // Even if the API fails, we must log them out locally
    } finally {
      await _clearSessionAndNavigate();
    }
  }

  // DELETE /me (Assumed endpoint for account deletion)
  Future<void> deleteAccount() async {
    isLoading.value = true;
    try {
      await _apiClient.delete(ApiEndpoint.logout);
      Get.snackbar("Success", "Account deleted successfully", snackPosition: SnackPosition.BOTTOM);
      await _clearSessionAndNavigate();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Failed to delete account. Please try again.", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _clearSessionAndNavigate() async {
    await UserInfo.clearAll(); // Ensure you have a method to wipe all tokens/user data
    isLoading.value = false;
    Get.offAll(() => const LoginScreen());
  }
}