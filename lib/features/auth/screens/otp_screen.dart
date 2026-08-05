import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/action_button.dart';
import 'package:outlive/core/universal_widgets/auth_header.dart';
import 'package:outlive/core/universal_widgets/custom_label.dart';
import 'package:outlive/features/auth/controllers/otp_controller.dart';
import '../../../core/theme/app_color.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpController());

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
                'Enter Your OTP',
                style: AppTextTheme.titleTextStyle.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 24.h),
              const CustomLabel(text: 'Enter Code'),
              SizedBox(height: 16.h),

              // 6-Digit OTP Row Block
              Row(
                // mainAxisAlignment is removed because Expanded takes up all available space
                children: List.generate(6, (index) => Expanded(
                  child: Padding(
                    // Adds spacing between boxes, but removes it on the last box
                    padding: EdgeInsets.only(right: index == 5 ? 0 : 8.w),
                    child: SizedBox(
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
                          fillColor: AppColor.lightSurfaceColor,
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
