import 'package:m_kemet/gen/assets.gen.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/features/onboarding/data/models/onboarding_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  List<OnboardingModel> getOnboardingPages();
  Future<void> setOnboardingCompleted();
  Future<bool> isOnboardingCompleted();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _onboardingKey = 'ONBOARDING_COMPLETED';

  OnboardingLocalDataSourceImpl(this.sharedPreferences);

  @override
  List<OnboardingModel> getOnboardingPages() {
    String title1 = 'ابحث عن فرصتك القادمة';
    String subTitle1 = 'اكتشف آلاف الوظائف المتاحة في مختلف المجالات ودول العالم بحرية وسهولة';
    String title2 = 'اعرض خبراتك أمام الشركات';
    String subTitle2 = 'بني ملفك الشخصي المتميز وليشاهد كبرى الشركات العالمية مهاراتك وانجازاتك';
    String title3 = 'وصول لفرص عمل خارج بلدك بسهولة';
    String subTitle3 = 'سهولة التقديم والتواصل المباشر مع أصحاب العمل الدوليين من مكانك';

    try {
      title1 = S.current.onboardingTitle1;
      subTitle1 = S.current.onboardingSubTitle1;
      title2 = S.current.onboardingTitle2;
      subTitle2 = S.current.onboardingSubTitle2;
      title3 = S.current.onboardingTitle3;
      subTitle3 = S.current.onboardingSubTitle3;
    } catch (_) {}

    return [
      OnboardingModel(
        title: title1,
        subTitle: subTitle1,
        imagePath: Assets.pngs.onboarding1.path,
      ),
      OnboardingModel(
        title: title2,
        subTitle: subTitle2,
        imagePath: Assets.pngs.onboarding2.path,
      ),
      OnboardingModel(
        title: title3,
        subTitle: subTitle3,
        imagePath: Assets.pngs.onboarding3.path,
      ),
    ];
  }

  @override
  Future<void> setOnboardingCompleted() async {
    await sharedPreferences.setBool(_onboardingKey, true);
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return sharedPreferences.getBool(_onboardingKey) ?? false;
  }
}
