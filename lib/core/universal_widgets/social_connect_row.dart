import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_color.dart';
import '../theme/text_theme.dart';
import 'small_action_button.dart';

class SocialConnectRow extends StatelessWidget {
  final String? iconPath;
  final IconData? fallbackIcon;
  final Color? iconColor;
  final String buttonText;
  final bool isConnected;
  final VoidCallback onTap;

  const SocialConnectRow({
    super.key,
    this.iconPath,
    this.fallbackIcon,
    this.iconColor,
    required this.buttonText,
    this.isConnected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 72.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColor.lightSurfaceColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconPath != null)
                Image.asset(
                  iconPath!,
                  width: 24.w,
                  height: 24.h,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    fallbackIcon ?? Icons.link,
                    color: iconColor ?? AppColor.primaryColor,
                    size: 24.sp,
                  ),
                )
              else
                Icon(
                  fallbackIcon ?? Icons.link,
                  color: iconColor ?? AppColor.primaryColor,
                  size: 24.sp,
                ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: SmallActionButton(
            text: buttonText,
            isConnected: isConnected,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
