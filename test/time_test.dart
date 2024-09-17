import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Time", () {
    setUp(bcTest.auth);

    test("readServerTime()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.timeService.readServerTime();

      debugPrint("Server Time: ${response.body?['data']['server_time']}");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("TimeUtilsTest", () async {
      var today = DateTime.now().toUtc();
      var tomorrow = today.add(Duration(days: 1));

      var _dateBefore = TimeUtil.utcDateTimeToUTCMillis(tomorrow);
      debugPrint("Date Before:  $_dateBefore");

      var _convertedDate = TimeUtil.utcMillisToUTCDateTime(_dateBefore);
      debugPrint("Converted: $_convertedDate");

      var _dateAfter = TimeUtil.utcDateTimeToUTCMillis(_convertedDate);
      debugPrint("Date After: $_dateAfter");

      expect(_dateBefore, _dateAfter);
    });
  });
}
