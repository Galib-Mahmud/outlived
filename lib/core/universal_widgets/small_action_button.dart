import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_color.dart';
import '../theme/text_theme.dart';

class SmallActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isConnected;
  final double? width;

  const SmallActionButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isConnected = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isConnected ? Colors.blueGrey.withOpacity(0.3) : AppColor.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          text,
          style: AppTextTheme.bodyTextStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
