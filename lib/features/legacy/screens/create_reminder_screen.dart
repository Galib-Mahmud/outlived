import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/round_action_btn.dart';
import 'package:outlive/features/contacts/screens/contact_selection_screen.dart';
import '../../../core/theme/app_color.dart';
import '../../contacts/controllers/contact_controller.dart';
import '../controllers/create_reminder_controller.dart';

class CreateReminderScreen extends StatelessWidget {
  const CreateReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateReminderController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Create Ongoing Reminder",
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/whatsapp.png',
                            width: 16.w,
                            height: 16.h,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'WhatsApp',
                            style: AppTextTheme.bodyTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    _buildFieldLabel('Message'),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: controller.messageController,
                      maxLines: 4,
                      style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor),
                      decoration: _buildInputDecoration('Type your message...', null, controller),
                    ),

                    SizedBox(height: 20.h),

                    _buildFieldLabel('Benefit Circle'),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: controller.benefitCircleController,
                      style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor),
                      decoration: _buildInputDecoration('Enter Name', 'assets/icons/contact.png', controller),
                    ),

                    SizedBox(height: 20.h),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Date'),
                              SizedBox(height: 8.h),
                              Obx(() => _buildPickerTile(
                                text: controller.selectedDateText.value,
                                icon: Icons.calendar_today_outlined,
                                onTap: () => controller.pickDate(context),
                              )),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Time'),
                              SizedBox(height: 8.h),
                              Obx(() => _buildPickerTile(
                                text: controller.selectedTimeText.value,
                                icon: Icons.access_time_rounded,
                                onTap: () => controller.pickTime(context),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    _buildFieldLabel('Continue Reward'),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: AppColor.lightSurfaceColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Obx(
                            () => Row(
                          children: [
                            _buildIntervalTab('Daily', controller),
                            _buildIntervalTab('Fridays', controller),
                            _buildIntervalTab('Weekly', controller),
                            _buildIntervalTab('Monthly', controller),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Obx(() => Stack(
                alignment: Alignment.center,
                children: [
                  RoundActionBtn(
                    // FIX: was always `controller.saveReminder` regardless
                    // of isLoading — the button never actually disabled,
                    // so a slow network let someone tap it multiple times
                    // and fire concurrent requests.
                    onPressed: controller.isLoading.value ? null : controller.saveReminder,
                    text: controller.isLoading.value ? 'Saving...' : 'Save Reminder',
                  ),
                  if (controller.isLoading.value)
                    Positioned(
                      right: 20.w,
                      child: SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      ),
                    ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: AppTextTheme.bodyTextStyle.copyWith(
        color: AppColor.lightTextColor,
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, String? suffixIcon, CreateReminderController controller) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextTheme.bodyTextStyle.copyWith(
        color: AppColor.lightTextTertiaryColor.withOpacity(0.6),
        fontSize: 14.sp,
      ),
      fillColor: AppColor.lightSurfaceColor,
      filled: true,
      suffixIcon: suffixIcon != null
          ? InkWell(
        onTap: () async {
          // Wait for the contact selection screen to return a result
          final result = await Get.to(() => const ContactSelectionScreen());
          // FIX: ContactSelectionScreen's Confirm button returns
          // List<ContactModel> (Get.back(result: selectedContacts.toList())),
          // never a String — so `result is String` was always false and
          // this field never actually got filled in after selecting contacts.
          if (result != null && result is List<ContactModel>) {
            controller.benefitCircleController.text =
                result.map((c) => c.name).join(', ');
          }
        },
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Image.asset(
            suffixIcon,
            width: 16.w,
            height: 16.h,
          ),
        ),
      )
          : null,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildPickerTile({required String text, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColor.lightSurfaceColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: AppTextTheme.bodyTextStyle.copyWith(
                color: text.contains('/') || text.contains(':')
                    ? AppColor.lightTextColor
                    : AppColor.lightTextTertiaryColor.withOpacity(0.6),
                fontSize: 14.sp,
              ),
            ),
            Icon(icon, color: AppColor.lightTextTertiaryColor.withOpacity(0.6), size: 16.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalTab(String val, CreateReminderController controller) {
    final isSelected = controller.selectedRewardInterval.value == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedRewardInterval.value = val,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ]
                : [],
          ),
          child: Center(
            child: Text(
              val,
              style: AppTextTheme.bodyTextStyle.copyWith(
                color: isSelected ? AppColor.lightTextColor : AppColor.lightTextSecondaryColor,
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}