import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/app_theme.dart';
import 'package:outlive/features/auth/screens/otp_screen.dart';
import 'package:outlive/features/landing/screens/landing_screen.dart';
import 'core/storage/local_storage.dart';
import 'features/onboarding/screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserInfo.init();
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
          debugShowCheckedModeBanner: false,
          theme: AppTheme().darkTheme,
          home: WelcomeScreen()
        );
      },
    );
  }
}

