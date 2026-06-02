import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/app_theme.dart';
import 'package:outlive/features/auth/screens/login_screen.dart';
import 'package:outlive/features/landing/screens/landing_screen.dart';

import 'features/status/screens/status_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'OutLive',
          theme: AppTheme().darkTheme,
          home: LandingScreen()
        );
      },
    );
  }
}

