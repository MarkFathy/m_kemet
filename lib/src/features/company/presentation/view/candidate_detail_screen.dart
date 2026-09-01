import 'package:flutter/material.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_back_button.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
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
                12.szW,
                Text(
                  S.of(context).candidateProfileTitle,
                  style: getTextStyle().darkNavy.w700.s20,
                ),
              ],
            ),

            20.szH,

            // Candidate Summary Card
            CandidateDetailSummaryCard(candidate: candidate),

            16.szH,

            // Video Container Mockup
            CandidateVideoCard(
              videoUrl: candidate.introVideoUrl,
              photoUrl: candidate.photoUrl,
            ),

            // Bio and Detailed Qualifications
            CandidateQualificationsCard(candidate: candidate),

            24.szH,

            // Primary Action Buttons Row
            const CandidateDetailActionBar(),

            20.szH,
          ],
        ),
      ),
    );
  }
}
