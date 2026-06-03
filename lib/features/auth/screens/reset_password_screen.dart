import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/action_button.dart';
import 'package:outlive/core/universal_widgets/auth_header.dart';
import 'package:outlive/core/universal_widgets/custom_label.dart';
import 'package:outlive/core/universal_widgets/custom_text_field.dart';
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
              const AuthHeader(),
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
              const CustomLabel(text: 'Password'),
              SizedBox(height: 8.h),
              Obx(() => CustomTextField(
                controller: controller.passwordController,
                obscureText: controller.obscurePassword.value,
                hintText: 'Enter new password',
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
              )),

              SizedBox(height: 24.h),
              const CustomLabel(text: 'Re Type Password'),
              SizedBox(height: 8.h),
              Obx(() => CustomTextField(
                controller: controller.reTypePasswordController,
                obscureText: controller.obscureReTypePassword.value,
                hintText: 'Re-type your password',
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
              )),

              SizedBox(height: 36.h),

              // Confirm CTA Button
              Obx(() => ActionButton(
                text: 'Confirm',
                isLoading: controller.isLoading.value,
                onPressed: controller.handlePasswordConfirm,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
