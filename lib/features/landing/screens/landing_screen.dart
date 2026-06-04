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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: Obx(
          () => controller.appBar[controller.selectedIndex.value]
        ),
      ),
      body: Obx(
        () => controller.tab[controller.selectedIndex.value]
      ),
      bottomNavigationBar: CustomBottomNavStack()
    );
  }
}
