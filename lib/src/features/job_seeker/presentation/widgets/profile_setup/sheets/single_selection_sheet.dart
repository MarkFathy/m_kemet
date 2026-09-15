import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class SingleSelectionSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final TextEditingController controller;
  final void Function(String selected)? onSelected;

  const SingleSelectionSheet({
    super.key,
    required this.title,
    required this.options,
    required this.controller,
    this.onSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<String> options,
    required TextEditingController controller,
    void Function(String selected)? onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: AppColors.whiteColor,
      builder: (modalCtx) => SingleSelectionSheet(
        title: title,
        options: options,
        controller: controller,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.borderGrey,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          16.szH,
          Text(
            title,
            style: getTextStyle().darkNavy.w700.s18,
          ),
          16.szH,
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: options.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = options[index];
                final isSelected = controller.text == item;
                return ListTile(
                  title: Text(
                    item,
                    style: isSelected
                        ? getTextStyle().darkNavy.w700.s15
                        : getTextStyle().darkNavy.w500.s15,
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.darkNavy,
                        )
                      : null,
                  onTap: () {
                    controller.text = item;
                    onSelected?.call(item);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
