import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/helpers/validators.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';

class NewPasswordBottomSheet extends StatefulWidget {
  final bool isLoading;
  final void Function(String password, String confirmPassword) onConfirm;

  const NewPasswordBottomSheet({
    super.key,
    required this.isLoading,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required bool isLoading,
    required void Function(String password, String confirmPassword) onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (modalContext) => NewPasswordBottomSheet(
        isLoading: isLoading,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<NewPasswordBottomSheet> createState() => _NewPasswordBottomSheetState();
}

class _NewPasswordBottomSheetState extends State<NewPasswordBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            16.szH,
            Text(
              'تعيين كلمة مرور جديدة',
              style: getTextStyle().darkNavy.w700.s20,
            ),
            6.szH,
            Text(
              'يرجى كتابة كلمة المرور الجديدة وتأكيدها للمتابعة',
              style: getTextStyle().greyColor.w400.s14,
            ),
            20.szH,

            DefaultTextField(
              controller: _passCtrl,
              label: S.of(context).passwordLabel,
              hint: S.of(context).passwordHint,
              isPassword: true,
              prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.greyColor, size: 20.sp),
              validator: (val) => Validators.validatePassword(
                val,
                emptyMessage: S.of(context).passwordHint,
                minLengthMessage: S.of(context).passwordValidationMessage,
              ),
            ),

            16.szH,

            DefaultTextField(
              controller: _confirmPassCtrl,
              label: S.of(context).confirmPasswordLabel,
              hint: S.of(context).confirmPasswordHint,
              isPassword: true,
              prefixIcon: Icon(Icons.lock_reset_rounded, color: AppColors.greyColor, size: 20.sp),
              validator: (val) => Validators.validatePasswordConfirm(
                val,
                _passCtrl.text,
                message: S.of(context).confirmPasswordMismatch,
              ),
            ),

            24.szH,

            CustomButton(
              text: 'تأكيد وحفظ كلمة المرور',
              isLoading: widget.isLoading,
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  widget.onConfirm(_passCtrl.text, _confirmPassCtrl.text);
                }
              },
              backgroundColor: AppColors.darkNavy,
              textStyle: getTextStyle().whiteColor.w700.s16,
            ),
          ],
        ),
      ),
    );
  }
}
