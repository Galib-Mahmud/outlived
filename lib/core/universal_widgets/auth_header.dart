import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_color.dart';
import '../theme/text_theme.dart';

class AuthHeader extends StatelessWidget {
  final String greeting;

  const AuthHeader({
    super.key,
    this.greeting = 'Assalamu Alaikum',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo_text.png',
            width: 140.w,
          ),
          SizedBox(height: 8.h),
          Text(
            greeting,
            style: AppTextTheme.bodyTextStyle.copyWith(
              color: AppColor.lightTextColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
