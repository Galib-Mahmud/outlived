import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import '../../../core/theme/app_color.dart';
import '../controllers/upgrade_controller.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpgradeController());

    return Scaffold(
      backgroundColor: AppColor.darkBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 40.h),

                    // Top Logo Branding
                    Center(
                      child: Image.asset(
                        'assets/images/logo_text.png',
                        width: 140.w,
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // Paywall Headline
                    Text(
                      'Upgrade to access premium features',
                      textAlign: TextAlign.center,
                      style: AppTextTheme.bodyTextStyle.copyWith(
                        color: AppColor.lightTextColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Interactive Tiers Container List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.tiers.length,
                      separatorBuilder: (_, __) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final tier = controller.tiers[index];
                        return Obx(() {
                          final isSelected = controller.selectedTierId.value == tier.id;
                          return _buildTierCard(controller, tier, isSelected);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Fixed Navigation Action Button
            Padding(
              padding: EdgeInsets.all(24.w),
              child: SizedBox(
                width: double.infinity,
                height: 56.h,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.processUpgrade,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColor.primaryColor.withOpacity(0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                    height: 24.h,
                    width: 24.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : Text(
                    'Next',
                    style: AppTextTheme.bodyTextStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tier Item Render Layout Builder with Stack-based Badging support
  Widget _buildTierCard(UpgradeController controller, SubscriptionTier tier, bool isSelected) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () => controller.selectTier(tier.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColor.darkSurfaceColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isSelected ? AppColor.primaryColor : AppColor.primaryColor.withOpacity(0.1),
                width: isSelected ? 2.r : 1.r,
              ),
            ),
            child: Row(
              children: [
                // Plan Circular Left Icon
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      tier.iconPath,
                      width: 24.w,
                      height: 24.h,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback fallback icons matching standard asset structures
                        if (tier.id == 'quarterly') return const Icon(Icons.star, color: Colors.amber);
                        if (tier.id == 'annually') return const Icon(Icons.emoji_events, color: Colors.amber);
                        return const Icon(Icons.military_tech, color: Colors.amber);
                      },
                    ),
                  ),
                ),

                SizedBox(width: 14.w),

                // Core Metadata Descriptions Block
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tier.title,
                        style: AppTextTheme.bodyTextStyle.copyWith(
                          color: AppColor.lightTextColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        tier.description,
                        style: AppTextTheme.bodyTextStyle.copyWith(
                          color: AppColor.lightTextTertiaryColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Side Numeric Price Display
                Text(
                  tier.price,
                  style: AppTextTheme.bodyTextStyle.copyWith(
                    color: isSelected ? AppColor.primaryColor : AppColor.lightTextSecondaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Discount Promo Ribbon Badge Position Layer
        if (tier.badgeText != null)
          Positioned(
            top: -10.h,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF2E5A36), // Balanced dark green discount indicator background
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                tier.badgeText!,
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}