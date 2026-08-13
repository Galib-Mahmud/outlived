import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:outlive/core/endpoint/api_client.dart';
import 'package:outlive/core/endpoint/api_endpoint.dart';

class SocialPostController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  // ─── TABS ────────────────────────────────────────────────────
  // 0 = Custom Post, 1 = AI Generated Post
  final RxInt selectedTab = 0.obs;

  final contentController = TextEditingController();

  var selectedCategory = 'Islamic'.obs;
  var selectedPlatform = 'Facebook'.obs;

  var selectedDateText = 'DD/MM/YY'.obs;
  // NOTE: per the API doc, POST /deeds has no time-of-day field at all
  // (only a date-only start_date). Picking a time currently has no effect
  // on what actually gets scheduled server-side — needs a backend field.
  var selectedTimeText = 'hh:mm'.obs;
  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;
  DateTime? get pickedDate => _pickedDate;
  TimeOfDay? get pickedTime => _pickedTime;

  var selectedRewardInterval = 'Daily'.obs;

  final Rx<File?> mediaFile = Rx<File?>(null);
  final RxString mediaUrl = ''.obs;

  final List<String> categories = ['Islamic', 'General', 'Reminders'];
  final List<String> platforms = ['Facebook', 'Instagram'];

  final RxBool isLoading = false.obs;

  final RxBool isEditing = false.obs;
  String? deedId;

  // ─── AI GENERATION STATE ────────────────────────────────────
  // Confirmed against the backend team's actual spec (not just the
  // general API doc) — this is the real request/response shape for
  // POST /ai/generate as available to regular app users.
  final List<String> aiGenerationTypes = const [
    'Text Only',
    'Image Only',
    'Text + Image',
    'Text + Video',
    "Qur'an & Hadith Only",
  ];
  final RxString selectedAiType = 'Text Only'.obs;

  // Confirmed 13-category curated list. `value` is what's actually sent
  // to the API; `label` is display-only. category is technically
  // free-text/unvalidated server-side, but these are the recommended set.
  static const List<Map<String, String>> aiCategories = [
    {'value': 'islamic', 'label': 'General'},
    {'value': 'charity', 'label': 'Charity / Sadaqah'},
    {'value': 'prayer', 'label': 'Prayer / Salah'},
    {'value': 'gratitude', 'label': 'Gratitude'},
    {'value': 'patience', 'label': 'Patience'},
    {'value': 'forgiveness', 'label': 'Forgiveness'},
    {'value': 'kindness', 'label': 'Kindness'},
    {'value': 'family', 'label': 'Family & Parents'},
    {'value': 'knowledge', 'label': 'Seeking Knowledge'},
    {'value': 'dhikr', 'label': 'Remembrance (Dhikr)'},
    {'value': 'repentance', 'label': 'Repentance'},
    {'value': 'ramadan', 'label': 'Ramadan'},
    {'value': 'hereafter', 'label': 'The Hereafter'},
  ];
  // Categories confirmed to have seeded verified Qur'an/Hadith citations —
  // used to gate the "Qur'an & Hadith Only" option, since it isn't a real
  // API parameter and can only be approximated by category choice.
  static const Set<String> _scriptureSeededCategories = {'charity', 'prayer', 'gratitude', 'islamic'};

  final RxnString aiSelectedCategory = RxnString();
  final aiTopicController = TextEditingController();
  // No UI control for these two yet (not in the design) — sent at the
  // documented defaults. Add controls here if you want them exposed.
  final String _aiTone = 'warm';
  final int _aiMaxLength = 280;
  final RxBool isGenerating = false.obs;
  final RxList<String> generatedPosts = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      deedId = Get.arguments['deedId'];
      isEditing.value = Get.arguments['isEditing'] ?? false;
      if (isEditing.value && deedId != null) {
        _fetchDeedDetails();
      }
    }
  }

  Future<void> _fetchDeedDetails() async {
    isLoading.value = true;
    try {
      final res = await _apiClient.get(ApiEndpoint.deedDetail(deedId!));
      if (res != null) {
        contentController.text = res['message_template'] ?? '';
        mediaUrl.value = res['media_url'] ?? '';

        final startDateStr = res['start_date'];
        if (startDateStr != null) {
          _pickedDate = DateTime.tryParse(startDateStr);
          if (_pickedDate != null) {
            selectedDateText.value = DateFormat('dd/MM/yy').format(_pickedDate!);
          }
        }

        final freq = res['frequency'];
        final cron = res['cron_expression'] as String?;
        if (freq == 'daily') {
          selectedRewardInterval.value = 'Daily';
        } else if (freq == 'weekly') {
          selectedRewardInterval.value = 'Weekly';
        } else if (freq == 'monthly') {
          selectedRewardInterval.value = 'Monthly';
        } else if (freq == 'custom' && cron != null && _isFridayCron(cron)) {
          selectedRewardInterval.value = 'Fridays';
        }
      }
    } on HttpException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } on NetworkException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to load post details", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  bool _isFridayCron(String cron) {
    final parts = cron.trim().split(RegExp(r'\s+'));
    return parts.length == 5 && parts[4] == '5';
  }

  String _fridayCronExpression() {
    final hour = _pickedTime?.hour ?? 9;
    final minute = _pickedTime?.minute ?? 0;
    return '$minute $hour * * 5';
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      mediaFile.value = File(pickedFile.path);
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      _pickedDate = picked;
      selectedDateText.value = DateFormat('dd/MM/yy').format(picked);
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _pickedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      _pickedTime = picked;
      selectedTimeText.value = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
    }
  }

  // ─── AI GENERATION ───────────────────────────────────────────
  Future<void> generateAiPost() async {
    if (selectedAiType.value == 'Image Only' ||
        selectedAiType.value == 'Text + Image' ||
        selectedAiType.value == 'Text + Video') {
      // Confirmed, not speculative: image/poster modes live on a
      // staff-only dashboard endpoint (/admin/content-test). A regular
      // app user gets a 403 there — there's no way to make this work for
      // this app without a separate user-facing endpoint being built.
      Get.snackbar(
        "Not available for app users",
        "Image/poster generation is staff-only right now and isn't accessible from the app.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (aiSelectedCategory.value == null) {
      Get.snackbar("Error", "Please select a category", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (selectedAiType.value == "Qur'an & Hadith Only" &&
        !_scriptureSeededCategories.contains(aiSelectedCategory.value)) {
      // Not a real API parameter — citations only get auto-attached for
      // these four categories, never forced. Guide the person toward a
      // category where it's actually possible rather than silently
      // generating unrelated content.
      Get.snackbar(
        "Pick a different category",
        "Verified Qur'an/Hadith citations are currently only available for Charity, Prayer, Gratitude, or General — pick one of those for this option.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isGenerating.value = true;
    generatedPosts.clear();
    try {
      final response = await _apiClient.post(
        ApiEndpoint.aiGenerate,
        body: {
          "category": aiSelectedCategory.value,
          if (aiTopicController.text.trim().isNotEmpty) "topic": aiTopicController.text.trim(),
          "tone": _aiTone,
          if (selectedPlatform.value.isNotEmpty) "platform": selectedPlatform.value.toLowerCase(),
          "count": 3,
          "max_length": _aiMaxLength,
        },
      );

      if (response is Map<String, dynamic>) {
        final posts = (response['posts'] as List<dynamic>?)?.cast<String>() ?? [];
        generatedPosts.assignAll(posts);
        if (posts.isEmpty) {
          Get.snackbar("Notice", "No posts were generated. Try a different topic.", snackPosition: SnackPosition.BOTTOM);
        } else if (selectedAiType.value == "Qur'an & Hadith Only") {
          Get.snackbar(
            "Note",
            "A verified citation is included only when available — not guaranteed for every result.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } on ServerException {
      Get.snackbar("Unavailable", "AI generation is currently unavailable. Please try again later.", snackPosition: SnackPosition.BOTTOM);
    } on HttpException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } on NetworkException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      debugPrint("AI generate error: $e");
      Get.snackbar("Error", "Failed to generate post", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isGenerating.value = false;
    }
  }

  void useGeneratedPost(String text) {
    contentController.text = text;
    selectedTab.value = 0;
  }

  Future<void> savePost() async {
    if (contentController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter post content", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (_pickedDate == null) {
      Get.snackbar("Error", "Please select a date", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      String? uploadedMediaUrl = mediaUrl.value;
      if (mediaFile.value != null) {
        uploadedMediaUrl = "https://api.outlived.ai/media/uploaded_image_placeholder.jpg";
      }

      String frequency;
      String? cronExpression;
      if (selectedRewardInterval.value == 'Fridays') {
        frequency = 'custom';
        cronExpression = _fridayCronExpression();
      } else if (selectedRewardInterval.value == 'Weekly') {
        frequency = 'weekly';
      } else if (selectedRewardInterval.value == 'Monthly') {
        frequency = 'monthly';
      } else {
        frequency = 'daily';
      }

      final payload = {
        "title": "Social Media Post",
        "description": "Auto-generated social post",
        "deed_type": "content_share",
        "frequency": frequency,
        if (cronExpression != null) "cron_expression": cronExpression,
        "start_date": DateFormat('yyyy-MM-dd').format(_pickedDate!),
        "message_template": contentController.text.trim(),
        "media_url": uploadedMediaUrl,
        "auto_generate": false,
      };

      if (isEditing.value && deedId != null) {
        await _apiClient.patch(ApiEndpoint.deedDetail(deedId!), body: payload);
        Get.back();
        Get.snackbar("Success", "Post updated successfully!", snackPosition: SnackPosition.BOTTOM);
      } else {
        await _apiClient.post(ApiEndpoint.deeds, body: payload);
        Get.back();
        Get.snackbar("Success", "Post created successfully!", snackPosition: SnackPosition.BOTTOM);
      }
    } on NetworkException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } on HttpException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      debugPrint("Save post error: $e");
      Get.snackbar("Error", "Failed to save post", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    contentController.dispose();
    aiTopicController.dispose();
    super.onClose();
  }
}