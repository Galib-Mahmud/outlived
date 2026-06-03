import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/round_action_btn.dart';
import '../../../core/theme/app_color.dart';

// Controller to handle state form management reactively
class CreateContactController extends GetxController {
  final nameController = TextEditingController();
  final numberController = TextEditingController();

  // Radio option tracker string ('Muslim', 'Invite To Islam', or 'Memory')
  var selectedCategory = 'Muslim'.obs;

  @override
  void onClose() {
    nameController.dispose();
    numberController.dispose();
    super.onClose();
  }
}

class CreateContactScreen extends StatelessWidget {
  const CreateContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateContactController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTextTheme.bodyTextStyle.copyWith(
              color: AppColor.lightTextColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColor.lightTextColor, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
                color: AppColor.lightSurfaceColor,
                shape: BoxShape.circle
            ),
            child: IconButton(
              onPressed: (){},
              icon: Icon(CupertinoIcons.bell, color: AppColor.lightTextSecondaryColor, size: 18.sp),
            ),
          )
        ],
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
                    SizedBox(height: 24.h),

                    // Input A: Contact Name
                    _buildFieldLabel('Contact Name'),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: controller.nameController,
                      style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor),
                      decoration: _buildInputDecoration('Enter Name', Icons.contact_page_outlined),
                    ),

                    SizedBox(height: 24.h),

                    // Input B: Contact Number
                    _buildFieldLabel('Contact Number'),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: controller.numberController,
                      keyboardType: TextInputType.phone,
                      style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor),
                      decoration: _buildInputDecoration('Enter Number', Icons.contact_page_outlined),
                    ),

                    SizedBox(height: 24.h),

                    // Input C: Category Row Segment
                    _buildFieldLabel('Category'),
                    SizedBox(height: 12.h),

                    Obx(
                          () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildRadioOption('Muslim', controller),
                          _buildRadioOption('Invite To Islam', controller),
                          _buildRadioOption('Memory', controller), // Matches "Memory" category label from reference
                        ],
                      ),
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: RoundActionBtn(
                onPressed: (){},
                text: 'Save',
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- Layout Helper Modules ---

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: AppTextTheme.bodyTextStyle.copyWith(
        color: AppColor.lightTextColor.withOpacity(0.6), // Slightly muted header label style
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData suffixIcon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextTheme.bodyTextStyle.copyWith(
        color: AppColor.lightTextTertiaryColor,
        fontSize: 14.sp,
      ),
      fillColor: AppColor.lightSurfaceColor,
      filled: true,
      suffixIcon: Icon(suffixIcon, color: AppColor.lightTextTertiaryColor.withOpacity(0.7), size: 20.sp),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: AppColor.lightTextTertiaryColor.withOpacity(0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: AppColor.lightTextTertiaryColor.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AppColor.primaryColor, width: 1),
      ),
    );
  }

  Widget _buildRadioOption(String val, CreateContactController controller) {
    final isSelected = controller.selectedCategory.value == val;
    return GestureDetector(
      onTap: () => controller.selectedCategory.value = val,
      child: Row(
        children: [
          Container(
            width: 16.r,
            height: 16.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColor.primaryColor : AppColor.lightTextTertiaryColor,
                width: isSelected ? 5.r : 1.5.r, // Expands native inner fill ring natively
              ),
              color: Colors.white,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            val,
            style: AppTextTheme.bodyTextStyle.copyWith(
              color: isSelected ? AppColor.lightTextColor : AppColor.lightTextSecondaryColor,
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}