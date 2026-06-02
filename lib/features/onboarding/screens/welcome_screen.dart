import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:outlive/core/theme/text_theme.dart';

import '../../../core/theme/app_color.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),

              // "AI Powered" Pill Tag
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF421A83),
                        const Color(0xFF1D0F33),
                      ],
                    ),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x46454540),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: AppColor.secondaryColor, size: 14.sp),
                    SizedBox(width: 6.w),
                    Text(
                      'AI Powered',
                      style: AppTextTheme.bodyTextStyle.copyWith(
                        color: AppColor.secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 48.h),

              // Catchphrase
              Text(
                'Where Your Good\nDeeds Outlive You.',
                textAlign: TextAlign.center,
                style: AppTextTheme.titleTextStyle
              ),

              const Spacer(),

              // OutLive Text Branding
              Image.asset(
                'assets/images/logo.png',
                width: 339.w,
                fit: BoxFit.contain,
              ),

              const Spacer(),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed('/login'), // Direct navigation using GetX
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: AppTextTheme.bodyTextStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: OutlinedButton(
                  onPressed: () => Get.toNamed('/signup'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF0E2B14)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: AppTextTheme.bodyTextStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}