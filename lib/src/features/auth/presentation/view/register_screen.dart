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
import 'package:m_kemet/src/features/auth/domain/usecases/register_candidate_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/register_company_usecase.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_state.dart';
/* import 'package:m_kemet/src/features/auth/presentation/view/otp_verification_screen.dart'; */
import 'package:m_kemet/src/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

class RegisterScreen extends StatelessWidget {
  final UserType? userType;

  const RegisterScreen({
    super.key,
    this.userType,
  });

  @override
  Widget build(BuildContext context) {
    final selectedType = userType ?? UserType.jobSeeker;

    return BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>()
        ..setUserType(selectedType)
        ..fetchGenders()
        ..fetchCountries(),
      child: _RegisterView(userType: selectedType),
    );
  }
}

class _RegisterView extends StatefulWidget {
  final UserType userType;

  const _RegisterView({required this.userType});

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _selectedDob;
  int? _selectedCountryId;
  int? _selectedGenderId;
  bool _termsAccepted = false;
  bool _autoValidate = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    setState(() {
      _autoValidate = true;
    });

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!_termsAccepted) {
      CustomSnackBar.showError(
        context,
        message: S.of(context).acceptTermsRequired,
      );
      return;
    }

    final isEmployer = widget.userType == UserType.employer;
    final cubit = context.read<AuthCubit>();

    if (isEmployer) {
      cubit.registerCompany(
        RegisterCompanyParams(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          /* email: _emailController.text.trim(), */
          password: _passwordController.text,
          passwordConfirmation: _confirmPasswordController.text,
        ),
      );
    } else {
      cubit.registerCandidate(
        RegisterCandidateParams(
          name: _nameController.text.trim(),
          /* email: _emailController.text.trim(), */
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          passwordConfirmation: _confirmPasswordController.text,
          currentCountryId: _selectedCountryId ?? 1,
          birthDate: _dobController.text.trim().isNotEmpty
              ? _dobController.text.trim()
              : '1996-05-15',
          genderId: _selectedGenderId ?? 1,
        ),
      );
    }
  }

  void _showCountrySheet() {
    final cubit = context.read<AuthCubit>();
    CountrySelectionBottomSheet.show(
      context,
      countries: cubit.state.countries,
      isLoading: cubit.state.countriesLoading,
      selectedCountryId: _selectedCountryId,
      onSelect: (country) {
        setState(() {
          _selectedCountryId = country.id;
          _countryController.text = '${country.flag ?? ''} ${country.name}'.trim();
        });
      },
    );
  }

  void _showDateSheet() {
    DatePickerBottomSheet.show(
      context,
      initialDate: _selectedDob,
      onConfirm: (date) {
        final formatted =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        setState(() {
          _selectedDob = date;
          _dobController.text = formatted;
        });
      },
    );
  }

  void _showGenderSheet() {
    final cubit = context.read<AuthCubit>();
    GenderSelectionBottomSheet.show(
      context,
      genders: cubit.state.genders,
      isLoading: cubit.state.gendersLoading,
      selectedGenderId: _selectedGenderId,
      onSelect: (gender) {
        setState(() {
          _selectedGenderId = gender.id;
          _genderController.text = gender.name;
        });
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
        } else if (state.status == AuthStatus.registerSuccess ||
            state.status == AuthStatus.loginSuccess ||
            state.status == AuthStatus.authenticated) {
          /*
          // Commented out OTP verification as per client request
          Go.toNamed(
            NamedRoutes.otpVerification,
            arguments: OtpScreenArgs(
              email: _emailController.text.trim(),
              userType: widget.userType,
              isPasswordReset: false,
            ),
          );
          */
          CustomSnackBar.showSuccess(
            context,
            message: state.successMessage ?? S.of(context).registrationSuccessMessage,
          );
          if (isEmployer) {
            Go.offAllNamed(NamedRoutes.companyMain);
          } else {
            SessionManager.setJobSeekerProfileCompleted(false);
            Go.offAllNamed(NamedRoutes.jobSeekerProfileSetup);
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
              autovalidateMode: _autoValidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
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

                  // Header
                  AuthHeader(
                    title: S.of(context).registerTitle,
                    subtitle: S.of(context).registerSubtitle,
                  ),

                  28.szH,

                  // 1. Name / Company Field
                  DefaultTextField(
                    controller: _nameController,
                    label: isEmployer ? S.of(context).companyNameLabel : S.of(context).fullNameLabel,
                    hint: isEmployer ? S.of(context).companyNameHint : S.of(context).fullNameHint,
                    prefixIcon: Icon(
                      isEmployer ? Icons.business_outlined : Icons.person_outline_rounded,
                      color: AppColors.greyColor,
                      size: 20.sp,
                    ),
                    validator: (value) => Validators.validateName(
                      value,
                      emptyMessage: isEmployer ? S.of(context).companyNameHint : S.of(context).fullNameHint,
                      minLengthMessage: isEmployer
                          ? S.of(context).companyNameMinLength
                          : S.of(context).fullNameMinLength,
                    ),
                  ),

                  16.szH,

                  // 2. Phone Input
                  DefaultTextField(
                    controller: _phoneController,
                    label: S.of(context).phoneLabel,
                    hint: S.of(context).phoneHint,
                    isPhone: true,
                    prefixIcon: Icon(Icons.phone_outlined, color: AppColors.greyColor, size: 20.sp),
                    validator: (value) => Validators.validatePhone(
                      value,
                      emptyMessage: S.of(context).phoneHint,
                      invalidMessage: S.of(context).phoneValidationMessage,
                    ),
                  ),

                  16.szH,

                  /*
                  // 3. Email Input (Commented out as per client request)
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
                  */

                  // Specific to Job Seeker
                  if (!isEmployer)
                    CandidateRegisterFields(
                      countryController: _countryController,
                      dobController: _dobController,
                      genderController: _genderController,
                      onCountryTap: _showCountrySheet,
                      onDobTap: _showDateSheet,
                      onGenderTap: _showGenderSheet,
                    ),

                  16.szH,

                  // Password Input
                  DefaultTextField(
                    controller: _passwordController,
                    label: S.of(context).passwordLabel,
                    hint: S.of(context).passwordHint,
                    isPassword: true,
                    action: TextInputAction.next,
                    prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.greyColor, size: 20.sp),
                    validator: (value) => Validators.validatePassword(
                      value,
                      emptyMessage: S.of(context).passwordHint,
                      minLengthMessage: S.of(context).passwordValidationMessage,
                    ),
                  ),

                  16.szH,

                  // Confirm Password Input
                  DefaultTextField(
                    controller: _confirmPasswordController,
                    label: S.of(context).confirmPasswordLabel,
                    hint: S.of(context).confirmPasswordHint,
                    isPassword: true,
                    action: TextInputAction.done,
                    prefixIcon: Icon(Icons.lock_reset_rounded, color: AppColors.greyColor, size: 20.sp),
                    validator: (value) => Validators.validatePasswordConfirm(
                      value,
                      _passwordController.text,
                      emptyMessage: S.of(context).confirmPasswordHint,
                      mismatchMessage: S.of(context).confirmPasswordMismatch,
                    ),
                  ),

                  16.szH,

                  // Terms & Conditions Checkbox Row
                  TermsAndPrivacyRow(
                    value: _termsAccepted,
                    onChanged: (val) => setState(() => _termsAccepted = val ?? false),
                  ),

                  20.szH,

                  // Register Action Button
                  CustomButton(
                    text: S.of(context).registerAction,
                    isLoading: isLoading,
                    onPressed: _onRegisterPressed,
                    backgroundColor: AppColors.darkNavy,
                    textStyle: getTextStyle().whiteColor.w700.s18,
                  ),

                  32.szH,

                  // Login Toggle Prompt
                  AuthSwitchPrompt(
                    promptText: S.of(context).alreadyHaveAccount,
                    actionText: S.of(context).signInNow,
                    onAction: () => Go.offNamed(NamedRoutes.login, arguments: widget.userType),
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
