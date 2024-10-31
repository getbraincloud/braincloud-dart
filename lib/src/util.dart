import 'package:flutter/foundation.dart';

class Util {
  static const String _defaultLang = "en";

  static getIsoCodeForCurrentLanguage() {
    return _defaultLang;
  }

  /// Method returns the fractional UTC offset in hours of the current timezone.
  ///
  /// returns The fractional UTC offset in hours
  static int getUTCOffsetForCurrentTimeZone() {
    int utcOffset = 0;
    try {
      utcOffset = DateTime.now().timeZoneOffset.inHours;
    } on Exception catch (_, e) {
      // what to do now?
      debugPrint(e.toString());
    }
    return utcOffset;
  }

  static String _usersLocale = "";

  /// Manually set the country code overriding the automatic value
  ///
  /// @param stringTwo letter ISO country code
  static void setCurrentCountryCode(String isoCode) {
    _usersLocale = isoCode;
  }

  /// Gets the current country code
  ///
  /// returns Two letter ISO country code
  static String getCurrentCountryCode() {
    return _usersLocale;
  }

  static bool isOptionalParameterValid(String? s) {
    return (s != null && s.isNotEmpty);
  }
}
