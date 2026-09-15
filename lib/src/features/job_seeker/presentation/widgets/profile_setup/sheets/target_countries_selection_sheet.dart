import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_cubit.dart';

class TargetCountriesSelectionSheet extends StatelessWidget {
  final List<CountryEntity> countries;
  final TextEditingController controller;

  const TargetCountriesSelectionSheet({
    super.key,
    required this.countries,
    required this.controller,
  });

  static Future<void> show(
    BuildContext context, {
    required List<CountryEntity> countries,
    required TextEditingController controller,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: AppColors.whiteColor,
      builder: (modalCtx) => TargetCountriesSelectionSheet(
        countries: countries,
        controller: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<JobSeekerProfileCubit>();
    String searchQuery = '';

    return StatefulBuilder(
      builder: (builderCtx, setModalState) {
        final selectedCountries = cubit.state.selectedTargetCountries;

        final filtered = countries
            .where((c) =>
                c.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.borderGrey,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                12.szH,
                Text(
                  S.of(context).targetCountriesLabel,
                  style: getTextStyle().darkNavy.w700.s18,
                ),
                16.szH,
                DefaultTextField(
                  hint: S.of(context).searchCountryHint,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.greyColor,
                    size: 20.sp,
                  ),
                  onChanged: (val) {
                    setModalState(() {
                      searchQuery = val ?? '';
                    });
                  },
                ),
                12.szH,
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            S.of(context).noCountryFound,
                            style: getTextStyle().greyColor.w400.s14,
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            final isChecked =
                                selectedCountries.any((c) => c.id == item.id);
                            return CheckboxListTile(
                              activeColor: AppColors.darkNavy,
                              title: Row(
                                children: [
                                  if (item.flag != null &&
                                      item.flag!.isNotEmpty) ...[
                                    Text(
                                      item.flag!,
                                      style: TextStyle(fontSize: 18.sp),
                                    ),
                                    8.szW,
                                  ],
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: isChecked
                                          ? getTextStyle().darkNavy.w700.s15
                                          : getTextStyle().darkNavy.w500.s15,
                                    ),
                                  ),
                                ],
                              ),
                              value: isChecked,
                              onChanged: (_) {
                                cubit.toggleTargetCountry(item);
                                setModalState(() {});
                              },
                            );
                          },
                        ),
                ),
                12.szH,
                CustomButton(
                  text: S.of(context).continueAction,
                  onPressed: () {
                    final updatedSelected = cubit.state.selectedTargetCountries;
                    controller.text =
                        updatedSelected.map((c) => c.name).join(', ');
                    Navigator.pop(context);
                  },
                  backgroundColor: AppColors.darkNavy,
                  textStyle: getTextStyle().whiteColor.w700.s16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
