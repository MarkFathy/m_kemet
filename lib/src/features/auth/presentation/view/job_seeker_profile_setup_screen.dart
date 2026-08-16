import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/app_cubit/app_cubit.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';

class JobSeekerProfileSetupScreen extends StatefulWidget {
  const JobSeekerProfileSetupScreen({super.key});

  @override
  State<JobSeekerProfileSetupScreen> createState() => _JobSeekerProfileSetupScreenState();
}

class _JobSeekerProfileSetupScreenState extends State<JobSeekerProfileSetupScreen> {
  // Professional Data Controllers
  final _professionController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceYearsController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _languagesController = TextEditingController();
  final _skillsController = TextEditingController();
  final _previousExperienceController = TextEditingController();
  final _expectedSalaryController = TextEditingController();
  final _travelPossibilityController = TextEditingController();
  final _targetCountriesController = TextEditingController();

  // Preset lists for searchable bottom sheets
  final List<String> _professions = [
    'سائق (Driver)',
    'كهربائي (Electrician)',
    'طباخ / شيف (Cook / Chef)',
    'فني تكييف وتبريد (AC Technician)',
    'سباك (Plumber)',
    'نجار (Carpenter)',
    'مهندس مدني / معماري (Civil / Architect Engineer)',
    'ممرض / ممرضة (Nurse)',
    'محاسب (Accountant)',
    'موظف استقبال / فندقة (Receptionist / Hospitality)',
    'خياط (Tailor)',
    'بائع / مبيعات (Sales Executive)',
    'مهنة أخرى (Other)',
  ];

  final List<String> _experienceYearsOptions = [
    'أقل من سنة (Less than 1 year)',
    '1 - 3 سنوات (1 - 3 years)',
    '3 - 5 سنوات (3 - 5 years)',
    '5 - 10 سنوات (5 - 10 years)',
    'أكثر من 10 سنوات (10+ years)',
  ];

  final List<String> _qualificationOptions = [
    'ثانوية عامة / ما يعادلها (High School)',
    'دبلوم فني / متوسط (Diploma)',
    'بكالوريوس / ليسانس (Bachelor Degree)',
    'ماجستير / دكتوراه (Master / PhD)',
    'بدون مؤهل (No Degree)',
  ];

  final List<String> _expectedSalaryOptions = [
    '\$500 - \$1,000 / شهرياً',
    '\$1,000 - \$2,000 / شهرياً',
    '\$2,000 - \$3,500 / شهرياً',
    '\$3,500+ / شهرياً',
  ];

  final List<String> _travelPossibilityOptions = [
    'متاح فوراً للسفر (Available Immediately)',
    'متاح خلال شهر (Available within 1 month)',
    'غير متاح حالياً (Not Available)',
  ];

  final List<String> _allTargetCountries = [
    'المملكة العربية السعودية (Saudi Arabia)',
    'الإمارات العربية المتحدة (UAE)',
    'الكويت (Kuwait)',
    'قطر (Qatar)',
    'سلطنة عمان (Oman)',
    'البحرين (Bahrain)',
    'ألمانيا (Germany)',
    'إيطاليا (Italy)',
    'كندا (Canada)',
    'أي دولة متاحة (Any Country)',
  ];

  final Set<String> _selectedTargetCountries = {};

  @override
  void dispose() {
    _professionController.dispose();
    _specializationController.dispose();
    _experienceYearsController.dispose();
    _qualificationController.dispose();
    _languagesController.dispose();
    _skillsController.dispose();
    _previousExperienceController.dispose();
    _expectedSalaryController.dispose();
    _travelPossibilityController.dispose();
    _targetCountriesController.dispose();
    super.dispose();
  }

  // 1. Searchable Profession Sheet
  void _showProfessionBottomSheet() {
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
            final filtered = _professions
                .where((item) => item.toLowerCase().contains(searchQuery.toLowerCase()))
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
                      S.of(context).professionLabel,
                      style: getTextStyle().darkNavy.w700.s18,
                    ),
                    16.szH,
                    DefaultTextField(
                      hint: S.of(context).searchProfessionHint,
                      prefixIcon: Icon(Icons.search_rounded, color: AppColors.greyColor, size: 20.sp),
                      onChanged: (val) {
                        setModalState(() {
                          searchQuery = val ?? '';
                        });
                      },
                    ),
                    12.szH,
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
                                final item = filtered[index];
                                final isSelected = _professionController.text == item;
                                return ListTile(
                                  title: Text(
                                    item,
                                    style: isSelected
                                        ? getTextStyle().darkNavy.w700.s15
                                        : getTextStyle().darkNavy.w500.s15,
                                  ),
                                  trailing: isSelected
                                      ? const Icon(Icons.check_circle_rounded, color: AppColors.darkNavy)
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _professionController.text = item;
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

  // 2. Generic Selection Sheet
  void _showSingleSelectionBottomSheet({
    required String title,
    required List<String> options,
    required TextEditingController controller,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
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
                title,
                style: getTextStyle().darkNavy.w700.s18,
              ),
              16.szH,
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: options.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = options[index];
                    final isSelected = controller.text == item;
                    return ListTile(
                      title: Text(
                        item,
                        style: isSelected
                            ? getTextStyle().darkNavy.w700.s15
                            : getTextStyle().darkNavy.w500.s15,
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded, color: AppColors.darkNavy)
                          : null,
                      onTap: () {
                        setState(() {
                          controller.text = item;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 3. Searchable Multi-selection Sheet for Target Destination Countries
  void _showTargetCountriesBottomSheet() {
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
            final filtered = _allTargetCountries
                .where((c) => c.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
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
                      S.of(context).targetCountriesLabel,
                      style: getTextStyle().darkNavy.w700.s18,
                    ),
                    16.szH,
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
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final isChecked = _selectedTargetCountries.contains(item);
                          return CheckboxListTile(
                            activeColor: AppColors.darkNavy,
                            title: Text(
                              item,
                              style: isChecked
                                  ? getTextStyle().darkNavy.w700.s15
                                  : getTextStyle().darkNavy.w500.s15,
                            ),
                            value: isChecked,
                            onChanged: (checked) {
                              setModalState(() {
                                if (checked == true) {
                                  _selectedTargetCountries.add(item);
                                } else {
                                  _selectedTargetCountries.remove(item);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    12.szH,
                    CustomButton(
                      text: S.of(context).continueAction,
                      onPressed: () {
                        setState(() {
                          _targetCountriesController.text = _selectedTargetCountries.join(', ');
                        });
                        Navigator.pop(context);
                      },
                      backgroundColor: AppColors.darkNavy,
                      textStyle: getTextStyle().whiteColor.w700.s16,
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

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppCubit>().state.locale.languageCode == 'ar';

    return AppScaffold(
      safeTop: true,
      safeBottom: true,
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.pW16,
          vertical: AppPadding.pH12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: Brand Name & User Profile / Language
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).appBrandName,
                  style: getTextStyle().darkNavy.w700.s20,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<AppCubit>().toggleLanguage();
                      },
                      borderRadius: BorderRadius.circular(8.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Text(
                          isArabic ? 'EN' : 'عربي',
                          style: getTextStyle().darkNavy.bold.s16,
                        ),
                      ),
                    ),
                    8.szW,
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: const Color(0xFFD0E8FF),
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.darkNavy,
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            20.szH,

            // Page Title
            Text(
              S.of(context).personalDocumentsTitle,
              style: getTextStyle().darkNavy.w700.s24,
            ),

            6.szH,

            Text(
              S.of(context).personalDocumentsSubtitle,
              style: getTextStyle().greyColor.w400.s14.copyWith(height: 1.5),
            ),

            24.szH,

            // SECTION 1: البيانات المهنية (Professional Data)
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.work_outline_rounded, color: AppColors.darkNavy, size: 22.sp),
                      8.szW,
                      Text(
                        S.of(context).professionalSectionTitle,
                        style: getTextStyle().darkNavy.w700.s18,
                      ),
                    ],
                  ),

                  16.szH,

                  // 1. Profession (Searchable Picker)
                  DefaultTextField(
                    controller: _professionController,
                    label: S.of(context).professionLabel,
                    hint: S.of(context).professionHint,
                    readOnly: true,
                    onTap: _showProfessionBottomSheet,
                    prefixIcon: Icon(Icons.engineering_outlined, color: AppColors.greyColor, size: 20.sp),
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
                  ),

                  16.szH,

                  // 2. Specialization
                  DefaultTextField(
                    controller: _specializationController,
                    label: S.of(context).specializationLabel,
                    hint: S.of(context).specializationHint,
                    prefixIcon: Icon(Icons.category_outlined, color: AppColors.greyColor, size: 20.sp),
                  ),

                  16.szH,

                  // 3. Years of Experience
                  DefaultTextField(
                    controller: _experienceYearsController,
                    label: S.of(context).experienceYearsLabel,
                    hint: S.of(context).experienceYearsHint,
                    readOnly: true,
                    onTap: () => _showSingleSelectionBottomSheet(
                      title: S.of(context).experienceYearsLabel,
                      options: _experienceYearsOptions,
                      controller: _experienceYearsController,
                    ),
                    prefixIcon: Icon(Icons.history_toggle_off_rounded, color: AppColors.greyColor, size: 20.sp),
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
                  ),

                  16.szH,

                  // 4. Educational Qualification
                  DefaultTextField(
                    controller: _qualificationController,
                    label: S.of(context).qualificationLabel,
                    hint: S.of(context).qualificationHint,
                    readOnly: true,
                    onTap: () => _showSingleSelectionBottomSheet(
                      title: S.of(context).qualificationLabel,
                      options: _qualificationOptions,
                      controller: _qualificationController,
                    ),
                    prefixIcon: Icon(Icons.school_outlined, color: AppColors.greyColor, size: 20.sp),
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
                  ),

                  16.szH,

                  // 5. Spoken Languages
                  DefaultTextField(
                    controller: _languagesController,
                    label: S.of(context).languagesLabel,
                    hint: S.of(context).languagesHint,
                    prefixIcon: Icon(Icons.translate_rounded, color: AppColors.greyColor, size: 20.sp),
                  ),

                  16.szH,

                  // 6. Skills
                  DefaultTextField(
                    controller: _skillsController,
                    label: S.of(context).skillsLabel,
                    hint: S.of(context).skillsHint,
                    prefixIcon: Icon(Icons.star_outline_rounded, color: AppColors.greyColor, size: 20.sp),
                  ),

                  16.szH,

                  // 7. Previous Experience (Multiline)
                  DefaultTextField(
                    controller: _previousExperienceController,
                    label: S.of(context).previousExperienceLabel,
                    hint: S.of(context).previousExperienceHint,
                    inputType: TextInputType.multiline,
                    maxLines: 3,
                    prefixIcon: Icon(Icons.description_outlined, color: AppColors.greyColor, size: 20.sp),
                  ),

                  16.szH,

                  // 8. Expected Salary
                  DefaultTextField(
                    controller: _expectedSalaryController,
                    label: S.of(context).expectedSalaryLabel,
                    hint: S.of(context).expectedSalaryHint,
                    readOnly: true,
                    onTap: () => _showSingleSelectionBottomSheet(
                      title: S.of(context).expectedSalaryLabel,
                      options: _expectedSalaryOptions,
                      controller: _expectedSalaryController,
                    ),
                    prefixIcon: Icon(Icons.attach_money_rounded, color: AppColors.greyColor, size: 20.sp),
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
                  ),

                  16.szH,

                  // 9. Willingness to Travel
                  DefaultTextField(
                    controller: _travelPossibilityController,
                    label: S.of(context).travelPossibilityLabel,
                    hint: S.of(context).travelPossibilityHint,
                    readOnly: true,
                    onTap: () => _showSingleSelectionBottomSheet(
                      title: S.of(context).travelPossibilityLabel,
                      options: _travelPossibilityOptions,
                      controller: _travelPossibilityController,
                    ),
                    prefixIcon: Icon(Icons.flight_takeoff_rounded, color: AppColors.greyColor, size: 20.sp),
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
                  ),

                  16.szH,

                  // 10. Preferred Destination Countries (Multi-select Sheet)
                  DefaultTextField(
                    controller: _targetCountriesController,
                    label: S.of(context).targetCountriesLabel,
                    hint: S.of(context).targetCountriesHint,
                    readOnly: true,
                    onTap: _showTargetCountriesBottomSheet,
                    prefixIcon: Icon(Icons.travel_explore_rounded, color: AppColors.greyColor, size: 20.sp),
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
                  ),
                ],
              ),
            ),

            24.szH,

            // SECTION 2: المستندات والوسائط (Documents & Intro Video)
            Text(
              S.of(context).documentsSectionTitle,
              style: getTextStyle().darkNavy.w700.s20,
            ),

            12.szH,

            // Item 1: Personal Photo (الصورة الشخصية)
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26.r,
                    backgroundColor: const Color(0xFFD0E8FF),
                    child: Icon(Icons.add_a_photo_outlined, color: AppColors.darkNavy, size: 22.sp),
                  ),
                  12.szW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).personalPhotoTitle,
                          style: getTextStyle().darkNavy.w700.s16,
                        ),
                        4.szH,
                        Text(
                          'صورة شخصية حديثة بخلفية بيضاء',
                          style: getTextStyle().greyColor.w400.s12,
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkNavy,
                      side: const BorderSide(color: AppColors.darkNavy),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: Text(
                      'رفع',
                      style: getTextStyle().darkNavy.w600.s13,
                    ),
                  ),
                ],
              ),
            ),

            14.szH,

            // Item 2: National ID / Card (صورة بطاقة الهوية)
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F3EC),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(Icons.credit_card_rounded, color: const Color(0xFF0F7D59), size: 24.sp),
                  ),
                  12.szW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).idCardTitle,
                          style: getTextStyle().darkNavy.w700.s16,
                        ),
                        4.szH,
                        Text(
                          'صورة وجهي البطاقة الشخصية',
                          style: getTextStyle().greyColor.w400.s12,
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkNavy,
                      side: const BorderSide(color: AppColors.darkNavy),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: Text(
                      'رفع',
                      style: getTextStyle().darkNavy.w600.s13,
                    ),
                  ),
                ],
              ),
            ),

            14.szH,

            // Item 3: Passport Copy Card (صورة جواز السفر)
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD0E8FF),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.badge_outlined,
                          color: AppColors.darkNavy,
                          size: 24.sp,
                        ),
                      ),
                      12.szW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).passportCopyTitle,
                              style: getTextStyle().darkNavy.w700.s16,
                            ),
                            4.szH,
                            Text(
                              S.of(context).passportCopyDesc,
                              style: getTextStyle().greyColor.w400.s12,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2F3EC),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          S.of(context).uploadedBadge,
                          style: getTextStyle().w600.s11.copyWith(
                            color: const Color(0xFF0F7D59),
                          ),
                        ),
                      ),
                    ],
                  ),

                  12.szH,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('100%', style: getTextStyle().greyColor.w600.s12),
                      Row(
                        children: [
                          Text('passport_scan_v2.pdf', style: getTextStyle().darkNavy.w600.s13),
                          6.szW,
                          Icon(Icons.check_circle_rounded, color: const Color(0xFF0F7D59), size: 16.sp),
                        ],
                      ),
                    ],
                  ),
                  6.szH,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: 1.0,
                      minHeight: 6.h,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F7D59)),
                    ),
                  ),
                ],
              ),
            ),

            14.szH,

            // Item 4: CV Upload Dropzone (السيرة الذاتية)
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(Icons.description_outlined, color: AppColors.darkNavy, size: 24.sp),
                      ),
                      12.szW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).cvTitle,
                              style: getTextStyle().darkNavy.w700.s16,
                            ),
                            4.szH,
                            Text(
                              S.of(context).cvDesc,
                              style: getTextStyle().greyColor.w400.s12,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          S.of(context).requiredBadge,
                          style: getTextStyle().w600.s11.copyWith(color: const Color(0xFFDC2626)),
                        ),
                      ),
                    ],
                  ),

                  14.szH,

                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.darkNavy.withValues(alpha: 0.3),
                          width: 1.5.w,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.cloud_upload_outlined, size: 30.sp, color: AppColors.darkNavy),
                          8.szH,
                          Text(
                            S.of(context).dragAndDropHint,
                            textAlign: TextAlign.center,
                            style: getTextStyle().darkNavy.w600.s13,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            14.szH,

            // Item 5: INTRO VIDEO CARD (⭐ الفيديو التعريفي ⭐)
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFFDE68A), width: 1.5.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.videocam_rounded,
                          color: const Color(0xFFD97706),
                          size: 26.sp,
                        ),
                      ),
                      12.szW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).introVideoTitle,
                              style: getTextStyle().darkNavy.w700.s16,
                            ),
                            4.szH,
                            Text(
                              'فيديو مدته 1 دقيقة لتعريف بالكفاءة',
                              style: getTextStyle().greyColor.w600.s12,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          S.of(context).requiredBadge,
                          style: getTextStyle().w600.s11.copyWith(color: const Color(0xFFDC2626)),
                        ),
                      ),
                    ],
                  ),

                  12.szH,

                  // Detailed Instructions Box
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFFFCD34D)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_outline_rounded, color: const Color(0xFFD97706), size: 20.sp),
                        8.szW,
                        Expanded(
                          child: Text(
                            S.of(context).introVideoDesc,
                            style: getTextStyle().darkNavy.w500.s13.copyWith(height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  14.szH,

                  // Video Upload Box
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFD97706),
                          width: 1.5.w,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.video_call_rounded, size: 40.sp, color: const Color(0xFFD97706)),
                          10.szH,
                          Text(
                            S.of(context).recordVideoHint,
                            textAlign: TextAlign.center,
                            style: getTextStyle().darkNavy.w700.s14,
                          ),
                          6.szH,
                          Text(
                            'الحد الأقصى للمدة: 01:00 دقيقة | MP4 / MOV',
                            style: getTextStyle().greyColor.w400.s12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            24.szH,

            // Profile Completion Gauge ("حالة الملف")
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('40%', style: getTextStyle().darkNavy.w700.s16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(S.of(context).profileStatusTitle, style: getTextStyle().darkNavy.w700.s18),
                          Text(S.of(context).documentsCompletion, style: getTextStyle().greyColor.w400.s12),
                        ],
                      ),
                    ],
                  ),
                  10.szH,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: 0.40,
                      minHeight: 8.h,
                      backgroundColor: const Color(0xFFCBD5E1),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.darkNavy),
                    ),
                  ),
                  20.szH,
                  CustomButton(
                    text: S.of(context).continueAction,
                    onPressed: () {
                      Go.offAllNamed(NamedRoutes.home);
                    },
                    backgroundColor: AppColors.steelBlue,
                    textStyle: getTextStyle().whiteColor.w700.s16,
                  ),
                ],
              ),
            ),

            20.szH,

            // Important Information Notice
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: AppColors.darkNavy, size: 22.sp),
                      8.szW,
                      Text(
                        S.of(context).importantInfoTitle,
                        style: getTextStyle().darkNavy.w700.s16,
                      ),
                    ],
                  ),
                  8.szH,
                  Text(
                    S.of(context).importantInfoDesc,
                    style: getTextStyle().darkNavy.w400.s13.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),

            16.szH,
          ],
        ),
      ),
    );
  }
}
