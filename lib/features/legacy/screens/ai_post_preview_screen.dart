// lib/features/legacy/screens/ai_post_preview_screen.dart
//
// Matches the "generated post preview" screenshot: content, an optional
// image, the scheduled date/time, saved/shared counts, share buttons, and
// Post/Edit actions.
//
// IMPORTANT — two things this screen can't fully back with your current
// API, flagged rather than faked:
// 1. Share buttons: there's no documented "share now" endpoint (Deeds
//    auto-post on schedule per §6, not on demand). These trigger the
//    native OS share sheet instead via the `share_plus` package — the
//    person picks which app to share into themselves. This needs
//    `share_plus` added to pubspec.yaml to compile.
// 2. "Saved by X / Shared by Y": this content hasn't been saved as a real
//    deed yet at the point this screen is reached from the AI-generate
//    flow, so there's no real count to show — both default to 0 rather
//    than showing fabricated numbers.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:outlive/core/theme/text_theme.dart';
import '../../../core/theme/app_color.dart';
import '../controllers/social_post_controller.dart';

class AiPostPreviewScreen extends StatelessWidget {
  final String content;
  final String? imageUrl;

  const AiPostPreviewScreen({super.key, required this.content, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Pulls the SocialPostController that's already in scope from the tab
    // this was launched from, so Post/Edit act on the same picked
    // date/time/interval rather than needing them passed through again.
    final controller = Get.find<SocialPostController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          _titleFromContent(content),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextTheme.titleTextStyle.copyWith(
            color: AppColor.lightTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColor.lightTextColor, size: 18.sp),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(color: AppColor.lightSurfaceColor, shape: BoxShape.circle),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_none_rounded, color: AppColor.lightTextSecondaryColor, size: 20.sp),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    if (imageUrl != null && imageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(imageUrl!, width: double.infinity, height: 200.h, fit: BoxFit.cover),
                      ),
                    if (imageUrl != null && imageUrl!.isNotEmpty) SizedBox(height: 16.h),

                    Text(
                      content,
                      style: AppTextTheme.bodyTextStyle.copyWith(
                        color: AppColor.lightTextColor.withOpacity(0.9),
                        fontSize: 14.sp,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: 16.h),
                    Obx(() {
                      final date = controller.pickedDate;
                      final time = controller.pickedTime;
                      final text = date == null
                          ? 'Not scheduled yet'
                          : 'Scheduled : ${DateFormat('d MMM').format(date)}.'
                          '${time != null ? ' ${time.format(context)}' : ''}';
                      return Text(
                        text,
                        style: AppTextTheme.bodyTextStyle.copyWith(
                          color: AppColor.lightTextSecondaryColor.withOpacity(0.7),
                          fontSize: 13.sp,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }),

                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.assignment_turned_in_outlined, color: AppColor.lightTextTertiaryColor.withOpacity(0.6), size: 16.sp),
                            SizedBox(width: 6.w),
                            // NOTE: 0 by default — this hasn't been saved as
                            // a real deed yet, so there's no real count.
                            Text(
                              'Saved by 0 people',
                              style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextTertiaryColor.withOpacity(0.8), fontSize: 13.sp),
                            ),
                          ],
                        ),
                        SizedBox(width: 32.w),
                        Row(
                          children: [
                            Icon(Icons.reply_rounded, color: AppColor.lightTextTertiaryColor.withOpacity(0.6), size: 16.sp),
                            SizedBox(width: 6.w),
                            Text(
                              'Shared by 0 people',
                              style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextTertiaryColor.withOpacity(0.8), fontSize: 13.sp),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(child: _shareButton(label: 'Share Instagram', icon: Icons.camera_alt_outlined)),
                        SizedBox(width: 12.w),
                        Expanded(child: _shareButton(label: 'Share WhatsApp', icon: Icons.chat_bubble_outline_rounded)),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: _shareButton(label: 'Share Facebook', icon: Icons.facebook_outlined),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),

            // ── Post + Edit actions ─────────────────────────────────
            // Screenshot only showed "Edit" — adding "Post" too since that
            // was explicitly requested; Post finalizes as-is, Edit goes
            // back to the form first.
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                children: [
                  Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                        controller.useGeneratedPost(content);
                        controller.savePost();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                        elevation: 0,
                      ),
                      child: Text(
                        controller.isLoading.value ? 'Posting...' : 'Post',
                        style: AppTextTheme.bodyTextStyle.copyWith(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w700),
                      ),
                    ),
                  )),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        controller.useGeneratedPost(content);
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColor.lightBoarderColor),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                      ),
                      child: Text(
                        'Edit',
                        style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor, fontSize: 15.sp, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _titleFromContent(String content) {
    final firstLine = content.split('\n').first.trim();
    if (firstLine.isEmpty) return 'Generated Post';
    return firstLine.length > 40 ? '${firstLine.substring(0, 40)}...' : firstLine;
  }

  Widget _shareButton({required String label, required IconData icon}) {
    return OutlinedButton.icon(
      onPressed: () {
        // Native OS share sheet — see the file-level note on why this
        // isn't a direct per-platform API call.
        Share.share(content);
      },
      icon: Icon(icon, size: 16.sp, color: AppColor.lightTextSecondaryColor),
      label: Text(
        label,
        style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor, fontSize: 13.sp, fontWeight: FontWeight.w500),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColor.lightBoarderColor),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }
}