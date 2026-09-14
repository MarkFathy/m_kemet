import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/cubit/candidate_search_cubit.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/cubit/candidate_search_state.dart';

class CandidateActiveFiltersBar extends StatelessWidget {
  const CandidateActiveFiltersBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidateSearchCubit, CandidateSearchState>(
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
                        _ActiveFilterChip(
                          label: state.activeFilter.countryName!,
                          onRemove: () {
                            final updated = state.activeFilter.copyWith(resetCountry: true);
                            context.read<CandidateSearchCubit>().applyFilter(updated);
                          },
                        ),
                      if (state.activeFilter.professionName != null &&
                          state.activeFilter.professionName != 'الكل' &&
                          state.activeFilter.professionName != S.of(context).allOptions)
                        _ActiveFilterChip(
                          label: state.activeFilter.professionName!,
                          onRemove: () {
                            final updated = state.activeFilter.copyWith(resetProfession: true);
                            context.read<CandidateSearchCubit>().applyFilter(updated);
                          },
                        ),
                      if (state.activeFilter.gender != null &&
                          state.activeFilter.gender != 'الكل' &&
                          state.activeFilter.gender != S.of(context).allOptions)
                        _ActiveFilterChip(
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
                        _ActiveFilterChip(
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
    );
  }
}

class _ActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _ActiveFilterChip({
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
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
