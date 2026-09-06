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
import 'package:m_kemet/src/core/widgets/buttons/language_switcher_button.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_cubit.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_state.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/documents_upload_section.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/important_info_notice_card.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/intro_video_upload_card.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/professional_data_section.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/profile_completion_gauge_card.dart';

class JobSeekerProfileSetupScreen extends StatelessWidget {
  const JobSeekerProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<JobSeekerProfileCubit>()..loadInitialData(),
      child: const _JobSeekerProfileSetupView(),
    );
  }
}

class _JobSeekerProfileSetupView extends StatefulWidget {
  const _JobSeekerProfileSetupView();

  @override
  State<_JobSeekerProfileSetupView> createState() => _JobSeekerProfileSetupViewState();
}

class _JobSeekerProfileSetupViewState extends State<_JobSeekerProfileSetupView> {
  // Professional Data Controllers
  final _nameController = TextEditingController();
  final _professionController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceYearsController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _languagesController = TextEditingController();
  final _skillsController = TextEditingController();
  final _previousExperienceController = TextEditingController();
  final _expectedSalaryController = TextEditingController();
  final _targetCountriesController = TextEditingController();

  bool _isDataPopulated = false;

  @override
  void initState() {
    super.initState();
    _professionController.addListener(_onFieldChanged);
    _specializationController.addListener(_onFieldChanged);
    _experienceYearsController.addListener(_onFieldChanged);
    _qualificationController.addListener(_onFieldChanged);
    _languagesController.addListener(_onFieldChanged);
    _skillsController.addListener(_onFieldChanged);
    _previousExperienceController.addListener(_onFieldChanged);
    _expectedSalaryController.addListener(_onFieldChanged);
    _targetCountriesController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _professionController.removeListener(_onFieldChanged);
    _specializationController.removeListener(_onFieldChanged);
    _experienceYearsController.removeListener(_onFieldChanged);
    _qualificationController.removeListener(_onFieldChanged);
    _languagesController.removeListener(_onFieldChanged);
    _skillsController.removeListener(_onFieldChanged);
    _previousExperienceController.removeListener(_onFieldChanged);
    _expectedSalaryController.removeListener(_onFieldChanged);
    _targetCountriesController.removeListener(_onFieldChanged);
    _nameController.dispose();
    _professionController.dispose();
    _specializationController.dispose();
    _experienceYearsController.dispose();
    _qualificationController.dispose();
    _languagesController.dispose();
    _skillsController.dispose();
    _previousExperienceController.dispose();
    _expectedSalaryController.dispose();
    _targetCountriesController.dispose();
    super.dispose();
  }

  bool _isProfileComplete(JobSeekerProfileState state) {
    // 1. All documents and media
    final hasPersonalPhoto = state.uploadedPersonalPhoto != null ||
        state.localPersonalPhotoPath != null;
    final hasNationalId = state.uploadedNationalId != null ||
        state.localNationalIdPath != null;
    final hasPassport = state.uploadedPassport != null ||
        state.localPassportPath != null;
    final hasCv = state.uploadedCv != null ||
        state.localCvPath != null;
    final hasVideo = state.uploadedVideo != null ||
        state.localVideoPath != null ||
        (state.profileDetail?.videoUrl != null &&
            state.profileDetail!.videoUrl!.isNotEmpty);

    if (!hasPersonalPhoto ||
        !hasNationalId ||
        !hasPassport ||
        !hasCv ||
        !hasVideo) {
      return false;
    }

    // 2. All professional data
    final hasProfession = state.selectedProfession != null ||
        _professionController.text.trim().isNotEmpty;
    final hasSpecialization = _specializationController.text.trim().isNotEmpty;
    final hasExperience = state.selectedExperienceLevel != null ||
        _experienceYearsController.text.trim().isNotEmpty;
    final hasQualification = state.selectedQualification != null ||
        _qualificationController.text.trim().isNotEmpty;
    final hasLanguages = state.languages.isNotEmpty ||
        _languagesController.text.trim().isNotEmpty;
    final hasSkills = state.skills.isNotEmpty ||
        _skillsController.text.trim().isNotEmpty;
    final hasSalary = _expectedSalaryController.text.trim().isNotEmpty;
    final hasSummary = _previousExperienceController.text.trim().isNotEmpty;
    final hasTargetCountries = state.selectedTargetCountries.isNotEmpty ||
        _targetCountriesController.text.trim().isNotEmpty;

    return hasProfession &&
        hasSpecialization &&
        hasExperience &&
        hasQualification &&
        hasLanguages &&
        hasSkills &&
        hasSalary &&
        hasSummary &&
        hasTargetCountries;
  }

  double _calculateCompletionPercentage(JobSeekerProfileState state) {
    const total = 14;
    int earned = 0;

    // Media & Docs (5)
    if (state.uploadedPersonalPhoto != null || state.localPersonalPhotoPath != null) earned++;
    if (state.uploadedNationalId != null || state.localNationalIdPath != null) earned++;
    if (state.uploadedPassport != null || state.localPassportPath != null) earned++;
    if (state.uploadedCv != null || state.localCvPath != null) earned++;
    if (state.uploadedVideo != null ||
        state.localVideoPath != null ||
        (state.profileDetail?.videoUrl != null && state.profileDetail!.videoUrl!.isNotEmpty)) {
      earned++;
    }

    // Data (9)
    if (state.selectedProfession != null || _professionController.text.trim().isNotEmpty) earned++;
    if (_specializationController.text.trim().isNotEmpty) earned++;
    if (state.selectedExperienceLevel != null || _experienceYearsController.text.trim().isNotEmpty) earned++;
    if (state.selectedQualification != null || _qualificationController.text.trim().isNotEmpty) earned++;
    if (state.languages.isNotEmpty || _languagesController.text.trim().isNotEmpty) earned++;
    if (state.skills.isNotEmpty || _skillsController.text.trim().isNotEmpty) earned++;
    if (_expectedSalaryController.text.trim().isNotEmpty) earned++;
    if (_previousExperienceController.text.trim().isNotEmpty) earned++;
    if (state.selectedTargetCountries.isNotEmpty || _targetCountriesController.text.trim().isNotEmpty) earned++;

    return (earned / total).clamp(0.0, 1.0);
  }

  void _populateProfileData(JobSeekerProfileState state) {
    if (_isDataPopulated) return;
    final profile = state.profileDetail;
    if (profile == null) return;

    if (profile.name != null && profile.name!.isNotEmpty) {
      _nameController.text = profile.name!;
    }
    if (state.selectedProfession != null) {
      _professionController.text = state.selectedProfession!.name;
    }
    if (profile.subSpecialization != null) {
      _specializationController.text = profile.subSpecialization!;
    }
    if (state.selectedExperienceLevel != null) {
      _experienceYearsController.text = state.selectedExperienceLevel!.name;
    } else if (profile.experienceYears != null) {
      _experienceYearsController.text = '${profile.experienceYears} سنوات';
    }
    if (state.selectedQualification != null) {
      _qualificationController.text = state.selectedQualification!.name;
    } else if (profile.qualification != null) {
      _qualificationController.text = profile.qualification!;
    }
    if (profile.languages.isNotEmpty) {
      _languagesController.text = profile.languages.join('، ');
    }
    if (profile.skills.isNotEmpty) {
      _skillsController.text = profile.skills.join('، ');
    }
    if (profile.summary != null) {
      _previousExperienceController.text = profile.summary!;
    }
    if (profile.expectedSalary != null) {
      _expectedSalaryController.text = '${profile.expectedSalary}';
    }
    if (state.selectedTargetCountries.isNotEmpty) {
      _targetCountriesController.text =
          state.selectedTargetCountries.map((c) => c.name).join(', ');
    }

    _isDataPopulated = true;
  }

  void _onContinuePressed(BuildContext context) {
    final cubit = context.read<JobSeekerProfileCubit>();

    final salaryText = _expectedSalaryController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final expectedSalary = num.tryParse(salaryText);

    cubit.submitProfile(
      name: _nameController.text.isNotEmpty ? _nameController.text : null,
      qualificationId: cubit.state.selectedQualification?.id,
      qualification: _qualificationController.text.isNotEmpty ? _qualificationController.text : null,
      subSpecialization: _specializationController.text.isNotEmpty ? _specializationController.text : null,
      expectedSalary: expectedSalary,
      summary: _previousExperienceController.text.isNotEmpty ? _previousExperienceController.text : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JobSeekerProfileCubit, JobSeekerProfileState>(
      listener: (context, state) {
        if (state.profileFetchStatus == LoadingStatus.success) {
          _populateProfileData(state);
          if (state.profileDetail?.hasCompletedOrSubmittedProfile == true) {
            SessionManager.setJobSeekerProfileCompleted(true);
            Go.offAllNamed(NamedRoutes.jobSeekerMain);
            return;
          }
        }

        if (state.submitStatus == SubmissionStatus.success) {
          CustomSnackBar.showSuccess(
            context,
            message: state.successMessage ?? 'تم حفظ وإرسال بيانات طلب التوظيف بنجاح',
          );
          Go.offAllNamed(NamedRoutes.jobSeekerMain);
        } else if (state.submitStatus == SubmissionStatus.failure) {
          CustomSnackBar.showError(
            context,
            message: state.errorMessage ?? 'حدث خطأ أثناء حفظ البيانات، يرجى المحاولة مرة أخرى',
          );
        } else if (state.errorMessage != null && state.submitStatus != SubmissionStatus.failure) {
          CustomSnackBar.showError(
            context,
            message: state.errorMessage!,
          );
        }
      },
      builder: (context, state) {
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
                // Top Header: Language Switcher Button
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: LanguageSwitcherButton(),
                ),

                16.szH,

                // Page Title & Subtitle
                Text(
                  S.of(context).personalDocumentsTitle,
                  style: getTextStyle().darkNavy.w700.s22,
                ),

                6.szH,

                Text(
                  S.of(context).personalDocumentsSubtitle,
                  style: getTextStyle().greyColor.w400.s14.copyWith(height: 1.4),
                ),

                20.szH,

                // SECTION 1: Professional Data Fields
                ProfessionalDataSection(
                  professionController: _professionController,
                  specializationController: _specializationController,
                  experienceYearsController: _experienceYearsController,
                  qualificationController: _qualificationController,
                  languagesController: _languagesController,
                  skillsController: _skillsController,
                  previousExperienceController: _previousExperienceController,
                  expectedSalaryController: _expectedSalaryController,
                  targetCountriesController: _targetCountriesController,
                ),

                20.szH,

                // SECTION 2: Required Documents Uploads
                const DocumentsUploadSection(),

                12.szH,

                // SECTION 3: Intro Video Upload Card
                const IntroVideoUploadCard(),

                20.szH,

                // SECTION 4: Profile Completion Gauge & Action
                ProfileCompletionGaugeCard(
                  completionPercentage: _calculateCompletionPercentage(state),
                  isLoading: state.submitStatus == SubmissionStatus.loading,
                  isEnabled: _isProfileComplete(state),
                  onContinuePressed: () => _onContinuePressed(context),
                ),

                16.szH,

                // SECTION 5: Important Information Notice Card
                const ImportantInfoNoticeCard(),

                16.szH,
              ],
            ),
          ),
        );
      },
    );
  }
}
