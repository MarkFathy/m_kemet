import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/cubit/candidate_search_cubit.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/cubit/candidate_search_state.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/widgets/candidate_filter_bottom_sheet.dart';

class CandidateSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const CandidateSearchBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidateSearchCubit, CandidateSearchState>(
      buildWhen: (prev, curr) =>
          prev.activeFilter.activeFilterCount != curr.activeFilter.activeFilterCount,
      builder: (context, state) {
        final filterCount = state.activeFilter.activeFilterCount;

        return Row(
          children: [
            Expanded(
              child: DefaultTextField(
                controller: controller,
                hint: S.of(context).searchCandidateHint,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.greyColor,
                  size: 20.sp,
                ),
                onChanged: (val) {
                  context.read<CandidateSearchCubit>().updateSearchQuery(val ?? '');
                },
              ),
            ),
            10.szW,
            InkWell(
              onTap: () => _openFilterBottomSheet(context),
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
    );
  }

  void _openFilterBottomSheet(BuildContext context) {
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
  }
}
