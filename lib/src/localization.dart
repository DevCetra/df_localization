//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' show Locale;

import 'package:df_config/df_translate_src/translation_file_reader.dart' show TranslationFileReader;
import 'package:df_pod/df_pod.dart' show SharedPod;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class Localization {
  Localization._();

  void setReader(TranslationFileReader reader) {
    _reader = reader;
  }

  static var _reader = TranslationFileReader(
    fileReader: (filePath) {
      return rootBundle.loadString(
        filePath,
        cache: true,
      );
    },
  );

  static const _FALLBACK_LOCALE = Locale('en', 'US');
  static const _CACHE_KEY = '<Localization.pLocale>';

  static final pLocale = SharedPod<Locale, String>(
    _CACHE_KEY,
    fromValue: (localeString) {
      final locale = () {
        if (localeString == null || localeString.isEmpty) {
          return _FALLBACK_LOCALE;
        }
        final parts = localeString.split('-');
        if (parts.length == 1) {
          final languageCode = parts[0];
          return Locale(languageCode);
        } else {
          final languageCode = parts.sublist(0, parts.length - 1).join('-');
          final countryCode = parts.last;
          return Locale(languageCode, countryCode);
        }
      }();

      final languageTag = locale.toLanguageTag().toLowerCase();
      _reader.read(languageTag);
      return locale;
    },
    toValue: (locale) {
      if (locale == null) {
        return null;
      }

      final languageTag = locale.toLanguageTag().toLowerCase();
      _reader.read(languageTag);
      return languageTag;
    },
    initialValue: _FALLBACK_LOCALE,
  )..refresh();
}
