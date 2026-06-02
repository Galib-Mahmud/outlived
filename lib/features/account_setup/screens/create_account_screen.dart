import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import '../../../core/theme/app_color.dart';
import '../controllers/create_account_controller.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateAccountController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColor.lightTextColor, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Create Content Account',
          style: AppTextTheme.bodyTextStyle.copyWith(
            color: AppColor.lightTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Get.toNamed('/next_route'),
            child: Text(
              'SKIP',
              style: AppTextTheme.bodyTextStyle.copyWith(
                color: AppColor.secondaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
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
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  color: AppColor.lightSurfaceColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Obx(() => Row(
                  children: [
                    _buildTabButton(controller, title: 'Facebook', index: 0),
                    _buildTabButton(controller, title: 'Instagram', index: 1),
                  ],
                )),
              ),
            ),

            SizedBox(height: 24.h),

            // Responsive Step List Content View
            Expanded(
              child: Obx(() => AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: controller.selectedTab.value == 0
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: _buildStepList(controller.facebookSteps),
                secondChild: _buildStepList(controller.instagramSteps),
              )),
            ),

            // Bottom Fixed Navigation Action Button
            Padding(
              padding: EdgeInsets.all(24.w),
              child: SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    // Action logic when proceeding
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: AppTextTheme.bodyTextStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tab Item Builder helper method
  Widget _buildTabButton(CreateAccountController controller, {required String title, required int index}) {
    final isSelected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF031606) : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected ? AppColor.primaryColor.withOpacity(0.4) : Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: AppTextTheme.bodyTextStyle.copyWith(
                color: isSelected ? AppColor.lightTextColor : AppColor.lightTextSecondaryColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
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