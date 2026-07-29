import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'app_title': 'ADYUTA Health',
      'vitals': 'Vitals',
      'triage': 'Triage',
      'child': 'Child',
      'anc': 'ANC',
      'check_symptoms': 'Check my symptoms',
    },
    'hi': {
      'app_title': 'अच्युत स्वास्थ्य',
      'vitals': 'महत्वपूर्ण संकेत',
      'triage': 'निदान',
      'child': 'बच्चा',
      'anc': 'प्रसव पूर्व',
      'check_symptoms': 'मेरे लक्षणों की जांच करें',
    },
    'kn': {
      'app_title': 'ಅಚ್ಯುತ ಆರೋಗ್ಯ',
      'vitals': 'ಜೀವನಾಧಾರಗಳು',
      'triage': 'ಚಿಕಿತ್ಸೆ',
      'child': 'ಮಗು',
      'anc': 'ಗರ್ಭಿಣಿ',
      'check_symptoms': 'ನನ್ನ ರೋಗಲಕ್ಷಣಗಳನ್ನು ಪರಿಶೀಲಿಸಿ',
    },
  };

  String get translate {
    return _localizedValues[locale.languageCode]!['app_title']!;
  }

  String translateKey(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']![key]!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi', 'kn'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
