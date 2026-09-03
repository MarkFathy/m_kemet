import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/app_progress_indicator.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_cubit.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_state.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile/job_seeker_details_card.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile/job_seeker_hero_card.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile/job_seeker_profile_header.dart';

class JobSeekerProfileTab extends StatelessWidget {
  const JobSeekerProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = authState.user;

        if (authState.status == AuthStatus.loading && user == null) {
          return const AppProgressIndicator.centered();
        }

        final name = user?.name ?? '';
        final email = user?.email ?? '';
        final phone = user?.phone ?? '';

        final countryName = user?.countryName ?? '';
        final countryFlag = user?.countryFlag ?? '';
        final countryDisplay = countryFlag.isNotEmpty ? '$countryName $countryFlag' : countryName;

        final gender = user?.gender ?? '';

        return BlocBuilder<JobSeekerProfileCubit, JobSeekerProfileState>(
          builder: (context, profileState) {
            // Priority:
            // 1. User avatar if provided by auth profile
            // 2. Personal photo uploaded in job form (uploadedPersonalPhoto)
            // 3. Document of type 'personal_photo' in profileDetail
            final personalPhotoDoc = profileState.uploadedPersonalPhoto ??
                profileState.profileDetail?.documents
                    .where((d) => d.documentType == 'personal_photo')
                    .firstOrNull;

            final remotePhotoUrl = (user?.avatar != null && user!.avatar!.isNotEmpty)
                ? user.avatar
                : (personalPhotoDoc?.fileUrl ?? personalPhotoDoc?.filePath);

            final localPhotoPath = profileState.localPersonalPhotoPath;
            final localPhotoFile = (localPhotoPath != null && localPhotoPath.isNotEmpty)
                ? File(localPhotoPath)
                : null;

            final professionTitle = profileState.selectedProfession?.name ??
                profileState.profileDetail?.subSpecialization;

            return RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  context.read<AuthCubit>().getProfile(),
                  context.read<JobSeekerProfileCubit>().loadInitialData(),
                ]);
              },
              color: AppColors.darkNavy,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.pW16,
                  vertical: AppPadding.pH12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar Header
                    const JobSeekerProfileHeader(),

                    16.szH,

                    // 1. User Hero Summary Card (With personal photo from form & title)
                    JobSeekerHeroCard(
                      name: name,
                      avatar: remotePhotoUrl,
                      localAvatarFile: localPhotoFile,
                      professionTitle: professionTitle,
                    ),

                    16.szH,

                    // 2. Candidate Profile Information Card (بيانات الحساب والملف الشخصي)
                    JobSeekerDetailsCard(
                      name: name,
                      phone: phone,
                      email: email,
                      countryDisplay: countryDisplay,
                      gender: gender,
                    ),

                    24.szH,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
