import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Test One Way Match", () {
    var streamId;

    test("startMatch()", () async {
      ServerResponse response = await bcTest.bcWrapper.oneWayMatchService
          .startMatch(otherPlayerId: userB.profileId!, rangeDelta: 1000);

      streamId = response.data?["playbackStreamId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("cancelMatch()", () async {
      ServerResponse response = await bcTest.bcWrapper.oneWayMatchService
          .cancelMatch(playbackStreamId: streamId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("startMatch()", () async {
      ServerResponse response = await bcTest.bcWrapper.oneWayMatchService
          .startMatch(otherPlayerId: userB.profileId!, rangeDelta: 1000);

      streamId = response.data?["playbackStreamId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("completeMatch()", () async {
      ServerResponse response = await bcTest.bcWrapper.oneWayMatchService
          .completeMatch(playbackStreamId: streamId);
      expect(response.statusCode, StatusCodes.ok);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
