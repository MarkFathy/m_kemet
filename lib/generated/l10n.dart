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

  /// `المستندات الشخصية والبيانات المهنية`
  String get personalDocumentsTitle {
    return Intl.message(
      'المستندات الشخصية والبيانات المهنية',
      name: 'personalDocumentsTitle',
      desc: '',
      args: [],
    );
  }

  /// `يرجى إكمال بياناتك المهنية ورفع المستندات لاستكمال ملفك الشخصي.`
  String get personalDocumentsSubtitle {
    return Intl.message(
      'يرجى إكمال بياناتك المهنية ورفع المستندات لاستكمال ملفك الشخصي.',
      name: 'personalDocumentsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `البيانات المهنية`
  String get professionalSectionTitle {
    return Intl.message(
      'البيانات المهنية',
      name: 'professionalSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `المهنة / المسمى الوظيفي`
  String get professionLabel {
    return Intl.message(
      'المهنة / المسمى الوظيفي',
      name: 'professionLabel',
      desc: '',
      args: [],
    );
  }

  /// `اختر المهنة (مثلاً: سائق، كهربائي...)`
  String get professionHint {
    return Intl.message(
      'اختر المهنة (مثلاً: سائق، كهربائي...)',
      name: 'professionHint',
      desc: '',
      args: [],
    );
  }

  /// `ابحث عن المهنة...`
  String get searchProfessionHint {
    return Intl.message(
      'ابحث عن المهنة...',
      name: 'searchProfessionHint',
      desc: '',
      args: [],
    );
  }

  /// `التخصص الدقيق`
  String get specializationLabel {
    return Intl.message(
      'التخصص الدقيق',
      name: 'specializationLabel',
      desc: '',
      args: [],
    );
  }

  /// `أدخل تخصصك الدقيق`
  String get specializationHint {
    return Intl.message(
      'أدخل تخصصك الدقيق',
      name: 'specializationHint',
      desc: '',
      args: [],
    );
  }

  /// `سنوات الخبرة`
  String get experienceYearsLabel {
    return Intl.message(
      'سنوات الخبرة',
      name: 'experienceYearsLabel',
      desc: '',
      args: [],
    );
  }

  /// `اختر سنوات الخبرة`
  String get experienceYearsHint {
    return Intl.message(
      'اختر سنوات الخبرة',
      name: 'experienceYearsHint',
      desc: '',
      args: [],
    );
  }

  /// `المؤهل الدراسي`
  String get qualificationLabel {
    return Intl.message(
      'المؤهل الدراسي',
      name: 'qualificationLabel',
      desc: '',
      args: [],
    );
  }

  /// `اختر المؤهل الدراسي`
  String get qualificationHint {
    return Intl.message(
      'اختر المؤهل الدراسي',
      name: 'qualificationHint',
      desc: '',
      args: [],
    );
  }

  /// `اللغات التي تجيدها`
  String get languagesLabel {
    return Intl.message(
      'اللغات التي تجيدها',
      name: 'languagesLabel',
      desc: '',
      args: [],
    );
  }

  /// `اختر اللغات`
  String get languagesHint {
    return Intl.message(
      'اختر اللغات',
      name: 'languagesHint',
      desc: '',
      args: [],
    );
  }

  /// `المهارات المهنية`
  String get skillsLabel {
    return Intl.message(
      'المهارات المهنية',
      name: 'skillsLabel',
      desc: '',
      args: [],
    );
  }

  /// `أدخل مهاراتك الرئيسية`
  String get skillsHint {
    return Intl.message(
      'أدخل مهاراتك الرئيسية',
      name: 'skillsHint',
      desc: '',
      args: [],
    );
  }

  /// `الخبرات السابقة`
  String get previousExperienceLabel {
    return Intl.message(
      'الخبرات السابقة',
      name: 'previousExperienceLabel',
      desc: '',
      args: [],
    );
  }

  /// `اكتب نبذة عن خبراتك وأماكن عملك السابقة`
  String get previousExperienceHint {
    return Intl.message(
      'اكتب نبذة عن خبراتك وأماكن عملك السابقة',
      name: 'previousExperienceHint',
      desc: '',
      args: [],
    );
  }

  /// `الراتب المتوقع`
  String get expectedSalaryLabel {
    return Intl.message(
      'الراتب المتوقع',
      name: 'expectedSalaryLabel',
      desc: '',
      args: [],
    );
  }

  /// `اختر الراتب المتوقع`
  String get expectedSalaryHint {
    return Intl.message(
      'اختر الراتب المتوقع',
      name: 'expectedSalaryHint',
      desc: '',
      args: [],
    );
  }

  /// `إمكانية السفر والتنقل`
  String get travelPossibilityLabel {
    return Intl.message(
      'إمكانية السفر والتنقل',
      name: 'travelPossibilityLabel',
      desc: '',
      args: [],
    );
  }

  /// `اختر إمكانية السفر`
  String get travelPossibilityHint {
    return Intl.message(
      'اختر إمكانية السفر',
      name: 'travelPossibilityHint',
      desc: '',
      args: [],
    );
  }

  /// `الدول التي ترغب بالسفر إليها`
  String get targetCountriesLabel {
    return Intl.message(
      'الدول التي ترغب بالسفر إليها',
      name: 'targetCountriesLabel',
      desc: '',
      args: [],
    );
  }

  /// `اختر الدول المرغوب السفر إليها`
  String get targetCountriesHint {
    return Intl.message(
      'اختر الدول المرغوب السفر إليها',
      name: 'targetCountriesHint',
      desc: '',
      args: [],
    );
  }

  /// `المستندات والوسائط المطلوبة`
  String get documentsSectionTitle {
    return Intl.message(
      'المستندات والوسائط المطلوبة',
      name: 'documentsSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `الصورة الشخصية`
  String get personalPhotoTitle {
    return Intl.message(
      'الصورة الشخصية',
      name: 'personalPhotoTitle',
      desc: '',
      args: [],
    );
  }

  /// `صورة بطاقة الهوية / الرقم القومي`
  String get idCardTitle {
    return Intl.message(
      'صورة بطاقة الهوية / الرقم القومي',
      name: 'idCardTitle',
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

  /// `الفيديو التعريفي (هام جداً)`
  String get introVideoTitle {
    return Intl.message(
      'الفيديو التعريفي (هام جداً)',
      name: 'introVideoTitle',
      desc: '',
      args: [],
    );
  }

  /// `مقطع فيديو تعريفي قصير (لمدة 1 دقيقة) تشرح فيه اسمك، مهنتك، خبراتك والدول التي ترغب بالسفر إليها`
  String get introVideoDesc {
    return Intl.message(
      'مقطع فيديو تعريفي قصير (لمدة 1 دقيقة) تشرح فيه اسمك، مهنتك، خبراتك والدول التي ترغب بالسفر إليها',
      name: 'introVideoDesc',
      desc: '',
      args: [],
    );
  }

  /// `اضغط هنا لرفع مقطع الفيديو التعريفي (1 دقيقة)`
  String get recordVideoHint {
    return Intl.message(
      'اضغط هنا لرفع مقطع الفيديو التعريفي (1 دقيقة)',
      name: 'recordVideoHint',
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

  /// `اكتمال الملف الشخصي`
  String get documentsCompletion {
    return Intl.message(
      'اكتمال الملف الشخصي',
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

  /// `تأكد من وضوح جميع المستندات وسريان مفعول جواز السفر لمدة لا تقل عن 6 أشهر وتصوير الفيديو بشكل واضح لتسريع ترشيحك للشركات.`
  String get importantInfoDesc {
    return Intl.message(
      'تأكد من وضوح جميع المستندات وسريان مفعول جواز السفر لمدة لا تقل عن 6 أشهر وتصوير الفيديو بشكل واضح لتسريع ترشيحك للشركات.',
      name: 'importantInfoDesc',
      desc: '',
      args: [],
    );
  }

  /// `حالة طلب التوظيف`
  String get requestStatusScreenTitle {
    return Intl.message(
      'حالة طلب التوظيف',
      name: 'requestStatusScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `قيد المراجعة`
  String get statusPending {
    return Intl.message(
      'قيد المراجعة',
      name: 'statusPending',
      desc: '',
      args: [],
    );
  }

  /// `تمت الموافقة`
  String get statusApproved {
    return Intl.message(
      'تمت الموافقة',
      name: 'statusApproved',
      desc: '',
      args: [],
    );
  }

  /// `مرفوض`
  String get statusRejected {
    return Intl.message('مرفوض', name: 'statusRejected', desc: '', args: []);
  }

  /// `طلبك قيد الدراسة والمراجعة`
  String get pendingHeaderTitle {
    return Intl.message(
      'طلبك قيد الدراسة والمراجعة',
      name: 'pendingHeaderTitle',
      desc: '',
      args: [],
    );
  }

  /// `قام فريقنا باستلام بياناتك ومستنداتك بنجاح، ويتم الآن التحقق من صحتها لترشيحك لأفضل فرص العمل.`
  String get pendingHeaderDesc {
    return Intl.message(
      'قام فريقنا باستلام بياناتك ومستنداتك بنجاح، ويتم الآن التحقق من صحتها لترشيحك لأفضل فرص العمل.',
      name: 'pendingHeaderDesc',
      desc: '',
      args: [],
    );
  }

  /// `تهانينا! تمت الموافقة على طلبك`
  String get approvedHeaderTitle {
    return Intl.message(
      'تهانينا! تمت الموافقة على طلبك',
      name: 'approvedHeaderTitle',
      desc: '',
      args: [],
    );
  }

  /// `تم اعتماد ملفك المهني بنجاح وأصبح متاحاً للعرض أمام كبرى الشركات والمؤسسات.`
  String get approvedHeaderDesc {
    return Intl.message(
      'تم اعتماد ملفك المهني بنجاح وأصبح متاحاً للعرض أمام كبرى الشركات والمؤسسات.',
      name: 'approvedHeaderDesc',
      desc: '',
      args: [],
    );
  }

  /// `نأسف، تم رفض الطلب حالياً`
  String get rejectedHeaderTitle {
    return Intl.message(
      'نأسف، تم رفض الطلب حالياً',
      name: 'rejectedHeaderTitle',
      desc: '',
      args: [],
    );
  }

  /// `يتعذر قبول الطلب في الوقت الحالي بسبب وجود ملاحظات على البيانات أو المستندات المرفقة.`
  String get rejectedHeaderDesc {
    return Intl.message(
      'يتعذر قبول الطلب في الوقت الحالي بسبب وجود ملاحظات على البيانات أو المستندات المرفقة.',
      name: 'rejectedHeaderDesc',
      desc: '',
      args: [],
    );
  }

  /// `سبب عدم القبول:`
  String get rejectionReasonTitle {
    return Intl.message(
      'سبب عدم القبول:',
      name: 'rejectionReasonTitle',
      desc: '',
      args: [],
    );
  }

  /// `صورة جواز السفر غير واضحة، والفيديو التعريفي يحتوي على تشويش في الصوت. يرجى إعادة الرفع.`
  String get rejectionReasonSample {
    return Intl.message(
      'صورة جواز السفر غير واضحة، والفيديو التعريفي يحتوي على تشويش في الصوت. يرجى إعادة الرفع.',
      name: 'rejectionReasonSample',
      desc: '',
      args: [],
    );
  }

  /// `إرسال البيانات`
  String get step1Title {
    return Intl.message(
      'إرسال البيانات',
      name: 'step1Title',
      desc: '',
      args: [],
    );
  }

  /// `فحص المستندات`
  String get step2Title {
    return Intl.message(
      'فحص المستندات',
      name: 'step2Title',
      desc: '',
      args: [],
    );
  }

  /// `القرار النهائي`
  String get step3Title {
    return Intl.message(
      'القرار النهائي',
      name: 'step3Title',
      desc: '',
      args: [],
    );
  }

  /// `الرقم المرجعي للطلب:`
  String get requestIdLabel {
    return Intl.message(
      'الرقم المرجعي للطلب:',
      name: 'requestIdLabel',
      desc: '',
      args: [],
    );
  }

  /// `تاريخ التقديم:`
  String get submissionDateLabel {
    return Intl.message(
      'تاريخ التقديم:',
      name: 'submissionDateLabel',
      desc: '',
      args: [],
    );
  }

  /// `الوقت المتوقع للرد:`
  String get estimatedTimeLabel {
    return Intl.message(
      'الوقت المتوقع للرد:',
      name: 'estimatedTimeLabel',
      desc: '',
      args: [],
    );
  }

  /// `24 - 48 ساعة عمل`
  String get estimatedTimeValue {
    return Intl.message(
      '24 - 48 ساعة عمل',
      name: 'estimatedTimeValue',
      desc: '',
      args: [],
    );
  }

  /// `تحديث الحالة`
  String get refreshStatus {
    return Intl.message(
      'تحديث الحالة',
      name: 'refreshStatus',
      desc: '',
      args: [],
    );
  }

  /// `الدعم الفني`
  String get contactSupport {
    return Intl.message(
      'الدعم الفني',
      name: 'contactSupport',
      desc: '',
      args: [],
    );
  }

  /// `تعديل وإعادة تقديم الطلب`
  String get resubmitRequest {
    return Intl.message(
      'تعديل وإعادة تقديم الطلب',
      name: 'resubmitRequest',
      desc: '',
      args: [],
    );
  }

  /// `الانتقال إلى الرئيسية`
  String get goToHome {
    return Intl.message(
      'الانتقال إلى الرئيسية',
      name: 'goToHome',
      desc: '',
      args: [],
    );
  }

  /// `البحث عن عمالة`
  String get navSearchCandidates {
    return Intl.message(
      'البحث عن عمالة',
      name: 'navSearchCandidates',
      desc: '',
      args: [],
    );
  }

  /// `الطلبات`
  String get navRequests {
    return Intl.message('الطلبات', name: 'navRequests', desc: '', args: []);
  }

  /// `المحفوظين`
  String get navSaved {
    return Intl.message('المحفوظين', name: 'navSaved', desc: '', args: []);
  }

  /// `الإشعارات`
  String get navNotifications {
    return Intl.message(
      'الإشعارات',
      name: 'navNotifications',
      desc: '',
      args: [],
    );
  }

  /// `الملف الشخصي`
  String get navProfile {
    return Intl.message('الملف الشخصي', name: 'navProfile', desc: '', args: []);
  }

  /// `البحث عن المرشحين`
  String get employerSearchTitle {
    return Intl.message(
      'البحث عن المرشحين',
      name: 'employerSearchTitle',
      desc: '',
      args: [],
    );
  }

  /// `ابحث بالاسم، المهنة، أو المهارة...`
  String get searchCandidateHint {
    return Intl.message(
      'ابحث بالاسم، المهنة، أو المهارة...',
      name: 'searchCandidateHint',
      desc: '',
      args: [],
    );
  }

  /// `تصفية نتائج البحث`
  String get filterTitle {
    return Intl.message(
      'تصفية نتائج البحث',
      name: 'filterTitle',
      desc: '',
      args: [],
    );
  }

  /// `تطبيق الفلاتر`
  String get applyFilters {
    return Intl.message(
      'تطبيق الفلاتر',
      name: 'applyFilters',
      desc: '',
      args: [],
    );
  }

  /// `إعادة ضبط`
  String get resetFilters {
    return Intl.message('إعادة ضبط', name: 'resetFilters', desc: '', args: []);
  }

  /// `الدولة الحالية`
  String get countryLabel {
    return Intl.message(
      'الدولة الحالية',
      name: 'countryLabel',
      desc: '',
      args: [],
    );
  }

  /// `العمر`
  String get ageLabel {
    return Intl.message('العمر', name: 'ageLabel', desc: '', args: []);
  }

  /// `حالة جواز السفر`
  String get passportStatusLabel {
    return Intl.message(
      'حالة جواز السفر',
      name: 'passportStatusLabel',
      desc: '',
      args: [],
    );
  }

  /// `عرض الملف`
  String get viewCandidateProfile {
    return Intl.message(
      'عرض الملف',
      name: 'viewCandidateProfile',
      desc: '',
      args: [],
    );
  }

  /// `محقق`
  String get verifiedBadge {
    return Intl.message('محقق', name: 'verifiedBadge', desc: '', args: []);
  }

  /// `غير محقق`
  String get unverifiedBadge {
    return Intl.message(
      'غير محقق',
      name: 'unverifiedBadge',
      desc: '',
      args: [],
    );
  }

  /// `جواز ساري`
  String get validPassport {
    return Intl.message('جواز ساري', name: 'validPassport', desc: '', args: []);
  }

  /// `غير ساري`
  String get invalidPassport {
    return Intl.message(
      'غير ساري',
      name: 'invalidPassport',
      desc: '',
      args: [],
    );
  }

  /// `الموقع الحالي`
  String get currentLocation {
    return Intl.message(
      'الموقع الحالي',
      name: 'currentLocation',
      desc: '',
      args: [],
    );
  }

  /// `الدول المطلوبة`
  String get requestedDestination {
    return Intl.message(
      'الدول المطلوبة',
      name: 'requestedDestination',
      desc: '',
      args: [],
    );
  }

  /// `المرشحين المحفوظين`
  String get savedCandidatesTitle {
    return Intl.message(
      'المرشحين المحفوظين',
      name: 'savedCandidatesTitle',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد مرشحين محفوظين حالياً`
  String get noSavedCandidates {
    return Intl.message(
      'لا يوجد مرشحين محفوظين حالياً',
      name: 'noSavedCandidates',
      desc: '',
      args: [],
    );
  }

  /// `طلبات التوظيف`
  String get requestsTitle {
    return Intl.message(
      'طلبات التوظيف',
      name: 'requestsTitle',
      desc: '',
      args: [],
    );
  }

  /// `الإشعارات`
  String get notificationsTitle {
    return Intl.message(
      'الإشعارات',
      name: 'notificationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `ملف الشركة`
  String get employerProfileTitle {
    return Intl.message(
      'ملف الشركة',
      name: 'employerProfileTitle',
      desc: '',
      args: [],
    );
  }

  /// `الملف الشخصي للمرشح`
  String get candidateProfileTitle {
    return Intl.message(
      'الملف الشخصي للمرشح',
      name: 'candidateProfileTitle',
      desc: '',
      args: [],
    );
  }

  /// `الخبرة`
  String get experienceLabel {
    return Intl.message('الخبرة', name: 'experienceLabel', desc: '', args: []);
  }

  /// `طلب تواصل`
  String get requestContact {
    return Intl.message(
      'طلب تواصل',
      name: 'requestContact',
      desc: '',
      args: [],
    );
  }

  /// `تحميل السيرة الذاتية`
  String get downloadCv {
    return Intl.message(
      'تحميل السيرة الذاتية',
      name: 'downloadCv',
      desc: '',
      args: [],
    );
  }

  /// `الإعدادات`
  String get navSettings {
    return Intl.message('الإعدادات', name: 'navSettings', desc: '', args: []);
  }

  /// `تنبيهات وإشعارات التطبيق`
  String get notificationsToggleTitle {
    return Intl.message(
      'تنبيهات وإشعارات التطبيق',
      name: 'notificationsToggleTitle',
      desc: '',
      args: [],
    );
  }

  /// `استلام تنبيهات فورية عند الرد على طلبات التواصل`
  String get notificationsToggleSub {
    return Intl.message(
      'استلام تنبيهات فورية عند الرد على طلبات التواصل',
      name: 'notificationsToggleSub',
      desc: '',
      args: [],
    );
  }

  /// `سجل الإشعارات والتنبيهات`
  String get notificationsHistoryTitle {
    return Intl.message(
      'سجل الإشعارات والتنبيهات',
      name: 'notificationsHistoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `مراجعة كافة الرسائل والتنبيهات السابقة`
  String get notificationsHistorySub {
    return Intl.message(
      'مراجعة كافة الرسائل والتنبيهات السابقة',
      name: 'notificationsHistorySub',
      desc: '',
      args: [],
    );
  }

  /// `عرض وتصفح المرشحين المميزين المحفوظين لديك`
  String get savedCandidatesSub {
    return Intl.message(
      'عرض وتصفح المرشحين المميزين المحفوظين لديك',
      name: 'savedCandidatesSub',
      desc: '',
      args: [],
    );
  }

  /// `شركة الخليج للاستقدام والتطوير`
  String get companyProfileHeader {
    return Intl.message(
      'شركة الخليج للاستقدام والتطوير',
      name: 'companyProfileHeader',
      desc: '',
      args: [],
    );
  }

  /// `حساب مؤسسة موثق | الرياض، السعودية`
  String get companyProfileSub {
    return Intl.message(
      'حساب مؤسسة موثق | الرياض، السعودية',
      name: 'companyProfileSub',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد نتائج طابقها البحث الحالي`
  String get noSearchResultsTitle {
    return Intl.message(
      'لا توجد نتائج طابقها البحث الحالي',
      name: 'noSearchResultsTitle',
      desc: '',
      args: [],
    );
  }

  /// `جرب تغيير كلمات البحث أو إعادة ضبط الفلاتر`
  String get noSearchResultsSub {
    return Intl.message(
      'جرب تغيير كلمات البحث أو إعادة ضبط الفلاتر',
      name: 'noSearchResultsSub',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد طلبات تواصل حالية`
  String get noRequestsTitle {
    return Intl.message(
      'لا يوجد طلبات تواصل حالية',
      name: 'noRequestsTitle',
      desc: '',
      args: [],
    );
  }

  /// `جميع طلبات التواصل والاستقدام المعروضة ستظهر هنا ومتابعة حالتها (قيد المراجعة، مقبول، مكتمل).`
  String get noRequestsSub {
    return Intl.message(
      'جميع طلبات التواصل والاستقدام المعروضة ستظهر هنا ومتابعة حالتها (قيد المراجعة، مقبول، مكتمل).',
      name: 'noRequestsSub',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد إشعارات جديدة`
  String get noNotificationsTitle {
    return Intl.message(
      'لا يوجد إشعارات جديدة',
      name: 'noNotificationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `سيصلك تنبيه فور قيام الإدارة بالموافقة على طلب التواصل أو تحديث حالته.`
  String get noNotificationsSub {
    return Intl.message(
      'سيصلك تنبيه فور قيام الإدارة بالموافقة على طلب التواصل أو تحديث حالته.',
      name: 'noNotificationsSub',
      desc: '',
      args: [],
    );
  }

  /// `يمكنك حفظ المرشحين المميزين أثناء البحث للعودة إليهم لاحقاً بسهولة.`
  String get savedCandidatesEmptySub {
    return Intl.message(
      'يمكنك حفظ المرشحين المميزين أثناء البحث للعودة إليهم لاحقاً بسهولة.',
      name: 'savedCandidatesEmptySub',
      desc: '',
      args: [],
    );
  }

  /// `الفيديو التعريفي للمرشح`
  String get candidateVideoTitle {
    return Intl.message(
      'الفيديو التعريفي للمرشح',
      name: 'candidateVideoTitle',
      desc: '',
      args: [],
    );
  }

  /// `نبذة عن المرشح`
  String get candidateBioTitle {
    return Intl.message(
      'نبذة عن المرشح',
      name: 'candidateBioTitle',
      desc: '',
      args: [],
    );
  }

  /// `البيانات المهنية والتفاصيل`
  String get candidateDetailsTitle {
    return Intl.message(
      'البيانات المهنية والتفاصيل',
      name: 'candidateDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `لغة التطبيق`
  String get appLanguageTitle {
    return Intl.message(
      'لغة التطبيق',
      name: 'appLanguageTitle',
      desc: '',
      args: [],
    );
  }

  /// `تغيير لغة العرض بين العربية والإنجليزية`
  String get appLanguageSub {
    return Intl.message(
      'تغيير لغة العرض بين العربية والإنجليزية',
      name: 'appLanguageSub',
      desc: '',
      args: [],
    );
  }

  /// `تم إرسال طلب التواصل بنجاح! سيتم مراجعة الطلب من الداشبورد والموافقة عليه للتواصل مع المرشح.`
  String get contactRequestSuccess {
    return Intl.message(
      'تم إرسال طلب التواصل بنجاح! سيتم مراجعة الطلب من الداشبورد والموافقة عليه للتواصل مع المرشح.',
      name: 'contactRequestSuccess',
      desc: '',
      args: [],
    );
  }

  /// `جارٍ فتح ملف السيرة الذاتية (CV) للمرشح...`
  String get cvDownloadInfo {
    return Intl.message(
      'جارٍ فتح ملف السيرة الذاتية (CV) للمرشح...',
      name: 'cvDownloadInfo',
      desc: '',
      args: [],
    );
  }

  /// `تم تفعيل إشعارات التطبيق`
  String get notificationsEnabledMsg {
    return Intl.message(
      'تم تفعيل إشعارات التطبيق',
      name: 'notificationsEnabledMsg',
      desc: '',
      args: [],
    );
  }

  /// `تم إيقاف إشعارات التطبيق`
  String get notificationsDisabledMsg {
    return Intl.message(
      'تم إيقاف إشعارات التطبيق',
      name: 'notificationsDisabledMsg',
      desc: '',
      args: [],
    );
  }

  /// `مكتمل`
  String get statusCompleted {
    return Intl.message('مكتمل', name: 'statusCompleted', desc: '', args: []);
  }

  /// `تسجيل الخروج`
  String get logout {
    return Intl.message('تسجيل الخروج', name: 'logout', desc: '', args: []);
  }

  /// `تسجيل الخروج من الحساب الحالي`
  String get logoutSub {
    return Intl.message(
      'تسجيل الخروج من الحساب الحالي',
      name: 'logoutSub',
      desc: '',
      args: [],
    );
  }

  /// `تأكيد تسجيل الخروج`
  String get logoutConfirmTitle {
    return Intl.message(
      'تأكيد تسجيل الخروج',
      name: 'logoutConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `هل أنت تأكد من رغبتك في تسجيل الخروج من حساب الشركة؟`
  String get logoutConfirmMsg {
    return Intl.message(
      'هل أنت تأكد من رغبتك في تسجيل الخروج من حساب الشركة؟',
      name: 'logoutConfirmMsg',
      desc: '',
      args: [],
    );
  }

  /// `حذف الحساب نهائياً`
  String get deleteAccount {
    return Intl.message(
      'حذف الحساب نهائياً',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `حذف حساب الشركة وكافة البيانات بشكل نهائي`
  String get deleteAccountSub {
    return Intl.message(
      'حذف حساب الشركة وكافة البيانات بشكل نهائي',
      name: 'deleteAccountSub',
      desc: '',
      args: [],
    );
  }

  /// `تنبيه: حذف حساب الشركة`
  String get deleteAccountConfirmTitle {
    return Intl.message(
      'تنبيه: حذف حساب الشركة',
      name: 'deleteAccountConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `سيؤدي حذف الحساب إلى إلغاء كافة طلبات التواصل، المرشحين المحفوظين، والمعلومات بشكل نهائي ولا يمكن استعادتها.`
  String get deleteAccountConfirmMsg {
    return Intl.message(
      'سيؤدي حذف الحساب إلى إلغاء كافة طلبات التواصل، المرشحين المحفوظين، والمعلومات بشكل نهائي ولا يمكن استعادتها.',
      name: 'deleteAccountConfirmMsg',
      desc: '',
      args: [],
    );
  }

  /// `حذف الحساب نهائياً`
  String get confirmDeleteAction {
    return Intl.message(
      'حذف الحساب نهائياً',
      name: 'confirmDeleteAction',
      desc: '',
      args: [],
    );
  }

  /// `إلغاء`
  String get cancel {
    return Intl.message('إلغاء', name: 'cancel', desc: '', args: []);
  }

  /// `أوافق على `
  String get agreeToTermsPrefix {
    return Intl.message(
      'أوافق على ',
      name: 'agreeToTermsPrefix',
      desc: '',
      args: [],
    );
  }

  /// `الشروط والأحكام وسياسة الخصوصية`
  String get termsAndConditions {
    return Intl.message(
      'الشروط والأحكام وسياسة الخصوصية',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `يرجى الموافقة على الشروط والأحكام لإتمام عملية التسجيل`
  String get acceptTermsRequired {
    return Intl.message(
      'يرجى الموافقة على الشروط والأحكام لإتمام عملية التسجيل',
      name: 'acceptTermsRequired',
      desc: '',
      args: [],
    );
  }

  /// `الشروط والأحكام وسياسة الخصوصية`
  String get termsScreenTitle {
    return Intl.message(
      'الشروط والأحكام وسياسة الخصوصية',
      name: 'termsScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `آخر تحديث: 17 أغسطس 2026`
  String get termsLastUpdated {
    return Intl.message(
      'آخر تحديث: 17 أغسطس 2026',
      name: 'termsLastUpdated',
      desc: '',
      args: [],
    );
  }

  /// `الموافقة والقبول`
  String get acceptAndContinue {
    return Intl.message(
      'الموافقة والقبول',
      name: 'acceptAndContinue',
      desc: '',
      args: [],
    );
  }

  /// `معلومات الاتصال والمنشأة`
  String get companyInfoTitle {
    return Intl.message(
      'معلومات الاتصال والمنشأة',
      name: 'companyInfoTitle',
      desc: '',
      args: [],
    );
  }

  /// `اسم الشركة`
  String get companyNameField {
    return Intl.message(
      'اسم الشركة',
      name: 'companyNameField',
      desc: '',
      args: [],
    );
  }

  /// `رقم الهاتف`
  String get companyPhoneField {
    return Intl.message(
      'رقم الهاتف',
      name: 'companyPhoneField',
      desc: '',
      args: [],
    );
  }

  /// `البريد الإلكتروني`
  String get companyEmailField {
    return Intl.message(
      'البريد الإلكتروني',
      name: 'companyEmailField',
      desc: '',
      args: [],
    );
  }

  /// `رقم السجل التجاري`
  String get companyCrField {
    return Intl.message(
      'رقم السجل التجاري',
      name: 'companyCrField',
      desc: '',
      args: [],
    );
  }

  /// `المقر الرئيسي`
  String get companyLocationField {
    return Intl.message(
      'المقر الرئيسي',
      name: 'companyLocationField',
      desc: '',
      args: [],
    );
  }

  /// `استعادة كلمة المرور`
  String get forgotPasswordTitle {
    return Intl.message(
      'استعادة كلمة المرور',
      name: 'forgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `أدخل البريد الإلكتروني أو رقم الهاتف المسجل بحسابك وسنرسل لك رمز التحقق لاستعادة الحساب.`
  String get forgotPasswordSub {
    return Intl.message(
      'أدخل البريد الإلكتروني أو رقم الهاتف المسجل بحسابك وسنرسل لك رمز التحقق لاستعادة الحساب.',
      name: 'forgotPasswordSub',
      desc: '',
      args: [],
    );
  }

  /// `إرسال رمز التحقق`
  String get sendResetCode {
    return Intl.message(
      'إرسال رمز التحقق',
      name: 'sendResetCode',
      desc: '',
      args: [],
    );
  }

  /// `تذكرت كلمة المرور؟`
  String get rememberedPassword {
    return Intl.message(
      'تذكرت كلمة المرور؟',
      name: 'rememberedPassword',
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
