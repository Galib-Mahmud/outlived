
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/app_color.dart';
import '../../../core/theme/text_theme.dart';

class DeleteBottomSheet extends StatelessWidget {
  const DeleteBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColor.lightSurfaceColor, // Or use the specific background container tone if needed
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, // Left aligned matching the design
        children: [
          // Title Text
          Text(
            'Delete Account?',
            style: AppTextTheme.bodyTextStyle.copyWith(
              color: AppColor.lightTextColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 8.h),

          // Subtitle Warning Text
          Text(
            'This action is permanent and cannot be undone.',
            style: AppTextTheme.bodyTextStyle.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),

          SizedBox(height: 24.h),

          // Action Buttons Layout
          Row(
            children: [
              // Cancel Button (Left - Dark Green Accent)
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor, // Using your brand's deep primary green color
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        'No, Cancel',
                        style: AppTextTheme.bodyTextStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Delete Button (Right - Red Destructive Accent)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // TODO: Implement your account deletion endpoint trigger logic
                    Get.back(); // Dismisses bottom sheet
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD32F2F), // Standard warning/destructive red
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        'Yes, Delete',
                        style: AppTextTheme.bodyTextStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h), // Ensures healthy padding separation from device bottom system bar
        ],
      ),
    );
  }
}

