import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/text_theme.dart';


class AccountSetupAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final bool showBackButton;
  final String? actionText;
  final VoidCallback? onActionTap;
  final Widget? actionWidget;

  const AccountSetupAppbar({
    super.key,
    required this.title,
    this.onBack,
    this.showBackButton = true,
    this.actionText,
    this.onActionTap,
    this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,

      leading: showBackButton
          ? IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: AppColor.lightTextColor,
          size: 20.sp,
        ),
        onPressed: onBack ?? () => Get.back(),
      )
          : null,

      title: Text(
        title,
        style: AppTextTheme.bodyTextStyle.copyWith(
          color: AppColor.lightTextColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),

      centerTitle: true,

      actions: [
        if (actionWidget != null)
          actionWidget!
        else if (actionText != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionText!,
              style: AppTextTheme.bodyTextStyle.copyWith(
                color: AppColor.secondaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}