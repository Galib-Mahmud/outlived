import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/text_theme.dart';
import '../../../core/theme/app_color.dart';
import '../controllers/contact_controller.dart';

class ContactSelectionScreen extends StatelessWidget {
  /// Optional: pre-selected contacts passed from parent screen
  final List<ContactModel>? preSelected;

  /// Callback when user confirms selection
  final void Function(List<ContactModel> selected)? onConfirm;

  const ContactSelectionScreen({
    super.key,
    this.preSelected,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final contactController = Get.put(ContactController());
    final selectionController = Get.put(
      ContactSelectionController(
        masterContacts: contactController.masterContacts,
        preSelected: preSelected,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            CupertinoIcons.chevron_left,
            color: AppColor.lightTextSecondaryColor,
            size: 18.sp,
          ),
        ),
        title: Text(
          'Select Contacts',
          style: AppTextTheme.bodyTextStyle.copyWith(
            color: AppColor.lightTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Obx(() {
            final allSelected = selectionController.areAllSelected;
            return TextButton(
              onPressed: selectionController.toggleSelectAll,
              child: Text(
                allSelected ? 'Deselect All' : 'Select All',
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: AppColor.primaryColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Search Bar ─────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: TextFormField(
                style: AppTextTheme.bodyTextStyle
                    .copyWith(color: AppColor.lightTextColor),
                onChanged: (value) =>
                selectionController.searchQuery.value = value,
                decoration: InputDecoration(
                  hintText: 'Search Contact',
                  hintStyle: AppTextTheme.bodyTextStyle.copyWith(
                    color: AppColor.lightTextTertiaryColor,
                    fontSize: 14.sp,
                  ),
                  prefixIcon: Icon(Icons.search,
                      color: AppColor.lightTextTertiaryColor, size: 20.sp),
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

            // ── Category Metric Cards ───────────────────────────────
            // FIX 2: onTap = category filter (short press)
            //        onLongPress = select all contacts in that category
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
              child: Obx(
                    () => Row(
                  children: [
                    _buildMetricCard(
                      controller: selectionController,
                      count: selectionController.countMuslim.toString(),
                      label: 'Muslim',
                      category: 'Muslim',
                    ),
                    SizedBox(width: 12.w),
                    _buildMetricCard(
                      controller: selectionController,
                      count: selectionController.countInvite.toString(),
                      label: 'Invite To Islam',
                      category: 'Invite To Islam',
                    ),
                    SizedBox(width: 12.w),
                    _buildMetricCard(
                      controller: selectionController,
                      count: selectionController.countLegacy.toString(),
                      label: 'Legacy Recipient',
                      category: 'Legacy Recipient',
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // ── Contacts List ───────────────────────────────────────
            Expanded(
              child: Obx(() {
                final groups = selectionController.filteredGroupedContacts;

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
                    final String letter = group['letter'] as String;
                    final List<ContactModel> contactsInGroup =
                    group['contacts'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Letter Header — tap to select entire letter group ──
                        // FIX 1: Obx wraps the header so isGroupSelected is reactive
                        Obx(() {
                          final bool isGroupSelected =
                          selectionController.isGroupSelected(contactsInGroup);
                          return GestureDetector(
                            onTap: () => selectionController
                                .toggleGroupSelection(contactsInGroup),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.w, vertical: 12.h),
                              color: AppColor.lightSurfaceColor.withOpacity(0.4),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    letter,
                                    style: AppTextTheme.bodyTextStyle.copyWith(
                                      color: AppColor.lightTextColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    width: 20.r,
                                    height: 20.r,
                                    decoration: BoxDecoration(
                                      color: isGroupSelected
                                          ? AppColor.primaryColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(4.r),
                                      border: Border.all(
                                        color: isGroupSelected
                                            ? AppColor.primaryColor
                                            : AppColor.lightTextTertiaryColor
                                            .withOpacity(0.4),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: isGroupSelected
                                        ? Icon(Icons.check,
                                        color: Colors.white, size: 13.sp)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                        // ── Contact Rows ──────────────────────────────────────
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: contactsInGroup.length,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (context, index) => Divider(
                            height: 1.h,
                            thickness: 1.h,
                            color: AppColor.lightTextTertiaryColor
                                .withOpacity(0.08),
                          ),
                          itemBuilder: (context, contactIndex) {
                            final contact = contactsInGroup[contactIndex];

                            // FIX 1: each row has its own Obx so checkbox is reactive
                            return Obx(() {
                              final bool isSelected =
                              selectionController.isContactSelected(contact);

                              return GestureDetector(
                                onTap: () =>
                                    selectionController.toggleContact(contact),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  color: isSelected
                                      ? AppColor.primaryColor.withOpacity(0.05)
                                      : Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.w, vertical: 16.h),
                                  child: Row(
                                    children: [
                                      // Checkbox
                                      AnimatedContainer(
                                        duration:
                                        const Duration(milliseconds: 150),
                                        width: 20.r,
                                        height: 20.r,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColor.primaryColor
                                              : Colors.transparent,
                                          borderRadius:
                                          BorderRadius.circular(4.r),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColor.primaryColor
                                                : AppColor.lightTextTertiaryColor
                                                .withOpacity(0.4),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: isSelected
                                            ? Icon(Icons.check,
                                            color: Colors.white, size: 13.sp)
                                            : null,
                                      ),

                                      SizedBox(width: 12.w),

                                      // Name
                                      Expanded(
                                        child: Text(
                                          contact.name,
                                          style: AppTextTheme.bodyTextStyle
                                              .copyWith(
                                            color: AppColor.lightTextColor,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),

                                      // Phone
                                      Text(
                                        contact.phone,
                                        style: AppTextTheme.bodyTextStyle
                                            .copyWith(
                                          color: AppColor.lightTextTertiaryColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
            ),

            // ── Bottom Confirm Button ───────────────────────────────
            Obx(() {
              final count = selectionController.selectedContacts.length;
              if (count == 0) return const SizedBox.shrink();

              return Container(
                padding:
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColor.lightSurfaceColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {
                      onConfirm?.call(
                          selectionController.selectedContacts.toList());
                      Get.back(
                          result:
                          selectionController.selectedContacts.toList());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Confirm ($count selected)',
                      style: AppTextTheme.bodyTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ── Metric Card ─────────────────────────────────────────────
  // Short tap  → category filter (same as before)
  // Long press → select/deselect ALL contacts in that category
  Widget _buildMetricCard({
    required ContactSelectionController controller,
    required String count,
    required String label,
    required String category,
  }) {
    final bool isSelected = controller.selectedCategory.value == category;
    final bool isCategorySelected =
    controller.isCategoryFullySelected(category);

    return SizedBox(
      width: 110.w,
      height: 110.h,
      child: GestureDetector(
        onTap: () => controller.toggleCategory(category),
        onLongPress: () => controller.toggleCategorySelection(category),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 110.w,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor.primaryColor.withOpacity(0.1)
                : AppColor.lightSurfaceColor,
            borderRadius: BorderRadius.circular(16.r),
            border: isCategorySelected
                ? Border.all(color: AppColor.primaryColor, width: 1.5)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count,
                    style: AppTextTheme.bodyTextStyle.copyWith(
                      color: AppColor.lightTextColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // Checkmark badge when category fully selected
                  if (isCategorySelected)
                    Container(
                      width: 16.r,
                      height: 16.r,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check,
                          color: Colors.white, size: 10.sp),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                style: AppTextTheme.bodyTextStyle.copyWith(
                  color: isSelected
                      ? AppColor.primaryColor
                      : AppColor.lightTextTertiaryColor,
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

// ─────────────────────────────────────────────────────────────
// ContactSelectionController
// ─────────────────────────────────────────────────────────────
class ContactSelectionController extends GetxController {
  final List<ContactModel> masterContacts;
  final List<ContactModel>? preSelected;

  ContactSelectionController({
    required this.masterContacts,
    this.preSelected,
  });

  var searchQuery = ''.obs;
  var selectedCategory = RxnString();
  final RxSet<ContactModel> selectedContacts = <ContactModel>{}.obs;

  @override
  void onInit() {
    super.onInit();
    if (preSelected != null) selectedContacts.addAll(preSelected!);
  }

  // ── Counters ───────────────────────────────────────────────
  int get countMuslim =>
      masterContacts.where((c) => c.category == 'Muslim').length;
  int get countInvite =>
      masterContacts.where((c) => c.category == 'Invite To Islam').length;
  int get countLegacy =>
      masterContacts.where((c) => c.category == 'Legacy Recipient').length;

  // ── Category Filter Toggle (short tap on card) ─────────────
  void toggleCategory(String category) {
    selectedCategory.value =
    selectedCategory.value == category ? null : category;
  }

  // ── Category Select Toggle (long press on card) ────────────
  bool isCategoryFullySelected(String category) {
    final contacts =
    masterContacts.where((c) => c.category == category).toList();
    return contacts.isNotEmpty && contacts.every(selectedContacts.contains);
  }

  void toggleCategorySelection(String category) {
    final contacts =
    masterContacts.where((c) => c.category == category).toList();
    if (isCategoryFullySelected(category)) {
      selectedContacts.removeAll(contacts);
    } else {
      selectedContacts.addAll(contacts);
    }
  }

  // ── Individual Contact Toggle ──────────────────────────────
  void toggleContact(ContactModel contact) {
    if (selectedContacts.contains(contact)) {
      selectedContacts.remove(contact);
    } else {
      selectedContacts.add(contact);
    }
  }

  bool isContactSelected(ContactModel contact) =>
      selectedContacts.contains(contact);

  // ── Letter Group Toggle ────────────────────────────────────
  bool isGroupSelected(List<ContactModel> contacts) =>
      contacts.isNotEmpty && contacts.every(selectedContacts.contains);

  void toggleGroupSelection(List<ContactModel> contacts) {
    if (isGroupSelected(contacts)) {
      selectedContacts.removeAll(contacts);
    } else {
      selectedContacts.addAll(contacts);
    }
  }

  // ── Select All / Deselect All ──────────────────────────────
  bool get areAllSelected =>
      masterContacts.isNotEmpty &&
          masterContacts.every(selectedContacts.contains);

  void toggleSelectAll() {
    if (areAllSelected) {
      selectedContacts.clear();
    } else {
      selectedContacts.addAll(masterContacts);
    }
  }

  // ── Filtered + Grouped ─────────────────────────────────────
  List<Map<String, dynamic>> get filteredGroupedContacts {
    Iterable<ContactModel> list = masterContacts;

    if (selectedCategory.value != null) {
      list = list.where((c) => c.category == selectedCategory.value);
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      list = list.where((c) =>
      c.name.toLowerCase().contains(query) || c.phone.contains(query));
    }

    final Map<String, List<ContactModel>> groups = {};
    for (var contact in list) {
      if (contact.name.isEmpty) continue;
      final firstLetter = contact.name[0].toUpperCase();
      groups.putIfAbsent(firstLetter, () => []).add(contact);
    }

    final sortedKeys = groups.keys.toList()..sort();
    return sortedKeys
        .map((key) => {'letter': key, 'contacts': groups[key]!})
        .toList();
  }
}