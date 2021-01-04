/*
 * @Description: 
 * @Author: CoolSnow (coolsnow2020@gmail.com)
 * @Date: 2020-09-08 18:31:33
 * @LastEditors: CoolSnow
 * @LastEditTime: 2020-09-10 11:58:39
 */
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'locale_util.dart';

///
/// For example:
///
/// import 'package:translation/i18n.dart';
///
/// I18n.of(context).text("app_name");
///
class I18n {
  I18n(Locale locale) {
    this.locale = locale;
    _localizedValues = null;
  }

  Locale locale;
  static Map<dynamic, dynamic> _localizedValues;
  static Map<dynamic, dynamic> _localizedValuesEn; // English map

  static I18n of(BuildContext context) {
    return Localizations.of<I18n>(context, I18n);
  }

  String text(String key) {
    try {
      String value = _localizedValues[key];
      if (value == null || value.isEmpty) {
        return englishText(key);
      } else {
        return value;
      }
    } catch (e) {
      return englishText(key);
    }
  }

  String englishText(String key) {
    return _localizedValuesEn[key] ?? '** $key not found';
  }

  static Future<I18n> load(Locale locale) async {
    I18n translations = new I18n(locale);
    String jsonContent =
        await rootBundle.loadString("locale/i18n_${locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);
    String enJsonContent = await rootBundle.loadString("locale/i18n_en.json");
    _localizedValuesEn = json.decode(enJsonContent);
    return translations;
  }

  get currentLanguage => locale.languageCode;
}

class I18nDelegate extends LocalizationsDelegate<I18n> {
  const I18nDelegate();

  // Support languages
  @override
  bool isSupported(Locale locale) {
    localeUtil.languageCode = locale.languageCode;
    return localeUtil.supportedLanguages.contains(locale.languageCode);
  }

  @override
  Future<I18n> load(Locale locale) => I18n.load(locale);

  @override
  bool shouldReload(I18nDelegate old) => true;
}

// Delegate strong init a Translations instance when language was changed
class SpecificLocalizationDelegate extends LocalizationsDelegate<I18n> {
  final Locale overriddenLocale;

  const SpecificLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => overriddenLocale != null;

  @override
  Future<I18n> load(Locale locale) => I18n.load(overriddenLocale);

  @override
  bool shouldReload(LocalizationsDelegate<I18n> old) => true;
}
