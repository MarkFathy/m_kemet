import 'package:flutter/material.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/language_switcher_button.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/documents_upload_section.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/important_info_notice_card.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/intro_video_upload_card.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/professional_data_section.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile_setup/profile_completion_gauge_card.dart';

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

  void _onContinuePressed() {
    Go.offAllNamed(NamedRoutes.requestStatus);
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
              travelPossibilityController: _travelPossibilityController,
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
              completionPercentage: 0.40,
              onContinuePressed: _onContinuePressed,
            ),

            16.szH,

            // SECTION 5: Important Information Notice Card
            const ImportantInfoNoticeCard(),

            16.szH,
          ],
        ),
      ),
    );
  }
}
