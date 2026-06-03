import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/features/account_setup/controllers/create_account_controller.dart';
import 'package:outlive/features/home/screens/home_screen.dart';
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
        onActionTap:(){
          Get.to(HomeScreen());
        }
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
                    Row(
                      children: [
                        _buildSocialIconBox('assets/icons/facebook.png'), // Replace with your asset paths
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Obx(() => _buildActionButton(
                            text: controller.isFacebookConnected.value ? 'Connected' : 'Connect',
                            isConnected: controller.isFacebookConnected.value,
                            onTap: controller.connectFacebook,
                          )),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // --- Instagram Row ---
                    Row(
                      children: [
                        _buildSocialIconBox('assets/icons/instagram.png'),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Obx(() => _buildActionButton(
                            text: controller.isInstagramConnected.value ? 'Connected' : 'Connect',
                            isConnected: controller.isInstagramConnected.value,
                            onTap: controller.connectInstagram,
                          )),
                        ),
                      ],
                    ),

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
                                child: SizedBox(
                                  height: 48.h,
                                  child: TextFormField(
                                    controller: controller.whatsappController,
                                    style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor, fontSize: 14.sp),
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: 'Enter WhatsApp number',
                                      hintStyle: AppTextTheme.bodyTextStyle.copyWith(
                                        color: AppColor.lightTextTertiaryColor.withOpacity(0.4),
                                        fontSize: 14.sp,
                                      ),
                                      fillColor: AppColor.lightSurfaceColor,
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
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
                              SizedBox(width: 8.w),
                              Obx(() => _buildActionButton(
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
                onPressed: (){
                  Get.to(HomeScreen());
                }
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
      width: 56.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColor.lightSurfaceColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetPath, width: 24.w, height: 24.h, errorBuilder: (context, error, stackTrace) {
              // Fallback placeholder icons in case local network assets are initializing
              if (assetPath.contains('facebook')) return const Icon(Icons.facebook, color: Colors.blue);
              if (assetPath.contains('whatsapp')) return const Icon(Icons.phone, color: Colors.green);
              return const Icon(Icons.camera_alt, color: Colors.pink);
            }),
            SizedBox(width: 2.w),
            Icon(Icons.arrow_drop_down, color: AppColor.lightTextTertiaryColor, size: 16.sp),
          ],
        ),
      ),
    );
  }

  // Reusable custom buttons to avoid repetitive decoration declarations
  Widget _buildActionButton({
    required String text,
    required bool isConnected,
    required VoidCallback onTap,
    double? width,
  }) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isConnected ? Colors.blueGrey.withOpacity(0.3) : AppColor.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          text,
          style: AppTextTheme.bodyTextStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}