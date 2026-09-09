import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/profile_detail_row.dart';

class CompanyProfileDetailsCard extends StatelessWidget {
  final String companyName;
  final String phone;
  final String email;
  final String? crNumber;
  final String? location;

  const CompanyProfileDetailsCard({
    super.key,
    required this.companyName,
    required this.phone,
    required this.email,
    this.crNumber,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          if (companyName.trim().isNotEmpty) ...[
            14.szH,
            ProfileDetailRow(
              icon: Icons.business_outlined,
              iconColor: AppColors.darkNavy,
              bgColor: AppColors.softBlueBg,
              label: S.of(context).companyNameField,
              value: companyName,
            ),
          ],
          if (phone.trim().isNotEmpty) ...[
            12.szH,
            const Divider(color: AppColors.dividerGrey, height: 1),
            12.szH,
            ProfileDetailRow(
              icon: Icons.phone_outlined,
              iconColor: AppColors.successGreen,
              bgColor: AppColors.successBg,
              label: S.of(context).companyPhoneField,
              value: phone,
            ),
          ],
          if (email.trim().isNotEmpty) ...[
            12.szH,
            const Divider(color: AppColors.dividerGrey, height: 1),
            12.szH,
            ProfileDetailRow(
              icon: Icons.email_outlined,
              iconColor: AppColors.warningAmber,
              bgColor: AppColors.warningBg,
              label: S.of(context).companyEmailField,
              value: email,
            ),
          ],
          if (crNumber != null && crNumber!.trim().isNotEmpty) ...[
            12.szH,
            const Divider(color: AppColors.dividerGrey, height: 1),
            12.szH,
            ProfileDetailRow(
              icon: Icons.badge_outlined,
              iconColor: AppColors.darkNavy,
              bgColor: AppColors.chipBg,
              label: S.of(context).companyCrField,
              value: crNumber!,
            ),
          ],
          if (location != null && location!.trim().isNotEmpty) ...[
            12.szH,
            const Divider(color: AppColors.dividerGrey, height: 1),
            12.szH,
            ProfileDetailRow(
              icon: Icons.location_on_outlined,
              iconColor: AppColors.steelBlue,
              bgColor: AppColors.softBlueBg,
              label: S.of(context).companyLocationField,
              value: location!,
            ),
          ],
        ],
      ),
    );
  }
}
