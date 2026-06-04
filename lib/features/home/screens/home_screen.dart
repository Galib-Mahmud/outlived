import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:outlive/core/theme/app_color.dart';
import '../../../core/theme/text_theme.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER SECTION ---
              Row(
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
                      GestureDetector(
                        onTap: controller.handleNotificationTap,
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
                      SizedBox(width: 12.w),
                      // Profile Image Avatar block
                      GestureDetector(
                        onTap: controller.handleProfileTap,
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.r),
                            image: const DecorationImage(
                              image: NetworkImage('https://i.pravatar.cc/300'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // --- SUNRISE & SUNSET CARD BANNER ---
              Container(
                width: double.infinity,
                height: 90.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/sunrise_bg.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black54,
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Circular Mini Sun Graphic Indicator
                      Container(
                        width: 54.w,
                        height: 54.h,
                        padding: EdgeInsets.all(8.r),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/sun_status_bg.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '7:23',
                                style: AppTextTheme.bodyTextStyle.copyWith(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              Text(
                                '6:32',
                                style: AppTextTheme.bodyTextStyle.copyWith(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sunrise & Sunset',
                            style: AppTextTheme.bodyTextStyle.copyWith(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Fajar will start at after 7:39 AM',
                            style: AppTextTheme.bodyTextStyle.copyWith(
                              fontSize: 12.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // --- PRIMARY MEMORY CARD BLOCK ---
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColor.lightSurfaceColor,
                  borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColor.lightBoarderColor, width: 1.r)
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/whatsapp.png',
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.memoryPost.author,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1A1A),
                                  ),
                                ),
                                Text(
                                  controller.memoryPost.relativeTime,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColor.secondaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: AppColor.primaryColor.withOpacity(0.2), width: 1.r)
                          ),
                          child: Text(
                            '• ${controller.memoryPost.tag}',
                            style: TextStyle(
                              color: AppColor.primaryColor.withOpacity(0.7),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        top: 14.h,
                        right: 14.w,
                        bottom: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.lightBackgroundColor,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: AppColor.lightBoarderColor, width: 1.r)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 3.w,
                            height: 64.h,
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(14.r),
                                bottomRight: Radius.circular(14.r),
                              )
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              controller.memoryPost.quote,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: const Color(0xFF2C2C2C),
                                height: 1.4.h,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // --- GOOD DEED POSTS HEADER SECTION ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  label('Good Deed Posts'),
                  GestureDetector(
                    onTap: controller.handleCreateNewDeed,
                    child: Text(
                      'Create Now',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColor.secondaryColor
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14.h),

              // Horizontal Good Deed List Row Block
              SizedBox(
                height: 155.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.goodDeedPosts.length,
                  separatorBuilder: (_, __) => SizedBox(width: 14.w),
                  itemBuilder: (context, index) {
                    final deed = controller.goodDeedPosts[index];
                    return Container(
                      width: 165.w,
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: AppColor.lightSurfaceColor,
                        borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(color: AppColor.lightBoarderColor, width: 1.r)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/icons/deed_icon.png',
                                width: 24.w,
                                height: 24.h,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                deed.timestamp,
                                style: TextStyle(
                                  color: const Color(0xFF9E9E9E),
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                deed.title,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1A1A1A),
                                  height: 1.2.h,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                deed.snippet,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: const Color(0xFF9E9E9E),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.lightBackgroundColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              deed.platform,
                              style: TextStyle(
                                color: const Color(0xFF555555),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 24.h),

              // --- IMPACT GRID MEASUREMENT ROW ---
              label('Your Impact'),

              SizedBox(height: 14.h),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.w,
                  mainAxisSpacing: 14.h,
                  childAspectRatio: 1.35,
                ),
                itemCount: controller.impactMetrics.length,
                itemBuilder: (context, index) {
                  final metric = controller.impactMetrics[index];
                  return Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: AppColor.lightSurfaceColor,
                       border: Border.all(color: AppColor.lightBoarderColor, width: 1.r),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              metric.isGreenIcon
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.send_rounded,
                              color: metric.isGreenIcon
                                  ? const Color(0xFF00C853)
                                  : const Color(0xFFAB47BC),
                              size: 20.sp,
                            ),
                            Icon(
                              Icons.trending_up_rounded,
                              color: const Color(0xFF9E9E9E),
                              size: 16.sp,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              metric.value,
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                            Text(
                              metric.label,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFF888888),
                                fontWeight: FontWeight.w500,
                                height: 1.2.h,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: 24.h),

              // --- DAILY REMINDER FOOTER BLOCK ---
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColor.lightSurfaceColor,
                  border: Border.all(color: AppColor.lightBoarderColor, width: 1.r),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    label('Daily Reminder Card'),
                    SizedBox(height: 12.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        top: 14.h,
                        right: 14.w,
                        bottom: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.lightBackgroundColor,
                        border: Border.all(color: AppColor.lightBoarderColor, width: 1.r),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 3.w,
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12.r),
                                bottomRight: Radius.circular(12.r),
                              )
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            '“Today is Jummah Day.”',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2C2C2C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Text label(String text) {
    return Text(
      text,
                  style: AppTextTheme.bodyTextStyle.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.lightTextColor
                  ),
                );
  }
}
