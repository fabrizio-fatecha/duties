import 'package:flutter/foundation.dart';

import '../localization/app_language.dart';
import '../localization/app_strings.dart';

class LocaleProvider extends ChangeNotifier {
  AppLanguage language = AppLanguage.en;

  AppStrings get strings => AppStrings.of(language);

  void toggle(AppLanguage value) {
    if (language == value) return;
    language = value;
    notifyListeners();
  }
}
