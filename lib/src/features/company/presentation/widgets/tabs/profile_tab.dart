import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/profile_detail_row.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.pW12,
        vertical: AppPadding.pH12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).employerProfileTitle,
            style: getTextStyle().darkNavy.w700.s24,
          ),
          16.szH,

          // Header Summary Card
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderGrey),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28.r,
                  backgroundColor: AppColors.softBlueBg,
                  child: Icon(Icons.business_rounded, color: AppColors.darkNavy, size: 26.sp),
                ),
                14.szW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'شركة الخليج للاستقدام والتطوير',
                              style: getTextStyle().darkNavy.w700.s16,
                            ),
                          ),
                          6.szW,
                          Icon(Icons.verified_rounded, size: 16.sp, color: AppColors.successGreen),
                        ],
                      ),
                      4.szH,
                      Text(
                        S.of(context).companyProfileSub,
                        style: getTextStyle().greyColor.w500.s12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          16.szH,

          // Detailed Info Card
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderGrey),
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
                Text(S.of(context).companyInfoTitle, style: getTextStyle().darkNavy.w700.s16),
                14.szH,
                ProfileDetailRow(
                  icon: Icons.business_outlined,
                  iconColor: AppColors.darkNavy,
                  bgColor: AppColors.softBlueBg,
                  label: S.of(context).companyNameField,
                  value: 'شركة الخليج للاستقدام والتطوير',
                ),
                12.szH,
                const Divider(color: AppColors.dividerGrey, height: 1),
                12.szH,
                ProfileDetailRow(
                  icon: Icons.phone_outlined,
                  iconColor: AppColors.successGreen,
                  bgColor: AppColors.successBg,
                  label: S.of(context).companyPhoneField,
                  value: '+966 50 123 4567',
                ),
                12.szH,
                const Divider(color: AppColors.dividerGrey, height: 1),
                12.szH,
                ProfileDetailRow(
                  icon: Icons.email_outlined,
                  iconColor: AppColors.warningAmber,
                  bgColor: AppColors.warningBg,
                  label: S.of(context).companyEmailField,
                  value: 'contact@gulf-recruitment.com',
                ),
                12.szH,
                const Divider(color: AppColors.dividerGrey, height: 1),
                12.szH,
                ProfileDetailRow(
                  icon: Icons.badge_outlined,
                  iconColor: AppColors.darkNavy,
                  bgColor: AppColors.chipBg,
                  label: S.of(context).companyCrField,
                  value: 'CR-1010928374',
                ),
                12.szH,
                const Divider(color: AppColors.dividerGrey, height: 1),
                12.szH,
                ProfileDetailRow(
                  icon: Icons.location_on_outlined,
                  iconColor: AppColors.steelBlue,
                  bgColor: AppColors.softBlueBg,
                  label: S.of(context).companyLocationField,
                  value: 'الرياض، المملكة العربية السعودية',
                ),
              ],
            ),
          ),

          20.szH,
        ],
      ),
    );
  }
}
