import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/app_theme.dart';
import 'package:outlive/features/landing/screens/landing_screen.dart';
import 'core/storage/local_storage.dart';
import 'features/onboarding/screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FIX: was missing. Every UserInfo call (including isLoggedIn() right
  // below) reads a SharedPreferences instance that only exists after this
  // runs — without it, the app crashes immediately with
  // "Failed assertion: '_prefs != null': UserInfo.init() must be called
  // before use".
  await UserInfo.init();

  // autorotate off — lock to portrait only, before runApp so the first
  // frame is already locked.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final bool isAuthenticated = await UserInfo.isLoggedIn();

  // FIX: was `const MyApp(isAuthenticated: isAuthenticated)`. isAuthenticated
  // is a runtime value (the result of an awaited call), not a compile-time
  // constant, so `const` here is a straight compile error.
  runApp(MyApp(isAuthenticated: isAuthenticated));
}

class MyApp extends StatelessWidget {
  // FIX: was a mutable field on a StatelessWidget.
  final bool isAuthenticated;

  const MyApp({super.key, this.isAuthenticated = false});

  // FIX: was declared `String get initialRoute` but returned Widgets
  // (LandingScreen()/WelcomeScreen()) — a type error that wouldn't compile.
  // Renamed and retyped to return the actual Widget, and it's now wired
  // into `home:` below instead of being computed and discarded.
  Widget get _initialScreen {
    if (isAuthenticated) {
      return const LandingScreen();
    } else {
      return const WelcomeScreen();
    }
  }

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
          // FIX: was hardcoded to `WelcomeScreen()` regardless of
          // isAuthenticated, so a logged-in user would still see onboarding
          // on every cold start. Now actually uses the auth-based choice.
          home: _initialScreen,
        );
      },
    );
  }
}