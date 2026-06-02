import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import '../../../core/theme/app_color.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController());

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

              // Page Title
              Text(
                'Reset Your Password',
                style: AppTextTheme.titleTextStyle.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 24.h),

              // Password Label & Field
              Text(
                'Password',
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: AppColor.lightTextColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(() => TextFormField(
                controller: controller.passwordController,
                obscureText: controller.obscurePassword.value,
                style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor),
                decoration: _buildInputDecoration('Enter new password').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscurePassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColor.lightTextTertiaryColor,
                      size: 20.sp,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              )),

              SizedBox(height: 24.h),

              // Re Type Password Label & Field
              Text(
                'Re Type Password',
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: AppColor.lightTextColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(() => TextFormField(
                controller: controller.reTypePasswordController,
                obscureText: controller.obscureReTypePassword.value,
                style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor),
                decoration: _buildInputDecoration('Re-type your password').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscureReTypePassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColor.lightTextTertiaryColor,
                      size: 20.sp,
                    ),
                    onPressed: controller.toggleReTypePasswordVisibility,
                  ),
                ),
              )),

              SizedBox(height: 36.h),

              // Confirm CTA Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.handlePasswordConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColor.primaryColor.withOpacity(0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                    height: 24.h,
                    width: 24.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : Text(
                    'Confirm',
                    style: AppTextTheme.bodyTextStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
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
    );
  }
}