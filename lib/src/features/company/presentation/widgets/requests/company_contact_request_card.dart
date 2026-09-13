import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/features/company/data/models/company_contact_request_model.dart';

class CompanyContactRequestCard extends StatelessWidget {
  final CompanyContactRequestModel request;
  final VoidCallback? onViewProfile;

  const CompanyContactRequestCard({
    super.key,
    required this.request,
    this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    final codeText = (request.code != null && request.code!.isNotEmpty)
        ? request.code!
        : '#${request.id}';

    final dateText = request.requestDate?.isNotEmpty == true
        ? request.requestDate!
        : (request.createdAt?.isNotEmpty == true
            ? request.createdAt!.split('T').first
            : '');

    return InkWell(
      onTap: onViewProfile,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
            // Row 1: Request Code & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.softBlueBg,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.tag_rounded,
                        size: 13.sp,
                        color: AppColors.darkNavy,
                      ),
                      4.szW,
                      Text(
                        codeText,
                        style: getTextStyle().darkNavy.w600.s12,
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(context),
              ],
            ),

            12.szH,

            // Candidate Name
            Text(
              request.name,
              style: getTextStyle().darkNavy.w700.s16,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            4.szH,

            // Profession
            Text(
              request.profession,
              style: getTextStyle().steelBlue.w600.s14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            14.szH,
            Divider(height: 1.h, color: AppColors.dividerGrey),
            10.szH,

            // Request Date
            if (dateText.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14.sp,
                    color: AppColors.greyColor,
                  ),
                  6.szW,
                  Text(
                    dateText,
                    style: getTextStyle().greyColor.w500.s12,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final status = request.status.toLowerCase();
    Color bg = AppColors.warningBg;
    Color color = AppColors.warningAmber;
    IconData icon = Icons.hourglass_empty_rounded;

    if (status == 'accepted' || status == 'approved') {
      bg = AppColors.successBg;
      color = AppColors.successGreen;
      icon = Icons.check_circle_rounded;
    } else if (status == 'rejected' || status == 'declined' || status == 'refused') {
      bg = AppColors.errorBg;
      color = AppColors.errorRed;
      icon = Icons.cancel_rounded;
    }

    final label = request.statusLabel.isNotEmpty
        ? request.statusLabel
        : (status == 'pending'
            ? S.of(context).statusPending
            : (status == 'accepted' || status == 'approved'
                ? S.of(context).statusApproved
                : S.of(context).statusRejected));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: color),
          5.szW,
          Text(
            label,
            style: getTextStyle().w700.s11.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
