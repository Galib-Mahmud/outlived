import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/action_button.dart';
import 'package:outlive/core/universal_widgets/auth_header.dart';
import 'package:outlive/core/universal_widgets/custom_label.dart';
import 'package:outlive/core/universal_widgets/custom_text_field.dart';
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
              const AuthHeader(),
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
              const CustomLabel(text: 'Email Address'),
              SizedBox(height: 8.h),
              // Email Form Field
              CustomTextField(
                controller: controller.emailController,
                hintText: 'Enter your email',
              ),
              SizedBox(height: 32.h),
              // Send OTP CTA Button — now disables + reflects isLoading so a
              // slow network can't cause a double-tap double-submit.
              Obx(
                    () => ActionButton(
                  text: controller.isLoading.value ? 'Sending...' : 'Send OTP',
                  onPressed: controller.isLoading.value ? null : controller.sendOtp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}