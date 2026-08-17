import 'package:flutter/material.dart';
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
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_back_button.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

class LoginScreen extends StatefulWidget {
  final UserType? userType;

  const LoginScreen({
    super.key,
    this.userType,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final selectedType = widget.userType ?? UserType.jobSeeker;
      if (selectedType == UserType.jobSeeker) {
        Go.offAllNamed(NamedRoutes.jobSeekerProfileSetup);
      } else {
        Go.offAllNamed(NamedRoutes.companyMain);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedType = widget.userType ?? UserType.jobSeeker;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomBackButton(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: selectedType == UserType.jobSeeker
                          ? const Color(0xFFD0E8FF)
                          : const Color(0xFFE2F3EC),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          selectedType == UserType.jobSeeker
                              ? Icons.person_search_rounded
                              : Icons.business_rounded,
                          size: 16.sp,
                          color: selectedType == UserType.jobSeeker
                              ? AppColors.darkNavy
                              : const Color(0xFF0F7D59),
                        ),
                        6.szW,
                        Text(
                          selectedType == UserType.jobSeeker
                              ? S.of(context).jobSeekerTitle
                              : S.of(context).employerTitle,
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
                S.of(context).loginTitle,
                style: getTextStyle().darkNavy.w700.s28,
              ),

              8.szH,

              // Subtitle
              Text(
                S.of(context).loginSubtitle,
                style: getTextStyle().greyColor.w400.s14.copyWith(height: 1.5),
              ),

              32.szH,

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

              16.szH,

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

              // Forgot Password Button
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Go.toNamed(NamedRoutes.forgotPassword, arguments: selectedType);
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
                onPressed: _onLoginPressed,
                backgroundColor: AppColors.darkNavy,
                textStyle: getTextStyle().whiteColor.w700.s18,
              ),

              32.szH,

              // Register Toggle Prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).dontHaveAccount,
                    style: getTextStyle().greyColor.w400.s14,
                  ),
                  TextButton(
                    onPressed: () {
                      Go.offNamed(NamedRoutes.register, arguments: selectedType);
                    },
                    child: Text(
                      S.of(context).signUpNow,
                      style: getTextStyle().darkNavy.w700.s14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
