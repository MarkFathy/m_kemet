import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/services/service_locater/service_locator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_back_button.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_search_cubit.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_search_state.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/candidate_card.dart';

class SavedCandidatesScreen extends StatelessWidget {
  const SavedCandidatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CandidateSearchCubit>(
      create: (context) => sl<CandidateSearchCubit>()..fetchCandidates(),
      child: AppScaffold(
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
              Row(
                children: [
                  const CustomBackButton(),
                  12.szW,
                  Text(
                    S.of(context).savedCandidatesTitle,
                    style: getTextStyle().darkNavy.w700.s20,
                  ),
                ],
              ),

              20.szH,

              BlocBuilder<CandidateSearchCubit, CandidateSearchState>(
                builder: (context, state) {
                  final savedList = state.savedCandidates;

                  if (state.status == CandidateSearchStatus.loading) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 60.h),
                      child: const Center(
                        child: CircularProgressIndicator(color: AppColors.darkNavy),
                      ),
                    );
                  }

                  if (savedList.isEmpty) {
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 20.h),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.borderGrey),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.bookmark_border_rounded, size: 54.sp, color: AppColors.greyColor),
                          16.szH,
                          Text(
                            S.of(context).noSavedCandidates,
                            style: getTextStyle().darkNavy.w700.s16,
                          ),
                          8.szH,
                          Text(
                            S.of(context).savedCandidatesEmptySub,
                            textAlign: TextAlign.center,
                            style: getTextStyle().greyColor.w400.s13.copyWith(height: 1.5),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: savedList.length,
                    separatorBuilder: (context, index) => 14.szH,
                    itemBuilder: (context, index) {
                      final candidate = savedList[index];
                      return CandidateCard(
                        candidate: candidate,
                        onViewProfile: () {
                          Go.toNamed(NamedRoutes.candidateDetail, arguments: candidate);
                        },
                        onToggleSave: () {
                          context.read<CandidateSearchCubit>().toggleSaveCandidate(candidate.id);
                        },
                      );
                    },
                  );
                },
              ),

              20.szH,
            ],
          ),
        ),
      ),
    );
  }
}
