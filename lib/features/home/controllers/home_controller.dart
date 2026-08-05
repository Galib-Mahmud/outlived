import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outlive/features/legacy/screens/social_post_screen.dart';
import 'package:outlive/features/notification/screens/notification_screen.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';

// NOTE: no endpoint for this exists in the API doc (no /memory or similar).
// Kept static until confirmed whether it's a real feature with its own
// endpoint or intentionally static content for now.
class MemoryPost {
  final String author;
  final String relativeTime;
  final String tag;
  final String quote;

  MemoryPost({
    required this.author,
    required this.relativeTime,
    required this.tag,
    required this.quote,
  });
}

class GoodDeedPost {
  final String id;
  final String title;
  final String timestamp;
  final String snippet;
  final String platform;

  GoodDeedPost({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.snippet,
    required this.platform,
  });

  // Maps a /deeds item (per the API doc's deed object) to what this card
  // displays. The doc's deed object has no "platform" field — that concept
  // belongs to social connections/deliveries, not deeds — so this uses
  // deed_type as a readable stand-in label. Flag this if you want it to
  // reflect something else (e.g. the deed's actual delivery channel).
  factory GoodDeedPost.fromJson(Map<String, dynamic> json) {
    final deedType = (json['deed_type'] as String?) ?? 'custom';
    return GoodDeedPost(
      id: json['id']?.toString() ?? '',
      title: (json['title'] as String?) ?? 'Untitled deed',
      timestamp: _formatDate(json['created_at'] as String?),
      snippet: (json['message_template'] as String?) ??
          (json['description'] as String?) ??
          '',
      platform: _labelForDeedType(deedType),
    );
  }

  static String _labelForDeedType(String deedType) {
    switch (deedType) {
      case 'reminder':
        return 'Reminder';
      case 'charity':
        return 'Charity';
      case 'content_share':
        return 'Content Share';
      default:
        return 'Custom';
    }
  }

  static String _formatDate(String? iso) {
    if (iso == null) return '';
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;
    final period = parsed.hour >= 12 ? 'PM' : 'AM';
    return '${parsed.day} ${months[parsed.month - 1]} $hour $period';
  }
}

class ImpactMetric {
  final String value;
  final String label;
  final bool isGreenIcon;
  final String? iconPath;

  ImpactMetric({
    required this.value,
    required this.label,
    required this.isGreenIcon,
    required this.iconPath,
  });
}

class HomeController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  // ─── STATES ──────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Static placeholder — see note above the MemoryPost class.
  final memoryPost = MemoryPost(
    author: "Sarah and 45 People",
    relativeTime: "Today • 7:00 PM",
    tag: "Muslim",
    quote:
    "\u201cAssalamu Alaikum dear friends \ud83e\udd0d .\nMay Allah bless you with peace, guidance, and success in this life and the next. ....\u201d",
  );

  final RxList<GoodDeedPost> goodDeedPosts = <GoodDeedPost>[].obs;
  final RxList<ImpactMetric> impactMetrics = <ImpactMetric>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  // ─── FETCH EVERYTHING FOR THIS SCREEN ─────────────────────────
  Future<void> fetchHomeData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final results = await Future.wait([
        _apiClient.get(ApiEndpoint.deeds),
        _apiClient.get(ApiEndpoint.metricsSummary),
      ]);

      _applyDeeds(results[0]);
      _applyMetrics(results[1]);
    } on UnauthorizedException {
      errorMessage.value = 'Please log in again.';
    } on NetworkException catch (e) {
      errorMessage.value = e.message;
    } on HttpException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Something went wrong loading your dashboard.';
      debugPrint('HomeController.fetchHomeData error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => fetchHomeData();

  void _applyDeeds(dynamic response) {
    // /deeds returns the paginated envelope {"count","next","previous","results"}
    final List<dynamic>? items =
    response is Map<String, dynamic> ? response['results'] as List<dynamic>? : null;
    if (items == null) {
      goodDeedPosts.clear();
      return;
    }
    goodDeedPosts.assignAll(
      items.map((e) => GoodDeedPost.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  void _applyMetrics(dynamic response) {
    if (response is! Map<String, dynamic>) {
      impactMetrics.clear();
      return;
    }
    impactMetrics.assignAll([
      ImpactMetric(
        value: '${response['reminders_delivered'] ?? 0}',
        label: 'Reminders Delivered',
        isGreenIcon: false,
        iconPath: 'assets/icons/reminder.png',
      ),
      ImpactMetric(
        value: '${response['people_reached'] ?? 0}',
        label: 'People Reached',
        isGreenIcon: false,
        iconPath: 'assets/icons/eye.png',
      ),
      ImpactMetric(
        value: '${response['recurring_deeds_active'] ?? 0}',
        label: 'Recurring Deeds Active',
        isGreenIcon: true,
        iconPath: 'assets/icons/deed.png',
      ),
      ImpactMetric(
        value: '${response['shared_count'] ?? 0}',
        label: 'Shares',
        isGreenIcon: true,
        iconPath: 'assets/icons/whatsapp.png',
      ),
    ]);
  }

  void handleNotificationTap() => Get.to(() => NotificationScreen());
  void handleProfileTap() => Get.toNamed('/profile');
  void handleCreateNewDeed() => Get.to(() => SocialPostScreen());
}