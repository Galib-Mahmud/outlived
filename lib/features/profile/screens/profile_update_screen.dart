import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/action_button.dart';
import '../../../core/theme/app_color.dart';

class ProfileUpdateScreen extends StatelessWidget {
  const ProfileUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Optional: Connect your existing controller handling text edits and image picking
    // final controller = Get.put(ProfileUpdateController());

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
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // Big Centered Profile Image Avatar
                    Center(
                      child: Container(
                        width: 140.r,
                        height: 140.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=400', // Matches the profile references
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Input 1: Name
                    _buildFieldLabel('Name'),
                    SizedBox(height: 8.h),
                    TextFormField(
                      style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor),
                      decoration: _buildInputDecoration('Full Name'),
                    ),

                    SizedBox(height: 20.h),

                    // Input 2: Address
                    _buildFieldLabel('Address'),
                    SizedBox(height: 8.h),
                    TextFormField(
                      style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor),
                      decoration: _buildInputDecoration('Type here.....'),
                    ),

                    SizedBox(height: 20.h),

                    // Input 3: Upload Image File Box
                    _buildFieldLabel('Upload Image'),
                    SizedBox(height: 8.h),
                    Container(
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

                    SizedBox(height: 20.h),

                    // Input 4: Social Media Link Matrix Rows
                    _buildFieldLabel('Social Media link'),
                    SizedBox(height: 12.h),

                    // Row A: Facebook
                    _buildSocialConnectRow(
                      iconPath: 'assets/icons/facebook.png', // Fallback to icons if needed
                      fallbackIcon: Icons.facebook,
                      iconColor: const Color(0xFF1877F2),
                    ),
                    SizedBox(height: 12.h),

                    // Row B: Instagram
                    _buildSocialConnectRow(
                      iconPath: 'assets/icons/instagram.png',
                      fallbackIcon: Icons.camera_alt_outlined,
                      iconColor: const Color(0xFFE1306C),
                    ),
                    SizedBox(height: 12.h),

                    // Row C: WhatsApp
                    _buildSocialConnectRow(
                      iconPath: 'assets/icons/whatsapp.png',
                      fallbackIcon: Icons.phone_android_rounded,
                      iconColor: const Color(0xFF25D366),
                    ),

                    SizedBox(height: 32.h),

                    // Save Action Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: ActionButton(
                        text: 'Save Changes',
                      )
                    ),
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

  // --- Helper Layout Elements ---

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
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
      hintStyle: AppTextTheme.bodyTextStyle,
      fillColor: AppColor.lightSurfaceColor,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AppColor.primaryColor, width: 1),
      ),
    );
  }

  Widget _buildSocialConnectRow({
    required String iconPath,
    required IconData fallbackIcon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        // Dropdown Style Social Indicator
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColor.lightSurfaceColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Safe Image Asset or standard fallback icon hook
              Icon(
                fallbackIcon,
                color: iconColor,
                size: 24.sp,
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.arrow_drop_down_rounded,
                color: AppColor.lightTextTertiaryColor,
                size: 20.sp,
              ),
            ],
          ),
        ),

        SizedBox(width: 12.w),

        // Connect Button Block
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Trigger social auth linking
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  'Connect',
                  style: AppTextTheme.bodyTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}