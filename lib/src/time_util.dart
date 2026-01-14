// Copyright 2026 bitHeads, Inc. All Rights Reserved.
class TimeUtil {
  static int utcDateTimeToUTCMillis(DateTime utcDate) {
    return utcDate.toUtc().millisecond; // return the utc milliseconds
  }

  static DateTime utcMillisToUTCDateTime(int utcMillis) {
    return DateTime.fromMillisecondsSinceEpoch(utcMillis, isUtc: true);
  }
}
