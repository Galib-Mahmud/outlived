import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:outlive/core/endpoint/api_client.dart';
import 'package:outlive/core/endpoint/api_endpoint.dart';

class ProfileUpdateController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  final fullNameController = TextEditingController();
  final addressController = TextEditingController();

  final Rx<File?> avatarFile = Rx<File?>(null);
  final RxString currentAvatarUrl = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      final res = await _apiClient.get(ApiEndpoint.me);
      if (res != null) {
        fullNameController.text = res['full_name'] ?? '';
        addressController.text = res['profile']?['address'] ?? '';
        currentAvatarUrl.value = res['profile']?['avatar'] ?? '';
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      Get.snackbar("Error", "Failed to load profile data", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      avatarFile.value = File(pickedFile.path);
    }
  }

  Future<void> saveChanges() async {
    if (fullNameController.text.isEmpty || addressController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      // 1. Upload Avatar if a new image was selected
      if (avatarFile.value != null) {
        // FIX: Changed uploadMultipart to multipart to match your ApiClient
        await _apiClient.multipart(
          ApiEndpoint.uploadAvatar,
          method: 'POST', // Your ApiClient requires the HTTP verb
          files: {'avatar': avatarFile.value!}, // Maps the field name 'avatar' to the File
          requiresAuth: true,
        );
      }

      // 2. Update Profile Details
      await _apiClient.patch(
        ApiEndpoint.updateProfile,
        body: {
          'address': addressController.text.trim(),
          'full_name': fullNameController.text.trim(),
        },
      );

      Get.snackbar("Success", "Profile updated successfully!", snackPosition: SnackPosition.BOTTOM);
      Get.back(); // Return to Profile Screen
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile. Please try again.", snackPosition: SnackPosition.BOTTOM);
      debugPrint("Save changes error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ─── SOCIAL CONNECTIONS ────────────────────────────────────────────

  Future<void> connectFacebook() async => _handleSocialConnect(includeInstagram: false);
  Future<void> connectInstagram() async => _handleSocialConnect(includeInstagram: true);

  Future<void> _handleSocialConnect({required bool includeInstagram}) async {
    isLoading.value = true;
    try {
      final result = await FacebookAuth.instance.login(permissions: [
        'public_profile', 'pages_show_list', 'pages_read_engagement',
        'pages_manage_posts', 'business_management', 'instagram_basic', 'instagram_content_publish',
      ]);

      if (result.status == LoginStatus.success) {
        final userToken = result.accessToken!.tokenString;

        var res = await _apiClient.post(
          ApiEndpoint.connectFacebook,
          body: {'access_token': userToken, 'include_instagram': includeInstagram},
        );

        // Handle Edge Case: User has multiple Pages and needs to select one
        if (res['needs_selection'] == true) {
          final pages = res['pages'] as List;
          final selectedPageId = await _showPagePickerDialog(pages);

          if (selectedPageId != null) {
            res = await _apiClient.post(
              ApiEndpoint.connectFacebook,
              body: {
                'access_token': userToken,
                'include_instagram': includeInstagram,
                'page_id': selectedPageId
              },
            );
          } else {
            Get.snackbar("Cancelled", "Page selection cancelled.", snackPosition: SnackPosition.BOTTOM);
            isLoading.value = false;
            return;
          }
        }

        final platform = includeInstagram ? "Instagram" : "Facebook";
        Get.snackbar("Success", "$platform connected successfully!", snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Cancelled", "Login cancelled.", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to connect account.", snackPosition: SnackPosition.BOTTOM);
      debugPrint("Social Connect error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> connectWhatsApp() async {
    isLoading.value = true;
    try {
      await _apiClient.post(ApiEndpoint.connectWhatsApp, body: {});
      Get.snackbar("Success", "WhatsApp opted-in!", snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to connect WhatsApp.", snackPosition: SnackPosition.BOTTOM);
      debugPrint("WA Connect error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _showPagePickerDialog(List pages) async {
    return await Get.dialog<String>(
      AlertDialog(
        title: const Text("Select a Facebook Page"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              final page = pages[index];
              return ListTile(
                title: Text(page['name'] ?? 'Unknown Page'),
                onTap: () => Get.back(result: page['id']),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        ],
      ),
    );
  }

  @override
  void onClose() {
    fullNameController.dispose();
    addressController.dispose();
    super.onClose();
  }
}