import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import '../../../core/theme/app_color.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "FAQ's",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scrollable Legal Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Intro Paragraph
                    _buildBodyText(
                      'This Privacy Policy describes how we collect, use, and protect your information when you use our Money Management App ("we," "our," or "us"). By using the app, you agree to this policy.',
                    ),

                    SizedBox(height: 24.h),

                    // Section 1: Information We Collect
                    _buildSectionHeader('Information We Collect'),
                    SizedBox(height: 12.h),
                    _buildBulletPoint('Personal details such as your name, email, and phone number.'),
                    _buildBulletPoint('Financial data you enter manually, such as income, expenses, and savings goals.'),
                    _buildBulletPoint('Device information (for performance and analytics).'),

                    SizedBox(height: 24.h),

                    // Section 2: How We Use Your Data
                    _buildSectionHeader('How We Use Your Data'),
                    SizedBox(height: 12.h),
                    _buildBulletPoint('To track and visualize your spending and income.'),
                    _buildBulletPoint('To personalize insights, reminders, and budgeting tips.'),
                    _buildBulletPoint('To improve app performance and user experience.'),

                    SizedBox(height: 24.h),

                    // Section 3: Data Security
                    _buildSectionHeader('Data Security'),
                    SizedBox(height: 12.h),
                    _buildBodyText(
                      'We use encryption and secure storage to keep your information safe. Your data is never sold to third parties.',
                    ),

                    SizedBox(height: 24.h),

                    // Section 4: Third-Party Services
                    _buildSectionHeader('Third-Party Services'),
                    SizedBox(height: 12.h),
                    _buildBodyText(
                      'Some app features may integrate with secure third-party services (like Google or Apple Sign-In). We never share your financial data without your consent.',
                    ),

                    SizedBox(height: 24.h),

                    // Section 5: Your Control
                    _buildSectionHeader('Your Control'),
                    SizedBox(height: 12.h),
                    _buildBodyText(
                      'You can delete your account and all data anytime from Settings → Delete Account.',
                    ),

                    SizedBox(height: 40.h), // Bottom buffer space for comfortable reading
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widget: Section Titles ---
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextTheme.titleTextStyle.copyWith(
        color: AppColor.lightTextColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
        fontStyle: FontStyle.italic, // Matches the styled slant header text in reference image
      ),
    );
  }

  // --- Helper Widget: Standard Body Text ---
  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: AppTextTheme.bodyTextStyle.copyWith(
        color: AppColor.lightTextColor,
        height: 1.45,
      ),
    );
  }

  // --- Helper Widget: Bullet Lists Layout ---
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Bullet Indicator Symbol
          Padding(
            padding: EdgeInsets.only(top: 6.h, right: 8.w),
            child: Container(
              width: 5.r,
              height: 5.r,
              decoration: BoxDecoration(
                color: AppColor.lightTextColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content text description
          Expanded(
            child: Text(
              text,
              style: AppTextTheme.bodyTextStyle.copyWith(
                color: AppColor.lightTextColor,
                fontSize: 16.sp,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}