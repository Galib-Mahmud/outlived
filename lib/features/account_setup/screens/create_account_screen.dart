import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/action_button.dart';
import 'package:outlive/features/auth/widgets/tab_btn.dart';
import '../../../core/theme/app_color.dart';
import '../controllers/create_account_controller.dart';
import '../widgets/account_setup_appbar.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateAccountController());

    return Scaffold(
      appBar: AccountSetupAppbar(
        title: 'Create Content Account',
        actionText: 'Skip',
        onActionTap: controller.completeSetup,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),

            // Top Tab Toggle Button System
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColor.lightSurfaceColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Obx(() => Row(
                  children: [
                    TabBtn(
                      isActive: controller.selectedTab.value == 0,
                      onTap: () => controller.selectedTab.value = 0,
                      text: 'Facebook',
                    ),
                    TabBtn(
                      isActive: controller.selectedTab.value == 1,
                      onTap: () => controller.selectedTab.value = 1,
                      text: 'Instagram',
                    ),
                  ],
                )),
              ),
            ),

            SizedBox(height: 24.h),

            // Responsive Step List Content View
            Expanded(
              child: Obx(() => AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: controller.selectedTab.value == 0
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: _buildStepList(controller.facebookSteps),
                secondChild: _buildStepList(controller.instagramSteps),
              )),
            ),

            // Bottom Fixed Navigation Action Button
            Obx(() => Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: ActionButton(
                text: controller.selectedTab.value == 0 ? 'Connect Facebook' : 'Connect Instagram',
                onPressed: controller.completeSetup,
              ),
            ))
          ],
        ),
      ),
    );
  }

  // Step List structural helper
  Widget _buildStepList(List<StepItem> steps) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: steps.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = steps[index];
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColor.lightSurfaceColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Header Line Block
              Row(
                children: [
                  Container(
                    width: 24.w,
                    height: 2.h,
                    color: AppColor.primaryColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '${item.stepNumber}${item.titleSuffix ?? ""}',
                    style: AppTextTheme.bodyTextStyle.copyWith(
                      color: AppColor.lightTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              // Structural Labels and Details Rendering Block
              if (item.description != null) ...[
                SizedBox(height: 12.h),
                Text(
                  item.description!,
                  style: AppTextTheme.bodyTextStyle.copyWith(
                    color: AppColor.lightTextSecondaryColor,
                    fontSize: 14.sp,
                  ),
                ),
              ],
              if (item.subLabel != null) ...[
                SizedBox(height: 12.h),
                Text(
                  item.subLabel!,
                  style: AppTextTheme.bodyTextStyle.copyWith(
                    color: AppColor.lightTextSecondaryColor,
                    fontSize: 14.sp,
                  ),
                ),
              ],
              if (item.bulletPoints != null) ...[
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: item.bulletPoints!.map((text) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ', style: TextStyle(color: AppColor.lightTextSecondaryColor, fontSize: 14.sp)),
                          Expanded(
                            child: Text(
                              text,
                              style: AppTextTheme.bodyTextStyle.copyWith(
                                color: AppColor.lightTextSecondaryColor,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
