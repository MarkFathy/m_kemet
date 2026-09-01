import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';

class DatePickerBottomSheet extends StatelessWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime> onConfirm;

  const DatePickerBottomSheet({
    super.key,
    this.initialDate,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    DateTime? initialDate,
    required ValueChanged<DateTime> onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => DatePickerBottomSheet(
        initialDate: initialDate,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxDate = DateTime(DateTime.now().year - 14, 12, 31);
    final defaultDate = DateTime(1996, 1, 1);
    DateTime tempPickedDate = initialDate ?? defaultDate;

    if (tempPickedDate.isAfter(maxDate)) {
      tempPickedDate = maxDate;
    }

    return Container(
      height: 320.h,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    S.of(context).skip,
                    style: getTextStyle().greyColor.w600.s14,
                  ),
                ),
                Text(
                  S.of(context).dateOfBirthLabel,
                  style: getTextStyle().darkNavy.w700.s16,
                ),
                TextButton(
                  onPressed: () {
                    onConfirm(tempPickedDate);
                    Navigator.pop(context);
                  },
                  child: Text(
                    S.of(context).continueAction,
                    style: getTextStyle().darkNavy.w700.s14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CupertinoTheme(
              data: CupertinoThemeData(
                brightness: Brightness.light,
                primaryColor: AppColors.darkNavy,
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(
                    color: const Color(0xFF073B62),
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                  ),
                  pickerTextStyle: TextStyle(
                    color: const Color(0xFF073B62),
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: tempPickedDate,
                minimumYear: 1950,
                maximumYear: DateTime.now().year - 14,
                onDateTimeChanged: (newDate) {
                  tempPickedDate = newDate;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
