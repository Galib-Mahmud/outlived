import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';

// 1. Import your custom Exceptions from api_client.dart
import 'package:outlive/core/endpoint/api_client.dart';

import '../../../core/storage/local_storage.dart';

class FacebookAuthController extends GetxController {
  var isLoading = false.obs;

  // ❗️ GET YOUR API CLIENT INSTANCE
  // If you injected it in main.dart using Get.put():
  final ApiClient api = Get.find<ApiClient>();
  // OR, if you have a global variable (e.g., final api = ApiClient(...)),
  // you can import and use that directly instead.

  Future<void> loginWithFacebook() async {
    isLoading.value = true;
    try {
      // 1. Trigger Facebook Login SDK
      final result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      if (result.status == LoginStatus.success) {
        final userToken = result.accessToken?.tokenString;

        if (userToken == null) {
          Get.snackbar("Error", "Failed to retrieve Facebook token.");
          return;
        }

        // 2. Call your API endpoint
        // FIX: Changed `auth: false` to `requiresAuth: false` to match ApiClient.dart
        final res = await api.post(
            '/auth/facebook',
            requiresAuth: false,
            body: {'access_token': userToken}
        ) as Map<String, dynamic>; // Cast to Map for safety

        // 3. Extract Data from Response
        final String access = res['access'] ?? '';
        final String refresh = res['refresh'] ?? '';
        final bool created = res['created'] ?? false;

        final Map<String, dynamic> user =
        res['user'] != null ? Map<String, dynamic>.from(res['user']) : {};

        // 4. STORE DATA LOCALLY USING USERINFO
        await UserInfo.setAccessToken(access);
        await UserInfo.setRefreshToken(refresh);

        if (user['email'] != null) await UserInfo.setUserEmail(user['email']);
        if (user['full_name'] != null) await UserInfo.setFullName(user['full_name']);
        if (user['role'] != null) await UserInfo.setRole(user['role']);

        // 5. Handle routing based on newly created vs existing user
        if (created) {
          // TODO: Navigate to Onboarding / Profile Setup
          // Get.offAll(() => const OnboardingScreen());
        } else {
          // TODO: Navigate to Home / Dashboard
          // Get.offAll(() => const HomeScreen());
        }

      } else if (result.status == LoginStatus.cancelled) {
        Get.snackbar("Cancelled", "Facebook login was cancelled.");
      } else {
        Get.snackbar("Login Failed", result.message ?? "An error occurred with Facebook.");
      }

    } on HttpException catch (e) {
      // 🎯 CATCHES BACKEND ERRORS (400 invalid token, 403 inactive account)
      // Your _extractErrorMessage handles DRF validation arrays perfectly!
      Get.snackbar("Login Failed", e.message);
    } on NetworkException catch (e) {
      // 🎯 CATCHES TIMEOUTS / NO INTERNET
      Get.snackbar("Network Error", e.message);
    } catch (e) {
      // Catches any other unexpected SDK errors
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}