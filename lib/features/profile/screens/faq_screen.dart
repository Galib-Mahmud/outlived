import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import '../../../core/theme/app_color.dart';

class FAQController extends GetxController {
  final expandedIndex = (-1).obs;

  void toggleTile(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else {
      expandedIndex.value = index;
    }
  }
}

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FAQController());

    final List<Map<String, String>> faqData = [
      {
        'question': 'What does this app do?',
        'answer':
        'This app is designed to help you organize your routine tasks seamlessly, trace your daily performance metrics, and keep your core records safe.',
      },
      {
        'question': 'How do I create an account?',
        'answer':
        'Simply tap Sign Up and follow the registration process.',
      },
      {
        'question': 'Can I reset my password?',
        'answer':
        'Yes, use the Forgot Password option from the login screen.',
      },
      {
        'question': 'Is my data secure?',
        'answer':
        'Yes, we use secure storage and encrypted communication.',
      },
      {
        'question': 'How can I contact support?',
        'answer':
        'You can contact support through the Help & Support section.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "FAQ's",
          style: AppTextTheme.titleTextStyle.copyWith(
            color: AppColor.lightTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.lightTextColor,
            size: 18.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 20.h,
          ),
          itemCount: faqData.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            return Obx(() {
              final isExpanded =
                  controller.expandedIndex.value == index;

              return Container(
                decoration: BoxDecoration(
                  color: AppColor.lightSurfaceColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColor.lightBoarderColor,
                    width: 1.w,
                  ),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    key: ValueKey(
                      "${index}_${isExpanded}",
                    ),
                    tilePadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    childrenPadding: EdgeInsets.zero,
                    maintainState: true,
                    initiallyExpanded: isExpanded,
                    onExpansionChanged: (_) {
                      controller.toggleTile(index);
                    },
                    title: Text(
                      faqData[index]['question']!,
                      style: AppTextTheme.bodyTextStyle.copyWith(
                        color: AppColor.lightTextColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        isExpanded
                            ? Icons.remove_rounded
                            : Icons.add_rounded,
                        key: ValueKey(isExpanded),
                        color: AppColor.primaryColor,
                        size: 22.sp,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          bottom: 16.h,
                        ),
                        child: Text(
                          faqData[index]['answer']!,
                          style: AppTextTheme.bodyTextStyle.copyWith(
                            color:
                            AppColor.lightTextSecondaryColor,
                            fontSize: 12.sp,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}