import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import '../../../core/theme/app_color.dart';
import '../controllers/status_controller.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StatusController());

    return Scaffold(
      backgroundColor: AppColor.darkBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // --- Concentric Success Checkmark Ring System ---
              Center(
                child: Container(
                  width: 140.w,
                  height: 140.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00FF87).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 110.w,
                      height: 110.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00FF87).withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 86.w,
                          height: 86.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00C853), // Core vibrant confirmation green
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 44.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              // --- Headline Statement Text ---
              Text(
                'Payment Success!',
                textAlign: TextAlign.center,
                style: AppTextTheme.titleTextStyle.copyWith(
                  color: AppColor.lightTextColor,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),

              SizedBox(height: 12.h),

              // --- Supporting Sub-label Description ---
              Text(
                'Your payment has been successfully done.',
                textAlign: TextAlign.center,
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: AppColor.lightTextSecondaryColor.withOpacity(0.7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(flex: 4),

              // --- Bottom Outlined Explore CTA Action Button ---
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: OutlinedButton(
                  onPressed: controller.navigateToHome,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppColor.primaryColor.withOpacity(0.25),
                      width: 1.r,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  child: Text(
                    'Explore Now',
                    style: AppTextTheme.bodyTextStyle.copyWith(
                      color: AppColor.lightTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}