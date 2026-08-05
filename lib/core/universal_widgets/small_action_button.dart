import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_color.dart';
import '../theme/text_theme.dart';

class SmallActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap; // null হলে বাটন ডিসেবল হবে
  final bool isConnected;
  final bool isLoading; // API কল হওয়ার সময় লোডিং দেখানোর জন্য
  final double? width;

  const SmallActionButton({
    super.key,
    required this.text,
    this.onTap,
    this.isConnected = false,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    // কানেক্টেড থাকলে বা লোডিং চললে বাটন ডিসেবল থাকবে
    final bool isDisabled = isConnected || isLoading || onTap == null;

    return SizedBox(
      width: width ?? double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onTap,
        style: ElevatedButton.styleFrom(
          // কানেক্টেড হলে হালকা গ্রে কালার, অন্যথায় প্রাইমারি কালার
          backgroundColor: isConnected
              ? Colors.blueGrey.withValues(alpha: 0.3)
              : AppColor.primaryColor,
          foregroundColor: isConnected ? Colors.blueGrey : Colors.white,
          elevation: 0,
          disabledBackgroundColor: Colors.blueGrey.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
          height: 20.h,
          width: 20.h,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Text(
          text,
          style: AppTextTheme.bodyTextStyle.copyWith(
            color: isConnected ? Colors.blueGrey : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}