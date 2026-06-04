import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/features/contacts/screens/contacts_screen.dart';
import 'package:outlive/features/home/screens/home_screen.dart';
import 'package:outlive/features/legacy/screens/legacy_screen.dart';
import 'package:outlive/features/notification/screens/notification_screen.dart';
import 'package:outlive/features/profile/screens/profile_screen.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/text_theme.dart';
import '../../contacts/screens/create_contact_screen.dart';
import '../../legacy/screens/create_reminder_screen.dart';

class BottomNavController extends GetxController {
  // Track active tab index (0: Home, 1: Legacy, 2: Contacts, 3: Profile)
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }


  final List<Widget> tab = [
    HomeScreen(),
    LegacyScreen(),
    ContactsScreen(),
    ProfileScreen()
  ];

  final List<AppBar> appBar = [
    AppBar(
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Assalamu Alaikum, Ovie',
                    style: AppTextTheme.titleTextStyle.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text('👋', style: TextStyle(fontSize: 18.sp)),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                'You have 3 important memories this week',
                style: AppTextTheme.bodyTextStyle.copyWith(
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Row(
            children: [

            ],
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      actions: [
        GestureDetector(
          onTap:(){
            Get.to(NotificationScreen());
          },
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColor.lightSurfaceColor,
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: const Color(0xFF1A1A1A),
                  size: 20.sp,
                ),
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
            ),
          ),
        ),
        Container(
          width: 40.w,
          height: 40.h,
          margin: EdgeInsets.only(left: 12.w, right: 8.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.r),
            image: const DecorationImage(
              image: NetworkImage('https://i.pravatar.cc/300'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
    AppBar(
      elevation: 0,
      title: Text(
        'Legacy',
        style: AppTextTheme.bodyTextStyle.copyWith(
            color: AppColor.lightTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        Container(
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
              color: AppColor.lightSurfaceColor,
              shape: BoxShape.circle
          ),
          child: IconButton(
            onPressed: (){
              Get.to(NotificationScreen());
            },
            icon: Icon(CupertinoIcons.bell, color: AppColor.lightTextSecondaryColor, size: 18.sp),
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
            fontWeight: FontWeight.w600
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        Container(
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
              color: AppColor.lightSurfaceColor,
              shape: BoxShape.circle
          ),
          child: IconButton(
            onPressed: (){
              Get.to(NotificationScreen());
            },
            icon: Icon(CupertinoIcons.bell, color: AppColor.lightTextSecondaryColor, size: 18.sp),
          ),
        ),

        Container(
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
              color: AppColor.lightSurfaceColor,
              shape: BoxShape.circle
          ),
          child: IconButton(
            onPressed: (){
              Get.to(CreateContactScreen());
            },
            icon: Icon(CupertinoIcons.plus, color: AppColor.lightTextSecondaryColor, size: 18.sp),
          ),
        )
      ],
    ),
    AppBar(
      elevation: 0,
      title: Text(
        'Profile',
        style: AppTextTheme.bodyTextStyle.copyWith(
            color: AppColor.lightTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        Container(
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
              color: AppColor.lightSurfaceColor,
              shape: BoxShape.circle
          ),
          child: IconButton(
            onPressed: (){
              // Handle notification icon action
             Get.to(NotificationScreen());
            },
            icon: Icon(CupertinoIcons.bell, color: AppColor.lightTextSecondaryColor, size: 18.sp),
          ),
        ),
      ],
    ),
  ];


  void onFabPressed() {
    // Handle center '+' button action
    Get.to(CreateReminderScreen());
  }
}