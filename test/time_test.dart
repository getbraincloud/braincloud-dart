import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:braincloud_dart/memory_persistence.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Time", () {
    test("readServerTime()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.timeService.readServerTime();

      print("Server Time: ${response.data?['server_time']}");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("readServerTime() error", () async {
      BrainCloudWrapper bcWrapper = BrainCloudWrapper(persistence: DataPersistence());

      bcWrapper.init(secretKey: bcTest.ids.secretKey, appId: bcTest.ids.appId, version: bcTest.ids.version, updateTick: 50);

      ServerResponse response =
          await bcWrapper.timeService.readServerTime();

      print("Server Time: ${response.data?['server_time']}");
      expect(response.statusCode, StatusCodes.forbidden);

      bcWrapper.onDestroy();
    });

    test("TimeUtilsTest", () async {
      var today = DateTime.now().toUtc();
      var tomorrow = today.add(Duration(days: 1));

      var _dateBefore = TimeUtil.utcDateTimeToUTCMillis(tomorrow);
      print("Date Before:  $_dateBefore");

      var _convertedDate = TimeUtil.utcMillisToUTCDateTime(_dateBefore);
      print("Converted: $_convertedDate");

      var _dateAfter = TimeUtil.utcDateTimeToUTCMillis(_convertedDate);
      print("Date After: $_dateAfter");

      expect(_dateBefore, _dateAfter);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
