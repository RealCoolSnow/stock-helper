/*
 * @Description: 
 * @Author: CoolSnow (coolsnow2020@gmail.com)
 * @Date: 2020-09-08 18:29:15
 * @LastEditors: CoolSnow
 * @LastEditTime: 2020-09-10 11:58:42
 */
import 'package:flutter/material.dart';

typedef void LocaleChangeCallback(Locale locale);

class LocaleUtil {
  /// Support languages list
  final List<String> supportedLanguages = [/*'en',*/ 'zh'];

  /// Support Locales list
  Iterable<Locale> supportedLocales() =>
      supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));

  /// Callback for manual locale changed
  LocaleChangeCallback onLocaleChanged;

  Locale locale;
  String languageCode;

  static final LocaleUtil _localeUtil = new LocaleUtil._internal();

  factory LocaleUtil() {
    return _localeUtil;
  }

  LocaleUtil._internal();

  /// current language
  String getLanguageCode() {
    if (languageCode == null) {
      return "zh";
    }
    return languageCode;
  }
}

LocaleUtil localeUtil = new LocaleUtil();
