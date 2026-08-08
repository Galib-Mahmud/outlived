// lib/features/legacy/controllers/post_detail_controller.dart
//
// NOTE: this file was reconstructed from scratch — the original wasn't
// shared, only post_detail_screen.dart. Built to match exactly what that
// screen reads (isLoading, mediaUrl, postContent, scheduledTimeText,
// savedCount, sharedCount, navigateToEditPost). If your real controller
// had extra logic (e.g. an entrance animation using `late Animation`,
// which is the likely source of the LateInitializationError you hit),
// that's not reproduced here since it wasn't visible to me — please share
// the original if there's more to merge back in.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../screens/social_post_screen.dart';

class PostDetailController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  final String deedId;
  PostDetailController({required this.deedId});

  // Every reactive field here is initialized at declaration (not `late`),
  // so build() always has a valid value to read even before the fetch
  // completes — this is what rules out a LateInitializationError.
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  final RxString mediaUrl = ''.obs;
  final RxString postContent = ''.obs;
  final RxString scheduledTimeText = ''.obs;
  final RxInt savedCount = 0.obs;
  final RxInt sharedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeedDetail();
  }

  Future<void> fetchDeedDetail() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _apiClient.get(ApiEndpoint.deedDetail(deedId));
      if (response is Map<String, dynamic>) {
        _applyDeed(response);
      } else {
        errorMessage.value = 'Unexpected response from server.';
      }
    } on UnauthorizedException {
      errorMessage.value = 'Please log in again.';
    } on NotFoundException {
      errorMessage.value = 'This post no longer exists.';
    } on NetworkException catch (e) {
      errorMessage.value = e.message;
    } on HttpException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Something went wrong loading this post.';
      debugPrint('PostDetailController.fetchDeedDetail error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _applyDeed(Map<String, dynamic> json) {
    mediaUrl.value = (json['media_url'] as String?) ?? '';

    // "Core Post Text Block" — prefer the actual message content, fall
    // back to the description if a template wasn't set.
    postContent.value = (json['message_template'] as String?) ??
        (json['description'] as String?) ??
        '';

    scheduledTimeText.value = _buildScheduleText(json);

    // API doc has no "saves" concept on a deed — kept at 0 as an explicit
    // placeholder, matching the note already in post_detail_screen.dart.
    savedCount.value = 0;

    // "Shared by" — mapped from the targets array length, per the comment
    // already in post_detail_screen.dart.
    final targets = json['targets'] as List<dynamic>?;
    sharedCount.value = targets?.length ?? 0;
  }

  String _buildScheduleText(Map<String, dynamic> json) {
    final status = json['status'] as String?;
    final frequency = json['frequency'] as String?;
    final nextRunAt = json['next_run_at'] as String?;

    if (status == 'paused') return 'Paused';

    if (nextRunAt != null) {
      final parsed = DateTime.tryParse(nextRunAt);
      if (parsed != null) {
        final local = parsed.toLocal();
        final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
        final minute = local.minute.toString().padLeft(2, '0');
        final period = local.hour >= 12 ? 'PM' : 'AM';
        final freqLabel = frequency != null ? ' • ${_capitalize(frequency)}' : '';
        return 'Next: ${local.day}/${local.month}/${local.year} $hour:$minute $period$freqLabel';
      }
    }

    return frequency != null ? _capitalize(frequency) : '';
  }

  String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  void navigateToEditPost() {
    // FIX: was a 'Coming soon' stub — now confirmed SocialPostController
    // reads Get.arguments['deedId'] and Get.arguments['isEditing'] in its
    // onInit(), so this wires up correctly to that contract.
    Get.to(
          () => const SocialPostScreen(),
      arguments: {'deedId': deedId, 'isEditing': true},
    );
  }
}