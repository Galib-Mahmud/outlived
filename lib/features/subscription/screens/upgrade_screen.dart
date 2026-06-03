import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/features/status/screens/status_screen.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/universal_widgets/action_button.dart';
import '../../home/screens/home_screen.dart';
import '../controllers/upgrade_controller.dart';

class UpgradeScreen extends StatelessWidget {
  const
  UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpgradeController());

    return Scaffold(
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
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: ActionButton(
                  text: 'Continue',
                  onPressed: (){
                    Get.to(StatusScreen());
                  }
              ),
            )
          ],
        ),
      ),
    );
  }

  // Tier Item Render Layout Builder with Stack-based Badging support
  Widget _buildTierCard(
      UpgradeController controller,
      SubscriptionTier tier,
      bool isSelected,
      ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () => controller.selectTier(tier.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 18.h,
            ),
            decoration: BoxDecoration(
              color: AppColor.lightSurfaceColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isSelected
                    ? AppColor.primaryColor
                    : AppColor.primaryColor.withOpacity(0.1),
                width: isSelected ? 4.r : 1.r,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Plan Icon
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(tier.iconPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(width: 16.w),

                /// Text Area
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.bodyTextStyle.copyWith(
                          color: AppColor.lightTextTertiaryColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 12.w),

                /// Price
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    tier.price,
                    textAlign: TextAlign.end,
                    style: AppTextTheme.bodyTextStyle.copyWith(
                      color: isSelected
                          ? AppColor.primaryColor
                          : AppColor.lightTextSecondaryColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// Badge
        if (tier.badgeText != null)
          Positioned(
            top: -10.h,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF2E5A36),
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