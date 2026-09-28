import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/profile_detail_row.dart';

class JobSeekerDetailsCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String countryDisplay;
  final String gender;

  const JobSeekerDetailsCard({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.countryDisplay,
    required this.gender,
  });

  static const Color _lightBlueBg = AppColors.softBlueBg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: _lightBlueBg,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.badge_outlined, color: AppColors.darkNavy, size: 16.sp),
              ),
              8.szW,
              Text(
                S.of(context).accountAndProfileDetailsTitle,
                style: getTextStyle().darkNavy.w700.s15,
              ),
            ],
          ),
          14.szH,
          ProfileDetailRow(
            icon: Icons.person_outline_rounded,
            iconColor: AppColors.darkNavy,
            bgColor: _lightBlueBg,
            label: S.of(context).fullNameLabel,
            value: name.isNotEmpty ? name : '—',
          ),
          12.szH,
          const Divider(color: AppColors.dividerGrey, height: 1),
          12.szH,
          ProfileDetailRow(
            icon: Icons.phone_outlined,
            iconColor: AppColors.darkNavy,
            bgColor: _lightBlueBg,
            label: S.of(context).phoneLabel,
            value: phone.isNotEmpty ? phone : '—',
          ),
          /*
          12.szH,
          const Divider(color: AppColors.dividerGrey, height: 1),
          12.szH,
          ProfileDetailRow(
            icon: Icons.email_outlined,
            iconColor: AppColors.darkNavy,
            bgColor: _lightBlueBg,
            label: S.of(context).emailLabel,
            value: email.isNotEmpty ? email : '—',
          ),
          */
          if (countryDisplay.isNotEmpty) ...[
            12.szH,
            const Divider(color: AppColors.dividerGrey, height: 1),
            12.szH,
            ProfileDetailRow(
              icon: Icons.public_rounded,
              iconColor: AppColors.darkNavy,
              bgColor: _lightBlueBg,
              label: S.of(context).currentCountryLabel,
              value: countryDisplay,
            ),
          ],
          if (gender.isNotEmpty) ...[
            12.szH,
            const Divider(color: AppColors.dividerGrey, height: 1),
            12.szH,
            ProfileDetailRow(
              icon: Icons.wc_rounded,
              iconColor: AppColors.darkNavy,
              bgColor: _lightBlueBg,
              label: S.of(context).genderLabel,
              value: gender,
            ),
          ],
        ],
      ),
    );
  }
}
