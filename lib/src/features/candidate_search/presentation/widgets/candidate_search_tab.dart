import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/empty_state.dart';
import 'package:m_kemet/src/core/widgets/shimmer/shimmer.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';
import 'package:m_kemet/src/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/cubit/candidate_search_cubit.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/cubit/candidate_search_state.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/widgets/candidate_card.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/widgets/candidate_filter_bottom_sheet.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

class CandidateSearchTab extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(CandidateEntity candidate) onViewCandidateProfile;

  const CandidateSearchTab({
    super.key,
    required this.searchController,
    required this.onViewCandidateProfile,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<CandidateSearchCubit>().fetchCandidates(),
      color: AppColors.darkNavy,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
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

            // Search Bar & Filter Button Row
            BlocBuilder<CandidateSearchCubit, CandidateSearchState>(
              buildWhen: (prev, curr) =>
                  prev.activeFilter.activeFilterCount != curr.activeFilter.activeFilterCount,
              builder: (context, state) {
                final filterCount = state.activeFilter.activeFilterCount;

                return Row(
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
                            topCountries: cubit.state.topCountries,
                            popularProfessions: cubit.state.popularProfessions,
                            isLoadingLookups: cubit.state.lookupsLoading,
                            onApplyFilter: (newFilter) {
                              cubit.applyFilter(newFilter);
                            },
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
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
                          if (filterCount > 0)
                            Positioned(
                              top: -4.h,
                              right: -4.w,
                              child: Container(
                                padding: EdgeInsets.all(5.r),
                                decoration: const BoxDecoration(
                                  color: AppColors.errorRed,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$filterCount',
                                  style: getTextStyle().whiteColor.w700.s10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            // Active Filters indicator chip bar
            BlocBuilder<CandidateSearchCubit, CandidateSearchState>(
              buildWhen: (prev, curr) => prev.activeFilter != curr.activeFilter,
              builder: (context, state) {
                if (!state.activeFilter.hasActiveFilters || state.activeFilter.activeFilterCount == 0) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (state.activeFilter.countryName != null &&
                                  state.activeFilter.countryName != 'الكل' &&
                                  state.activeFilter.countryName != S.of(context).allOptions)
                                _buildActiveFilterChip(
                                  label: state.activeFilter.countryName!,
                                  onRemove: () {
                                    final updated = state.activeFilter.copyWith(resetCountry: true);
                                    context.read<CandidateSearchCubit>().applyFilter(updated);
                                  },
                                ),
                              if (state.activeFilter.professionName != null &&
                                  state.activeFilter.professionName != 'الكل' &&
                                  state.activeFilter.professionName != S.of(context).allOptions)
                                _buildActiveFilterChip(
                                  label: state.activeFilter.professionName!,
                                  onRemove: () {
                                    final updated = state.activeFilter.copyWith(resetProfession: true);
                                    context.read<CandidateSearchCubit>().applyFilter(updated);
                                  },
                                ),
                              if (state.activeFilter.gender != null &&
                                  state.activeFilter.gender != 'الكل' &&
                                  state.activeFilter.gender != S.of(context).allOptions)
                                _buildActiveFilterChip(
                                  label: (state.activeFilter.gender == 'ذكر' || state.activeFilter.gender == 'male')
                                      ? S.of(context).male
                                      : ((state.activeFilter.gender == 'أنثى' || state.activeFilter.gender == 'female')
                                          ? S.of(context).female
                                          : state.activeFilter.gender!),
                                  onRemove: () {
                                    final updated = state.activeFilter.copyWith(resetGender: true);
                                    context.read<CandidateSearchCubit>().applyFilter(updated);
                                  },
                                ),
                              if (state.activeFilter.isValidPassport != null)
                                _buildActiveFilterChip(
                                  label: state.activeFilter.isValidPassport!
                                      ? S.of(context).validPassport
                                      : S.of(context).invalidPassport,
                                  onRemove: () {
                                    final updated = state.activeFilter.copyWith(resetPassport: true);
                                    context.read<CandidateSearchCubit>().applyFilter(updated);
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.read<CandidateSearchCubit>().resetFilter(),
                        child: Text(
                          S.of(context).resetFilters,
                          style: getTextStyle().greyColor.w600.s12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            20.szH,

            // Dynamic Search Results
            BlocBuilder<CandidateSearchCubit, CandidateSearchState>(
              builder: (context, state) {
                if (state.status == CandidateSearchStatus.loading) {
                  return const CandidateListShimmer();
                }

                if (state.status == CandidateSearchStatus.failure) {
                  final isNetworkError = state.errorMessage == null ||
                      state.errorMessage!.contains('host lookup') ||
                      state.errorMessage!.contains('connection') ||
                      state.errorMessage!.contains('SocketException') ||
                      state.errorMessage!.contains('اتصال') ||
                      state.errorMessage!.contains('انترنت') ||
                      state.errorMessage!.contains('Internet');

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.read<CandidateSearchCubit>().fetchCandidates(),
                    child: EmptyState(
                      icon: isNetworkError ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
                      title: isNetworkError
                          ? S.of(context).noInternetTitle
                          : (state.errorMessage ?? S.of(context).noInternetTitle),
                    ),
                  );
                }

                if (state.candidates.isEmpty) {
                  return EmptyState(
                    icon: Icons.search_off_rounded,
                    title: S.of(context).noSearchResultsTitle,
                    subtitle: S.of(context).noSearchResultsSub,
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
                        context.read<BookmarksCubit>().toggleBookmark(candidate);
                        context.read<CandidateSearchCubit>().toggleSaveCandidate(candidate.id);
                      },
                    );
                  },
                );
              },
            ),

            100.szH,
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip({required String label, required VoidCallback onRemove}) {
    return Container(
      margin: EdgeInsets.only(left: 6.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.softBlueBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: getTextStyle().darkNavy.w600.s12),
          4.szW,
          InkWell(
            onTap: onRemove,
            child: Icon(Icons.close_rounded, size: 14.sp, color: AppColors.greyColor),
          ),
        ],
      ),
    );
  }
}
