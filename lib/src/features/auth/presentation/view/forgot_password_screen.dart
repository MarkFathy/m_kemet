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
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:m_kemet/src/features/auth/presentation/view/otp_verification_screen.dart';
import 'package:m_kemet/src/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final UserType? userType;

  const ForgotPasswordScreen({
    super.key,
    this.userType,
  });

  @override
  Widget build(BuildContext context) {
    final selectedType = userType ?? UserType.jobSeeker;

    return BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>()..setUserType(selectedType),
      child: _ForgotPasswordView(userType: selectedType),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  final UserType userType;

  const _ForgotPasswordView({required this.userType});

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  void _onSendResetCodePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().forgotPassword(_accountController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmployer = widget.userType == UserType.employer;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error && state.errorMessage != null) {
          CustomSnackBar.showError(context, message: state.errorMessage!);
        } else if (state.status == AuthStatus.otpSent) {
          Go.toNamed(
            NamedRoutes.otpVerification,
            arguments: OtpScreenArgs(
              email: _accountController.text.trim(),
              userType: widget.userType,
              isPasswordReset: true,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.isLoading;

        return AppScaffold(
          safeTop: true,
          safeBottom: true,
          backgroundColor: const Color(0xFFF7F9FC),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.pW20,
              vertical: AppPadding.pH16,
            ),
            child: Form(
              key: _formKey,
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

                  32.szH,

                  // Header
                  AuthHeader(
                    title: S.of(context).forgotPasswordTitle,
                    subtitle: S.of(context).forgotPasswordSub,
                  ),

                  36.szH,

                  // Email Input
                  DefaultTextField(
                    controller: _accountController,
                    label: S.of(context).emailLabel,
                    hint: S.of(context).emailHint,
                    inputType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.greyColor, size: 20.sp),
                    validator: (value) => Validators.validateEmail(
                      value,
                      emptyMessage: S.of(context).emailHint,
                      invalidMessage: S.of(context).emailValidationMessage,
                    ),
                  ),

                  28.szH,

                  // Submit Button
                  CustomButton(
                    text: S.of(context).sendResetCode,
                    isLoading: isLoading,
                    onPressed: _onSendResetCodePressed,
                    backgroundColor: AppColors.darkNavy,
                    textStyle: getTextStyle().whiteColor.w700.s18,
                  ),

                  32.szH,

                  // Return to Login Link
                  Center(
                    child: TextButton.icon(
                      onPressed: () => Go.back(),
                      icon: Icon(Icons.arrow_back_rounded, color: AppColors.darkNavy, size: 18.sp),
                      label: Text(
                        S.of(context).signInNow,
                        style: getTextStyle().darkNavy.w600.s14,
                      ),
                    ),
                  ),

                  16.szH,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
