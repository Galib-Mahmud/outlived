import 'package:get/get.dart';
import 'package:outlive/features/legacy/screens/social_post_screen.dart';
import 'package:outlive/features/notification/screens/notification_screen.dart';

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
  final String title;
  final String timestamp;
  final String snippet;
  final String platform;

  GoodDeedPost({
    required this.title,
    required this.timestamp,
    required this.snippet,
    required this.platform,
  });
}

class ImpactMetric {
  final String value;
  final String label;
  final bool isGreenIcon;

  ImpactMetric({
    required this.value,
    required this.label,
    required this.isGreenIcon,
  });
}

class HomeController extends GetxController {
  // Mock data matching the UI elements in image_8ce8be.png
  final memoryPost = MemoryPost(
    author: "Sarah and 45 People",
    relativeTime: "Today • 7:00 PM",
    tag: "Muslim",
    quote: "“Assalamu Alaikum dear friends 🤍 .\nMay Allah bless you with peace, guidance, and success in this life and the next. ....”",
  );

  final List<GoodDeedPost> goodDeedPosts = [
    GoodDeedPost(
      title: "Prayer is the key to peace",
      timestamp: "11 May 1 PM",
      snippet: "\"Prayer is not just a ritual,...\"",
      platform: "Facebook",
    ),
    GoodDeedPost(
      title: "Prayer is the key to peace",
      timestamp: "11 May 1 PM",
      snippet: "\"Prayer is not just a ritual,...\"",
      platform: "Facebook",
    ),
  ];

  final List<ImpactMetric> impactMetrics = [
    ImpactMetric(value: "12", label: "People Viewed", isGreenIcon: false),
    ImpactMetric(value: "12", label: "Recurring Reminders Active", isGreenIcon: true),
    ImpactMetric(value: "12", label: "Shares This Month", isGreenIcon: false),
    ImpactMetric(value: "12", label: "Ongoing Deeds Running", isGreenIcon: true),
  ];

  void handleNotificationTap() => Get.to(NotificationScreen());
  void handleProfileTap() => Get.toNamed('/profile');
  void handleCreateNewDeed() => Get.to(SocialPostScreen());
}