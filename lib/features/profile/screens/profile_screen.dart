import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/app_theme.dart';
import 'package:outlive/core/theme/text_theme.dart';
import '../../../core/theme/app_color.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Header Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: AppColor.lightSurfaceColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColor.lightBoarderColor , width: 1.w)
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: AppColor.lightTextTertiaryColor.withOpacity(0.2),
                      backgroundImage: const NetworkImage(
                        'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=400', // Placeholder match
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kurt Cobain',
                            style: AppTextTheme.bodyTextStyle.copyWith(
                              color: AppColor.lightTextColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Kurtcobain@email.com',
                            style: AppTextTheme.bodyTextStyle.copyWith(
                              color: AppColor.lightTextTertiaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Active Status Tag
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color:AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Active',
                        style: AppTextTheme.bodyTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // --- Group 1: Profile Settings ---
              _buildSettingsGroup(
                title: 'Profile',
                children: [
                  _buildMenuRow(
                    label: 'Profile Update',
                    onTap: () => Get.toNamed('/profile-update'),
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuRow(
                    label: 'Create Content Account',
                    onTap: () => Get.toNamed('/create-content'),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // --- Group 2: Account Settings ---
              _buildSettingsGroup(
                title: 'Account',
                children: [
                  _buildMenuRow(
                    label: 'Change Password',
                    onTap: () => Get.toNamed('/change-password'),
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuRow(
                    label: 'Delete Account',
                    onTap: () => Get.toNamed('/delete-account'),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // --- Group 3: More Settings ---
              _buildSettingsGroup(
                title: 'More',
                children: [
                  _buildMenuRowWithToggle(
                    label: 'Daily Prayer Remainder',
                    value: true, // Use controller.isPrayerReminderEnabled.value with Obx dynamically
                    onChanged: (val) {},
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuRowWithToggle(
                    label: 'Notification Preferences',
                    value: false,
                    onChanged: (val) {},
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuRow(
                    label: 'Terms & Conditions',
                    onTap: () => Get.toNamed('/terms'),
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuRow(
                    label: 'Privacy Policy',
                    onTap: () => Get.toNamed('/privacy'),
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuRow(
                    label: "Faq's",
                    onTap: () => Get.toNamed('/faqs'),
                  ),
                ],
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  // --- Layout Component Helpers ---

  Widget _buildSettingsGroup({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.lightSurfaceColor,
        borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColor.lightBoarderColor , width: 1.w)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextTheme.bodyTextStyle.copyWith(
              color: AppColor.lightTextColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMenuRow({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColor.lightBackgroundColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextTheme.bodyTextStyle.copyWith(
                color: AppColor.lightTextColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColor.lightTextColor,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuRowWithToggle({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.lightBackgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextTheme.bodyTextStyle.copyWith(
              color: AppColor.lightTextColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          CustomSwitch(
            value: value,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}


class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const trackWidth = 48.0;
    const trackHeight = 18.0;
    const thumbSize = 28.0;
    const trackColor = Color(0xFF6B7280);

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: SizedBox(
        width: trackWidth + (thumbSize - trackHeight), // extra space for overflow
        height: thumbSize, // height = thumb size so it doesn't clip
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Track — vertically centered
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: trackWidth,
                height: trackHeight,
                decoration: BoxDecoration(
                  color: trackColor,
                  borderRadius: BorderRadius.circular(trackHeight / 2),
                ),
              ),
            ),
            // Thumb — bigger, overflows track top & bottom
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? trackWidth - thumbSize : 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: thumbSize,
                height: thumbSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: trackColor,
                    width: 3.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
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