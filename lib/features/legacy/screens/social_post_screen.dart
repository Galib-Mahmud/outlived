import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import '../../../core/theme/app_color.dart';
import '../controllers/social_post_controller.dart';
import 'ai_post_preview_screen.dart';

class SocialPostScreen extends StatelessWidget {
  const SocialPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SocialPostController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Obx(() => Text(
          controller.isEditing.value ? "Edit Post" : "Social Media Post",
          style: AppTextTheme.titleTextStyle.copyWith(
            color: AppColor.lightTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        )),
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.lightTextColor,
            size: 18.sp,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(color: AppColor.lightSurfaceColor, shape: BoxShape.circle),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_none_rounded, color: AppColor.lightTextSecondaryColor, size: 20.sp),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Custom Post / AI Generated Post tab switcher ──────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Obx(
                    () => Row(
                  children: [
                    _buildTopTab(
                      label: 'Custom Post',
                      isSelected: controller.selectedTab.value == 0,
                      onTap: () => controller.selectedTab.value = 0,
                    ),
                    SizedBox(width: 24.w),
                    _buildTopTab(
                      label: 'Ai Generated Post',
                      isSelected: controller.selectedTab.value == 1,
                      onTap: () => controller.selectedTab.value = 1,
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1.h, color: AppColor.lightBoarderColor),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.isEditing.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return controller.selectedTab.value == 0
                    ? _CustomPostTab(controller: controller)
                    : _AiGeneratedTab(controller: controller);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTab({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Text(
              label,
              style: AppTextTheme.bodyTextStyle.copyWith(
                color: isSelected ? AppColor.lightTextColor : AppColor.lightTextTertiaryColor,
                fontSize: 15.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Container(
            height: 2.h,
            width: 90.w,
            color: isSelected ? const Color(0xFFC19A2A) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CUSTOM POST TAB — unchanged from the existing implementation
// ═══════════════════════════════════════════════════════════════
class _CustomPostTab extends StatelessWidget {
  final SocialPostController controller;
  const _CustomPostTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                _buildFieldLabel('Select category'),
                SizedBox(height: 8.h),
                Obx(() => _buildDropdownField(
                  value: controller.selectedCategory.value,
                  items: controller.categories,
                  onChanged: (val) => controller.selectedCategory.value = val!,
                )),
                SizedBox(height: 20.h),
                _buildFieldLabel('Post Content'),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: controller.contentController,
                  maxLines: 5,
                  style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor),
                  decoration: InputDecoration(
                    hintText: 'Type your content here...',
                    hintStyle: AppTextTheme.bodyTextStyle.copyWith(
                      color: AppColor.lightTextTertiaryColor.withOpacity(0.6),
                      fontSize: 14.sp,
                    ),
                    fillColor: AppColor.lightSurfaceColor,
                    filled: true,
                    contentPadding: EdgeInsets.all(16.r),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                _buildFieldLabel('Upload'),
                SizedBox(height: 8.h),
                Obx(() {
                  ImageProvider? imageProvider;
                  if (controller.mediaFile.value != null) {
                    imageProvider = FileImage(controller.mediaFile.value!);
                  } else if (controller.mediaUrl.value.isNotEmpty) {
                    imageProvider = NetworkImage(controller.mediaUrl.value);
                  }
                  return GestureDetector(
                    onTap: controller.pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: AppColor.lightSurfaceColor,
                        borderRadius: BorderRadius.circular(10.r),
                        image: imageProvider != null
                            ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                            : null,
                      ),
                      child: imageProvider == null
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, color: AppColor.lightTextTertiaryColor, size: 32.sp),
                            SizedBox(height: 8.h),
                            Text(
                              'Choose your file',
                              style: AppTextTheme.bodyTextStyle.copyWith(
                                color: AppColor.lightTextSecondaryColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                          : null,
                    ),
                  );
                }),
                SizedBox(height: 20.h),
                _buildFieldLabel('Schedule This Post'),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => _buildPickerTile(
                        text: controller.selectedDateText.value,
                        icon: Icons.calendar_today_outlined,
                        onTap: () => controller.pickDate(context),
                      )),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Obx(() => _buildPickerTile(
                        text: controller.selectedTimeText.value,
                        icon: Icons.access_time_rounded,
                        onTap: () => controller.pickTime(context),
                      )),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                _buildFieldLabel('Platform'),
                SizedBox(height: 8.h),
                Obx(() => _buildDropdownField(
                  value: controller.selectedPlatform.value,
                  items: controller.platforms,
                  onChanged: (val) => controller.selectedPlatform.value = val!,
                )),
                SizedBox(height: 20.h),
                _buildFieldLabel('Continue Reward'),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: AppColor.lightSurfaceColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Obx(
                        () => Row(
                      children: [
                        _buildIntervalTab('Daily', controller),
                        _buildIntervalTab('Fridays', controller),
                        _buildIntervalTab('Weekly', controller),
                        _buildIntervalTab('Monthly', controller),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Obx(() => GestureDetector(
            onTap: controller.isLoading.value ? null : controller.savePost,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: controller.isLoading.value
                    ? AppColor.primaryColor.withOpacity(0.5)
                    : AppColor.primaryColor,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Center(
                child: Text(
                  controller.isLoading.value
                      ? 'Saving...'
                      : (controller.isEditing.value ? 'Update Post' : 'Save'),
                  style: AppTextTheme.bodyTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildDropdownField({required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(color: AppColor.lightSurfaceColor, borderRadius: BorderRadius.circular(10.r)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColor.lightSurfaceColor,
          icon: Icon(Icons.arrow_drop_down_rounded, color: AppColor.lightTextTertiaryColor, size: 24.sp),
          style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor, fontSize: 14.sp),
          items: items.map((String val) => DropdownMenuItem<String>(value: val, child: Text(val))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPickerTile({required String text, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(color: AppColor.lightSurfaceColor, borderRadius: BorderRadius.circular(10.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: AppTextTheme.bodyTextStyle.copyWith(
                color: text.contains('/') || text.contains(':')
                    ? AppColor.lightTextColor
                    : AppColor.lightTextTertiaryColor.withOpacity(0.6),
                fontSize: 14.sp,
              ),
            ),
            Icon(icon, color: AppColor.lightTextTertiaryColor.withOpacity(0.6), size: 16.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalTab(String val, SocialPostController controller) {
    final isSelected = controller.selectedRewardInterval.value == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedRewardInterval.value = val,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))]
                : [],
          ),
          child: Center(
            child: Text(
              val,
              style: AppTextTheme.bodyTextStyle.copyWith(
                color: isSelected ? AppColor.lightTextColor : AppColor.lightTextSecondaryColor,
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// AI GENERATED POST TAB — matches the "Ai Generated Post" screenshot
// ═══════════════════════════════════════════════════════════════
class _AiGeneratedTab extends StatelessWidget {
  final SocialPostController controller;
  const _AiGeneratedTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            'What would you like to generate?',
            style: AppTextTheme.bodyTextStyle.copyWith(
              color: AppColor.lightTextColor,
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Obx(() => Column(
            children: controller.aiGenerationTypes.map((type) {
              final isSelected = controller.selectedAiType.value == type;
              final isImageMode = type == 'Image Only' || type == 'Text + Image' || type == 'Text + Video';
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: GestureDetector(
                  onTap: () => controller.selectedAiType.value = type,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: AppColor.lightSurfaceColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isSelected ? AppColor.primaryColor : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          type,
                          style: AppTextTheme.bodyTextStyle.copyWith(
                            color: isImageMode ? AppColor.lightTextTertiaryColor : AppColor.lightTextColor,
                            fontSize: 14.sp,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                        // Confirmed staff-only (403 for app users) — shown
                        // as locked rather than removed, since it's still
                        // part of the requested design.
                        if (isImageMode)
                          Icon(Icons.lock_outline_rounded, size: 14.sp, color: AppColor.lightTextTertiaryColor),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          )),

          SizedBox(height: 12.h),
          Text(
            'Select category',
            style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor, fontWeight: FontWeight.w700, fontSize: 15.sp),
          ),
          SizedBox(height: 8.h),
          Obx(() => Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(color: AppColor.lightSurfaceColor, borderRadius: BorderRadius.circular(10.r)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.aiSelectedCategory.value,
                isExpanded: true,
                hint: Text(
                  'Select a Category',
                  style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextTertiaryColor.withOpacity(0.7), fontSize: 14.sp),
                ),
                dropdownColor: AppColor.lightSurfaceColor,
                icon: Icon(Icons.arrow_drop_down_rounded, color: AppColor.lightTextTertiaryColor, size: 24.sp),
                style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor, fontSize: 14.sp),
                // FIX: was reusing controller.categories (Islamic/General/
                // Reminders) — an unrelated list used by the Custom Post
                // tab's own category field. AI generation has its own real
                // 13-category set confirmed by the backend team.
                items: SocialPostController.aiCategories
                    .map((c) => DropdownMenuItem<String>(value: c['value'], child: Text(c['label']!)))
                    .toList(),
                onChanged: (val) => controller.aiSelectedCategory.value = val,
              ),
            ),
          )),

          SizedBox(height: 20.h),
          Text(
            'Topic (Optional)',
            style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor, fontWeight: FontWeight.w700, fontSize: 15.sp),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller.aiTopicController,
            style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor, fontSize: 14.sp),
            decoration: InputDecoration(
              hintText: 'Type here...',
              hintStyle: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextTertiaryColor.withOpacity(0.6), fontSize: 14.sp),
              fillColor: AppColor.lightSurfaceColor,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
            ),
          ),

          // ── Generated results, shown inline once available ──────────
          Obx(() {
            if (controller.generatedPosts.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(top: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose a generated post',
                    style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor, fontWeight: FontWeight.w700, fontSize: 15.sp),
                  ),
                  SizedBox(height: 10.h),
                  ...controller.generatedPosts.map((text) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: InkWell(
                      onTap: () => Get.to(() => AiPostPreviewScreen(content: text)),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: AppColor.lightSurfaceColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColor.lightBoarderColor),
                        ),
                        child: Text(
                          text,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor.withOpacity(0.85), fontSize: 13.sp, height: 1.4),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            );
          }),

          SizedBox(height: 24.h),
          Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isGenerating.value ? null : controller.generateAiPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.isGenerating.value
                    ? AppColor.primaryColor.withOpacity(0.5)
                    : AppColor.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                elevation: 0,
              ),
              child: Text(
                controller.isGenerating.value ? 'Generating...' : 'Generate',
                style: AppTextTheme.bodyTextStyle.copyWith(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w700),
              ),
            ),
          )),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}