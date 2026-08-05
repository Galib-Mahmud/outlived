// lib/features/auth/controllers/login_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outlive/features/auth/screens/otp_screen.dart';
import 'package:outlive/features/home/screens/home_screen.dart';
import 'package:outlive/features/landing/screens/landing_screen.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/storage/local_storage.dart';


class LoginController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  final RxInt selectedTab = 0.obs;
  final RxBool obscurePassword = false.obs;
  final RxBool obscureReTypePassword = false.obs;
  final RxBool hasError = false.obs;
  final RxBool isLoading = false.obs;

  // Login Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign Up Controllers (Added full_name for OUTLIVED API)
  final fullNameController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final signUpRePasswordController = TextEditingController();

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void toggleReTypePasswordVisibility() => obscureReTypePassword.value = !obscureReTypePassword.value;

  // ─── LOGIN ─────────────────────────────────────────────────────────
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      hasError.value = true; return;
    }
    hasError.value = false;
    isLoading.value = true;

    try {
      final response = await _apiClient.post(
        ApiEndpoint.login,
        body: {'email': emailController.text.trim(), 'password': passwordController.text},
        requiresAuth: false,
      );

      if (response != null) {
        // OUTLIVED Login returns {access, refresh}
        await UserInfo.setAccessToken(response['access'] ?? '');
        await UserInfo.setRefreshToken(response['refresh'] ?? '');

        // Note: OUTLIVED login doesn't return user profile.
        // You may want to call GET /me here to fetch user details if needed.
        Get.to(() => const LandingScreen());
      }
    } on UnauthorizedException {
      hasError.value = true;
      Get.snackbar("Error", "Invalid email or password", snackPosition: SnackPosition.BOTTOM);
    } on NetworkException catch (e) {
      // FIX: this catch was missing entirely. NetworkException (timeouts,
      // no internet) is a distinct type from HttpException, so it wasn't
      // caught before — it just propagated silently, leaving isLoading
      // reset but no error shown and no navigation. This is very likely
      // the "nothing happens" behavior being reported.
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } on HttpException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      // Catch-all so no future exception type can silently swallow
      // navigation like this again.
      Get.snackbar("Error", "Something went wrong. Please try again.", snackPosition: SnackPosition.BOTTOM);
      debugPrint("LoginController.login unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ─── SIGN UP ───────────────────────────────────────────────────────
  Future<void> signUp() async {
    if (fullNameController.text.isEmpty || signUpEmailController.text.isEmpty || signUpPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields", snackPosition: SnackPosition.BOTTOM); return;
    }
    if (signUpPasswordController.text != signUpRePasswordController.text) {
      Get.snackbar("Error", "Passwords do not match", snackPosition: SnackPosition.BOTTOM); return;
    }

    isLoading.value = true;
    try {
      int? statusCode;
      await _apiClient.post(
        ApiEndpoint.register,
        body: {
          'full_name': fullNameController.text.trim(),
          'email': signUpEmailController.text.trim(),
          'password': signUpPasswordController.text,
        },
        requiresAuth: false,
        onStatusCode: (code) => statusCode = code,
      );

      // Only proceed to the OTP screen on the exact status the API doc
      // specifies for a successful registration (201 Created). Any other
      // 2xx would previously have navigated too, since post() only threw
      // on 4xx/5xx — this makes the check explicit.
      if (statusCode == 201) {
        await UserInfo.setUserEmail(signUpEmailController.text.trim());
        Get.snackbar("Success", "OTP sent to your email!", snackPosition: SnackPosition.TOP);
        Get.to(() => const OtpScreen());
      } else {
        Get.snackbar("Error", "Unexpected response from server (status: $statusCode).", snackPosition: SnackPosition.BOTTOM);
      }
    } on NetworkException catch (e) {
      // Same missing-catch bug as login() — see note there.
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } on HttpException catch (e) {
      Get.snackbar("Error", _extractMessage(e.body) ?? e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.", snackPosition: SnackPosition.BOTTOM);
      debugPrint("LoginController.signUp unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String? _extractMessage(String? body) {
    if (body == null) return null;
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('detail')) return decoded['detail'].toString();
        if (decoded.containsKey('email')) return decoded['email'].first.toString(); // DRF often returns lists for field errors
      }
    } catch (_) {}
    return null;
  }
}
