import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/app_theme.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/features/account_setup/screens/social_setup_screen.dart';
import 'package:outlive/features/home/screens/home_screen.dart';
import 'package:outlive/features/landing/screens/landing_screen.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/universal_widgets/action_button.dart';
import '../../account_setup/screens/create_account_screen.dart';
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

              // Top Logo Branding & Greeting
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/logo_text.png', width: 140.w),
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

              SizedBox(height: 40.h),

              // Custom Tab Switcher (Login / Sign Up)
              Container(
                width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColor.lightSurfaceColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    TabBtn(
                        controller: controller,
                        index: 0,
                        text: 'Login'
                    ),
                    TabBtn(
                        controller: controller,
                        index: 1,
                        text: 'Sign Up'
                    ),
                  ],
                )
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
            ],
          ),
        ),
      ),
    );
  }

  // --- Sub-Widgets Layout Extensions ---

  Widget _buildLoginForm(LoginController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labal_text('Email Address'),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller.emailController,
          style: AppTextTheme.bodyTextStyle.copyWith(
            color: AppColor.lightTextColor,
          ),
          decoration: _buildInputDecoration('Enter your email'),
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            labal_text('Password'),
            GestureDetector(
              onTap: () => Get.to(ForgotPasswordScreen()),
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
              () => TextFormField(
            controller: controller.passwordController,
            obscureText: controller.obscurePassword.value,
            style: AppTextTheme.bodyTextStyle.copyWith(
              color: AppColor.lightTextColor,
            ),
            decoration: _buildInputDecoration('Enter your password').copyWith(
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
                  'Please enter correct password',
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
        ActionButton(
          text: 'Login',
          onPressed: () {
            Get.to(LandingScreen());
          },
        )
      ],
    );
  }

  Widget _buildSignUpForm(LoginController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labal_text('Email Address'),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller.emailController,
          style: AppTextTheme.bodyTextStyle.copyWith(
            color: AppColor.lightTextColor,
          ),
          decoration: _buildInputDecoration('Enter your email'),
        ),
        SizedBox(height: 24.h),
        labal_text('Password'),
        SizedBox(height: 8.h),
        Obx(
              () => TextFormField(
            controller: controller.passwordController,
            obscureText: controller.obscurePassword.value,
            style: AppTextTheme.bodyTextStyle.copyWith(
              color: AppColor.lightTextColor,
            ),
            decoration: _buildInputDecoration('Enter your password').copyWith(
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
        ),
        SizedBox(height: 16.h),
        labal_text('Re Type Password'),
        SizedBox(height: 8.h),
        Obx(
              () => TextFormField(
            // Consider using a separate reTypePasswordController here
            controller: controller.passwordController,
            obscureText: controller.obscurePassword.value,
            style: AppTextTheme.bodyTextStyle.copyWith(
              color: AppColor.lightTextColor,
            ),
            decoration: _buildInputDecoration('Enter your password').copyWith(
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
        ),
        SizedBox(height: 32.h),
        ActionButton(
          text: 'Sign Up',
          onPressed: () {
            Get.to(CreateAccountScreen());
          },
        ),
        SizedBox(height: 16.h),
        Text(
          'By clicking the “sign up” button, you accept the terms of the Privacy Policy.',
          style: TextStyle(
            fontFamily: FontFamily.sfprodisplay.name,
            color: AppColor.lightTextTertiaryColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Text labal_text(String text) {
    return Text(
      text,
      style: AppTextTheme.bodyTextStyle.copyWith(
        color: AppColor.lightTextColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextTheme.bodyTextStyle.copyWith(
        color: AppColor.lightTextTertiaryColor,
      ),
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
