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

class ForgotPasswordScreen extends StatefulWidget {
  final UserType? userType;

  const ForgotPasswordScreen({
    super.key,
    this.userType,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  void _onSendResetCodePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      Go.toNamed(NamedRoutes.otpVerification, arguments: widget.userType);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with Back Button
              const CustomBackButton(),

              20.szH,

              // Lock Icon Badge
              Center(
                child: Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: const BoxDecoration(
                    color: AppColors.softBlueBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    color: AppColors.darkNavy,
                    size: 36.sp,
                  ),
                ),
              ),

              20.szH,

              // Title
              Text(
                S.of(context).forgotPasswordTitle,
                textAlign: TextAlign.center,
                style: getTextStyle().darkNavy.w700.s24,
              ),

              8.szH,

              // Subtitle
              Text(
                S.of(context).forgotPasswordSub,
                textAlign: TextAlign.center,
                style: getTextStyle().greyColor.w400.s14.copyWith(height: 1.5),
              ),

              28.szH,

              // Email / Phone Field Input
              DefaultTextField(
                controller: _accountController,
                label: S.of(context).emailLabel,
                hint: S.of(context).emailHint,
                inputType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email_outlined, color: AppColors.greyColor, size: 20.sp),
                validator: (value) => Validators.validateEmpty(
                  value,
                  message: S.of(context).emailHint,
                ),
              ),

              24.szH,

              // Send Action Button
              CustomButton(
                text: S.of(context).sendResetCode,
                onPressed: _onSendResetCodePressed,
                backgroundColor: AppColors.darkNavy,
                textStyle: getTextStyle().whiteColor.w700.s16,
              ),

              24.szH,

              // Remember Password Prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).rememberedPassword,
                    style: getTextStyle().greyColor.w400.s14,
                  ),
                  TextButton(
                    onPressed: () {
                      Go.offNamed(NamedRoutes.login, arguments: widget.userType);
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
  }
}
