import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outlive/core/theme/app_color.dart';
import 'package:outlive/core/theme/app_theme.dart';

class AppTextTheme {

  static TextStyle get titleTextStyle => TextStyle(
      fontSize: 24.sp,
      color: AppColor.lightTextColor,
      fontFamily: FontFamily.inter.name,
      fontWeight: FontWeight.w700
  );

  static TextStyle get bodyTextStyle => TextStyle(
    fontSize: 14.sp,
    color: AppColor.lightTextSecondaryColor,
    fontFamily: FontFamily.inter.name,
    fontWeight: FontWeight.w400
  );
}