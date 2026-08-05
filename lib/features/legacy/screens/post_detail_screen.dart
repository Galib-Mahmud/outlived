import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/round_action_btn.dart';
import '../../../core/theme/app_color.dart';
import '../controllers/post_detail_controller.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostDetailController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Post Details",
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
        child: Obx(() {
          // Show a loading spinner while fetching the deed details
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),

                      // Media Content Banner Box Container
                      Container(
                        width: double.infinity,
                        height: 190.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          image: DecorationImage(
                            // Use API media_url, fallback to placeholder if empty
                            image: controller.mediaUrl.value.isNotEmpty
                                ? NetworkImage(controller.mediaUrl.value)
                                : const NetworkImage('https://img.magnific.com/free-photo/teenage-girl-with-praying-peace-hope-dreams-concept_1150-9114.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Core Post Text Block Body Field
                      Text(
                        controller.postContent.value,
                        style: AppTextTheme.bodyTextStyle.copyWith(
                          color: AppColor.lightTextColor.withOpacity(0.9),
                          fontSize: 14.sp,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Timestamp Scheduled Context Row Label
                      Text(
                        controller.scheduledTimeText.value,
                        style: AppTextTheme.bodyTextStyle.copyWith(
                          color: AppColor.lightTextSecondaryColor.withOpacity(0.7),
                          fontSize: 13.sp,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Metric Engagement Indicators Layout Row
                      Row(
                        children: [
                          // Saved Counter Metric (Placeholder as API doesn't explicitly track "saves" on deeds yet)
                          Row(
                            children: [
                              Icon(
                                Icons.assignment_turned_in_outlined,
                                color: AppColor.lightTextTertiaryColor.withOpacity(0.6),
                                size: 16.sp,
                              ),
                              SizedBox(width: 6.w),
                              Obx(() => Text(
                                'Saved by ${controller.savedCount.value} people',
                                style: AppTextTheme.bodyTextStyle.copyWith(
                                  color: AppColor.lightTextTertiaryColor.withOpacity(0.8),
                                  fontSize: 13.sp,
                                ),
                              )),
                            ],
                          ),
                          SizedBox(width: 32.w),

                          // Shared Counter Metric (Mapped from API 'targets' array length)
                          Row(
                            children: [
                              Icon(
                                Icons.reply_rounded,
                                color: AppColor.lightTextTertiaryColor.withOpacity(0.6),
                                size: 16.sp,
                              ),
                              SizedBox(width: 6.w),
                              Obx(() => Text(
                                'Shared by ${controller.sharedCount.value} people',
                                style: AppTextTheme.bodyTextStyle.copyWith(
                                  color: AppColor.lightTextTertiaryColor.withOpacity(0.8),
                                  fontSize: 13.sp,
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: RoundActionBtn(
                  onPressed: controller.navigateToEditPost,
                  text: 'Edit Post',
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}