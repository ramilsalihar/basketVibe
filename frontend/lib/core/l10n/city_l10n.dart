import 'package:basketvibe/core/l10n/app_localizations.dart';

const _ruToEn = <String, String>{
  'Бишкек, Кыргызстан': 'Bishkek, Kyrgyzstan',
  'Алматы, Казахстан': 'Almaty, Kazakhstan',
  'Ташкент, Узбекистан': 'Tashkent, Uzbekistan',
};

const _enToRu = <String, String>{
  'Bishkek, Kyrgyzstan': 'Бишкек, Кыргызстан',
  'Almaty, Kazakhstan': 'Алматы, Казахстан',
  'Tashkent, Uzbekistan': 'Ташкент, Узбекистан',
};

extension CityL10n on AppLocalizations {
  String localizedCity(String city) {
    if (localeName == 'en') {
      return _ruToEn[city] ?? _enToRu.keys.firstWhere(
        (k) => k.toLowerCase() == city.toLowerCase(),
        orElse: () => city,
      );
    }
    if (localeName == 'ru') {
      return _enToRu[city] ?? _ruToEn.keys.firstWhere(
        (k) => k.toLowerCase() == city.toLowerCase(),
        orElse: () => city,
      );
    }
    return city;
  }
}
