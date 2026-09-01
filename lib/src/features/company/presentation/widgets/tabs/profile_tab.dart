import 'package:flutter/material.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/profile/company_profile_details_card.dart';
import 'package:m_kemet/src/features/company/presentation/widgets/profile/company_profile_header_card.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
          const CompanyProfileHeaderCard(),

          16.szH,

          // Detailed Info Card
          const CompanyProfileDetailsCard(),

          24.szH,
        ],
      ),
    );
  }
}
