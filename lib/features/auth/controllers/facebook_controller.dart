// lib/features/auth/controllers/facebook_auth_controller.dart

import 'dart:developer' as developer;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:outlive/core/endpoint/api_client.dart';
import 'package:outlive/core/endpoint/api_endpoint.dart';
import 'package:outlive/features/landing/screens/landing_screen.dart';
import '../../../core/storage/local_storage.dart';

class FacebookAuthController extends GetxController {
  var isLoading = false.obs;

  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  Future<void> loginWithFacebook() async {
    isLoading.value = true;
    try {
      final result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      // DEBUG: tells us immediately if the Facebook SDK step itself is
      // the problem (bad key hash / app not live / permissions denied)
      // vs. something after it. Remove once the flow is confirmed working.
      developer.log(
        'FB LOGIN RESULT: status=${result.status}, message=${result.message}',
        name: 'FacebookAuth',
      );

      if (result.status == LoginStatus.success) {
        final userToken = result.accessToken?.tokenString;
        if (userToken == null) {
          Get.snackbar("Error", "Failed to retrieve Facebook token.");
          return;
        }

        final raw = await _apiClient.post(
          ApiEndpoint.loginFacebook,
          requiresAuth: false,
          body: {'access_token': userToken},
        );

        // DEBUG: shows exactly what the backend sent back, including if
        // it's an error shape your `is! Map<String, dynamic>` check would
        // otherwise mask as a generic "Unexpected response" snackbar.
        developer.log('BACKEND RAW RESPONSE: $raw', name: 'FacebookAuth');

        if (raw is! Map<String, dynamic>) {
          Get.snackbar("Error", "Unexpected response from server.");
          return;
        }
        final res = raw;

        final String access = res['access'] ?? '';
        final String refresh = res['refresh'] ?? '';
        final bool created = res['created'] ?? false;
        final Map<String, dynamic> user =
        res['user'] != null ? Map<String, dynamic>.from(res['user']) : {};

        if (access.isEmpty || refresh.isEmpty) {
          Get.snackbar("Error", "Login succeeded but no tokens were returned.");
          return;
        }

        await UserInfo.setAccessToken(access);
        await UserInfo.setRefreshToken(refresh);
        if (user['email'] != null) await UserInfo.setUserEmail(user['email']);
        if (user['full_name'] != null) await UserInfo.setFullName(user['full_name']);
        if (user['role'] != null) await UserInfo.setRole(user['role']);

        // DEBUG: confirms the write actually landed in SharedPreferences
        // before we navigate away. If this prints null, the problem is in
        // UserInfo.init() timing, not this controller.
        final stored = await UserInfo.getAccessToken();
        developer.log('TOKEN AFTER STORE: $stored', name: 'FacebookAuth');

        if (created) {
          Get.offAll(() => const LandingScreen());
        } else {
          Get.offAll(() => const LandingScreen());
        }
      } else if (result.status == LoginStatus.cancelled) {
        Get.snackbar("Cancelled", "Facebook login was cancelled.");
      } else {
        Get.snackbar("Login Failed", result.message ?? "An error occurred with Facebook.");
      }
    } on ForbiddenException {
      Get.snackbar("Login Failed", "This account is inactive. Please contact support.");
    } on HttpException catch (e) {
      Get.snackbar("Login Failed", e.message);
    } on NetworkException catch (e) {
      Get.snackbar("Network Error", e.message);
    } catch (e, stackTrace) {
      // FIX: was `catch (e)` only, so the real cause (line/class it came
      // from) was invisible whenever this generic branch caught something.
      developer.log('UNEXPECTED ERROR', name: 'FacebookAuth', error: e, stackTrace: stackTrace);
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}