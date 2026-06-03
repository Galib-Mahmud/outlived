import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/action_button.dart';
import 'package:outlive/core/universal_widgets/custom_label.dart';
import 'package:outlive/core/universal_widgets/custom_text_field.dart';
import '../../../core/theme/app_color.dart';
import '../../auth/controllers/reset_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

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
          onPressed: () => Get.back(),
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
              const CustomLabel(text: 'Old Password'),
              SizedBox(height: 8.h),
              Obx(() => CustomTextField(
                controller: controller.passwordController,
                obscureText: controller.obscurePassword.value,
                hintText: 'Enter old password',
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
              const CustomLabel(text: 'New Password'),
              SizedBox(height: 8.h),
              Obx(() => CustomTextField(
                controller: controller.reTypePasswordController,
                obscureText: controller.obscureReTypePassword.value,
                hintText: 'Enter new password',
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

              SizedBox(height: 24.h),
              const CustomLabel(text: 'Re Type Password'),
              SizedBox(height: 8.h),
              Obx(() => CustomTextField(
                // Use a separate controller if available in ResetPasswordController
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

              ActionButton(
                text: 'Confirm',
                onPressed: () {
                  // Implement confirmation logic
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
