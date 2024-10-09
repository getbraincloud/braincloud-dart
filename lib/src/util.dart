import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class Util {
  static final DateTime _unixEpoch = DateTime(1970, 1, 1, 0, 0, 0).toUtc();

  static DateTime bcTimeToDateTime(int millis) {
    return _unixEpoch.add(Duration(milliseconds: millis));
  }

  static double dateTimeToBcTimestamp(DateTime dateTime) {
    return dateTime.toUtc().millisecondsSinceEpoch.toDouble();
  }

  static const String _defaultLang = "en";

  static getIsoCodeForCurrentLanguage() {
    return _defaultLang;
  }

  /// Method returns the fractional UTC offset in hours of the current timezone.

  /// @returns The fractional UTC offset in hours
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

  /// @param stringTwo letter ISO country code
  static void setCurrentCountryCode(String isoCode) {
    _usersLocale = isoCode;
  }

  /// Gets the current country code

  /// @returns Two letter ISO country code
  static String getCurrentCountryCode() {
    return _usersLocale;
  }

  static bool isOptionalParameterValid(String? s) {
    return (s != null && s.isNotEmpty);
  }

  static int dateTimeToUnixTimestamp(DateTime dateTime) {
    return dateTime.toUtc().millisecondsSinceEpoch;
  }

  int toInt64(Uint8List byteArray, int index) {
    ByteBuffer buffer = byteArray.buffer;
    ByteData data = ByteData.view(buffer);
    int short = data.getInt64(index);
    return short;
  }
}
