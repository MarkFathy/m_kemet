import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/widgets/confirm_action_bottom_sheet.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_detail_cubit.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_detail_state.dart';

class CandidateDetailActionBar extends StatelessWidget {
  const CandidateDetailActionBar({super.key});

  void _showConfirmContactRequestSheet(BuildContext context) {
    showConfirmActionBottomSheet(
      context,
      icon: Icons.person_add_alt_1_rounded,
      iconBgColor: AppColors.softBlueBg,
      iconColor: AppColors.darkNavy,
      title: 'تأكيد طلب التواصل',
      message:
          'هل أنت متأكد من رغبتك في إرسال طلب تواصل مع هذا المرشح؟ سيتم إرسال الطلب لإدارة المنصة للمراجعة.',
      cancelLabel: S.of(context).cancel,
      confirmLabel: 'تأكيد الإرسال',
      confirmColor: AppColors.darkNavy,
      onConfirm: () {
        context.read<CandidateDetailCubit>().sendContactRequest();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidateDetailCubit, CandidateDetailState>(
      builder: (context, state) {
        final isSent = state.isContactRequestSent;
        final isSending = state.isSendingContactRequest;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (isSent || isSending)
                ? null
                : () => _showConfirmContactRequestSheet(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkNavy,
              foregroundColor: AppColors.whiteColor,
              disabledBackgroundColor: isSending
                  ? AppColors.softBlueBg
                  : (isSent ? const Color(0xFFF1F5F9) : const Color(0xFFF1F5F9)),
              disabledForegroundColor: AppColors.darkNavy,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              elevation: (isSent || isSending) ? 0 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: isSending
                    ? BorderSide(
                        color: AppColors.darkNavy.withValues(alpha: 0.2),
                        width: 1.2,
                      )
                    : (isSent
                        ? BorderSide(
                            color: AppColors.warningAmber.withValues(alpha: 0.5),
                            width: 1.2,
                          )
                        : BorderSide.none),
              ),
            ),
            child: isSending
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.darkNavy,
                          ),
                          backgroundColor:
                              AppColors.skyBlue.withValues(alpha: 0.35),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        S.of(context).sendingContactRequest,
                        style: getTextStyle().darkNavy.w700.s14,
                      ),
                    ],
                  )
                : (isSent
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            (state.contactRequestStatusLabel?.contains('مقبول') ==
                                        true ||
                                    state.contactRequestStatusLabel
                                            ?.toLowerCase()
                                            .contains('approved') ==
                                        true)
                                ? Icons.check_circle_rounded
                                : Icons.hourglass_top_rounded,
                            size: 18.sp,
                            color: (state.contactRequestStatusLabel?.contains('مقبول') ==
                                        true ||
                                    state.contactRequestStatusLabel
                                            ?.toLowerCase()
                                            .contains('approved') ==
                                        true)
                                ? AppColors.successGreen
                                : AppColors.warningAmber,
                          ),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: Text(
                              state.contactRequestStatusLabel ??
                                  'طلب تواصل قيد الانتظار',
                              style: getTextStyle().w700.s14.copyWith(
                                    color: const Color(0xFF1E293B),
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_add_alt_1_rounded,
                            size: 18.sp,
                            color: AppColors.whiteColor,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            S.of(context).requestContact,
                            style: getTextStyle().whiteColor.w700.s14,
                          ),
                        ],
                      )),
          ),
        );
      },
    );
  }
}
