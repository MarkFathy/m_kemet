import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/profile/company_profile_details_card.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/profile/company_profile_header_card.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();
    final authCubit = context.read<AuthCubit>();
    if (authCubit.state.user == null) {
      authCubit.getProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = authState.user;

        if (authState.status == AuthStatus.loading && user == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.darkNavy),
          );
        }

        if (authState.status == AuthStatus.error && user == null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.pW24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.errorRed),
                  16.szH,
                  Text(
                    authState.errorMessage ?? S.of(context).profileLoadError,
                    textAlign: TextAlign.center,
                    style: getTextStyle().darkNavy.w600.s14,
                  ),
                  16.szH,
                  ElevatedButton(
                    onPressed: () => context.read<AuthCubit>().getProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkNavy,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      S.of(context).retryAction,
                      style: getTextStyle().whiteColor.w600.s14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final companyName = (user?.companyName != null && user!.companyName!.isNotEmpty)
            ? user.companyName!
            : (user?.name ?? '');
        final phone = user?.phone ?? '';
        final email = user?.email ?? '';
        final crNumber = user?.crNumber;
        final location = user?.location ?? user?.countryName;
        final isVerified = user?.isVerified ?? (user?.status == 'active');
        final status = user?.status;

        return RefreshIndicator(
          onRefresh: () => context.read<AuthCubit>().getProfile(),
          color: AppColors.darkNavy,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.pW12,
              vertical: AppPadding.pH12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).employerProfileTitle,
                  style: getTextStyle().darkNavy.w700.s24,
                ),
                16.szH,

                // Header Summary Card
                CompanyProfileHeaderCard(
                  companyName: companyName,
                  isVerified: isVerified,
                  status: status,
                ),

                16.szH,

                // Detailed Info Card
                CompanyProfileDetailsCard(
                  companyName: companyName,
                  phone: phone,
                  email: email,
                  crNumber: crNumber,
                  location: location,
                ),

                100.szH,
              ],
            ),
          ),
        );
      },
    );
  }
}
