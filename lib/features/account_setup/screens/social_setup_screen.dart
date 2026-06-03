import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/universal_widgets/custom_text_field.dart';
import 'package:outlive/core/universal_widgets/small_action_button.dart';
import 'package:outlive/core/universal_widgets/social_connect_row.dart';
import 'package:outlive/features/home/screens/home_screen.dart';
import 'package:outlive/features/subscription/screens/upgrade_screen.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/universal_widgets/action_button.dart';
import '../controllers/social_setup_controller.dart';
import '../widgets/account_setup_appbar.dart';

class SocialSetupScreen extends StatelessWidget {
  const SocialSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SocialSetupController());

    return Scaffold(
      appBar: AccountSetupAppbar(
        title: 'Create Content Account',
        actionText: 'Skip',
        onActionTap: () => Get.to(() => const UpgradeScreen()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  children: [
                    // --- Facebook Row ---
                    Obx(() => SocialConnectRow(
                      iconPath: 'assets/icons/facebook.png',
                      buttonText: controller.isFacebookConnected.value ? 'Connected' : 'Connect',
                      isConnected: controller.isFacebookConnected.value,
                      onTap: controller.connectFacebook,
                    )),

                    SizedBox(height: 16.h),

                    // --- Instagram Row ---
                    Obx(() => SocialConnectRow(
                      iconPath: 'assets/icons/instagram.png',
                      buttonText: controller.isInstagramConnected.value ? 'Connected' : 'Connect',
                      isConnected: controller.isInstagramConnected.value,
                      onTap: controller.connectInstagram,
                    )),

                    SizedBox(height: 16.h),

                    // --- WhatsApp Input Row ---
                    Row(
                      children: [
                        _buildSocialIconBox('assets/icons/whatsapp.png'),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: controller.whatsappController,
                                  hintText: 'Enter WhatsApp number',
                                  keyboardType: TextInputType.phone,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Obx(() => SmallActionButton(
                                text: controller.isWhatsAppConnected.value ? 'Connected' : 'Connect',
                                isConnected: controller.isWhatsAppConnected.value,
                                onTap: controller.connectWhatsApp,
                                width: 90.w,
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // --- Bottom Navigation Button ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: ActionButton(
                text: 'Complete Setup',
                onPressed: () => Get.to(() => const HomeScreen()),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Helper template for social channel brand labels on left side
  Widget _buildSocialIconBox(String assetPath) {
    return Container(
      width: 72.w, // Standardized with SocialConnectRow
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColor.lightSurfaceColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              width: 24.w,
              height: 24.h,
              errorBuilder: (context, error, stackTrace) {
                if (assetPath.contains('whatsapp')) return const Icon(Icons.phone, color: Colors.green);
                return const Icon(Icons.link, color: AppColor.primaryColor);
              },
            ),
            SizedBox(width: 4.w),
            Icon(Icons.arrow_drop_down_rounded, color: AppColor.lightTextTertiaryColor, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
