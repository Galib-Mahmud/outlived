import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/round_action_btn.dart';
import 'package:outlive/features/onboarding/controllers/onboarding_question_controller.dart';
import '../../../core/theme/app_color.dart';

class OnboardingQuestionScreen extends StatelessWidget {
  const OnboardingQuestionScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final OnboardingQuestionController onboardingQuestionController = Get.put(OnboardingQuestionController());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Central Logo Area
              Image.asset(
                'assets/images/logo.png',
                width: 200.w,
                fit: BoxFit.contain,
              ),

              const Spacer(flex: 2),

              // Deep Question Text
              Obx(
                () => Text(
                  onboardingQuestionController.questions[onboardingQuestionController.currentQuestionIndex.value],
                  textAlign: TextAlign.center,
                  style: AppTextTheme.titleTextStyle.copyWith(
                    fontSize: 30.sp,
                    height: 1.3,
                  ),
                ),
              ),

              const Spacer(flex: 4),

              // Next Button

              RoundActionBtn(
                  onPressed: onboardingQuestionController.goToNextQuestion,
                  text: 'Next'
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}