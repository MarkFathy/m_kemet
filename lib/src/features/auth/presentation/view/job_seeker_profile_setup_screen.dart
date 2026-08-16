import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/app_cubit/app_cubit.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';

class JobSeekerProfileSetupScreen extends StatefulWidget {
  const JobSeekerProfileSetupScreen({super.key});

  @override
  State<JobSeekerProfileSetupScreen> createState() => _JobSeekerProfileSetupScreenState();
}

class _JobSeekerProfileSetupScreenState extends State<JobSeekerProfileSetupScreen> {
  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppCubit>().state.locale.languageCode == 'ar';

    return AppScaffold(
      safeTop: true,
      safeBottom: true,
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.pW16,
          vertical: AppPadding.pH12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar with Brand & User Avatar / Lang
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).appBrandName,
                  style: getTextStyle().darkNavy.w700.s20,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<AppCubit>().toggleLanguage();
                      },
                      borderRadius: BorderRadius.circular(8.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Text(
                          isArabic ? 'EN' : 'عربي',
                          style: getTextStyle().darkNavy.bold.s16,
                        ),
                      ),
                    ),
                    8.szW,
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: const Color(0xFFD0E8FF),
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.darkNavy,
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            20.szH,

            // Header Titles
            Text(
              S.of(context).personalDocumentsTitle,
              style: getTextStyle().darkNavy.w700.s26,
            ),

            6.szH,

            Text(
              S.of(context).personalDocumentsSubtitle,
              style: getTextStyle().greyColor.w400.s14.copyWith(height: 1.5),
            ),

            24.szH,

            // Document Card 1: Passport Copy (Uploaded 100%)
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD0E8FF),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.badge_outlined,
                          color: AppColors.darkNavy,
                          size: 24.sp,
                        ),
                      ),
                      12.szW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).passportCopyTitle,
                              style: getTextStyle().darkNavy.w700.s16,
                            ),
                            4.szH,
                            Text(
                              S.of(context).passportCopyDesc,
                              style: getTextStyle().greyColor.w400.s12,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2F3EC),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              S.of(context).uploadedBadge,
                              style: getTextStyle().w600.s11.copyWith(
                                color: const Color(0xFF0F7D59),
                              ),
                            ),
                          ),
                          6.szW,
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.greyColor,
                              size: 20.sp,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),

                  14.szH,

                  // Progress File Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '100%',
                        style: getTextStyle().greyColor.w600.s12,
                      ),
                      Row(
                        children: [
                          Text(
                            'passport_scan_v2.pdf',
                            style: getTextStyle().darkNavy.w600.s13,
                          ),
                          6.szW,
                          Icon(
                            Icons.check_circle_rounded,
                            color: const Color(0xFF0F7D59),
                            size: 16.sp,
                          ),
                        ],
                      ),
                    ],
                  ),

                  6.szH,

                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: 1.0,
                      minHeight: 6.h,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F7D59)),
                    ),
                  ),
                ],
              ),
            ),

            16.szH,

            // Document Card 2: CV Upload Dropzone
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.description_outlined,
                          color: AppColors.darkNavy,
                          size: 24.sp,
                        ),
                      ),
                      12.szW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).cvTitle,
                              style: getTextStyle().darkNavy.w700.s16,
                            ),
                            4.szH,
                            Text(
                              S.of(context).cvDesc,
                              style: getTextStyle().greyColor.w400.s12,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          S.of(context).requiredBadge,
                          style: getTextStyle().w600.s11.copyWith(
                            color: const Color(0xFFDC2626),
                          ),
                        ),
                      ),
                    ],
                  ),

                  16.szH,

                  // Dashed Dropzone Button
                  InkWell(
                    onTap: () {
                      // Trigger file picker UI when ready
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.darkNavy.withValues(alpha: 0.3),
                          width: 1.5.w,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 32.sp,
                            color: AppColors.darkNavy,
                          ),
                          8.szH,
                          Text(
                            S.of(context).dragAndDropHint,
                            textAlign: TextAlign.center,
                            style: getTextStyle().darkNavy.w600.s13,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            16.szH,

            // Document Card 3: Intro Video & Certificates (Uploading 45%)
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2F3EC),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.workspace_premium_outlined,
                          color: const Color(0xFF0F7D59),
                          size: 24.sp,
                        ),
                      ),
                      12.szW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).introVideoTitle,
                              style: getTextStyle().darkNavy.w700.s16,
                            ),
                            4.szH,
                            Text(
                              S.of(context).introVideoDesc,
                              style: getTextStyle().greyColor.w400.s12,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          S.of(context).uploadingBadge,
                          style: getTextStyle().w600.s11.copyWith(
                            color: AppColors.darkNavy,
                          ),
                        ),
                      ),
                    ],
                  ),

                  14.szH,

                  // Upload Progress 45%
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '45%',
                        style: getTextStyle().greyColor.w600.s12,
                      ),
                      Row(
                        children: [
                          Text(
                            'cert_hotel_managment_2023.pdf',
                            style: getTextStyle().darkNavy.w600.s13,
                          ),
                          6.szW,
                          Icon(
                            Icons.autorenew_rounded,
                            color: AppColors.darkNavy,
                            size: 16.sp,
                          ),
                        ],
                      ),
                    ],
                  ),

                  6.szH,

                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: 0.45,
                      minHeight: 6.h,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.darkNavy),
                    ),
                  ),
                ],
              ),
            ),

            24.szH,

            // Profile Completion Status Card ("حالة الملف")
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '33%',
                        style: getTextStyle().darkNavy.w700.s16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            S.of(context).profileStatusTitle,
                            style: getTextStyle().darkNavy.w700.s18,
                          ),
                          Text(
                            S.of(context).documentsCompletion,
                            style: getTextStyle().greyColor.w400.s12,
                          ),
                        ],
                      ),
                    ],
                  ),

                  10.szH,

                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: 0.33,
                      minHeight: 8.h,
                      backgroundColor: const Color(0xFFCBD5E1),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.darkNavy),
                    ),
                  ),

                  16.szH,

                  // Checklist items
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        S.of(context).passportCopyTitle,
                        style: getTextStyle().darkNavy.w600.s13,
                      ),
                      6.szW,
                      Icon(Icons.check_circle_rounded, color: const Color(0xFF0F7D59), size: 16.sp),
                    ],
                  ),

                  8.szH,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        S.of(context).cvTitle,
                        style: getTextStyle().greyColor.w500.s13,
                      ),
                      6.szW,
                      Icon(Icons.radio_button_unchecked_rounded, color: AppColors.greyColor, size: 16.sp),
                    ],
                  ),

                  8.szH,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        S.of(context).introVideoTitle,
                        style: getTextStyle().greyColor.w500.s13,
                      ),
                      6.szW,
                      Icon(Icons.radio_button_unchecked_rounded, color: AppColors.greyColor, size: 16.sp),
                    ],
                  ),

                  20.szH,

                  CustomButton(
                    text: S.of(context).continueAction,
                    onPressed: () {
                      Go.offAllNamed(NamedRoutes.home);
                    },
                    backgroundColor: AppColors.steelBlue,
                    textStyle: getTextStyle().whiteColor.w700.s16,
                  ),
                ],
              ),
            ),

            20.szH,

            // Important Information Notice Card ("معلومات هامة")
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.darkNavy,
                        size: 22.sp,
                      ),
                      8.szW,
                      Text(
                        S.of(context).importantInfoTitle,
                        style: getTextStyle().darkNavy.w700.s16,
                      ),
                    ],
                  ),

                  8.szH,

                  Text(
                    S.of(context).importantInfoDesc,
                    style: getTextStyle().darkNavy.w400.s13.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),

            16.szH,
          ],
        ),
      ),
    );
  }
}
