import 'package:get/get.dart';

class LegacyMessageModel {
  final String id;
  final String timeText;     // e.g., "Tomorrow 6:00 AM" or "Yesterday 4:00 PM"
  final String groupHeader;  // e.g., "Tomorrow" or "Past Messages"
  final String content;
  final String recipients;   // e.g., "Sarah and 45 People"
  final String scheduleType; // e.g., "Fridays"
  final bool isUpcoming;

  LegacyMessageModel({
    required this.id,
    required this.timeText,
    required this.groupHeader,
    required this.content,
    required this.recipients,
    required this.scheduleType,
    required this.isUpcoming,
  });
}

class LegacyController extends GetxController {
  // Active Tab Index Tracker (0 = Previous, 1 = Upcoming)
  var selectedTab = 1.obs;

  // Search query tracker string
  var searchQuery = ''.obs;

  // Master mock dataset mimicking the design layout text exactly
  final RxList<LegacyMessageModel> masterMessages = <LegacyMessageModel>[
    LegacyMessageModel(
      id: '1',
      groupHeader: 'Tomorrow',
      timeText: 'Tomorrow 6:00 AM',
      recipients: 'Sarah and 45 People',
      scheduleType: 'Fridays',
      isUpcoming: true,
      content: '"Assalamu Alaikum dear friends 🤍\n\nMay Allah bless you with peace, guidance, and success in this life and the next. Remember Allah in your good times and difficult times, keep your prayers strong, and never lose hope in His mercy.\n\n“Indeed, with hardship comes ease.” — Surah Ash-Sharh 94:6\n\nMay Allah keep us all steadfast on the right path. Ameen 🤲🏼"',
    ),
    LegacyMessageModel(
      id: '2',
      groupHeader: 'Tomorrow',
      timeText: 'Tomorrow 6:00 AM',
      recipients: 'Sarah and 45 People',
      scheduleType: 'Fridays',
      isUpcoming: true,
      content: '"Assalamu Alaikum dear friends 🤍\n\nMay Allah bless you with peace, guidance, and success in this life and the next. Remember Allah in your good times and difficult times, keep your prayers strong, and never lose hope in His mercy.\n\n“Indeed, with hardship comes ease.” — Surah Ash-Sharh 94:6\n\nMay Allah keep us all steadfast on the right path. Ameen 🤲🏼"',
    ),
    LegacyMessageModel(
      id: '3',
      groupHeader: 'Past Messages',
      timeText: 'May 28, 6:00 AM',
      recipients: 'Ahmad and 12 People',
      scheduleType: 'Once',
      isUpcoming: false,
      content: '"Assalamu Alaikum, this is a completed previous legacy reflection text for your records layout verification."',
    ),
  ].obs;

  // Delete message handler pipeline action
  void deleteMessage(String id) {
    masterMessages.removeWhere((msg) => msg.id == id);
  }

  // Combined synchronous reactive filtering pipeline
  List<LegacyMessageModel> get filteredMessages {
    final targetUpcoming = selectedTab.value == 1;

    return masterMessages.where((msg) {
      // 1. Filter by Active Tab Segment Context
      if (msg.isUpcoming != targetUpcoming) return false;

      // 2. Apply text searching across body content or category chips if queried
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        return msg.content.toLowerCase().contains(query) ||
            msg.recipients.toLowerCase().contains(query);
      }
      return true;
    }).toList();
  }
}