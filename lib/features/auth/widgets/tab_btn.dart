import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/features/account_setup/controllers/create_account_controller.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/text_theme.dart';
import '../controllers/login_controller.dart';

class TabBtn extends StatelessWidget {
  final int index;
  final String text;
  final LoginController? controller;
  final CreateAccountController? createAccountController;

  const TabBtn({
    super.key,
    this.controller,
    this.createAccountController,
    required this.index,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Expanded(
        child: GestureDetector(
          onTap: () => controller != null
              ? controller!.selectedTab.value = index
              : createAccountController!.selectedTab.value = index,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 20),
            padding: EdgeInsets.symmetric(vertical: 10.h),
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: (
                  controller != null
                      ? controller!.selectedTab.value == index
                      : createAccountController!.selectedTab.value == index
              )
                  ? AppColor.lightBackgroundColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: (
                    controller != null
                        ? controller!.selectedTab.value == index
                        : createAccountController!.selectedTab.value == index
                )
                    ? Color(0xFFDEDEDE)
                    : Colors.transparent
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: (
                      controller != null
                          ? controller!.selectedTab.value == index
                          : createAccountController!.selectedTab.value == index
                  )
                      ? Colors.black
                      : AppColor.lightTextSecondaryColor,
                  fontWeight:(
                      controller != null
                          ? controller!.selectedTab.value == index
                          : createAccountController!.selectedTab.value == index
                  )
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}