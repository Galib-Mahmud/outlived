import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/action_button.dart';
import 'package:outlive/features/auth/controllers/otp_controller.dart';
import '../../../core/theme/app_color.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpController());

    return Scaffold(
      backgroundColor: AppColor.darkBackgroundColor,
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
                'Enter Your OTP',
                style: AppTextTheme.titleTextStyle.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 24.h),

              // Input Field Label
              Text(
                'Enter Code',
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: AppColor.lightTextColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 16.h),

              // 5-Digit OTP Row Block
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) => SizedBox(
                  width: 56.w,
                  height: 56.h,
                  child: TextFormField(
                    controller: controller.controllers[index],
                    focusNode: controller.focusNodes[index],
                    onChanged: (value) => controller.handleOtpTyping(value, index),
                    style: AppTextTheme.titleTextStyle.copyWith(
                      color: AppColor.lightTextColor,
                      fontSize: 20.sp,
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: '-',
                      hintStyle: AppTextTheme.bodyTextStyle.copyWith(
                        color: AppColor.lightTextTertiaryColor,
                        fontSize: 18.sp,
                      ),
                      fillColor: AppColor.darkSurfaceColor,
                      filled: true,
                      contentPadding: EdgeInsets.zero,
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
                )),
              ),

              SizedBox(height: 36.h),

              // Submit CTA Button
              ActionButton(
                text: 'Verify OTP',
                onPressed: controller.verifyOtp,
              )
            ],
          ),
        ),
      ),
    );
  }
}