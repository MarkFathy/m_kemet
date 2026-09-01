import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/helpers/validators.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';
import 'package:m_kemet/src/features/auth/domain/entities/user_entity.dart';

class EditAccountCredentialsSheet extends StatefulWidget {
  final UserEntity? currentUser;
  final void Function(String name, String email, String phone)? onSave;

  const EditAccountCredentialsSheet({
    super.key,
    this.currentUser,
    this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    UserEntity? currentUser,
    void Function(String name, String email, String phone)? onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditAccountCredentialsSheet(
        currentUser: currentUser,
        onSave: onSave,
      ),
    );
  }

  @override
  State<EditAccountCredentialsSheet> createState() => _EditAccountCredentialsSheetState();
}

class _EditAccountCredentialsSheetState extends State<EditAccountCredentialsSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _changePasswordExpanded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentUser?.name ?? '');
    _emailController = TextEditingController(text: widget.currentUser?.email ?? '');
    _phoneController = TextEditingController(text: widget.currentUser?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_changePasswordExpanded) {
      if (_newPasswordController.text.isNotEmpty &&
          _newPasswordController.text != _confirmPasswordController.text) {
        CustomSnackBar.showError(context, message: 'كلمة المرور الجديدة غير متطابقة مع التأكيد');
        return;
      }
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _isLoading = false);

    widget.onSave?.call(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _phoneController.text.trim(),
    );

    Navigator.pop(context);

    CustomSnackBar.showSuccess(
      context,
      message: 'تم تحديث بيانات تسجيل الدخول والحساب بنجاح',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      padding: EdgeInsets.only(
        left: AppPadding.pW16,
        right: AppPadding.pW16,
        top: AppPadding.pH16,
        bottom: bottomInset + AppPadding.pH16,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet Handle Bar
              Center(
                child: Container(
                  width: 44.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: AppColors.borderGrey,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),

              16.szH,

              // Header Title & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.softBlueBg,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.manage_accounts_rounded,
                            color: AppColors.darkNavy,
                            size: 22.sp,
                          ),
                        ),
                        10.szW,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تعديل بيانات الحساب',
                                style: getTextStyle().darkNavy.w700.s16,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'بيانات تسجيل الدخول ومعلومات الاتصال',
                                style: getTextStyle().greyColor.w400.s11,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: AppColors.greyColor, size: 22.sp),
                  ),
                ],
              ),

              16.szH,
              const Divider(color: AppColors.dividerGrey, height: 1),
              16.szH,

              // Full Name
              DefaultTextField(
                controller: _nameController,
                label: S.of(context).fullNameLabel,
                hint: S.of(context).fullNameHint,
                prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.greyColor, size: 20.sp),
                validator: (val) => val == null || val.trim().isEmpty ? 'يرجى إدخال الاسم بالكامل' : null,
              ),

              14.szH,

              // Email Address
              DefaultTextField(
                controller: _emailController,
                label: S.of(context).emailLabel,
                hint: S.of(context).emailHint,
                inputType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email_outlined, color: AppColors.greyColor, size: 20.sp),
                validator: (val) => Validators.validateEmail(
                  val,
                  emptyMessage: S.of(context).emailHint,
                  invalidMessage: S.of(context).emailValidationMessage,
                ),
              ),

              14.szH,

              // Phone Number
              DefaultTextField(
                controller: _phoneController,
                label: S.of(context).phoneLabel,
                hint: S.of(context).phoneHint,
                inputType: TextInputType.phone,
                prefixIcon: Icon(Icons.phone_outlined, color: AppColors.greyColor, size: 20.sp),
                validator: (val) => val == null || val.trim().isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
              ),

              16.szH,

              // Expandable Change Password Header
              InkWell(
                onTap: () {
                  setState(() => _changePasswordExpanded = !_changePasswordExpanded);
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.softBlueBg.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.darkNavy.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lock_reset_rounded, color: AppColors.darkNavy, size: 20.sp),
                      8.szW,
                      Expanded(
                        child: Text(
                          'تغيير كلمة المرور (اختياري)',
                          style: getTextStyle().darkNavy.w600.s13,
                        ),
                      ),
                      Icon(
                        _changePasswordExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.darkNavy,
                        size: 22.sp,
                      ),
                    ],
                  ),
                ),
              ),

              // Change Password Fields
              if (_changePasswordExpanded) ...[
                14.szH,
                DefaultTextField(
                  controller: _currentPasswordController,
                  label: 'كلمة المرور الحالية',
                  hint: 'أدخل كلمة المرور الحالية',
                  isPassword: true,
                  prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.greyColor, size: 20.sp),
                ),
                12.szH,
                DefaultTextField(
                  controller: _newPasswordController,
                  label: 'كلمة المرور الجديدة',
                  hint: 'أدخل كلمة المرور الجديدة',
                  isPassword: true,
                  prefixIcon: Icon(Icons.lock_rounded, color: AppColors.greyColor, size: 20.sp),
                ),
                12.szH,
                DefaultTextField(
                  controller: _confirmPasswordController,
                  label: 'تأكيد كلمة المرور الجديدة',
                  hint: 'أعد إدخال كلمة المرور الجديدة',
                  isPassword: true,
                  prefixIcon: Icon(Icons.check_circle_outline_rounded, color: AppColors.greyColor, size: 20.sp),
                ),
              ],

              24.szH,

              // Action Buttons
              CustomButton(
                text: 'حفظ التعديلات',
                isLoading: _isLoading,
                onPressed: _handleSave,
                backgroundColor: AppColors.darkNavy,
                textStyle: getTextStyle().whiteColor.w700.s16,
              ),

              12.szH,
            ],
          ),
        ),
      ),
    );
  }
}
