import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Test Playback Stream", () {
    var streamId;

    Future<String> createStream() async {
      ServerResponse response = await bcTest.bcWrapper.playbackStreamService
          .startStream(
              targetPlayerId: userB.profileId!, includeSharedData: true);

      streamId = response.data?["playbackStreamId"];

      return streamId;
    };

    test("startStream()", () async {
      ServerResponse response = await bcTest.bcWrapper.playbackStreamService
          .startStream(
              targetPlayerId: userB.profileId!, includeSharedData: true);

      streamId = response.data?["playbackStreamId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("addEvent()", () async {
      if (streamId == null) await createStream();

      ServerResponse response = await bcTest.bcWrapper.playbackStreamService
          .addEvent(
              playbackStreamId: streamId,
              eventData: {"data": 10},
              summary: {"summary": 10});
      expect(response.statusCode, StatusCodes.ok);
    });

    test("readStream()", () async {
      if (streamId == null) await createStream();

      ServerResponse response = await bcTest.bcWrapper.playbackStreamService
          .readStream(playbackStreamId: streamId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getRecentStreamsForInitiatingPlayer()", () async {
      ServerResponse response = await bcTest.bcWrapper.playbackStreamService
          .getRecentStreamsForInitiatingPlayer(maxNumStreams: 1);

      expect(response.statusCode, StatusCodes.ok);
      expect(response.data?['streams'], isA<List>());
    });

    test("getRecentStreamsForInitiatingPlayer(w/playerId)", () async {
      ServerResponse response = await bcTest.bcWrapper.playbackStreamService
          .getRecentStreamsForInitiatingPlayer(initiatingPlayerId:userB.profileId,maxNumStreams : 1);

      expect(response.statusCode, StatusCodes.ok);
      expect(response.data?['streams'], isA<List>());
    });

    test("getRecentStreamsForTargetPlayer()", () async {
      ServerResponse response = await bcTest.bcWrapper.playbackStreamService
          .getRecentStreamsForTargetPlayer(maxNumStreams: 1);
      expect(response.statusCode, StatusCodes.ok);      
      expect(response.data?['streams'], isA<List>());      
    });

    test("getRecentStreamsForTargetPlayer(w/playerId)", () async {
      ServerResponse response = await bcTest.bcWrapper.playbackStreamService
          .getRecentStreamsForTargetPlayer(targetPlayerId: userB.profileId,maxNumStreams: 1);
      expect(response.statusCode, StatusCodes.ok);      
      expect(response.data?['streams'], isA<List>());      
    });

    test("endStream()", () async {
      if (streamId == null) await createStream();
      ServerResponse response = await bcTest.bcWrapper.playbackStreamService
          .endStream(playbackStreamId: streamId);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("protectStreamUntil()", () async {
      if (streamId == null) await createStream();

      ServerResponse response = await bcTest.bcWrapper.playbackStreamService
          .protectStreamUntil(
              playbackStreamId: streamId!, numDays: 8);

      expect(response.statusCode, StatusCodes.ok);
      expect(response.data?['protectedUntil'], isA<String>());
    });


    test("deleteStream()", () async {
      if (streamId == null) await createStream();
      ServerResponse response = await bcTest.bcWrapper.playbackStreamService
          .deleteStream(playbackStreamId: streamId);
      expect(response.statusCode, StatusCodes.ok);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
