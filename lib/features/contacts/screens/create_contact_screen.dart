import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/core/universal_widgets/round_action_btn.dart';
import '../../../core/theme/app_color.dart';
import '../controllers/contact_controller.dart';

class CreateContactController extends GetxController {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  var selectedCategory = 'Muslim'.obs;
  final RxBool isSaving = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    numberController.dispose();
    super.onClose();
  }

  Future<void> getContact() async {
    final FlutterNativeContactPicker contactPicker = FlutterNativeContactPicker();
    Contact? contact = await contactPicker.selectContact();

    if (contact != null) {
      nameController.text = contact.fullName ?? '';
      numberController.text = contact.phoneNumbers?.isNotEmpty == true ? contact.phoneNumbers!.first : '';
    }
  }

  // FIX: this previously did nothing at all — the entered name, number,
  // and category were discarded and the button had no onPressed logic.
  Future<void> save() async {
    final name = nameController.text.trim();
    final phone = numberController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      Get.snackbar("Error", "Please enter a name and number", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSaving.value = true;
    try {
      final newContact = ContactModel(name: name, phone: phone, category: selectedCategory.value);

      // NOTE: saves into the in-memory list ContactsScreen displays.
      // The real backend's POST /contacts endpoint (per the API doc) has
      // no dedicated category field — only a free-text "relationship"
      // field — so this isn't synced to the server yet. Flag if you want
      // it persisted there too (e.g. storing the category string in
      // "relationship", or adding a real category field server-side).
      if (Get.isRegistered<ContactController>()) {
        Get.find<ContactController>().addContact(newContact);
      }

      Get.back();
      Get.snackbar("Success", "Contact saved", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving.value = false;
    }
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
              fontWeight: FontWeight.w600),
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
                shape: BoxShape.circle),
            child: IconButton(
              onPressed: () {},
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

                    _buildFieldLabel('Contact Name'),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: controller.nameController,
                      style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor),
                      decoration: _buildInputDecoration('Enter Name', controller.getContact),
                    ),

                    SizedBox(height: 24.h),

                    _buildFieldLabel('Contact Number'),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: controller.numberController,
                      keyboardType: TextInputType.phone,
                      style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor),
                      decoration: _buildInputDecoration('Enter Number', controller.getContact),
                    ),

                    SizedBox(height: 24.h),

                    _buildFieldLabel('Category'),
                    SizedBox(height: 12.h),

                    Obx(
                          () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildRadioOption('Muslim', controller),
                          _buildRadioOption('Invite To Islam', controller),
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
              child: Obx(
                    () => RoundActionBtn(
                  onPressed: controller.save,
                  text: controller.isSaving.value ? 'Saving...' : 'Save',
                ),
              ),
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
        color: AppColor.lightTextColor.withOpacity(0.6),
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, void Function()? onContactTap) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextTheme.bodyTextStyle.copyWith(
        color: AppColor.lightTextTertiaryColor,
        fontSize: 14.sp,
      ),
      fillColor: AppColor.lightSurfaceColor,
      filled: true,
      suffixIcon: InkWell(
        onTap: onContactTap,
        child: Image.asset(
          'assets/icons/contact.png',
          width: 20.r,
          height: 20.r,
          color: AppColor.lightTextTertiaryColor,
        ),
      ),
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
                width: isSelected ? 5.r : 1.5.r,
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