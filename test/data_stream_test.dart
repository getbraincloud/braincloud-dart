import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Data Stream", () {
    test("customPageEvent()", () async {
      ServerResponse response = await bcTest.bcWrapper.dataStreamService
          .customPageEvent(
              eventName: "testPage",
              jsonEventProperties: {"testProperty": "1"});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("customScreenEvent()", () async {
      ServerResponse response = await bcTest.bcWrapper.dataStreamService
          .customScreenEvent(
              eventName: "testScreen",
              jsonEventProperties: {"testProperty": "1"});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("customTrackEvent()", () async {
      ServerResponse response = await bcTest.bcWrapper.dataStreamService
          .customTrackEvent(
              eventName: "testTrack",
              jsonEventProperties: {"testProperty": "1"});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("submitCrashReport()", () async {
      ServerResponse response = await bcTest.bcWrapper.dataStreamService
          .submitCrashReport(
              crashType: "unknown",
              errorMsg: "ERRORS test",
              crashJson: {"dialog": "5"},
              crashLog: "func",
              userName: "testname",
              userEmail: "testemail",
              userNotes: "notessss",
              userSubmitted: false);

      expect(response.statusCode, StatusCodes.ok);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
