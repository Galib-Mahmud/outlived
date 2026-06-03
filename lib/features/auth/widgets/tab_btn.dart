import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/text_theme.dart';

class TabBtn extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const TabBtn({
    super.key,
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: isActive
                ? AppColor.lightBackgroundColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: isActive
                  ? const Color(0xFFDEDEDE)
                  : Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: AppTextTheme.bodyTextStyle.copyWith(
                color: isActive
                    ? Colors.black
                    : AppColor.lightTextSecondaryColor,
                fontWeight: isActive
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
