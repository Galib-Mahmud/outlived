import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/auth_header.dart';
import 'package:outlive/core/universal_widgets/custom_label.dart';
import 'package:outlive/core/universal_widgets/custom_text_field.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/universal_widgets/action_button.dart';
import '../controllers/facebook_controller.dart';
import '../controllers/login_controller.dart';
import '../widgets/tab_btn.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              const AuthHeader(),
              SizedBox(height: 40.h),

              // Custom Tab Switcher (Login / Sign Up)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColor.lightSurfaceColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Obx(
                      () => Row(
                    children: [
                      TabBtn(
                        isActive: controller.selectedTab.value == 0,
                        onTap: () => controller.selectedTab.value = 0,
                        text: 'Login',
                      ),
                      TabBtn(
                        isActive: controller.selectedTab.value == 1,
                        onTap: () => controller.selectedTab.value = 1,
                        text: 'Sign Up',
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // Reactive Form Content
              Obx(() {
                if (controller.selectedTab.value == 0) {
                  return _buildLoginForm(controller);
                } else {
                  return _buildSignUpForm(controller);
                }
              }),

              // Facebook sign-in is offered on both tabs, since it serves
              // as either login or signup depending on whether the backend
              // reports the account as newly created.
              SizedBox(height: 24.h),
              _buildDivider(),
              SizedBox(height: 20.h),
              const _FacebookLoginButton(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColor.lightBoarderColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'OR',
            style: AppTextTheme.bodyTextStyle.copyWith(
              color: AppColor.lightTextTertiaryColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColor.lightBoarderColor)),
      ],
    );
  }

  // --- Sub-Widgets Layout Extensions ---

  Widget _buildLoginForm(LoginController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomLabel(text: 'Email Address'),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: controller.emailController,
          hintText: 'Enter your email',
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomLabel(text: 'Password'),
            GestureDetector(
              onTap: () => Get.to(() => const ForgotPasswordScreen()),
              child: Text(
                'Forgot Password?',
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: AppColor.primaryColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Obx(
              () => CustomTextField(
            controller: controller.passwordController,
            hintText: 'Enter your password',
            obscureText: controller.obscurePassword.value,
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
        ),
        Obx(
              () => controller.hasError.value
              ? Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: const Color(0xFFD32F2F),
                  size: 16.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Please enter correct email and password',
                  style: AppTextTheme.bodyTextStyle.copyWith(
                    color: const Color(0xFFD32F2F),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
              : const SizedBox.shrink(),
        ),
        SizedBox(height: 32.h),
        Obx(
              () => ActionButton(
            text: controller.isLoading.value ? 'Logging in...' : 'Login',
            onPressed: controller.isLoading.value ? null : controller.login,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm(LoginController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomLabel(text: 'Full Name'),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: controller.fullNameController,
          hintText: 'Enter your full name',
        ),
        SizedBox(height: 24.h),

        const CustomLabel(text: 'Email Address'),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: controller.signUpEmailController,
          hintText: 'Enter your email',
        ),
        SizedBox(height: 24.h),

        const CustomLabel(text: 'Password'),
        SizedBox(height: 8.h),
        Obx(
              () => CustomTextField(
            controller: controller.signUpPasswordController,
            obscureText: controller.obscurePassword.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.obscurePassword.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
            hintText: '',
          ),
        ),
        SizedBox(height: 16.h),

        const CustomLabel(text: 'Re Type Password'),
        SizedBox(height: 8.h),
        Obx(
              () => CustomTextField(
            controller: controller.signUpRePasswordController,
            obscureText: controller.obscureReTypePassword.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.obscureReTypePassword.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: controller.toggleReTypePasswordVisibility,
            ),
            hintText: '',
          ),
        ),
        SizedBox(height: 32.h),
        Obx(
              () => ActionButton(
            text: controller.isLoading.value ? 'Signing up...' : 'Sign Up',
            onPressed: controller.isLoading.value ? null : controller.signUp,
          ),
        ),
      ],
    );
  }
}

class _FacebookLoginButton extends StatelessWidget {
  const _FacebookLoginButton();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FacebookAuthController());

    return Obx(
          () => SizedBox(
        width: double.infinity,
        height: 50.h,
        child: OutlinedButton(
          onPressed: controller.isLoading.value ? null : controller.loginWithFacebook,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColor.lightBoarderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: controller.isLoading.value
              ? SizedBox(
            width: 20.w,
            height: 20.h,
            child: const CircularProgressIndicator(strokeWidth: 2),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.facebook, color: const Color(0xFF1877F2), size: 20.sp),
              SizedBox(width: 10.w),
              Text(
                'Continue with Facebook',
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: AppColor.lightTextColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}