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
    } on HttpException catch (e) {
      debugPrint("Error fetching user data: ${e.message}");
      Get.snackbar("Error", "Failed to load profile data", snackPosition: SnackPosition.BOTTOM);
    } on NetworkException catch (e) {
      debugPrint("Error fetching user data: ${e.message}");
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
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
        // FIX: ApiEndpoint.uploadAvatar was removed as a duplicate of
        // meProfileAvatar (same path, two names) — using the canonical one.
        await _apiClient.multipart(
          ApiEndpoint.meProfileAvatar,
          method: 'POST',
          files: {'avatar': avatarFile.value!},
          requiresAuth: true,
        );
      }

      // 2. Update Profile Details
      // FIX: ApiEndpoint.updateProfile was removed as a duplicate of
      // meProfile — using the canonical one.
      await _apiClient.patch(
        ApiEndpoint.meProfile,
        body: {
          'address': addressController.text.trim(),
          'full_name': fullNameController.text.trim(),
        },
      );

      Get.back();
      Get.snackbar("Success", "Profile updated successfully!", snackPosition: SnackPosition.BOTTOM);
    } on HttpException catch (e) {
      // FIX: was a generic catch(e) that always showed the same message
      // regardless of cause — your API doc specifically calls out avatar
      // size/type validation errors here, so surface the real message.
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
      debugPrint("Save changes error: ${e.message}");
    } on NetworkException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
      debugPrint("Save changes error: ${e.message}");
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
        final userToken = result.accessToken?.tokenString;
        if (userToken == null) {
          Get.snackbar("Error", "Failed to retrieve Facebook token.", snackPosition: SnackPosition.BOTTOM);
          return;
        }

        // FIX: ApiEndpoint.connectFacebook was removed as a duplicate of
        // socialConnectFacebook — using the canonical one.
        var res = await _apiClient.post(
          ApiEndpoint.socialConnectFacebook,
          body: {'access_token': userToken, 'include_instagram': includeInstagram},
        );

        // FIX: accessed res['needs_selection'] without checking res is a
        // Map first — matches the defensive check used in
        // SocialConnectController/HomeController.
        if (res is Map<String, dynamic> && res['needs_selection'] == true) {
          final pages = res['pages'] as List;
          final selectedPageId = await _showPagePickerDialog(pages);

          if (selectedPageId != null) {
            res = await _apiClient.post(
              ApiEndpoint.socialConnectFacebook,
              body: {
                'access_token': userToken,
                'include_instagram': includeInstagram,
                'page_id': selectedPageId
              },
            );
          } else {
            Get.snackbar("Cancelled", "Page selection cancelled.", snackPosition: SnackPosition.BOTTOM);
            return;
          }
        }

        final platform = includeInstagram ? "Instagram" : "Facebook";
        Get.snackbar("Success", "$platform connected successfully!", snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Cancelled", "Login cancelled.", snackPosition: SnackPosition.BOTTOM);
      }
    } on HttpException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
      debugPrint("Social Connect error: ${e.message}");
    } on NetworkException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
      debugPrint("Social Connect error: ${e.message}");
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
      // FIX: ApiEndpoint.connectWhatsApp was removed as a duplicate of
      // socialConnectWhatsApp — using the canonical one.
      await _apiClient.post(ApiEndpoint.socialConnectWhatsApp, body: {});
      Get.snackbar("Success", "WhatsApp opted-in!", snackPosition: SnackPosition.BOTTOM);
    } on HttpException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
      debugPrint("WA Connect error: ${e.message}");
    } on NetworkException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
      debugPrint("WA Connect error: ${e.message}");
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