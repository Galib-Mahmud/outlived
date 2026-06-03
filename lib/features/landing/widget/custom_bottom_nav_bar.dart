import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_controller.dart';
import 'package:outlive/core/theme/text_theme.dart';

class CustomBottomNavStack extends StatelessWidget {
  const CustomBottomNavStack({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavController());

    // Main parent structure uses a Stack to safely float the center action button outside parent clipping
    return SizedBox(
      height: 110.h, // Increased total box height to accommodate the upward overflow
      child: Stack(
        clipBehavior: Clip.none, // Crucial parameter to allow target container overflow rendering
        alignment: Alignment.bottomCenter,
        children: [
          // 1. Core Navigation Bar Surface
          Container(
            height: 80.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.white, // Exact light panel surface from reference context image_8d4e3a.png
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20.r,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Side Group (Home & Legacy Tabs)
                Row(
                  children: [
                    _buildLeftRightTabItem(
                      controller,
                      index: 0,
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                      label: 'Home',
                    ),
                    SizedBox(width: 24.w),
                    _buildLeftRightTabItem(
                      controller,
                      index: 1,
                      icon: Icons.calendar_today_outlined,
                      activeIcon: Icons.calendar_today_rounded,
                      label: 'Legacy',
                    ),
                  ],
                ),

                // Pure empty spacing spacer context gap corresponding to the floated center layout width size
                SizedBox(width: 72.w),

                // Right Side Group (Contacts & Profile Tabs)
                Row(
                  children: [
                    _buildLeftRightTabItem(
                      controller,
                      index: 2,
                      icon: Icons.import_contacts_outlined,
                      activeIcon: Icons.import_contacts_rounded,
                      label: 'Contacts',
                    ),
                    SizedBox(width: 24.w),
                    _buildLeftRightTabItem(
                      controller,
                      index: 3,
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      label: 'Profile',
                    ),
                  ],
                ),
              ],
            )),
          ),

          // 2. Floated Center Action Button (Positioned vertically offset outside parent)
          Positioned(
            top: 0, // Pushes absolute component vertically to top boundary, floating out of background frame box
            child: GestureDetector(
              onTap: controller.onFabPressed,
              child: Container(
                width: 68.w,
                height: 68.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E5A36), // Balanced specific baseline template green tone matching visual design
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E5A36).withOpacity(0.25),
                      blurRadius: 12.r,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Structural sub-elements rendering layout matching active profile bounds parameters configuration
  Widget _buildLeftRightTabItem(
      BottomNavController controller, {
        required int index,
        required IconData icon,
        required IconData activeIcon,
        required String label,
      }) {
    final isSelected = controller.selectedIndex.value == index;

    print('Rendering tab index: $index, isSelected: $isSelected'); // Debug log to verify state changes

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF4F4F4) : Colors.transparent, // Squircle block structure active template background tracking
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? Colors.black : Colors.grey.shade400,
                size: 24.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: AppTextTheme.bodyTextStyle.copyWith(
                color: isSelected ? Colors.black : Colors.grey.shade500,
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}