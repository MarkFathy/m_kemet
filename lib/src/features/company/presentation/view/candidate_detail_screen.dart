import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/core/widgets/app_progress_indicator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_back_button.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_detail_cubit.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_detail_state.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/candidate_detail/candidate_detail_action_bar.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/candidate_detail/candidate_detail_summary_card.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/candidate_detail/candidate_qualifications_card.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/candidate_detail/candidate_video_card.dart';

class CandidateDetailScreen extends StatelessWidget {
  final CandidateEntity candidate;

  const CandidateDetailScreen({
    super.key,
    required this.candidate,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CandidateDetailCubit>(
          create: (context) => sl<CandidateDetailCubit>(param1: candidate)..fetchCandidateDetail(),
        ),
        // Expose the global singleton BookmarksCubit to this route's context
        BlocProvider<BookmarksCubit>.value(
          value: sl<BookmarksCubit>(),
        ),
      ],
      child: BlocConsumer<CandidateDetailCubit, CandidateDetailState>(
        listener: (context, state) {
          if (state.contactRequestMessage != null) {
            CustomSnackBar.showSuccess(
              context,
              message: state.contactRequestMessage!,
            );
          } else if (state.errorMessage != null && !state.isSendingContactRequest) {
            CustomSnackBar.showError(
              context,
              message: state.errorMessage!,
            );
          }
        },
        builder: (context, state) {
          final currentCandidate = state.candidate;
          final isLoading = state.status == CandidateDetailStatus.loading;

          return AppScaffold(
            safeTop: true,
            safeBottom: true,
            backgroundColor: AppColors.pageBg,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.pW12,
                vertical: AppPadding.pH12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Back Button
                  Row(
                    children: [
                      const CustomBackButton(),
                      8.szW,
                      Expanded(
                        child: Text(
                          S.of(context).candidateProfileTitle,
                          style: getTextStyle().darkNavy.w700.s20,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isLoading) ...[
                        8.szW,
                        SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const AppProgressIndicator(),
                        ),
                      ],
                      IconButton(
                        onPressed: () {
                          final cubit = context.read<CandidateDetailCubit>();
                          // Sync BookmarksCubit so saved_candidates_screen stays consistent
                          context.read<BookmarksCubit>().toggleBookmark(currentCandidate);
                          cubit.toggleBookmark();
                        },
                        icon: Icon(
                          currentCandidate.isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: currentCandidate.isSaved
                              ? AppColors.warningAmber
                              : AppColors.darkNavy,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),

                  20.szH,

                  // Candidate Summary Card
                  CandidateDetailSummaryCard(candidate: currentCandidate),

                  16.szH,

                  // Video Section (plays video or shows clear unavailable status)
                  CandidateVideoCard(
                    videoUrl: currentCandidate.introVideoUrl,
                    thumbnailUrl: currentCandidate.videoThumbnailUrl,
                  ),

                  // Bio and Detailed Qualifications (without CV or extra unwanted fields)
                  CandidateQualificationsCard(candidate: currentCandidate),

                  24.szH,

                  // Primary Action Buttons Row (Request Contact)
                  const CandidateDetailActionBar(),

                  20.szH,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
