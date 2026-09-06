# منصة كيميت للتوظيف والتدريب | Kemet (مـ كيميت)

<p align="center">
  <img src="assets/images/logo.png" alt="Kemet Logo" width="120" />
</p>

<p align="center">
  <b>منصة ذكية ومتكاملة للربط بين الباحثين عن عمل والشركات في مصر والشرق الأوسط، بتجربة مستخدم عصرية وأداء فائق.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.27+-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Architecture-Clean%20Architecture-success?style=for-the-badge" />
  <img src="https://img.shields.io/badge/State%20Management-Bloc%20%2F%20Cubit-blueviolet?style=for-the-badge" />
</p>

---

## 📌 عن المشروع (About The Project)

**كيميت (Kemet)** هو تطبيق جوال مبني باستخدام إطار عمل **Flutter**، يهدف إلى تسهيل وتنظيم عملية التوظيف والبحث عن الكفاءات، حيث يوفر تجربتين مخصصتين بالكامل:

1. **باحث عن عمل (Job Seeker):**
   - استكمال ملف تعريفي احترافي (البيانات الأساسية، رفع وتعديل المستندات، رفع فيديو تعريفي Video CV، واختيار التخصص).
   - متابعة حالة طلبات التوظيف والاعتماد مباشرة (قيد المراجعة، تم القبول، إلخ).
   - إدارة إعدادات الحساب وتغيير اللغة وكلمة المرور وحذف الحساب نهائياً.

2. **الشركات وأصحاب الأعمال (Company / Recruiter):**
   - استعراض وبحث متقدم عن المرشحين والكوادر الوظيفية مع فلاتر ذكية.
   - معاينة السيرة الذاتية والفيديوهات التعريفية للمرشحين مع تشغيل ذكي وـ Thumbnail معاينة تلقائية.
   - حفظ المرشحين في المفضلة (Bookmarks) للرجوع إليهم لاحقاً.
   - متابعة وإدارة طلبات التوظيف والاتصال المباشر بالمرشحين.

---

## ✨ أبرز المميزات (Key Features)

- **🎨 واجهة مستخدم عصرية وفخمة (Modern UI/UX):**
  - متوافقة مع مختلف مقاسات الشاشات باستخدام `flutter_screenutil`.
  - شريط تنقل سفلي عائم وزجاجي مخصص (`Floating Bottom Nav Bar`).
  - تأثيرات تحميل متطورة (`Custom Shimmers`) ورسوميات تفاعلية (`Lottie Animations`).
- **🌐 دعم كامل للغات (Localization):**
  - ثنائي اللغة بالكامل (العربية والإنجليزية) بنظام RTL / LTR سلس وسريع.
- **🎥 استعراض الفيديو والمستندات:**
  - مشغل فيديو مدمج (`video_player`) مع دعم كاش ومعاينة مصغرة للفيديوهات قبل الفتح.
  - محرر وقاص للصور (`image_cropper`) لاختيار الصور الشخصية بدقة.
  - رفع المستندات والملفات بصيغ مختلفة (`PDF`, `DOC`, `DOCX`).
- **🔐 أمان وإدارة الجلسات:**
  - تأمين وحفظ التوكينات الحساسة باستخدام `flutter_secure_storage`.
  - توثيق متعدد المراحل بالـ OTP عبر الرسائل النصية.
  - دعم تدفق حذف الحساب الآمن لكلا النوعين من المستخدمين.

---

## 🏗️ الهيكلية المعمارية (Architecture & Tech Stack)

تم بناء المشروع باتباع أفضل الممارسات البرمجية عبر **Clean Architecture** مع الالتزام بمبادئ **SOLID**:

```
lib/
├── generated/                     # ملفات الترجمة والتوطين المولدة تلقائياً
├── src/
│   ├── config/                    # إعدادات التطبيق، الثيمات، الألوان والخطوط
│   │   ├── res/                   # ColorManager, FontManager, Assets
│   │   └── themes/                # AppTheme (Light/Dark Ready)
│   ├── core/                      # المكونات المشتركة عبر المشروع
│   │   ├── api/                   # Dio Client, Interceptors, Endpoints, Error Handling
│   │   ├── app_cubit/             # إدارة إعدادات التطبيق العامة (اللغة، الثيم)
│   │   ├── navigation/            # Custom Router, Deep Linking, Animations
│   │   ├── services/              # SessionManager, Service Locator (GetIt)
│   │   └── widgets/               # المكونات التفاعلية العامة (Buttons, Dialogs, Shimmers)
│   └── features/                  # موديولات ومميزات التطبيق (Features)
│       ├── auth/                  # تسجيل الدخول، إنشاء الحساب، كود التحقق OTP
│       ├── bookmarks/             # حفظ المرشحين
│       ├── company/               # بوابات وواجهات الشركات وإدارة المرشحين
│       ├── job_seeker/            # بوابات الباحث عن عمل ورفع المستندات
│       ├── notifications/         # نظام الإشعارات
│       ├── onboarding/            # شاشات الترحيب والتعريف بالتطبيق
│       ├── splash/                # شاشة البداية والتحقق من الجلسة
│       └── user_type_selection/   # اختيار نوع الحساب (شركة / باحث عن عمل)
└── main.dart                      # نقطة انطلاق التطبيق
```

### 🛠️ الحزم والتقنيات المستخدمة (Dependencies):
- **State Management:** `flutter_bloc` مع نمط `Cubit`.
- **Dependency Injection:** `get_it`.
- **Networking:** `dio` مع معالجة متقدمة للأخطاء و `pretty_dio_logger`.
- **Local Storage:** `shared_preferences` و `flutter_secure_storage`.
- **Navigation:** محرك تنقل مخصص يدعم الانتقالات السلسة (`Transitions`) والتوجيه المنظم.
- **Media & Files:** `video_player`, `image_picker`, `file_picker`, `image_cropper`.

---

## 🚀 التشغيل والتثبيت (Getting Started)

### المتطلبات الأساسية:
- تثبيت [Flutter SDK](https://docs.flutter.dev/get-started/install) (الإصدار 3.24 أو أحدث).
- تثبيت [Android Studio](https://developer.android.com/studio) أو [VS Code].
- بيئة تشغيل Java JDK 17.

### خطوات التثبيت:

1. **استنساخ المستودع (Clone Repository):**
   ```bash
   git clone https://github.com/YourUsername/m_kemet.git
   cd m_kemet
   ```

2. **تنزيل الحزم والاعتماديات:**
   ```bash
   flutter pub get
   ```

3. **توليد ملفات التوطين والترجمة (Localization Generation):**
   ```bash
   flutter pub run intl_utils:generate
   ```

4. **تشغيل التطبيق في وضع التطوير (Debug Mode):**
   ```bash
   flutter run
   ```

5. **بناء نسخة APK نهائية:**
   ```bash
   flutter build apk --release
   ```

---

## 📱 لقطات من التطبيق (Screenshots)

> *يمكنك إضافة صور التطبيق هنا داخل مجلد `screenshots/` وعرضها بالتتابع:*

| شاشات الترحيب | اختيار نوع المستخدم | الملف الشخصي والمستندات | استعراض المرشحين |
|:---:|:---:|:---:|:---:|
| <img src="screenshots/onboarding.png" width="200"/> | <img src="screenshots/user_type.png" width="200"/> | <img src="screenshots/profile.png" width="200"/> | <img src="screenshots/company_home.png" width="200"/> |

---

## 📄 الترخيص (License)

هذا المشروع مطور ومملوك من قبل فريق عمل **Kemet**. جميع الحقوق محفوظة © 2026.
