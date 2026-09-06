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
import 'package:m_kemet/src/core/services/session_manager.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_back_button.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:m_kemet/src/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

class LoginScreen extends StatelessWidget {
  final UserType? userType;

  const LoginScreen({
    super.key,
    this.userType,
  });

  @override
  Widget build(BuildContext context) {
    final selectedType = userType ?? UserType.jobSeeker;

    return BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>()..setUserType(selectedType),
      child: _LoginView(userType: selectedType),
    );
  }
}

class _LoginView extends StatefulWidget {
  final UserType userType;

  const _LoginView({required this.userType});

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isCheckingProfile = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_isCheckingProfile) return;
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            fallbackUserType: widget.userType,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmployer = widget.userType == UserType.employer;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error && state.errorMessage != null) {
          CustomSnackBar.showError(context, message: state.errorMessage!);
        } else if (state.status == AuthStatus.loginSuccess ||
            state.status == AuthStatus.authenticated) {
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
                    title: S.of(context).loginTitle,
                    subtitle: S.of(context).loginSubtitle,
                  ),

                  36.szH,

                  // Email Input
                  DefaultTextField(
                    controller: _emailController,
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

                  20.szH,

                  // Password Input
                  DefaultTextField(
                    controller: _passwordController,
                    label: S.of(context).passwordLabel,
                    hint: S.of(context).passwordHint,
                    isPassword: true,
                    action: TextInputAction.done,
                    prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.greyColor, size: 20.sp),
                    validator: (value) => Validators.validatePassword(
                      value,
                      emptyMessage: S.of(context).passwordHint,
                      minLengthMessage: S.of(context).passwordValidationMessage,
                    ),
                  ),

                  12.szH,

                  // Forgot Password Link
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () {
                        Go.toNamed(NamedRoutes.forgotPassword, arguments: widget.userType);
                      },
                      child: Text(
                        S.of(context).forgotPassword,
                        style: getTextStyle().darkNavy.w600.s14,
                      ),
                    ),
                  ),

                  24.szH,

                  // Login Action Button
                  CustomButton(
                    text: S.of(context).loginAction,
                    isLoading: isLoading || _isCheckingProfile,
                    onPressed: _isCheckingProfile ? null : _onLoginPressed,
                    backgroundColor: AppColors.darkNavy,
                    textStyle: getTextStyle().whiteColor.w700.s18,
                  ),

                  32.szH,

                  // Register Toggle Prompt
                  AuthSwitchPrompt(
                    promptText: S.of(context).dontHaveAccount,
                    actionText: S.of(context).signUpNow,
                    onAction: () => Go.offNamed(NamedRoutes.register, arguments: widget.userType),
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
