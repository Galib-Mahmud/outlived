import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:outlive/core/endpoint/api_client.dart';
import 'package:outlive/core/endpoint/api_endpoint.dart';

class LegacyMessageModel {
  final String id;
  final String timeText;
  final String groupHeader;
  final String content;
  final String recipients;
  final String scheduleType;
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

  // Maps the OUTLIVED API 'Deed' response to our UI Model
  factory LegacyMessageModel.fromDeedJson(Map<String, dynamic> json) {
    final String id = json['id'] ?? '';
    final String title = json['title'] ?? '';
    final String template = json['message_template'] ?? json['description'] ?? title;
    final String frequency = json['frequency'] ?? 'custom';
    final String status = json['status'] ?? 'active';

    // Parse next_run_at
    DateTime? nextRun;
    if (json['next_run_at'] != null) {
      nextRun = DateTime.tryParse(json['next_run_at']);
    }

    // Parse targets for recipients (e.g., "Sarah and 45 People")
    final List<dynamic> targets = json['targets'] ?? [];
    String recipients = '0 People';
    if (targets.isNotEmpty) {
      if (targets.length == 1) {
        recipients = targets[0]['name'] ?? '1 Person';
      } else {
        recipients = '${targets[0]['name']} and ${targets.length - 1} People';
      }
    }

    // Map frequency to UI chip
    String scheduleType = frequency.capitalizeFirst ?? 'Custom';

    // Determine isUpcoming and format time/group headers
    bool isUpcoming = status == 'active' && nextRun != null && nextRun.isAfter(DateTime.now());
    String timeText = '';
    String groupHeader = '';

    if (nextRun != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final runDate = DateTime(nextRun.year, nextRun.month, nextRun.day);

      if (runDate == today) {
        groupHeader = 'Today';
        timeText = 'Today ${DateFormat('h:mm a').format(nextRun)}';
      } else if (runDate == tomorrow) {
        groupHeader = 'Tomorrow';
        timeText = 'Tomorrow ${DateFormat('h:mm a').format(nextRun)}';
      } else if (nextRun.isBefore(now)) {
        groupHeader = 'Past Messages';
        timeText = DateFormat('MMM d, h:mm a').format(nextRun);
        isUpcoming = false;
      } else {
        groupHeader = DateFormat('MMM d').format(nextRun);
        timeText = DateFormat('MMM d, h:mm a').format(nextRun);
      }
    } else {
      groupHeader = isUpcoming ? 'Upcoming' : 'Past Messages';
      timeText = 'N/A';
    }

    return LegacyMessageModel(
      id: id,
      timeText: timeText,
      groupHeader: groupHeader,
      content: template,
      recipients: recipients,
      scheduleType: scheduleType,
      isUpcoming: isUpcoming,
    );
  }
}

class LegacyController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  // Scroll Controller for infinite scrolling
  final scrollController = ScrollController();

  var selectedTab = 1.obs;
  var searchQuery = ''.obs;

  final RxList<LegacyMessageModel> masterMessages = <LegacyMessageModel>[].obs;

  // Pagination & Loading States
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  int _currentPage = 1;
  final int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    fetchDeeds(isRefresh: true);
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      loadMoreDeeds();
    }
  }

  Future<void> fetchDeeds({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      hasMoreData.value = true;
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      // Fetch from GET /deeds with pagination
      final response = await _apiClient.get(
          '${ApiEndpoint.deeds}?page=$_currentPage&page_size=$_pageSize'
      );

      if (response != null) {
        final List<dynamic> results = response['results'] ?? [];

        if (isRefresh) masterMessages.clear();

        if (results.isEmpty) {
          hasMoreData.value = false;
        } else {
          final newModels = results.map((json) => LegacyMessageModel.fromDeedJson(json)).toList();
          masterMessages.addAll(newModels);
          _currentPage++;

          if (response['next'] == null) hasMoreData.value = false;
        }
      }
    } on NetworkException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } on HttpException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      debugPrint("Fetch deeds error: $e");
      Get.snackbar("Error", "Failed to load deeds", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void loadMoreDeeds() {
    if (!isLoadingMore.value && hasMoreData.value && !isLoading.value) {
      fetchDeeds();
    }
  }

  Future<void> deleteMessage(String id) async {
    try {
      // Call DELETE /deeds/{id}
      await _apiClient.delete('${ApiEndpoint.deeds}/$id');
      masterMessages.removeWhere((msg) => msg.id == id);
      Get.snackbar("Success", "Deed deleted successfully", snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete deed", snackPosition: SnackPosition.BOTTOM);
    }
  }

  List<LegacyMessageModel> get filteredMessages {
    final targetUpcoming = selectedTab.value == 1;

    return masterMessages.where((msg) {
      if (msg.isUpcoming != targetUpcoming) return false;

      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        return msg.content.toLowerCase().contains(query) ||
            msg.recipients.toLowerCase().contains(query);
      }
      return true;
    }).toList();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}