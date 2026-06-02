import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/action_button.dart';
import '../../../core/theme/app_color.dart';
import '../controllers/forget_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColor.lightTextColor, size: 20.sp),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // Top Logo Branding & Greeting
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo_text.png',
                      width: 140.w,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Assalamu Alaikum',
                      style: AppTextTheme.bodyTextStyle.copyWith(
                        color: AppColor.lightTextColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 48.h),

              // Page Header Title
              Text(
                'Forget Password',
                style: AppTextTheme.titleTextStyle.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 24.h),

              // Input Field Label
              Text(
                'Email Address',
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: AppColor.lightTextColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 8.h),

              // Email Form Field
              TextFormField(
                controller: controller.emailController,
                style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor),
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextTertiaryColor),
                  fillColor: AppColor.lightSurfaceColor,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: AppColor.primaryColor.withOpacity(0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: AppColor.primaryColor.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColor.primaryColor),
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // Send OTP CTA Button
              ActionButton(
                text: 'Send OTP',
                onPressed: controller.sendOtp,
              )
            ],
          ),
        ),
      ),
    );
  }
}