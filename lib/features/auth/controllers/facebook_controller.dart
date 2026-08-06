// lib/features/auth/controllers/facebook_auth_controller.dart

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:outlive/core/endpoint/api_client.dart';
import 'package:outlive/core/endpoint/api_endpoint.dart';
import 'package:outlive/features/landing/screens/landing_screen.dart';
import '../../../core/storage/local_storage.dart';

class FacebookAuthController extends GetxController {
  var isLoading = false.obs;

  // FIX: Get.find<ApiClient>() would throw at runtime — nothing in this
  // codebase registers ApiClient via Get.put(). Every other controller
  // (LoginController, HomeController, SocialConnectController,
  // ForgotPasswordController) instantiates its own ApiClient directly, so
  // this matches that same pattern instead of assuming DI that isn't set up.
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  Future<void> loginWithFacebook() async {
    isLoading.value = true;
    try {
      final result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      if (result.status == LoginStatus.success) {
        final userToken = result.accessToken?.tokenString;
        if (userToken == null) {
          Get.snackbar("Error", "Failed to retrieve Facebook token.");
          return;
        }

        // NOTE: ApiEndpoint.loginFacebook ('/auth/facebook') is not in the
        // documented API spec — confirm it exists on the backend before
        // relying on this in production.
        final raw = await _apiClient.post(
          ApiEndpoint.loginFacebook,
          requiresAuth: false,
          body: {'access_token': userToken},
        );

        // FIX: was an unchecked `as Map<String, dynamic>` cast — if the
        // server ever returned something else (empty body, a list), this
        // would throw a raw TypeError. Now it fails with a clear message.
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

        // FIX: both branches were `// TODO` — meaning a successful Facebook
        // login stored tokens but never navigated anywhere, identical to
        // the earlier "silent success, nothing happens" bug. Using
        // Get.offAll (not Get.to) so the login/signup screen doesn't
        // remain in the back stack after a successful auth.
        //
        // Both currently go to LandingScreen, matching what the regular
        // email/password login() does today. If newly-created Facebook
        // users should land on a separate onboarding/profile-setup screen
        // instead, point me at it and I'll split this branch.
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
      // Doc explicitly calls out "inactive accounts → 403" as a distinct
      // case — worth a clearer message than the generic "Access denied."
      Get.snackbar("Login Failed", "This account is inactive. Please contact support.");
    } on HttpException catch (e) {
      Get.snackbar("Login Failed", e.message);
    } on NetworkException catch (e) {
      Get.snackbar("Network Error", e.message);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}