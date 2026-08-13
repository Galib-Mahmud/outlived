import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/features/contacts/screens/contacts_screen.dart';
import 'package:outlive/features/home/screens/home_screen.dart';
import 'package:outlive/features/legacy/screens/legacy_screen.dart';
import 'package:outlive/features/notification/screens/notification_screen.dart';
import 'package:outlive/features/profile/screens/profile_screen.dart';

import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/text_theme.dart';
import '../../contacts/screens/create_contact_screen.dart';
import '../../legacy/screens/create_reminder_screen.dart';

class BottomNavController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  // Track active tab index (0: Home, 1: Legacy, 2: Contacts, 3: Profile)
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  // ─── Dynamic top-bar state ──────────────────────────────────────
  // Real data, fetched from GET /me — replaces the previous hardcoded
  // pravatar.cc placeholder.
  final RxString avatarUrl = ''.obs;

  // NOTE: defaults to false/hidden rather than the previous hardcoded
  // always-on red dot. Your API doc has no notifications endpoint at all
  // (no /notifications, no unread-count field anywhere) — there's nothing
  // real to fetch yet. This needs a backend endpoint before it can show
  // an honest unread state; left off rather than permanently "lit" and
  // misleading.
  final RxBool hasUnreadNotifications = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final res = await _apiClient.get(ApiEndpoint.me);
      if (res != null) {
        avatarUrl.value = res['profile']?['avatar'] ?? '';
      }
    } catch (e) {
      debugPrint('BottomNavController: failed to fetch profile: $e');
    }
  }

  final List<Widget> tab = [
    HomeScreen(),
    LegacyScreen(),
    ContactsScreen(),
    ProfileScreen(),
  ];

  List<AppBar> get appBar => [
    AppBar(
      title: Text(
        'Home',
        style: AppTextTheme.bodyTextStyle.copyWith(
          color: AppColor.lightTextColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        GestureDetector(
          onTap: () => Get.to(() => const NotificationScreen()),
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColor.lightSurfaceColor,
              shape: BoxShape.circle,
            ),
            child: Obx(() => Stack(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: const Color(0xFF1A1A1A),
                  size: 20.sp,
                ),
                if (hasUnreadNotifications.value)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            )),
          ),
        ),
        // FIX: was a hardcoded NetworkImage('https://i.pravatar.cc/300')
        // placeholder — now shows the real user's avatar from GET /me,
        // wrapped in Obx so it updates once the fetch completes (the
        // outer AppBar list itself isn't reactive, but this inner Obx
        // rebuilds independently when avatarUrl changes).
        Obx(() => Container(
          width: 40.w,
          height: 40.h,
          margin: EdgeInsets.only(left: 12.w, right: 8.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.r),
            color: AppColor.lightSurfaceColor,
            image: avatarUrl.value.isNotEmpty
                ? DecorationImage(image: NetworkImage(avatarUrl.value), fit: BoxFit.cover)
                : null,
          ),
          child: avatarUrl.value.isEmpty
              ? Icon(Icons.person_outline, color: AppColor.lightTextTertiaryColor, size: 20.sp)
              : null,
        )),
      ],
    ),
    AppBar(
      elevation: 0,
      title: Text(
        'Legacy',
        style: AppTextTheme.bodyTextStyle.copyWith(
          color: AppColor.lightTextColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        Container(
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(color: AppColor.lightSurfaceColor, shape: BoxShape.circle),
          child: IconButton(
            onPressed: () => Get.to(() => const NotificationScreen()),
            icon: Icon(CupertinoIcons.bell, color: AppColor.lightTextSecondaryColor, size: 18.sp),
          ),
        ),
      ],
    ),
    AppBar(
      elevation: 0,
      title: Text(
        // FIX: this is the Contacts tab (tab[2] = ContactsScreen()), but
        // the title said "Profile" — same mismatch the "+" action already
        // correctly implies (create *contact*, not profile).
        'Contacts',
        style: AppTextTheme.bodyTextStyle.copyWith(
          color: AppColor.lightTextColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        Container(
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(color: AppColor.lightSurfaceColor, shape: BoxShape.circle),
          child: IconButton(
            onPressed: () => Get.to(() => const NotificationScreen()),
            icon: Icon(CupertinoIcons.bell, color: AppColor.lightTextSecondaryColor, size: 18.sp),
          ),
        ),
        Container(
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(color: AppColor.lightSurfaceColor, shape: BoxShape.circle),
          child: IconButton(
            onPressed: () => Get.to(() => const CreateContactScreen()),
            icon: Icon(CupertinoIcons.plus, color: AppColor.lightTextSecondaryColor, size: 18.sp),
          ),
        ),
      ],
    ),
    AppBar(
      elevation: 0,
      title: Text(
        'Profile',
        style: AppTextTheme.bodyTextStyle.copyWith(
          color: AppColor.lightTextColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        Container(
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(color: AppColor.lightSurfaceColor, shape: BoxShape.circle),
          child: IconButton(
            onPressed: () => Get.to(() => const NotificationScreen()),
            icon: Icon(CupertinoIcons.bell, color: AppColor.lightTextSecondaryColor, size: 18.sp),
          ),
        ),
      ],
    ),
  ];

  void onFabPressed() {
    // NOTE: always opens Create Reminder regardless of which tab is
    // active — matches the original behavior. If tapping '+' should
    // create something different per-tab (e.g. a contact while on the
    // Contacts tab), let me know and I'll branch this on selectedIndex.
    Get.to(() => const CreateReminderScreen());
  }
}