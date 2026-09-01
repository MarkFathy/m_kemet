import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class CompanyProfileHeaderCard extends StatelessWidget {
  final String companyName;

  const CompanyProfileHeaderCard({
    super.key,
    this.companyName = 'شركة الخليج للاستقدام والتطوير',
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
                        companyName,
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
    );
  }
}
