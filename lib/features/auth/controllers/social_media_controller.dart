import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';

class SocialConnectController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  // ─── STATES ──────────────────────────────────────────────────
  final RxBool isFacebookConnected = false.obs;
  final RxBool isWhatsappConnected = false.obs;
  final RxBool isConnecting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchConnections();
    registerPushNotifications();
  }

  // ─── 1. FETCH CONNECTIONS (GET /social/connections) ──────────
  Future<void> fetchConnections() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoint.socialConnections,
        requiresAuth: true,
      );

      // FIX: this endpoint returns the paginated envelope
      // {"count", "next", "previous", "results": [...]} per the API doc —
      // not a bare list — so the items live in response['results'].
      final List<dynamic>? connections =
      response is Map<String, dynamic> ? response['results'] as List<dynamic>? : null;

      if (connections != null) {
        isFacebookConnected.value = connections.any(
              (c) => c['platform'] == 'facebook' && c['status'] == 'connected',
        );
        isWhatsappConnected.value = connections.any(
              (c) => c['platform'] == 'whatsapp' && c['status'] == 'connected',
        );
      }
    } catch (e) {
      debugPrint("Error fetching connections: $e");
    }
  }

  // ─── 2. FACEBOOK CONNECT ──────────────────────────────────────
  Future<void> connectFacebook() async {
    if (isFacebookConnected.value) {
      Get.snackbar("Info", "Already connected", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isConnecting.value = true;
    try {
      final result = await FacebookAuth.instance.login(
        permissions: [
          'public_profile', 'pages_show_list', 'pages_read_engagement',
          'pages_manage_posts', 'business_management', 'instagram_basic',
          'instagram_content_publish',
        ],
      );

      if (result.status != LoginStatus.success) {
        Get.snackbar("Error", "Facebook login cancelled", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final userToken = result.accessToken!.tokenString;
      final response = await _sendFbTokenToBackend(userToken);
      if (response == null) return;

      if (response['needs_selection'] == true) {
        final pages = response['pages'] as List;
        final selectedPageId = await _showPagePicker(pages);
        if (selectedPageId == null) return;

        final finalResponse = await _sendFbTokenToBackend(userToken, pageId: selectedPageId);
        if (finalResponse != null) {
          isFacebookConnected.value = true;
          Get.snackbar("Success", "${finalResponse['page']['name']} connected!", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        }
      } else {
        isFacebookConnected.value = true;
        Get.snackbar("Success", "${response['page']['name']} connected!", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isConnecting.value = false;
    }
  }

  Future<Map<String, dynamic>?> _sendFbTokenToBackend(String userToken, {String? pageId}) async {
    try {
      final body = {
        'access_token': userToken,
        if (pageId != null) 'page_id': pageId,
      };
      return await _apiClient.post(
        ApiEndpoint.socialConnectFacebook,
        body: body,
        requiresAuth: true,
      );
    } on HttpException catch (e) {
      Get.snackbar("Error", _extractMessage(e.body) ?? "Connection failed", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    }
  }

  Future<String?> _showPagePicker(List<dynamic> pages) async {
    return await Get.bottomSheet<String>(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            const Text("Select your Page", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return ListTile(
                    title: Text(page['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.back(result: page['id']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ─── 3. WHATSAPP TOGGLE ───────────────────────────────────────
  Future<void> toggleWhatsApp() async {
    try {
      if (isWhatsappConnected.value) {
        // FIX: ApiEndpoint.socialDisconnectWhatsApp was removed in favor of
        // the generic per-platform disconnect endpoint from the API doc.
        await _apiClient.post(
          ApiEndpoint.socialDisconnect('whatsapp'),
          requiresAuth: true,
        );
        isWhatsappConnected.value = false;
        Get.snackbar("Success", "WhatsApp disconnected", snackPosition: SnackPosition.BOTTOM);
      } else {
        await _apiClient.post(
          ApiEndpoint.socialConnectWhatsApp,
          body: {},
          requiresAuth: true,
        );
        isWhatsappConnected.value = true;
        Get.snackbar("Success", "WhatsApp opted-in", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      }
    } on HttpException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // ─── 4. FIREBASE PUSH NOTIFICATIONS (POST /me/devices) ───────
  Future<void> registerPushNotifications() async {
    try {
      // FIX: request notification permission before getToken(), per the
      // API doc's §5.4 flow — without this, iOS in particular can silently
      // fail to return a token.
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) return;

      // FIX: ApiEndpoint.registerDevice was renamed to ApiEndpoint.devices.
      await _apiClient.post(
        ApiEndpoint.devices,
        body: {
          'token': fcmToken,
          'platform': Platform.isAndroid ? 'android' : 'ios',
        },
        requiresAuth: true,
      );
      debugPrint("FCM token registered successfully");

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        await _apiClient.post(
          ApiEndpoint.devices,
          body: {'token': newToken, 'platform': Platform.isAndroid ? 'android' : 'ios'},
          requiresAuth: true,
        );
      });
    } catch (e) {
      debugPrint("Error registering FCM token: $e");
    }
  }

  // ─── HELPER ──────────────────────────────────────────────────
  String? _extractMessage(String? body) {
    if (body == null) return null;
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        if (decoded['code'] == 'no_page') return "You don't have any Facebook Page.";
        if (decoded['code'] == 'graph_error') return "Facebook token expired.";
        if (decoded.containsKey('detail')) return decoded['detail'].toString();
      }
    } catch (_) {}
    return null;
  }
}