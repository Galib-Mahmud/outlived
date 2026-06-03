import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_color.dart';
import '../theme/text_theme.dart';

class RoundActionBtn extends StatelessWidget {
  Color fillColor;
  Color textColor;
  void Function() onPressed;
  String text;
  bool isOutlined;
  RoundActionBtn({
    this.fillColor = AppColor.primaryColor,
    this.textColor = Colors.white,
    this.isOutlined = false,
    required this.onPressed,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: fillColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          side: isOutlined ? const BorderSide(color: AppColor.lightBoarderColor) : BorderSide.none,
        ),
        child: Text(
          text,
          style: AppTextTheme.bodyTextStyle.copyWith(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}