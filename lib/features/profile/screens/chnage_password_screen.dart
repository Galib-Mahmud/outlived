import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/action_button.dart';
import '../../../core/theme/app_color.dart';
import '../../auth/controllers/reset_password_controller.dart';

class ChnagePasswordScreen extends StatelessWidget {
  const ChnagePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Change Password",
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Password Label & Field
              Text(
                'Old Password',
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
                'New Password',
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
              ActionButton(
                text: 'Confirm',
                onPressed: (){

                },
              )
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