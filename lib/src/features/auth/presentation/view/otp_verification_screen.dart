import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/core/services/session_manager.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_back_button.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/core/widgets/text_fields/custom_pin_input.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:m_kemet/src/features/auth/presentation/widgets/auth_widgets.dart';
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

class OtpVerificationScreen extends StatelessWidget {
  final OtpScreenArgs? args;
  final UserType? userType;

  const OtpVerificationScreen({
    super.key,
    this.args,
    this.userType,
  });

  @override
  Widget build(BuildContext context) {
    final email = args?.email ?? '';
    final resolvedUserType = args?.userType ?? userType ?? UserType.jobSeeker;

    return BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>()
        ..setUserType(resolvedUserType)
        ..setPendingEmail(email),
      child: _OtpVerificationView(
        args: args,
        userType: resolvedUserType,
      ),
    );
  }
}

class _OtpVerificationView extends StatefulWidget {
  final OtpScreenArgs? args;
  final UserType userType;

  const _OtpVerificationView({
    this.args,
    required this.userType,
  });

  @override
  State<_OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<_OtpVerificationView> {
  final _pinController = TextEditingController();
  late Timer _timer;
  int _secondsRemaining = 60;
  bool _isCheckingProfile = false;

  String get _email => widget.args?.email ?? '';
  bool get _isPasswordReset => widget.args?.isPasswordReset ?? false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pinController.dispose();
    super.dispose();
  }

  void _onVerifyPressed() {
    final code = _pinController.text.trim();
    if (code.length != 6) {
      CustomSnackBar.showError(context, message: 'يرجى إدخال رمز التحقق كاملاً (6 أرقام)');
      return;
    }

    final cubit = context.read<AuthCubit>();
    if (_isPasswordReset) {
      cubit.verifyResetOtp(
        email: _email,
        code: code,
      );
    } else {
      cubit.verifyOtp(
        email: _email,
        code: code,
        userType: widget.userType,
      );
    }
  }

  void _showNewPasswordSheet() {
    NewPasswordBottomSheet.show(
      context,
      isLoading: context.read<AuthCubit>().state.isLoading,
      onConfirm: (password, confirmPassword) {
        context.read<AuthCubit>().resetPassword(
              ResetPasswordParams(
                email: _email,
                code: _pinController.text.trim(),
                password: password,
                passwordConfirmation: confirmPassword,
              ),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEmployer = widget.userType == UserType.employer;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error && state.errorMessage != null) {
          CustomSnackBar.showError(context, message: state.errorMessage!);
        } else if (state.status == AuthStatus.otpResent) {
          _startTimer();
        } else if (state.status == AuthStatus.otpVerified) {
          final targetType = state.userType ?? widget.userType;
          if (targetType == UserType.jobSeeker) {
            setState(() => _isCheckingProfile = true);
            SessionManager.checkAndSyncJobSeekerProfileCompleted().then((isCompleted) {
              if (mounted) {
                setState(() => _isCheckingProfile = false);
                if (isCompleted) {
                  Go.offAllNamed(NamedRoutes.jobSeekerMain);
                } else {
                  Go.offAllNamed(NamedRoutes.jobSeekerProfileSetup);
                }
              }
            });
          } else {
            Go.offAllNamed(NamedRoutes.companyMain);
          }
        } else if (state.status == AuthStatus.resetOtpVerified) {
          _showNewPasswordSheet();
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
                // Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBackButton(),
                    AuthRoleBadge(isEmployer: isEmployer),
                  ],
                ),

                20.szH,

                // Title & Subtitle
                Text(
                  S.of(context).otpTitle,
                  style: getTextStyle().darkNavy.w700.s22,
                ),

                6.szH,

                Text(
                  S.of(context).otpSubtitle,
                  style: getTextStyle().greyColor.w400.s14.copyWith(height: 1.4),
                ),

                if (_email.isNotEmpty) ...[
                  4.szH,
                  Text(
                    _email,
                    style: getTextStyle().darkNavy.w600.s15,
                  ),
                ],

                28.szH,

                // Custom 6-Digit PIN Box Input
                CustomPinInput(
                  controller: _pinController,
                  onCompleted: (pin) => _onVerifyPressed(),
                ),

                24.szH,

                // Resend Timer Row
                OtpTimerResendSection(
                  isLoading: state.resendOtpLoading,
                  secondsRemaining: _secondsRemaining,
                  onResend: () {
                    context.read<AuthCubit>().resendOtp(_email);
                  },
                ),

                32.szH,

                // Verify Button
                CustomButton(
                  text: S.of(context).verifyAction,
                  isLoading: isLoading || _isCheckingProfile,
                  onPressed: _isCheckingProfile ? null : _onVerifyPressed,
                  backgroundColor: AppColors.darkNavy,
                  textStyle: getTextStyle().whiteColor.w700.s18,
                ),

                16.szH,
              ],
            ),
          ),
        );
      },
    );
  }
}
