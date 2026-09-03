import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_detail_cubit.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_detail_state.dart';

class CandidateDetailActionBar extends StatelessWidget {
  const CandidateDetailActionBar({super.key});

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
                : () {
                    context.read<CandidateDetailCubit>().sendContactRequest();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkNavy,
              foregroundColor: AppColors.whiteColor,
              disabledBackgroundColor: const Color(0xFFF1F5F9),
              disabledForegroundColor: AppColors.darkNavy,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              elevation: isSent ? 0 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: isSent
                    ? BorderSide(
                        color: AppColors.successGreen.withValues(alpha: 0.5),
                        width: 1.2,
                      )
                    : BorderSide.none,
              ),
            ),
            child: isSending
                ? SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: AppColors.whiteColor,
                    ),
                  )
                : Text(
                    isSent
                        ? (state.contactRequestStatusLabel ??
                            S.of(context).contactRequestSuccess)
                        : S.of(context).requestContact,
                    style: getTextStyle().w700.s14.copyWith(
                          color: isSent
                              ? const Color(0xFF1E293B)
                              : AppColors.whiteColor,
                        ),
                  ),
          ),
        );
      },
    );
  }
}
