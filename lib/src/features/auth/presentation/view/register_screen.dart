import 'package:flutter/cupertino.dart';
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
import 'package:m_kemet/src/features/auth/domain/usecases/register_candidate_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/register_company_usecase.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:m_kemet/src/features/auth/presentation/view/otp_verification_screen.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

class RegisterScreen extends StatefulWidget {
  final UserType? userType;

  const RegisterScreen({
    super.key,
    this.userType,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
  int? _selectedGenderId; // 1 for male, 2 for female
  bool _termsAccepted = false;


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

  void _onRegisterPressed(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_termsAccepted) {
      CustomSnackBar.showError(
        context,
        message: S.of(context).acceptTermsRequired,
      );
      return;
    }

    final isEmployer = (widget.userType ?? UserType.jobSeeker) == UserType.employer;
    final cubit = context.read<AuthCubit>();

    if (isEmployer) {
      cubit.registerCompany(
        RegisterCompanyParams(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          passwordConfirmation: _confirmPasswordController.text,
        ),
      );
    } else {
      cubit.registerCandidate(
        RegisterCandidateParams(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
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

  void _showCountryBottomSheet(BuildContext context) {
    final countries = context.read<AuthCubit>().state.countries;
    final isLoading = context.read<AuthCubit>().state.countriesLoading;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = countries
                .where((c) => c.name.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    12.szH,
                    Text(
                      S.of(context).currentCountryLabel,
                      style: getTextStyle().darkNavy.w700.s18,
                    ),
                    16.szH,

                    // Search Field
                    DefaultTextField(
                      hint: S.of(context).searchCountryHint,
                      prefixIcon: Icon(Icons.search_rounded, color: AppColors.greyColor, size: 20.sp),
                      onChanged: (val) {
                        setModalState(() {
                          searchQuery = val ?? '';
                        });
                      },
                    ),

                    12.szH,

                    if (isLoading)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      Expanded(
                        child: filtered.isEmpty
                            ? Center(
                                child: Text(
                                  S.of(context).noCountryFound,
                                  style: getTextStyle().greyColor.w400.s14,
                                ),
                              )
                            : ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemCount: filtered.length,
                                separatorBuilder: (context, index) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final country = filtered[index];
                                  final isSelected = _selectedCountryId == country.id;
                                  return ListTile(
                                    leading: country.flag != null
                                        ? Text(
                                            country.flag!,
                                            style: TextStyle(fontSize: 24.sp),
                                          )
                                        : null,
                                    title: Text(
                                      country.name,
                                      style: isSelected
                                          ? getTextStyle().darkNavy.w700.s15
                                          : getTextStyle().darkNavy.w500.s15,
                                    ),
                                    trailing: isSelected
                                        ? const Icon(Icons.check_circle_rounded, color: AppColors.darkNavy)
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        _selectedCountryId = country.id;
                                        _countryController.text =
                                            '${country.flag ?? ''} ${country.name}'.trim();
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDatePickerBottomSheet() {
    final maxDate = DateTime(DateTime.now().year - 14, 12, 31);
    final defaultDate = DateTime(1996, 1, 1);
    DateTime tempPickedDate = _selectedDob ?? defaultDate;

    // Clamp to valid range
    if (tempPickedDate.isAfter(maxDate)) {
      tempPickedDate = maxDate;
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
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
                        // Format as Y-m-d matching backend requirement
                        final formatted =
                            '${tempPickedDate.year}-${tempPickedDate.month.toString().padLeft(2, '0')}-${tempPickedDate.day.toString().padLeft(2, '0')}';
                        setState(() {
                          _selectedDob = tempPickedDate;
                          _dobController.text = formatted;
                        });
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
      },
    );
  }

  void _showGenderBottomSheet(BuildContext context) {
    final genders = context.read<AuthCubit>().state.genders;
    final isGendersLoading = context.read<AuthCubit>().state.gendersLoading;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              16.szH,
              Text(
                S.of(context).genderLabel,
                style: getTextStyle().darkNavy.w700.s18,
              ),
              20.szH,
              if (isGendersLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(),
                )
              else
                Row(
                  children: [
                    for (int i = 0; i < genders.length; i++) ...[
                      Expanded(
                        child: Builder(
                          builder: (ctx) {
                            final gender = genders[i];
                            final isMale = gender.name.contains('ذكر') || gender.id == 1;
                            final isSelected = _selectedGenderId == gender.id;
                            final activeColor = isMale ? AppColors.darkNavy : const Color(0xFFDB2777);
                            final activeBg = isMale ? const Color(0xFFD0E8FF) : const Color(0xFFFCE7F3);

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedGenderId = gender.id;
                                  _genderController.text = gender.name;
                                });
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(14.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: isSelected ? activeBg : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: isSelected ? activeColor : const Color(0xFFE2E8F0),
                                    width: 1.5.w,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isMale ? Icons.male_rounded : Icons.female_rounded,
                                      size: 32.sp,
                                      color: activeColor,
                                    ),
                                    6.szH,
                                    Text(
                                      gender.name,
                                      style: getTextStyle().w700.s16.copyWith(
                                        color: activeColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (i < genders.length - 1) SizedBox(width: 16.w),
                    ],
                  ],
                ),
              20.szH,
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedType = widget.userType ?? UserType.jobSeeker;
    final isEmployer = selectedType == UserType.employer;

    return BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>()
        ..setUserType(selectedType)
        ..fetchGenders()
        ..fetchCountries(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error && state.errorMessage != null) {
            CustomSnackBar.showError(context, message: state.errorMessage!);
          } else if (state.status == AuthStatus.registerSuccess) {
            Go.toNamed(
              NamedRoutes.otpVerification,
              arguments: OtpScreenArgs(
                email: _emailController.text.trim(),
                userType: selectedType,
                isPasswordReset: false,
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
                    // Top Bar with Custom iOS Back Button & Role Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomBackButton(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: isEmployer ? const Color(0xFFE2F3EC) : const Color(0xFFD0E8FF),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isEmployer ? Icons.business_rounded : Icons.person_search_rounded,
                                size: 16.sp,
                                color: isEmployer ? const Color(0xFF0F7D59) : AppColors.darkNavy,
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
                      S.of(context).registerTitle,
                      style: getTextStyle().darkNavy.w700.s28,
                    ),

                    8.szH,

                    // Subtitle
                    Text(
                      S.of(context).registerSubtitle,
                      style: getTextStyle().greyColor.w400.s14.copyWith(height: 1.5),
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
                        message: isEmployer ? S.of(context).companyNameHint : S.of(context).fullNameHint,
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

                    // 3. Email Input
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

                    // Fields specific to Job Seeker
                    if (!isEmployer) ...[
                      16.szH,

                      // 4. Current Country (Searchable Bottom Sheet Selection)
                      DefaultTextField(
                        controller: _countryController,
                        label: S.of(context).currentCountryLabel,
                        hint: S.of(context).currentCountryHint,
                        readOnly: true,
                        onTap: () => _showCountryBottomSheet(context),
                        prefixIcon: Icon(Icons.public_rounded, color: AppColors.greyColor, size: 20.sp),
                        suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
                        validator: (value) => Validators.validateEmpty(
                          value,
                          message: S.of(context).currentCountryHint,
                        ),
                      ),

                      16.szH,

                      // 5. Date of Birth (Cupertino Sheet Selection)
                      DefaultTextField(
                        controller: _dobController,
                        label: S.of(context).dateOfBirthLabel,
                        hint: S.of(context).dateOfBirthHint,
                        readOnly: true,
                        onTap: _showDatePickerBottomSheet,
                        prefixIcon: Icon(Icons.calendar_today_rounded, color: AppColors.greyColor, size: 20.sp),
                        suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
                        validator: (value) => Validators.validateEmpty(
                          value,
                          message: S.of(context).dateOfBirthHint,
                        ),
                      ),

                      16.szH,

                      // 6. Gender Selection (Male / Female Sheet Selection)
                      DefaultTextField(
                        controller: _genderController,
                        label: S.of(context).genderLabel,
                        hint: S.of(context).genderHint,
                        readOnly: true,
                        onTap: () => _showGenderBottomSheet(context),
                        prefixIcon: Icon(Icons.wc_rounded, color: AppColors.greyColor, size: 20.sp),
                        suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
                        validator: (value) => Validators.validateEmpty(
                          value,
                          message: S.of(context).genderHint,
                        ),
                      ),
                    ],

                    16.szH,

                    // 7. Password Input
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

                    // 8. Confirm Password Input
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
                        message: S.of(context).confirmPasswordMismatch,
                      ),
                    ),

                    16.szH,

                    // 9. Terms & Conditions Checkbox Row
                    Row(
                      children: [
                        Checkbox(
                          value: _termsAccepted,
                          activeColor: AppColors.darkNavy,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                          onChanged: (val) {
                            setState(() {
                              _termsAccepted = val ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final result = await Go.toNamed(NamedRoutes.termsAndConditions);
                              if (result == true) {
                                setState(() {
                                  _termsAccepted = true;
                                });
                              }
                            },
                            child: Text.rich(
                              TextSpan(
                                text: S.of(context).agreeToTermsPrefix,
                                style: getTextStyle().greyColor.w400.s13,
                                children: [
                                  TextSpan(
                                    text: S.of(context).termsAndConditions,
                                    style: getTextStyle().darkNavy.w700.s13.copyWith(
                                          decoration: TextDecoration.underline,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    20.szH,

                    // Register Action Button
                    CustomButton(
                      text: S.of(context).registerAction,
                      isLoading: isLoading,
                      onPressed: () => _onRegisterPressed(context),
                      backgroundColor: AppColors.darkNavy,
                      textStyle: getTextStyle().whiteColor.w700.s18,
                    ),

                    32.szH,

                    // Login Toggle Prompt
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).alreadyHaveAccount,
                          style: getTextStyle().greyColor.w400.s14,
                        ),
                        TextButton(
                          onPressed: () {
                            Go.offNamed(NamedRoutes.login, arguments: selectedType);
                          },
                          child: Text(
                            S.of(context).signInNow,
                            style: getTextStyle().darkNavy.w700.s14,
                          ),
                        ),
                      ],
                    ),

                    16.szH,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
