import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/app_progress_indicator.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';

class CountrySelectionBottomSheet extends StatefulWidget {
  final List<CountryEntity> countries;
  final bool isLoading;
  final int? selectedCountryId;
  final ValueChanged<CountryEntity> onSelect;

  const CountrySelectionBottomSheet({
    super.key,
    required this.countries,
    required this.isLoading,
    this.selectedCountryId,
    required this.onSelect,
  });

  static Future<void> show(
    BuildContext context, {
    required List<CountryEntity> countries,
    required bool isLoading,
    int? selectedCountryId,
    required ValueChanged<CountryEntity> onSelect,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => CountrySelectionBottomSheet(
        countries: countries,
        isLoading: isLoading,
        selectedCountryId: selectedCountryId,
        onSelect: onSelect,
      ),
    );
  }

  @override
  State<CountrySelectionBottomSheet> createState() => _CountrySelectionBottomSheetState();
}

class _CountrySelectionBottomSheetState extends State<CountrySelectionBottomSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.countries
        .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            12.szH,
            Text(
              S.of(context).currentCountryLabel,
              style: getTextStyle().darkNavy.w700.s18,
            ),
            16.szH,

            // Search Field
            DefaultTextField(
              hint: S.of(context).searchCountryHint,
              prefixIcon: Icon(Icons.search_rounded, color: AppColors.greyColor, size: 20.sp),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val ?? '';
                });
              },
            ),

            12.szH,

            if (widget.isLoading)
              const Expanded(
                child: AppProgressIndicator.centered(),
              )
            else
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          S.of(context).noCountryFound,
                          style: getTextStyle().greyColor.w400.s14,
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final country = filtered[index];
                          final isSelected = widget.selectedCountryId == country.id;
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            leading: country.flag != null
                                ? Text(
                                    country.flag!,
                                    style: TextStyle(fontSize: 22.sp),
                                  )
                                : null,
                            title: Text(
                              country.name,
                              style: isSelected
                                  ? getTextStyle().darkNavy.w700.s15
                                  : getTextStyle().darkNavy.w500.s15,
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check_circle_rounded, color: AppColors.darkNavy)
                                : null,
                            onTap: () {
                              widget.onSelect(country);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
