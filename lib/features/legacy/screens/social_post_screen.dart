import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import '../../../core/theme/app_color.dart';
import '../controllers/social_post_controller.dart';

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
      ),
      body: SafeArea(
        child: Obx(() {
          // Show loading spinner if fetching data for Edit Mode
          if (controller.isLoading.value && controller.isEditing.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),

                      // Section 1: Select Category Dropdown
                      _buildFieldLabel('Select category'),
                      SizedBox(height: 8.h),
                      Obx(() => _buildDropdownField(
                        value: controller.selectedCategory.value,
                        items: controller.categories,
                        onChanged: (val) => controller.selectedCategory.value = val!,
                      )),

                      SizedBox(height: 20.h),

                      // Section 2: Post Content Box
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

                      // Section 3: Custom File Upload Row Box (Upgraded with Image Preview)
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

                      // Section 4: Schedule This Post Split Row Picker
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

                      // Section 5: Platform Dropdown
                      _buildFieldLabel('Platform'),
                      SizedBox(height: 8.h),
                      Obx(() => _buildDropdownField(
                        value: controller.selectedPlatform.value,
                        items: controller.platforms,
                        onChanged: (val) => controller.selectedPlatform.value = val!,
                      )),

                      SizedBox(height: 20.h),

                      // Section 6: Continue Reward Multi-Segment Row
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

              // Persistent Save Action Button
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
        }),
      ),
    );
  }

  // --- Helper Layout Layout Modules ---

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: AppTextTheme.bodyTextStyle.copyWith(
        color: AppColor.lightTextColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColor.lightSurfaceColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColor.lightSurfaceColor,
          icon: Icon(Icons.arrow_drop_down_rounded, color: AppColor.lightTextTertiaryColor, size: 24.sp),
          style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor, fontSize: 14.sp),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val),
            );
          }).toList(),
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
        decoration: BoxDecoration(
          color: AppColor.lightSurfaceColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
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
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ]
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