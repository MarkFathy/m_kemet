import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';

class RequestsTab extends StatelessWidget {
  const RequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final mockRequests = [
      {
        'candidateName': 'سارة خالد البقمي',
        'profession': 'ممرضة رعاية مركزة',
        'date': '17 أغسطس 2026',
        'ref': '#REQ-8041',
        'status': S.of(context).statusApproved,
        'statusColor': AppColors.successGreen,
        'statusBg': AppColors.successBg,
        'canConnect': true,
      },
      {
        'candidateName': 'أحمد محمود حسن',
        'profession': 'سائق شاحنة نقل ثقيل',
        'date': '16 أغسطس 2026',
        'ref': '#REQ-8038',
        'status': S.of(context).statusPending,
        'statusColor': AppColors.warningAmber,
        'statusBg': AppColors.warningBg,
        'canConnect': false,
      },
      {
        'candidateName': 'خالد يوسف العمراني',
        'profession': 'فني كهرباء ومقاولات',
        'date': '12 أغسطس 2026',
        'ref': '#REQ-7910',
        'status': S.of(context).statusCompleted,
        'statusColor': AppColors.darkNavy,
        'statusBg': AppColors.softBlueBg,
        'canConnect': true,
      },
    ];

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
            S.of(context).requestsTitle,
            style: getTextStyle().darkNavy.w700.s24,
          ),
          16.szH,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockRequests.length,
            separatorBuilder: (context, index) => 12.szH,
            itemBuilder: (context, index) {
              final req = mockRequests[index];
              final canConnect = req['canConnect'] as bool;

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(req['ref'] as String, style: getTextStyle().greyColor.w600.s12),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: req['statusBg'] as Color,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            req['status'] as String,
                            style: getTextStyle().w700.s11.copyWith(
                                  color: req['statusColor'] as Color,
                                ),
                          ),
                        ),
                      ],
                    ),
                    8.szH,
                    Text(req['candidateName'] as String, style: getTextStyle().darkNavy.w700.s16),
                    4.szH,
                    Text(req['profession'] as String, style: getTextStyle().steelBlue.w500.s13),
                    12.szH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(req['date'] as String, style: getTextStyle().greyColor.w400.s12),
                        if (canConnect)
                          ElevatedButton.icon(
                            onPressed: () {
                              CustomSnackBar.showSuccess(
                                context,
                                message: S.of(context).contactRequestSuccess,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkNavy,
                              foregroundColor: AppColors.whiteColor,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            icon: Icon(Icons.chat_bubble_outline_rounded, size: 14.sp),
                            label: Text(
                              S.of(context).requestContact,
                              style: getTextStyle().whiteColor.w700.s12,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          100.szH,
        ],
      ),
    );
  }
}
