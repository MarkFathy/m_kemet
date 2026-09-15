import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/helpers/validators.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

class NewPasswordBottomSheet extends StatefulWidget {
  final UserType? userType;
  final void Function(String password, String confirmPassword) onConfirm;

  const NewPasswordBottomSheet({
    super.key,
    this.userType,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    UserType? userType,
    required void Function(String password, String confirmPassword) onConfirm,
  }) {
    final authCubit = context.read<AuthCubit>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (modalContext) => BlocProvider.value(
        value: authCubit,
        child: NewPasswordBottomSheet(
          userType: userType,
          onConfirm: onConfirm,
        ),
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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.passwordResetSuccess) {
          Navigator.pop(context);
          CustomSnackBar.showSuccess(
            context,
            message: state.successMessage ?? S.of(context).passwordResetSuccessMessage,
          );
          Go.offAllNamed(NamedRoutes.login, arguments: widget.userType);
        } else if (state.status == AuthStatus.error && state.errorMessage != null) {
          CustomSnackBar.showError(context, message: state.errorMessage!);
        }
      },
      builder: (context, state) {
        final isResetLoading = state.resetPasswordLoading;

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
                  S.of(context).setNewPasswordTitle,
                  style: getTextStyle().darkNavy.w700.s20,
                ),
                6.szH,
                Text(
                  S.of(context).setNewPasswordSub,
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
                    emptyMessage: S.of(context).confirmPasswordHint,
                    mismatchMessage: S.of(context).confirmPasswordMismatch,
                  ),
                ),

                24.szH,

                CustomButton(
                  text: S.of(context).confirmAndSavePassword,
                  isLoading: isResetLoading,
                  onPressed: isResetLoading
                      ? null
                      : () {
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
      },
    );
  }
}
