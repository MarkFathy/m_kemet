import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/services/session_manager.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/core/widgets/status_badge.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/candidate_document_entity.dart';

class RejectedStatusCard extends StatelessWidget {
  /// Documents with per-document rejection reasons from the backend
  final List<CandidateDocumentEntity> documents;

  const RejectedStatusCard({
    super.key,
    this.documents = const [],
  });

  /// Human-readable label for each document type
  String _docLabel(String type) {
    switch (type) {
      case 'personal_photo':
        return 'الصورة الشخصية';
      case 'national_id':
        return 'بطاقة الهوية الوطنية';
      case 'passport':
        return 'جواز السفر';
      case 'cv':
        return 'السيرة الذاتية (CV)';
      default:
        return type;
    }
  }

  /// Icon for each document type
  IconData _docIcon(String type) {
    switch (type) {
      case 'personal_photo':
        return Icons.person_outline_rounded;
      case 'national_id':
        return Icons.badge_outlined;
      case 'passport':
        return Icons.airplane_ticket_outlined;
      case 'cv':
        return Icons.description_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only show documents that have a rejection reason
    final rejectedDocs = documents
        .where((d) =>
            !d.isApproved &&
            d.rejectionReason != null &&
            d.rejectionReason!.trim().isNotEmpty)
        .toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.5), width: 1.5.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header Icon ──────────────────────────────────────────────────
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: AppColors.errorBg,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.errorRed, width: 2.w),
            ),
            child: Icon(
              Icons.cancel_rounded,
              color: AppColors.errorRed,
              size: 36.sp,
            ),
          ),

          14.szH,

          StatusBadge(
            label: S.of(context).statusRejected,
            color: AppColors.errorRed,
            bgColor: AppColors.errorBg,
          ),

          14.szH,

          Text(
            S.of(context).rejectedHeaderTitle,
            textAlign: TextAlign.center,
            style: getTextStyle().darkNavy.w700.s18,
          ),

          6.szH,

          Text(
            S.of(context).rejectedHeaderDesc,
            textAlign: TextAlign.center,
            style: getTextStyle().greyColor.w400.s13.copyWith(height: 1.4),
          ),

          20.szH,

          // ── Per-document rejection reasons ───────────────────────────────
          if (rejectedDocs.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.errorBg,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  Row(
                    children: [
                      Icon(
                        Icons.report_problem_outlined,
                        color: AppColors.errorRed,
                        size: 18.sp,
                      ),
                      8.szW,
                      Expanded(
                        child: Text(
                          S.of(context).rejectionReasonTitle,
                          style: getTextStyle().w700.s14.copyWith(
                                color: AppColors.errorRed,
                              ),
                        ),
                      ),
                    ],
                  ),

                  12.szH,

                  // One row per rejected document
                  ...rejectedDocs.map((doc) => _buildDocRejectionRow(context, doc)),
                ],
              ),
            ),
            20.szH,
          ] else ...[
            // Fallback generic note when no per-doc reasons
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.errorBg,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: AppColors.errorRed, size: 18.sp),
                  10.szW,
                  Expanded(
                    child: Text(
                      S.of(context).rejectionReasonSample,
                      style: getTextStyle().w500.s13.copyWith(
                            color: AppColors.errorRed,
                            height: 1.5,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            20.szH,
          ],

          // ── Resubmit Button ──────────────────────────────────────────────
          CustomButton(
            text: S.of(context).resubmitRequest,
            onPressed: () async {
              await SessionManager.setJobSeekerProfileCompleted(false);
              Go.offAllNamed(NamedRoutes.jobSeekerProfileSetup);
            },
            backgroundColor: AppColors.errorRed,
            textStyle: getTextStyle().whiteColor.w700.s16,
          ),

          12.szH,

          // ── Contact Support Button ───────────────────────────────────────
          OutlinedButton(
            onPressed: () {
              CustomSnackBar.showInfo(
                context,
                message: S.of(context).supportReadyToHelp,
              );
            },
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 44.h),
              foregroundColor: AppColors.darkNavy,
              side: const BorderSide(color: AppColors.darkNavy),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.headset_mic_outlined, size: 18.sp, color: AppColors.darkNavy),
                8.szW,
                Text(
                  S.of(context).contactSupport,
                  style: getTextStyle().darkNavy.w700.s14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocRejectionRow(BuildContext context, CandidateDocumentEntity doc) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doc type icon
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.errorBg,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                _docIcon(doc.documentType),
                color: AppColors.errorRed,
                size: 16.sp,
              ),
            ),
            10.szW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _docLabel(doc.documentType),
                    style: getTextStyle().w700.s13.copyWith(color: AppColors.darkNavy),
                  ),
                  4.szH,
                  Text(
                    doc.rejectionReason!,
                    style: getTextStyle().w400.s12.copyWith(
                          color: AppColors.errorRed,
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
