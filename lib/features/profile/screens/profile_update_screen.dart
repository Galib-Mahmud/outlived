import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/action_button.dart';
import 'package:outlive/core/universal_widgets/custom_label.dart';
import 'package:outlive/core/universal_widgets/custom_text_field.dart';
import 'package:outlive/core/universal_widgets/social_connect_row.dart';
import '../../../core/theme/app_color.dart';
import '../controller/profile_update_controller.dart';

class ProfileUpdateScreen extends StatelessWidget {
  const ProfileUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileUpdateController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Profile Update",
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // Big Centered Profile Image Avatar
                    Center(
                      child: GestureDetector(
                        onTap: controller.pickImage,
                        child: Obx(() {
                          ImageProvider? imageProvider;
                          if (controller.avatarFile.value != null) {
                            imageProvider = FileImage(controller.avatarFile.value!);
                          } else if (controller.currentAvatarUrl.value.isNotEmpty) {
                            imageProvider = NetworkImage(controller.currentAvatarUrl.value);
                          } else {
                            imageProvider = const NetworkImage(
                              'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=400',
                            );
                          }

                          return Stack(
                            children: [
                              Container(
                                width: 140.r,
                                height: 140.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2.w),
                                  ),
                                  child: Icon(Icons.camera_alt, color: Colors.white, size: 20.sp),
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    const CustomLabel(text: 'Name'),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      hintText: 'Full Name',
                      controller: controller.fullNameController,
                    ),

                    SizedBox(height: 20.h),

                    const CustomLabel(text: 'Address'),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      hintText: 'Type here.....',
                      controller: controller.addressController,
                    ),

                    SizedBox(height: 20.h),

                    const CustomLabel(text: 'Upload Image'),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: controller.pickImage,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColor.lightSurfaceColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: AppColor.lightBackgroundColor,
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(color: AppColor.lightBoarderColor),
                              ),
                              child: Text(
                                'Choose your image',
                                style: AppTextTheme.bodyTextStyle.copyWith(
                                  color: AppColor.lightTextSecondaryColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    const CustomLabel(text: 'Social Media link'),
                    SizedBox(height: 12.h),

                    SocialConnectRow(
                      iconPath: 'assets/icons/facebook.png',
                      fallbackIcon: Icons.facebook,
                      iconColor: const Color(0xFF1877F2),
                      buttonText: 'Connect',
                      onTap: controller.connectFacebook,
                    ),
                    SizedBox(height: 12.h),

                    SocialConnectRow(
                      iconPath: 'assets/icons/instagram.png',
                      fallbackIcon: Icons.camera_alt_outlined,
                      iconColor: const Color(0xFFE1306C),
                      buttonText: 'Connect',
                      onTap: controller.connectInstagram,
                    ),
                    SizedBox(height: 12.h),

                    SocialConnectRow(
                      iconPath: 'assets/icons/whatsapp.png',
                      fallbackIcon: Icons.phone_android_rounded,
                      iconColor: const Color(0xFF25D366),
                      buttonText: 'Connect',
                      onTap: controller.connectWhatsApp,
                    ),

                    SizedBox(height: 32.h),

                    Obx(() => ActionButton(
                      text: 'Save Changes',
                      onPressed: controller.isLoading.value ? null : controller.saveChanges,
                    )),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}