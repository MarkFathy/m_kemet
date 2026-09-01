import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/app_progress_indicator.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile/edit_account_credentials_sheet.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile/job_seeker_details_card.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile/job_seeker_hero_card.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/profile/job_seeker_profile_header.dart';

class JobSeekerProfileTab extends StatefulWidget {
  const JobSeekerProfileTab({super.key});

  @override
  State<JobSeekerProfileTab> createState() => _JobSeekerProfileTabState();
}

class _JobSeekerProfileTabState extends State<JobSeekerProfileTab> {
  String? _customName;
  String? _customEmail;
  String? _customPhone;

  void _openEditCredentialsSheet(BuildContext context, user) {
    EditAccountCredentialsSheet.show(
      context,
      currentUser: user,
      onSave: (name, email, phone) {
        setState(() {
          _customName = name;
          _customEmail = email;
          _customPhone = phone;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state.user;

        if (state.status == AuthStatus.loading && user == null) {
          return const AppProgressIndicator.centered();
        }

        final name = _customName ?? user?.name ?? '';
        final email = _customEmail ?? user?.email ?? '';
        final phone = _customPhone ?? user?.phone ?? '';

        final countryName = user?.countryName ?? '';
        final countryFlag = user?.countryFlag ?? '';
        final countryDisplay = countryFlag.isNotEmpty ? '$countryName $countryFlag' : countryName;

        final gender = user?.gender ?? '';

        return RefreshIndicator(
          onRefresh: () async {
            await context.read<AuthCubit>().getProfile();
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
                JobSeekerProfileHeader(
                  onEdit: () => _openEditCredentialsSheet(context, user),
                ),

                16.szH,

                // 1. User Hero Summary Card
                JobSeekerHeroCard(
                  name: name,
                  avatar: user?.avatar,
                ),

                16.szH,

                // 2. Candidate Profile Information Card (بيانات الملف الشخصي)
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
  }
}
