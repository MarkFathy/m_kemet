class Validators {
  static String? validateEmpty(String? value, {String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? 'LocaleKeys.fillField';
    }
    return null;
  }

  static String? validateName(
    String? value, {
    String? message,
    String? emptyMessage,
    String? minLengthMessage,
  }) {
    if (value?.trim().isEmpty ?? true) {
      return emptyMessage ?? message ?? 'LocaleKeys.fillField';
    } else if (value!.trim().length < 2) {
      return minLengthMessage ?? message ?? 'LocaleKeys.nameValidation';
    }
    return null;
  }

  static String? validateNote(String? value, {String? message}) {
    if (value?.trim().isEmpty ?? true) {
      return message ?? 'LocaleKeys.fillField';
    } else if (value!.length < 10) {
      return message ?? 'LocaleKeys.noteValidation';
    }
    return null;
  }

  static String? validatePassword(
    String? value, {
    int minLength = 8,
    String? emptyMessage,
    String? minLengthMessage,
    String? mixedCaseMessage,
    String? symbolMessage,
    bool requireMixedCase = false,
    bool requireSpecialChar = false,
  }) {
    if (value == null || value.trim().isEmpty) {
      return emptyMessage ?? 'Password is required';
    }
    if (value.length < minLength) {
      return minLengthMessage ?? 'Password must be at least $minLength characters';
    }
    if (requireMixedCase) {
      final hasUpper = RegExp(r'[A-Z]').hasMatch(value);
      final hasLower = RegExp(r'[a-z]').hasMatch(value);
      if (!hasUpper || !hasLower) {
        return mixedCaseMessage ?? 'يجب أن تحتوي كلمة المرور على حرف كبير وحرف صغير على الأقل.';
      }
    }
    if (requireSpecialChar) {
      final hasSymbol = RegExp(r'[!@#$%^&*(),.?":{}|<>\-_+=\[\]\\\/~`؛،؟]').hasMatch(value);
      if (!hasSymbol) {
        return symbolMessage ?? 'يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل.';
      }
    }
    return null;
  }

  static String? validateEmail(
    String? value, {
    String? emptyMessage,
    String? invalidMessage,
  }) {
    final val = value?.trim();
    if (val == null || val.isEmpty) {
      return emptyMessage ?? 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(val)) {
      return invalidMessage ?? 'Please enter a valid email address';
    }
    return null;
  }

  static String? validateEmailOrNull(String? value, {String? message}) {
    if (value?.trim().isNotEmpty ?? true) {
      if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.["
        'a-zA-Z]+',
      ).hasMatch(value!)) {
        return message ?? 'LocaleKeys.mailValidation';
      }
    }
    return null;
  }

  static String? validatePhone(
    String? value, {
    String? emptyMessage,
    String? invalidMessage,
  }) {
    final val = value?.trim();
    if (val == null || val.isEmpty) {
      return emptyMessage ?? 'Please enter phone number';
    }
    if (val.length < 8 || !RegExp(r'^[+]*[(]?[0-9]{1,4}[)]?[-\s./0-9]*$').hasMatch(val)) {
      return invalidMessage ?? 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validatePhoneOrNull(String? value, {String? message}) {
    if (value!.trim().isNotEmpty) {
      if (!RegExp(r'^(?:\0)?(?:50|52|54|55|56|58)\d{7}$').hasMatch(value)) {
        return message ?? 'LocaleKeys.phoneValidation';
      }
    }
    return null;
  }

  static String? validatePasswordConfirm(
    String? value,
    String? pass, {
    String? emptyMessage,
    String? mismatchMessage,
    String? message,
  }) {
    if (value?.trim().isEmpty ?? true) {
      return emptyMessage ?? message ?? 'LocaleKeys.fillField';
    } else if (value != pass) {
      return mismatchMessage ?? message ?? 'LocaleKeys.confirmValidation';
    }
    return null;
  }

  static String? validateDropDown<T>(T? value, {String? message}) {
    if (value == null) {
      return message ?? 'LocaleKeys.fillField';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    final regex = RegExp(
      r'^https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,}$',
    );

    if (!regex.hasMatch(value!)) {
      return 'LocaleKeys.validatorUrl';
    } else {
      return null;
    }
  }
}
