import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/round_action_btn.dart';
import 'package:outlive/features/legacy/screens/post_detail_screen.dart';
import 'package:outlive/features/legacy/screens/social_post_screen.dart';
import '../../../core/theme/app_color.dart';
import '../controllers/legacy_controller.dart';

class LegacyScreen extends StatelessWidget {
  const LegacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LegacyController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: TextFormField(
                style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor),
                onChanged: (val) => controller.searchQuery.value = val,
                decoration: InputDecoration(
                  hintText: 'Search Legacy',
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

            // 2. Tab Bar Layout Header Row Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColor.lightTextTertiaryColor.withOpacity(0.15),
                      width: 1.h,
                    ),
                  ),
                ),
                child: Obx(
                      () => Row(
                    children: [
                      _buildTabButton(
                        label: 'Previous',
                        isSelected: controller.selectedTab.value == 0,
                        onTap: () => controller.selectedTab.value = 0,
                      ),
                      SizedBox(width: 16.w),
                      _buildTabButton(
                        label: 'Upcoming',
                        isSelected: controller.selectedTab.value == 1,
                        onTap: () => controller.selectedTab.value = 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Dynamic Grouped Message Output List View
            Expanded(
              child: Obx(() {
                final list = controller.filteredMessages;
                final hasNoDeedsAtAll = controller.masterMessages.isEmpty;

                // A. Initial Loading State
                if (controller.isLoading.value && list.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // B. True Empty State (User has absolutely no deeds)
                if (list.isEmpty && hasNoDeedsAtAll) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 80.h),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Your first ongoing deed \nstarts here',
                            style: AppTextTheme.bodyTextStyle.copyWith(
                              color: AppColor.lightTextColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 18.h),
                          RoundActionBtn(
                            onPressed: () {
                              Get.to(() => const SocialPostScreen());
                            },
                            text: 'Start Now',
                          )
                        ],
                      ),
                    ),
                  );
                }

                // C. No Search/Filter Results State
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'No matching results found',
                      style: AppTextTheme.bodyTextStyle.copyWith(
                        color: AppColor.lightTextTertiaryColor,
                        fontSize: 16.sp,
                      ),
                    ),
                  );
                }

                // D. Main List View with Pull-to-Refresh and Pagination
                return RefreshIndicator(
                  onRefresh: () => controller.fetchDeeds(isRefresh: true),
                  color: AppColor.primaryColor,
                  child: ListView.builder(
                    controller: controller.scrollController,
                    // Ensures pull-to-refresh works even if the list is too short to scroll
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: list.length + (controller.isLoadingMore.value ? 1 : 0),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    itemBuilder: (context, index) {

                      // Show loading spinner at the bottom when fetching more pages
                      if (index == list.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final item = list[index];
                      final showHeader = index == 0 || list[index - 1].groupHeader != item.groupHeader;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showHeader) ...[
                            Padding(
                              padding: EdgeInsets.only(bottom: 12.h, top: index == 0 ? 0 : 12.h),
                              child: Text(
                                item.groupHeader,
                                style: AppTextTheme.bodyTextStyle.copyWith(
                                  color: AppColor.lightTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],

                          // Card Module Layout Item
                          InkWell(
                            onTap: () {
                              // Pass the deed ID to the detail screen
                              Get.to(() => PostDetailScreen(deedId: item.id));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: AppColor.lightSurfaceColor,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(color: AppColor.lightBoarderColor.withOpacity(0.04)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top Info Row (WhatsApp Icon indicator & Target Time)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        'assets/icons/whatsapp.png',
                                        width: 20.w,
                                        height: 20.h,
                                      ),
                                      Text(
                                        item.timeText,
                                        style: AppTextTheme.bodyTextStyle.copyWith(
                                          color: AppColor.secondaryColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 16.h),

                                  // Main Message Content Area
                                  Text(
                                    item.content,
                                    style: AppTextTheme.bodyTextStyle.copyWith(
                                      color: AppColor.lightTextColor.withOpacity(0.7),
                                      fontSize: 12.sp,
                                      height: 1.45,
                                    ),
                                  ),

                                  SizedBox(height: 16.h),

                                  // Footer Action Button Badges Group Row
                                  Row(
                                    children: [
                                      _buildFooterChip(item.recipients),
                                      SizedBox(width: 8.w),
                                      _buildFooterChip(item.scheduleType),
                                      const Spacer(),
                                      if (controller.selectedTab.value == 1)
                                        GestureDetector(
                                          onTap: () => controller.deleteMessage(item.id),
                                          child: Container(
                                            padding: EdgeInsets.all(8.r),
                                            decoration: BoxDecoration(
                                              color: Colors.red.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(6.r),
                                            ),
                                            child: Icon(
                                              Icons.delete_outline_rounded,
                                              color: const Color(0xFFD32F2F),
                                              size: 16.sp,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  // --- Layout Helper Modules ---

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
            child: Text(
              label,
              style: AppTextTheme.bodyTextStyle.copyWith(
                color: isSelected ? AppColor.lightTextColor : AppColor.lightTextTertiaryColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          // Active Indicator Line Anchor
          Container(
            height: 2.h,
            width: 72.w,
            color: isSelected ? const Color(0xFFC19A2A) : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColor.lightBackgroundColor,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColor.lightTextTertiaryColor.withOpacity(0.08)),
      ),
      child: Text(
        text,
        style: AppTextTheme.bodyTextStyle.copyWith(
          color: AppColor.lightTextColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}