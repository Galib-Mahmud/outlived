import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import 'package:outlive/features/contacts/screens/create_contact_screen.dart';
import '../../../core/theme/app_color.dart';
import '../controllers/contact_controller.dart'; // Update path correctly

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Injecting the dynamic Contact State Controller
    final controller = Get.put(ContactController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: TextFormField(
                style: AppTextTheme.bodyTextStyle.copyWith(color: AppColor.lightTextColor),
                onChanged: (value) => controller.searchQuery.value = value, // Updates stream queries
                decoration: InputDecoration(
                  hintText: 'Search Contact',
                  hintStyle: AppTextTheme.bodyTextStyle.copyWith(
                    color: AppColor.lightTextTertiaryColor,
                    fontSize: 14.sp,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColor.lightTextTertiaryColor, size: 20.sp),
                  fillColor: AppColor.lightSurfaceColor,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // 3. Category Metrics Segment
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
              child: Obx(
                    () => Row(
                  children: [
                    _buildMetricCard(
                      count: controller.countMuslim.toString(),
                      label: 'Muslim',
                      isSelected: controller.selectedCategory.value == 'Muslim',
                      onTap: () => controller.toggleCategory('Muslim'),
                    ),
                    SizedBox(width: 12.w),
                    _buildMetricCard(
                      count: controller.countInvite.toString(),
                      label: 'Invite To Islam',
                      isSelected: controller.selectedCategory.value == 'Invite To Islam',
                      onTap: () => controller.toggleCategory('Invite To Islam'),
                    ),
                    SizedBox(width: 12.w),
                    _buildMetricCard(
                      count: controller.countLegacy.toString(),
                      label: 'Legacy Recipient',
                      isSelected: controller.selectedCategory.value == 'Legacy Recipient',
                      onTap: () => controller.toggleCategory('Legacy Recipient'),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // 4. Dynamically Filtering Grouped Contacts List
            Expanded(
              child: Obx(() {
                final groups = controller.filteredGroupedContacts;

                if (groups.isEmpty) {
                  return Center(
                    child: Text(
                      'No matching contacts found',
                      style: AppTextTheme.bodyTextStyle.copyWith(
                        color: AppColor.lightTextTertiaryColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: groups.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, groupIndex) {
                    final group = groups[groupIndex];
                    final List<ContactModel> contactsInGroup = group['contacts'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Letter Header Block Section
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                          color: AppColor.lightSurfaceColor.withOpacity(0.4),
                          child: Text(
                            group['letter'] as String,
                            style: AppTextTheme.bodyTextStyle.copyWith(
                              color: AppColor.lightTextColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        // Items belonging to this letter group
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: contactsInGroup.length,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (context, index) => Divider(
                            height: 1.h,
                            thickness: 1.h,
                            color: AppColor.lightTextTertiaryColor.withOpacity(0.08),
                          ),
                          itemBuilder: (context, contactIndex) {
                            final contact = contactsInGroup[contactIndex];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    contact.name,
                                    style: AppTextTheme.bodyTextStyle.copyWith(
                                      color: AppColor.lightTextColor,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    contact.phone,
                                    style: AppTextTheme.bodyTextStyle.copyWith(
                                      color: AppColor.lightTextTertiaryColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMetricCard({
    required String count,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 110.w,
      height: 110.h,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 110.w,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.primaryColor.withOpacity(0.1) : AppColor.lightSurfaceColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                count,
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: AppColor.lightTextColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: isSelected ? AppColor.primaryColor : AppColor.lightTextTertiaryColor,
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}