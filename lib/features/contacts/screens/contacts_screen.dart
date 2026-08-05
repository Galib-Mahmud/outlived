import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import '../../../core/theme/app_color.dart';
import '../controllers/contact_controller.dart'; // Update path correctly

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContactController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: TextFormField(
                style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor),
                onChanged: (value) => controller.searchQuery.value = value,
                decoration: InputDecoration(
                  hintText: 'Search Contact',
                  hintStyle: AppTextTheme.bodyTextStyle.copyWith(
                    color: AppColor.lightTextTertiaryColor,
                    fontSize: 14.sp,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColor.lightTextTertiaryColor, size: 20.sp),
                  fillColor: AppColor.lightSurfaceColor,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Category Metrics Segment
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
              child: Obx(
                    () => Row(
                  children: [
                    _buildMetricCard(
                      count: controller.countMuslim.toString(),
                      label: 'Muslim',
                      isSelected: controller.selectedCategory.value == 'Muslim',
                      onTap: () => controller.toggleCategory('Muslim'),
                    ),
                    SizedBox(width: 12.w),
                    _buildMetricCard(
                      count: controller.countInvite.toString(),
                      label: 'Invite To Islam',
                      isSelected: controller.selectedCategory.value == 'Invite To Islam',
                      onTap: () => controller.toggleCategory('Invite To Islam'),
                    ),
                    SizedBox(width: 12.w),
                    _buildMetricCard(
                      count: controller.countLegacy.toString(),
                      label: 'Legacy Recipient',
                      isSelected: controller.selectedCategory.value == 'Legacy Recipient',
                      onTap: () => controller.toggleCategory('Legacy Recipient'),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Dynamically Filtering Grouped Contacts List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.masterContacts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.value.isNotEmpty && controller.masterContacts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.person_crop_circle_badge_exclam,
                              color: AppColor.lightTextTertiaryColor, size: 36.sp),
                          SizedBox(height: 12.h),
                          Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: AppTextTheme.bodyTextStyle.copyWith(
                              color: AppColor.lightTextTertiaryColor,
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          TextButton(
                            onPressed: controller.likelyPermanentlyDenied.value
                                ? controller.openPermissionSettings
                                : controller.fetchDeviceContacts,
                            child: Text(
                              controller.likelyPermanentlyDenied.value ? 'Open Settings' : 'Retry',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final groups = controller.filteredGroupedContacts;

                if (groups.isEmpty) {
                  return Center(
                    child: Text(
                      'No matching contacts found',
                      style: AppTextTheme.bodyTextStyle.copyWith(
                        color: AppColor.lightTextTertiaryColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchDeviceContacts,
                  child: ListView.builder(
                    itemCount: groups.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, groupIndex) {
                      final group = groups[groupIndex];
                      final List<ContactModel> contactsInGroup = group['contacts'];

                      // FIX 1: Added mainAxisSize: MainAxisSize.min to prevent the RenderFlex overflow
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                            color: AppColor.lightSurfaceColor.withOpacity(0.4),
                            child: Text(
                              group['letter'] as String,
                              style: AppTextTheme.bodyTextStyle.copyWith(
                                color: AppColor.lightTextColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          // FIX 2: Replaced nested ListView with mapped columns for better performance
                          ...contactsInGroup.asMap().entries.map((entry) {
                            final index = entry.key;
                            final contact = entry.value;
                            final isLastItem = index == contactsInGroup.length - 1;

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        contact.name,
                                        style: AppTextTheme.bodyTextStyle.copyWith(
                                          color: AppColor.lightTextColor,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        contact.phone,
                                        style: AppTextTheme.bodyTextStyle.copyWith(
                                          color: AppColor.lightTextTertiaryColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!isLastItem)
                                  Divider(
                                    height: 1.h,
                                    thickness: 1.h,
                                    color: AppColor.lightTextTertiaryColor.withOpacity(0.08),
                                  ),
                              ],
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String count,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 110.w,
      height: 110.h,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 110.w,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.primaryColor.withOpacity(0.1) : AppColor.lightSurfaceColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                count,
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: AppColor.lightTextColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: isSelected ? AppColor.primaryColor : AppColor.lightTextTertiaryColor,
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}