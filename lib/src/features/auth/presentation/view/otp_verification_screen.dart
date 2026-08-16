import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_back_button.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/core/widgets/text_fields/custom_pin_input.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

class OtpVerificationScreen extends StatefulWidget {
  final UserType? userType;

  const OtpVerificationScreen({
    super.key,
    this.userType,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _pinController = TextEditingController();
  Timer? _timer;
  int _secondsRemaining = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onVerifyPressed() {
    if (_pinController.text.length == 6) {
      if (widget.userType == UserType.jobSeeker || widget.userType == null) {
        Go.offAllNamed(NamedRoutes.jobSeekerProfileSetup);
      } else {
        Go.offAllNamed(NamedRoutes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedType = widget.userType ?? UserType.jobSeeker;
    final isEmployer = selectedType == UserType.employer;

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

            24.szH,

            // Title
            Text(
              S.of(context).otpTitle,
              style: getTextStyle().darkNavy.w700.s28,
            ),

            8.szH,

            // Subtitle
            Text(
              S.of(context).otpSubtitle,
              style: getTextStyle().greyColor.w400.s14.copyWith(height: 1.5),
            ),

            36.szH,

            // 6-digit Pinput OTP Input Widget
            CustomPinInput(
              length: 6,
              controller: _pinController,
              onCompleted: (pin) {
                _onVerifyPressed();
              },
            ),

            32.szH,

            // Resend Code Countdown
            Center(
              child: _secondsRemaining > 0
                  ? Text(
                      '${S.of(context).resendIn}$_secondsRemaining',
                      style: getTextStyle().greyColor.w400.s14,
                    )
                  : TextButton(
                      onPressed: () {
                        _startTimer();
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
              onPressed: _onVerifyPressed,
              backgroundColor: AppColors.darkNavy,
              textStyle: getTextStyle().whiteColor.w700.s18,
            ),

            16.szH,
          ],
        ),
      ),
    );
  }
}
