import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/helpers/validators.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_back_button.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/core/widgets/text_fields/custom_pin_input.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

class OtpScreenArgs {
  final String email;
  final UserType? userType;
  final bool isPasswordReset;

  const OtpScreenArgs({
    required this.email,
    this.userType,
    this.isPasswordReset = false,
  });
}

class OtpVerificationScreen extends StatefulWidget {
  final UserType? userType;
  final OtpScreenArgs? args;

  const OtpVerificationScreen({
    super.key,
    this.userType,
    this.args,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _pinController = TextEditingController();
  Timer? _timer;
  int _secondsRemaining = 120;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 120;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  String _formatTimer(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _pinController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String get _email {
    return widget.args?.email ?? 'candidate@example.com';
  }

  UserType get _resolvedUserType {
    return widget.args?.userType ?? widget.userType ?? UserType.jobSeeker;
  }

  bool get _isPasswordReset {
    return widget.args?.isPasswordReset ?? false;
  }

  void _onVerifyPressed(BuildContext context) {
    if (_pinController.text.length == 6) {
      final cubit = context.read<AuthCubit>();
      if (_isPasswordReset) {
        cubit.verifyResetOtp(
          email: _email,
          code: _pinController.text.trim(),
        );
      } else {
        cubit.verifyOtp(
          email: _email,
          code: _pinController.text.trim(),
          userType: _resolvedUserType,
        );
      }
    }
  }

  void _showNewPasswordBottomSheet(BuildContext parentContext) {
    final formKey = GlobalKey<FormState>();
    final passCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (modalContext) {
        return BlocProvider.value(
          value: parentContext.read<AuthCubit>(),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.passwordResetSuccess) {
                Navigator.pop(modalContext);
                CustomSnackBar.showSuccess(
                  parentContext,
                  message: state.successMessage ?? 'Password reset successfully',
                );
                Go.offAllNamed(NamedRoutes.login, arguments: _resolvedUserType);
              } else if (state.status == AuthStatus.error && state.errorMessage != null) {
                CustomSnackBar.showError(modalContext, message: state.errorMessage!);
              }
            },
            builder: (context, state) {
              final isSubmitting = state.isLoading;

              return Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 16.h,
                  bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24.h,
                ),
                child: Form(
                  key: formKey,
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
                        controller: passCtrl,
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
                        controller: confirmPassCtrl,
                        label: S.of(context).confirmPasswordLabel,
                        hint: S.of(context).confirmPasswordHint,
                        isPassword: true,
                        prefixIcon: Icon(Icons.lock_reset_rounded, color: AppColors.greyColor, size: 20.sp),
                        validator: (val) => Validators.validatePasswordConfirm(
                          val,
                          passCtrl.text,
                          message: S.of(context).confirmPasswordMismatch,
                        ),
                      ),

                      24.szH,

                      CustomButton(
                        text: 'تأكيد وحفظ كلمة المرور',
                        isLoading: isSubmitting,
                        onPressed: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  context.read<AuthCubit>().resetPassword(
                                        ResetPasswordParams(
                                          email: _email,
                                          code: _pinController.text.trim(),
                                          password: passCtrl.text,
                                          passwordConfirmation: confirmPassCtrl.text,
                                        ),
                                      );
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedType = _resolvedUserType;
    final isEmployer = selectedType == UserType.employer;

    return BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>()
        ..setUserType(selectedType)
        ..setPendingEmail(_email),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error && state.errorMessage != null) {
            CustomSnackBar.showError(context, message: state.errorMessage!);
          } else if (state.status == AuthStatus.otpResent) {
            CustomSnackBar.showSuccess(
              context,
              message: state.successMessage ?? 'تم إعادة إرسال الرمز بنجاح',
            );
            _startTimer();
          } else if (state.status == AuthStatus.otpVerified) {
            final targetType = state.userType ?? selectedType;
            if (targetType == UserType.jobSeeker) {
              Go.offAllNamed(NamedRoutes.jobSeekerProfileSetup);
            } else {
              Go.offAllNamed(NamedRoutes.companyMain);
            }
          } else if (state.status == AuthStatus.resetOtpVerified) {
            _showNewPasswordBottomSheet(context);
          }
        },
        builder: (context, state) {
          final isLoading = state.isLoading;

          return AppScaffold(
            safeTop: true,
            safeBottom: true,
            backgroundColor: AppColors.pageBg,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.pW12,
                vertical: AppPadding.pH12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar with Custom iOS Back Button & Role Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomBackButton(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: isEmployer ? AppColors.successBg : AppColors.softBlueBg,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isEmployer ? Icons.business_rounded : Icons.person_search_rounded,
                              size: 16.sp,
                              color: isEmployer ? AppColors.successGreen : AppColors.darkNavy,
                            ),
                            6.szW,
                            Text(
                              isEmployer ? S.of(context).employerTitle : S.of(context).jobSeekerTitle,
                              style: getTextStyle().darkNavy.w600.s12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  20.szH,

                  // Title
                  Text(
                    S.of(context).otpTitle,
                    style: getTextStyle().darkNavy.w700.s26,
                  ),

                  6.szH,

                  // Subtitle
                  Text(
                    '${S.of(context).otpSubtitle}\n$_email',
                    style: getTextStyle().greyColor.w400.s14.copyWith(height: 1.4),
                  ),

                  32.szH,

                  // 6-digit Pinput OTP Input Widget
                  CustomPinInput(
                    length: 6,
                    controller: _pinController,
                    onCompleted: (pin) {
                      _onVerifyPressed(context);
                    },
                  ),

                  28.szH,

                  // Resend Code Countdown
                  Center(
                    child: state.resendOtpLoading
                        ? SizedBox(
                            width: 24.r,
                            height: 24.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.darkNavy,
                            ),
                          )
                        : _secondsRemaining > 0
                            ? Text(
                                '${S.of(context).resendIn}${_formatTimer(_secondsRemaining)}',
                                style: getTextStyle().greyColor.w500.s14,
                              )
                            : TextButton(
                                onPressed: () {
                                  context.read<AuthCubit>().resendOtp(_email);
                                },
                                child: Text(
                                  S.of(context).resendCode,
                                  style: getTextStyle().darkNavy.w700.s14,
                                ),
                              ),
                  ),

                  32.szH,

                  // Verify Action Button
                  CustomButton(
                    text: S.of(context).verifyAction,
                    isLoading: isLoading,
                    onPressed: () => _onVerifyPressed(context),
                    backgroundColor: AppColors.darkNavy,
                    textStyle: getTextStyle().whiteColor.w700.s18,
                  ),

                  16.szH,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
