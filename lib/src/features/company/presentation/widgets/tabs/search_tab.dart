import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_search_cubit.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_search_state.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/candidate_card.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/candidate_filter_bottom_sheet.dart';

class SearchTab extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(CandidateEntity candidate) onViewCandidateProfile;

  const SearchTab({
    super.key,
    required this.searchController,
    required this.onViewCandidateProfile,
  });

  @override
  Widget build(BuildContext context) {
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
            S.of(context).employerSearchTitle,
            style: getTextStyle().darkNavy.w700.s24,
          ),

          14.szH,

          // Search Bar & Filter Action Button Row
          Row(
            children: [
              Expanded(
                child: DefaultTextField(
                  controller: searchController,
                  hint: S.of(context).searchCandidateHint,
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.greyColor, size: 20.sp),
                  onChanged: (val) {
                    context.read<CandidateSearchCubit>().updateSearchQuery(val ?? '');
                  },
                ),
              ),
              10.szW,
              InkWell(
                onTap: () {
                  final cubit = context.read<CandidateSearchCubit>();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: AppColors.transparentColor,
                    builder: (_) => CandidateFilterBottomSheet(
                      initialFilter: cubit.state.activeFilter,
                      onApplyFilter: (newFilter) {
                        cubit.applyFilter(newFilter);
                      },
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.darkNavy,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: AppColors.whiteColor,
                    size: 22.sp,
                  ),
                ),
              ),
            ],
          ),

          20.szH,

          // Dynamic Search Results
          BlocBuilder<CandidateSearchCubit, CandidateSearchState>(
            builder: (context, state) {
              if (state.status == CandidateSearchStatus.loading) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.darkNavy),
                  ),
                );
              }

              if (state.candidates.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded, size: 54.sp, color: AppColors.greyColor),
                        12.szH,
                        Text(
                          S.of(context).noSearchResultsTitle,
                          style: getTextStyle().darkNavy.w700.s16,
                        ),
                        6.szH,
                        Text(
                          S.of(context).noSearchResultsSub,
                          style: getTextStyle().greyColor.w400.s13,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.candidates.length,
                separatorBuilder: (context, index) => 14.szH,
                itemBuilder: (context, index) {
                  final candidate = state.candidates[index];
                  return CandidateCard(
                    candidate: candidate,
                    onViewProfile: () => onViewCandidateProfile(candidate),
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
    );
  }
}
