import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/features/auth/screens/login_screen.dart';
import 'package:outlive/features/onboarding/screens/onboarding_question_screen.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/universal_widgets/round_action_btn.dart';

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
                  color: AppColor.lightBackgroundColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFFDEDEDE),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x46A6A69B).withOpacity(0.4),
                      blurRadius: 5,
                      offset: const Offset(0, 1),
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
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: AppColor.lightTextColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                )
              ),

              const Spacer(),

              // OutLive Text Branding
              Image.asset(
                'assets/images/logo.png',
                width: 300.w,
                fit: BoxFit.contain,
              ),

              const Spacer(),

              // Login Button
              RoundActionBtn(
                  text: 'Login',
                  onPressed: () => Get.to(LoginScreen())
              ),

              SizedBox(height: 16.h),
              RoundActionBtn(
                  text: 'Sign Up',
                  isOutlined: true,
                  fillColor: AppColor.lightBackgroundColor,
                  textColor: AppColor.primaryColor,
                  onPressed: () => Get.to(OnboardingQuestionScreen())
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

