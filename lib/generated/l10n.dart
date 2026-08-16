// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `بوابتك لفرص العمل الدولية وتجربة سفر استثنائية`
  String get splashTitle {
    return Intl.message(
      'بوابتك لفرص العمل الدولية وتجربة سفر استثنائية',
      name: 'splashTitle',
      desc: '',
      args: [],
    );
  }

  /// `ابحث عن فرصتك القادمة`
  String get onboardingTitle1 {
    return Intl.message(
      'ابحث عن فرصتك القادمة',
      name: 'onboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `اكتشف آلاف الوظائف المتاحة في مختلف المجالات ودول العالم بحرية وسهولة`
  String get onboardingSubTitle1 {
    return Intl.message(
      'اكتشف آلاف الوظائف المتاحة في مختلف المجالات ودول العالم بحرية وسهولة',
      name: 'onboardingSubTitle1',
      desc: '',
      args: [],
    );
  }

  /// `اعرض خبراتك أمام الشركات`
  String get onboardingTitle2 {
    return Intl.message(
      'اعرض خبراتك أمام الشركات',
      name: 'onboardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `بني ملفك الشخصي المتميز وليشاهد كبرى الشركات العالمية مهاراتك وانجازاتك`
  String get onboardingSubTitle2 {
    return Intl.message(
      'بني ملفك الشخصي المتميز وليشاهد كبرى الشركات العالمية مهاراتك وانجازاتك',
      name: 'onboardingSubTitle2',
      desc: '',
      args: [],
    );
  }

  /// `وصول لفرص عمل خارج بلدك بسهولة`
  String get onboardingTitle3 {
    return Intl.message(
      'وصول لفرص عمل خارج بلدك بسهولة',
      name: 'onboardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `سهولة التقديم والتواصل المباشر مع أصحاب العمل الدوليين من مكانك`
  String get onboardingSubTitle3 {
    return Intl.message(
      'سهولة التقديم والتواصل المباشر مع أصحاب العمل الدوليين من مكانك',
      name: 'onboardingSubTitle3',
      desc: '',
      args: [],
    );
  }

  /// `تخطي`
  String get skip {
    return Intl.message('تخطي', name: 'skip', desc: '', args: []);
  }

  /// `التالي`
  String get next {
    return Intl.message('التالي', name: 'next', desc: '', args: []);
  }

  /// `ابدأ الآن`
  String get getStarted {
    return Intl.message('ابدأ الآن', name: 'getStarted', desc: '', args: []);
  }

  /// `مسار للتوظيف`
  String get appBrandName {
    return Intl.message(
      'مسار للتوظيف',
      name: 'appBrandName',
      desc: '',
      args: [],
    );
  }

  /// `كيف ترغب في استخدام مسار؟`
  String get userTypeTitle {
    return Intl.message(
      'كيف ترغب في استخدام مسار؟',
      name: 'userTypeTitle',
      desc: '',
      args: [],
    );
  }

  /// `يرجى تحديد نوع الحساب الذي يعكس هدفك من استخدام المنصة سنوفر لك التجربة الأمثل.`
  String get userTypeSubtitle {
    return Intl.message(
      'يرجى تحديد نوع الحساب الذي يعكس هدفك من استخدام المنصة سنوفر لك التجربة الأمثل.',
      name: 'userTypeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `باحث عن عمل`
  String get jobSeekerTitle {
    return Intl.message(
      'باحث عن عمل',
      name: 'jobSeekerTitle',
      desc: '',
      args: [],
    );
  }

  /// `استكشف فرصال وظيفية متميزة في قطاع السياحة والسفر وابنِ ملفك المهني.`
  String get jobSeekerDesc {
    return Intl.message(
      'استكشف فرصال وظيفية متميزة في قطاع السياحة والسفر وابنِ ملفك المهني.',
      name: 'jobSeekerDesc',
      desc: '',
      args: [],
    );
  }

  /// `البحث عن وظائف والتقديم بسهولة`
  String get jobSeekerFeature1 {
    return Intl.message(
      'البحث عن وظائف والتقديم بسهولة',
      name: 'jobSeekerFeature1',
      desc: '',
      args: [],
    );
  }

  /// `إنشاء وتحديث سيرتك الذاتية`
  String get jobSeekerFeature2 {
    return Intl.message(
      'إنشاء وتحديث سيرتك الذاتية',
      name: 'jobSeekerFeature2',
      desc: '',
      args: [],
    );
  }

  /// `صاحب عمل / شركة`
  String get employerTitle {
    return Intl.message(
      'صاحب عمل / شركة',
      name: 'employerTitle',
      desc: '',
      args: [],
    );
  }

  /// `أبحث عن كفاءات ومواهب للانضمام إلى فريقي وأرغب في إدارة طلبات التوظيف.`
  String get employerDesc {
    return Intl.message(
      'أبحث عن كفاءات ومواهب للانضمام إلى فريقي وأرغب في إدارة طلبات التوظيف.',
      name: 'employerDesc',
      desc: '',
      args: [],
    );
  }

  /// `نشر إعلانات وظيفية جديدة`
  String get employerFeature1 {
    return Intl.message(
      'نشر إعلانات وظيفية جديدة',
      name: 'employerFeature1',
      desc: '',
      args: [],
    );
  }

  /// `إدارة وتصفية المرشحين للعمل`
  String get employerFeature2 {
    return Intl.message(
      'إدارة وتصفية المرشحين للعمل',
      name: 'employerFeature2',
      desc: '',
      args: [],
    );
  }

  /// `المتابعة`
  String get continueAction {
    return Intl.message('المتابعة', name: 'continueAction', desc: '', args: []);
  }

  /// `تسجيل الدخول`
  String get loginTitle {
    return Intl.message('تسجيل الدخول', name: 'loginTitle', desc: '', args: []);
  }

  /// `مرحباً بك مجدداً! يرجى إدخال بياناتك للمتابعة`
  String get loginSubtitle {
    return Intl.message(
      'مرحباً بك مجدداً! يرجى إدخال بياناتك للمتابعة',
      name: 'loginSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `إنشاء حساب جديد`
  String get registerTitle {
    return Intl.message(
      'إنشاء حساب جديد',
      name: 'registerTitle',
      desc: '',
      args: [],
    );
  }

  /// `قم بإنشاء حسابك واستكشف أحدث وأفضل الفرص`
  String get registerSubtitle {
    return Intl.message(
      'قم بإنشاء حسابك واستكشف أحدث وأفضل الفرص',
      name: 'registerSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `البريد الإلكتروني`
  String get emailLabel {
    return Intl.message(
      'البريد الإلكتروني',
      name: 'emailLabel',
      desc: '',
      args: [],
    );
  }

  /// `أدخل البريد الإلكتروني`
  String get emailHint {
    return Intl.message(
      'أدخل البريد الإلكتروني',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور`
  String get passwordLabel {
    return Intl.message(
      'كلمة المرور',
      name: 'passwordLabel',
      desc: '',
      args: [],
    );
  }

  /// `أدخل كلمة المرور`
  String get passwordHint {
    return Intl.message(
      'أدخل كلمة المرور',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `تأكيد كلمة المرور`
  String get confirmPasswordLabel {
    return Intl.message(
      'تأكيد كلمة المرور',
      name: 'confirmPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `أدخل تأكيد كلمة المرور`
  String get confirmPasswordHint {
    return Intl.message(
      'أدخل تأكيد كلمة المرور',
      name: 'confirmPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `الاسم الكامل`
  String get fullNameLabel {
    return Intl.message(
      'الاسم الكامل',
      name: 'fullNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `أدخل الاسم الكامل`
  String get fullNameHint {
    return Intl.message(
      'أدخل الاسم الكامل',
      name: 'fullNameHint',
      desc: '',
      args: [],
    );
  }

  /// `رقم الهاتف`
  String get phoneLabel {
    return Intl.message('رقم الهاتف', name: 'phoneLabel', desc: '', args: []);
  }

  /// `أدخل رقم الهاتف`
  String get phoneHint {
    return Intl.message(
      'أدخل رقم الهاتف',
      name: 'phoneHint',
      desc: '',
      args: [],
    );
  }

  /// `اسم الشركة / المؤسسة`
  String get companyNameLabel {
    return Intl.message(
      'اسم الشركة / المؤسسة',
      name: 'companyNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `أدخل اسم الشركة`
  String get companyNameHint {
    return Intl.message(
      'أدخل اسم الشركة',
      name: 'companyNameHint',
      desc: '',
      args: [],
    );
  }

  /// `الدولة الحالية`
  String get currentCountryLabel {
    return Intl.message(
      'الدولة الحالية',
      name: 'currentCountryLabel',
      desc: '',
      args: [],
    );
  }

  /// `اختر الدولة الحالية`
  String get currentCountryHint {
    return Intl.message(
      'اختر الدولة الحالية',
      name: 'currentCountryHint',
      desc: '',
      args: [],
    );
  }

  /// `ابحث عن اسم الدولة...`
  String get searchCountryHint {
    return Intl.message(
      'ابحث عن اسم الدولة...',
      name: 'searchCountryHint',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد نتائج مطابقة`
  String get noCountryFound {
    return Intl.message(
      'لا توجد نتائج مطابقة',
      name: 'noCountryFound',
      desc: '',
      args: [],
    );
  }

  /// `تاريخ الميلاد`
  String get dateOfBirthLabel {
    return Intl.message(
      'تاريخ الميلاد',
      name: 'dateOfBirthLabel',
      desc: '',
      args: [],
    );
  }

  /// `اختر تاريخ الميلاد`
  String get dateOfBirthHint {
    return Intl.message(
      'اختر تاريخ الميلاد',
      name: 'dateOfBirthHint',
      desc: '',
      args: [],
    );
  }

  /// `الجنس`
  String get genderLabel {
    return Intl.message('الجنس', name: 'genderLabel', desc: '', args: []);
  }

  /// `اختر الجنس`
  String get genderHint {
    return Intl.message('اختر الجنس', name: 'genderHint', desc: '', args: []);
  }

  /// `ذكر`
  String get male {
    return Intl.message('ذكر', name: 'male', desc: '', args: []);
  }

  /// `أنثى`
  String get female {
    return Intl.message('أنثى', name: 'female', desc: '', args: []);
  }

  /// `نسيت كلمة المرور؟`
  String get forgotPassword {
    return Intl.message(
      'نسيت كلمة المرور؟',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الدخول`
  String get loginAction {
    return Intl.message(
      'تسجيل الدخول',
      name: 'loginAction',
      desc: '',
      args: [],
    );
  }

  /// `إنشاء حساب`
  String get registerAction {
    return Intl.message(
      'إنشاء حساب',
      name: 'registerAction',
      desc: '',
      args: [],
    );
  }

  /// `ليس لديك حساب؟`
  String get dontHaveAccount {
    return Intl.message(
      'ليس لديك حساب؟',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `لديك حساب بالفعل؟`
  String get alreadyHaveAccount {
    return Intl.message(
      'لديك حساب بالفعل؟',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `سجل الآن`
  String get signUpNow {
    return Intl.message('سجل الآن', name: 'signUpNow', desc: '', args: []);
  }

  /// `سجل الدخول`
  String get signInNow {
    return Intl.message('سجل الدخول', name: 'signInNow', desc: '', args: []);
  }

  /// `التحقق من رمز OTP`
  String get otpTitle {
    return Intl.message(
      'التحقق من رمز OTP',
      name: 'otpTitle',
      desc: '',
      args: [],
    );
  }

  /// `يرجى إدخال رمز التحقق المكون من 6 أرقام المرسل إليك`
  String get otpSubtitle {
    return Intl.message(
      'يرجى إدخال رمز التحقق المكون من 6 أرقام المرسل إليك',
      name: 'otpSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `تأكيد الرمز`
  String get verifyAction {
    return Intl.message(
      'تأكيد الرمز',
      name: 'verifyAction',
      desc: '',
      args: [],
    );
  }

  /// `إعادة إرسال الرمز`
  String get resendCode {
    return Intl.message(
      'إعادة إرسال الرمز',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `إعادة الإرسال خلال `
  String get resendIn {
    return Intl.message(
      'إعادة الإرسال خلال ',
      name: 'resendIn',
      desc: '',
      args: [],
    );
  }

  /// `يرجى إدخال بريد إلكتروني صحيح`
  String get emailValidationMessage {
    return Intl.message(
      'يرجى إدخال بريد إلكتروني صحيح',
      name: 'emailValidationMessage',
      desc: '',
      args: [],
    );
  }

  /// `يرجى إدخال رقم هاتف صحيح`
  String get phoneValidationMessage {
    return Intl.message(
      'يرجى إدخال رقم هاتف صحيح',
      name: 'phoneValidationMessage',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور يجب ألا تقل عن 8 أحرف`
  String get passwordValidationMessage {
    return Intl.message(
      'كلمة المرور يجب ألا تقل عن 8 أحرف',
      name: 'passwordValidationMessage',
      desc: '',
      args: [],
    );
  }

  /// `كلمتا المرور غير متطابقتين`
  String get confirmPasswordMismatch {
    return Intl.message(
      'كلمتا المرور غير متطابقتين',
      name: 'confirmPasswordMismatch',
      desc: '',
      args: [],
    );
  }

  /// `المستندات الشخصية`
  String get personalDocumentsTitle {
    return Intl.message(
      'المستندات الشخصية',
      name: 'personalDocumentsTitle',
      desc: '',
      args: [],
    );
  }

  /// `يرجى رفع المستندات التالية لاستكمال ملفك الشخصي.`
  String get personalDocumentsSubtitle {
    return Intl.message(
      'يرجى رفع المستندات التالية لاستكمال ملفك الشخصي.',
      name: 'personalDocumentsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `صورة جواز السفر`
  String get passportCopyTitle {
    return Intl.message(
      'صورة جواز السفر',
      name: 'passportCopyTitle',
      desc: '',
      args: [],
    );
  }

  /// `صيغة PDF أو JPG، أقصى حجم 5 ميجابايت`
  String get passportCopyDesc {
    return Intl.message(
      'صيغة PDF أو JPG، أقصى حجم 5 ميجابايت',
      name: 'passportCopyDesc',
      desc: '',
      args: [],
    );
  }

  /// `السيرة الذاتية (CV)`
  String get cvTitle {
    return Intl.message(
      'السيرة الذاتية (CV)',
      name: 'cvTitle',
      desc: '',
      args: [],
    );
  }

  /// `صيغة PDF أو DOCX، أقصى حجم 5 ميجابايت`
  String get cvDesc {
    return Intl.message(
      'صيغة PDF أو DOCX، أقصى حجم 5 ميجابايت',
      name: 'cvDesc',
      desc: '',
      args: [],
    );
  }

  /// `الفيديو التعريفي وشهادات الخبرة`
  String get introVideoTitle {
    return Intl.message(
      'الفيديو التعريفي وشهادات الخبرة',
      name: 'introVideoTitle',
      desc: '',
      args: [],
    );
  }

  /// `مقطع فيديو تعريفي قصير (اختياري) أو شهادات خبرة`
  String get introVideoDesc {
    return Intl.message(
      'مقطع فيديو تعريفي قصير (اختياري) أو شهادات خبرة',
      name: 'introVideoDesc',
      desc: '',
      args: [],
    );
  }

  /// `تم الرفع`
  String get uploadedBadge {
    return Intl.message('تم الرفع', name: 'uploadedBadge', desc: '', args: []);
  }

  /// `مطلوب`
  String get requiredBadge {
    return Intl.message('مطلوب', name: 'requiredBadge', desc: '', args: []);
  }

  /// `قيد الرفع`
  String get uploadingBadge {
    return Intl.message(
      'قيد الرفع',
      name: 'uploadingBadge',
      desc: '',
      args: [],
    );
  }

  /// `اضغط هنا لتصفح الملفات أو رفع المستند`
  String get dragAndDropHint {
    return Intl.message(
      'اضغط هنا لتصفح الملفات أو رفع المستند',
      name: 'dragAndDropHint',
      desc: '',
      args: [],
    );
  }

  /// `حالة الملف`
  String get profileStatusTitle {
    return Intl.message(
      'حالة الملف',
      name: 'profileStatusTitle',
      desc: '',
      args: [],
    );
  }

  /// `اكتمال المستندات`
  String get documentsCompletion {
    return Intl.message(
      'اكتمال المستندات',
      name: 'documentsCompletion',
      desc: '',
      args: [],
    );
  }

  /// `معلومات هامة`
  String get importantInfoTitle {
    return Intl.message(
      'معلومات هامة',
      name: 'importantInfoTitle',
      desc: '',
      args: [],
    );
  }

  /// `تأكد من وضوح جميع المستندات وسريان مفعول جواز السفر لمدة لا تقل عن 6 أشهر لتسريع عملية التوظيف.`
  String get importantInfoDesc {
    return Intl.message(
      'تأكد من وضوح جميع المستندات وسريان مفعول جواز السفر لمدة لا تقل عن 6 أشهر لتسريع عملية التوظيف.',
      name: 'importantInfoDesc',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
