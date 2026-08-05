import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/features/account_setup/screens/create_account_screen.dart';
import 'package:outlive/features/profile/screens/change_password_screen.dart';
import 'package:outlive/features/profile/screens/privacy_policy_screen.dart';
import 'package:outlive/features/profile/screens/profile_update_screen.dart';
import 'package:outlive/features/profile/screens/terms_conditions_screen.dart';
import '../../../core/theme/app_color.dart';
import '../controller/profile_controller.dart';
import '../widgets/custom_switch.dart';
import '../widgets/delete_bottom_sheet.dart';
import 'faq_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Header Card
              Obx(() => Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                    color: AppColor.lightSurfaceColor,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColor.lightBoarderColor, width: 1.w)
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: AppColor.lightTextTertiaryColor.withOpacity(0.2),
                      backgroundImage: controller.avatarUrl.value.isNotEmpty
                          ? NetworkImage(controller.avatarUrl.value)
                          : const NetworkImage('https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=400'),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.fullName.value,
                            style: AppTextTheme.bodyTextStyle.copyWith(
                              color: AppColor.lightTextColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            controller.email.value,
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
                    if (controller.isSubscriptionActive.value)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
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
              )),

              SizedBox(height: 20.h),

              // --- Group 1: Profile Settings ---
              _buildSettingsGroup(
                title: 'Profile',
                children: [
                  _buildMenuRow(
                      label: 'Profile Update',
                      onTap: () => Get.to(() => const ProfileUpdateScreen())
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuRow(
                    label: 'Create Content Account',
                    onTap: () => Get.to(() => CreateAccountScreen(isFromSettings: true)),
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
                      onTap: () => Get.to(() => const ChangePasswordScreen())
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuRow(
                    label: 'Logout',
                    onTap: () => _showLogoutDialog(controller),
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuRow(
                    label: 'Delete Account',
                    onTap: () => _showDeleteDialog(controller),
                    textColor: Colors.red, // Visual cue for destructive action
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // --- Group 3: More Settings ---
              _buildSettingsGroup(
                title: 'More',
                children: [
                  // Obx(() => _buildMenuRowWithToggle(
                  //   label: 'Daily Prayer Remainder',
                  //   value: controller.isPrayerReminderEnabled.value,
                  //   onChanged: controller.togglePrayerReminder,
                  // )),
                  SizedBox(height: 12.h),
                  // Obx(() => _buildMenuRowWithToggle(
                  //   label: 'Notification Preferences',
                  //   value: controller.isPushNotificationEnabled.value,
                  //   onChanged: controller.togglePushNotifications,
                  // )),
                  SizedBox(height: 12.h),
                  _buildMenuRow(
                      label: 'Terms & Conditions',
                      onTap: () => Get.to(() => const TermsConditionsScreen())
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuRow(
                      label: 'Privacy Policy',
                      onTap: () => Get.to(() => const PrivacyPolicyScreen())
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuRow(
                      label: "Faq's",
                      onTap: () => Get.to(() => const FAQScreen())
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Dialogs for Destructive Actions ---

  void _showLogoutDialog(ProfileController controller) {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      textConfirm: "Logout",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Close dialog
        controller.logout();
      },
    );
  }

  void _showDeleteDialog(ProfileController controller) {
    Get.defaultDialog(
      title: "Delete Account",
      middleText: "This action cannot be undone. All your data will be permanently deleted. Are you sure?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back(); // Close dialog
        controller.deleteAccount();
      },
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
          border: Border.all(color: AppColor.lightBoarderColor, width: 1.w)
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

  Widget _buildMenuRow({required String label, required VoidCallback onTap, Color? textColor}) {
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
                color: textColor ?? AppColor.lightTextColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: textColor ?? AppColor.lightTextColor,
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