import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/app_theme.dart';
import 'package:outlive/core/theme/text_theme.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/universal_widgets/action_button.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Injecting the GetX Controller
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
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  color: AppColor.lightSurfaceColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Obx(
                  () => Row(
                    children: [
                      // Login Tab Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.changeTab(0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: controller.selectedTab.value == 0
                                  ? const Color(0xFF031606)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: controller.selectedTab.value == 0
                                    ? AppColor.primaryColor.withOpacity(0.4)
                                    : Colors.transparent,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Login',
                                style: AppTextTheme.bodyTextStyle.copyWith(
                                  color: controller.selectedTab.value == 0
                                      ? Colors.white
                                      : AppColor.lightTextSecondaryColor,
                                  fontWeight: controller.selectedTab.value == 0
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Sign Up Tab Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.changeTab(1),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: controller.selectedTab.value == 1
                                  ? const Color(0xFF031606)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: controller.selectedTab.value == 1
                                    ? AppColor.primaryColor.withOpacity(0.4)
                                    : Colors.transparent,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Sign Up',
                                style: AppTextTheme.bodyTextStyle.copyWith(
                                  color: controller.selectedTab.value == 1
                                      ? Colors.white
                                      : AppColor.lightTextSecondaryColor,
                                  fontWeight: controller.selectedTab.value == 1
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // Reactive Form Content switching smoothly between tabs
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
        // Email Input Field
        Text(
          'Email Address',
          style: AppTextTheme.bodyTextStyle.copyWith(
            color: AppColor.lightTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller.emailController,
          style: AppTextTheme.bodyTextStyle.copyWith(
            color: AppColor.lightTextColor,
          ),
          decoration: _buildInputDecoration('Enter your email'),
        ),

        SizedBox(height: 24.h),

        // Password Header Area
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password',
              style: AppTextTheme.bodyTextStyle.copyWith(
                color: AppColor.lightTextColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed('/forgot-password'),
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

        // Password Input Field
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

        // Dynamic Error Display
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
            // Trigger Login Logic
          },
        )
      ],
    );
  }

  Widget _buildSignUpForm(LoginController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Input Field
        Text(
          'Email Address',
          style: AppTextTheme.bodyTextStyle.copyWith(
            color: AppColor.lightTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller.emailController,
          style: AppTextTheme.bodyTextStyle.copyWith(
            color: AppColor.lightTextColor,
          ),
          decoration: _buildInputDecoration('Enter your email'),
        ),

        SizedBox(height: 24.h),

        // Password Header Area
        Text(
          'Password',
          style: AppTextTheme.bodyTextStyle.copyWith(
            color: AppColor.lightTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),

        // Password Input Field
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

        Text(
          'Re Type Password',
          style: AppTextTheme.bodyTextStyle.copyWith(
            color: AppColor.lightTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
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

        SizedBox(height: 32.h),

        // Login CTA Button
        ActionButton(
          text: 'Sign Up',
          onPressed: () {
            // Trigger Sign Up Logic
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


