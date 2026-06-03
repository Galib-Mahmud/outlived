import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/app_color.dart';
import 'package:outlive/core/theme/text_theme.dart';

import '../controllers/bottom_nav_controller.dart';
import '../widget/custom_bottom_nav_bar.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTextTheme.bodyTextStyle.copyWith(
            color: AppColor.lightTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColor.lightSurfaceColor,
              shape: BoxShape.circle
            ),
            child: IconButton(
              onPressed: (){},
              icon: Icon(CupertinoIcons.bell, color: AppColor.lightTextSecondaryColor, size: 18.sp),
            ),
          )
        ],
      ),
      body: Obx(
        () => controller.tab[controller.selectedIndex.value]
      ),
      bottomNavigationBar: CustomBottomNavStack()
    );
  }
}
