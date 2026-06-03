import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import '../../../core/theme/app_color.dart';

// Simple lightweight GetX state tracking for Notification Tabs
class NotificationController extends GetxController {
  var selectedTab = 0.obs; // 0 for All, 1 for Unread
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    // Mock data based on image_f49d58.png
    final List<Map<String, dynamic>> notifications = [
      {
        'title': "Today’s Fajr time in 3:55 AM.",
        'time': '1h ago',
        'isPrayer': true,
      },
      {
        'title': 'Your anniversary is today.',
        'time': '1h ago',
        'isPrayer': false,
      },
      {
        'title': "Today’s Johor time in 1:00 PM.",
        'time': '1h ago',
        'isPrayer': true,
      },
      {
        'title': 'Your anniversary is today.',
        'time': '1h ago',
        'isPrayer': false,
      },
      {
        'title': "Today’s Johor time in 1:00 PM.",
        'time': '1h ago',
        'isPrayer': true,
      },
      {
        'title': 'Your anniversary is today.',
        'time': '1h ago',
        'isPrayer': false,
      },
      {
        'title': "Today’s Johor time in 1:00 PM.",
        'time': '1h ago',
        'isPrayer': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Notification",
          style: AppTextTheme.titleTextStyle.copyWith(
            color: AppColor.lightTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
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
        child: Column(
          children: [
            // Custom Sub-Tab Switcher (All / Unread)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: AppColor.lightSurfaceColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Obx(
                      () => Row(
                    children: [
                      _buildTabItem(
                        text: 'All',
                        isSelected: controller.selectedTab.value == 0,
                        onTap: () => controller.selectedTab.value = 0,
                      ),
                      _buildTabItem(
                        text: 'Unread',
                        isSelected: controller.selectedTab.value == 1,
                        onTap: () => controller.selectedTab.value = 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Notifications List
            Obx(
                (){
                  if(controller.selectedTab.value == 0){
                    // Show all notifications
                    return Expanded(
                      child: ListView.separated(
                        itemCount: notifications.length,
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) => Divider(
                          color: AppColor.lightTextTertiaryColor.withOpacity(0.08),
                          height: 1.h,
                          thickness: 1.h,
                        ),
                        itemBuilder: (context, index) {
                          final dynamic item = notifications[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Dynamic Avatar Circle Icon Layout Container
                                Container(
                                  width: 40.r,
                                  height: 40.r,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F2EA), // Soft sage tint background matching image reference
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      item['isPrayer'] as bool
                                          ? Icons.wb_twighlight // Alternate placeholder for prayer notifications
                                          : Icons.calendar_today_outlined, // Alternate placeholder for personal alerts
                                      color: AppColor.primaryColor, // Deep signature brand green
                                      size: 20.sp,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 16.w),

                                // Text Layout Content Block
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'] as String,
                                        style: AppTextTheme.bodyTextStyle.copyWith(
                                          color: AppColor.lightTextColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        item['time'] as String,
                                        style: AppTextTheme.bodyTextStyle.copyWith(
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    // Show only unread notifications (for demo, let's assume all are unread)
                    return Expanded(
                      child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: notification['isPrayer'] ? AppColor.primaryColor : AppColor.secondaryColor,
                              child: Icon(
                                notification['isPrayer'] ? Icons.access_time : Icons.event,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                            title: Text(
                              notification['title'],
                              style: AppTextTheme.bodyTextStyle.copyWith(
                                color: AppColor.lightTextColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              notification['time'],
                              style: AppTextTheme.bodyTextStyle.copyWith(
                                color: AppColor.lightTextSecondaryColor,
                                fontSize: 12.sp,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
            )
          ],
        ),
      ),
    );
  }

  // --- Helper Widget: Individual Tab Buttons Layout ---
  Widget _buildTabItem({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: AppTextTheme.bodyTextStyle.copyWith(
                color: isSelected ? AppColor.lightTextColor : AppColor.lightTextSecondaryColor,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}