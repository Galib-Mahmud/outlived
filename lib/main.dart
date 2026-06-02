import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/app_theme.dart';

import 'features/account_setup/screens/create_account_screen.dart';
import 'features/account_setup/screens/social_setup_screen.dart';
import 'features/auth/screens/forget_password_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/otp_screen.dart';
import 'features/auth/screens/reset_password_screen.dart';
import 'features/onboarding/screens/onboarding_question_screen.dart';
import 'features/onboarding/screens/welcome_screen.dart';
import 'features/status/screens/status_screen.dart';
import 'features/subscription/screens/upgrade_screen.dart';

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
          home: StatusScreen()
        );
      },
    );
  }
}

