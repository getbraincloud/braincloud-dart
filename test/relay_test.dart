// @TestOn('!browser')
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  group("Test Relay", () {
    int successCount = 0;
    int failureCount = 0;

    RelayConnectionType connectionType = RelayConnectionType.invalid;
    RelayConnectOptions? connectOptions;
    Completer readyCompleter = Completer();
    final String testHelloString = "Hello World!";
    final String testWelcomeString = "Welcome aboard";
    int currentNetId = 0;

    /// ========================================================================================================
    /// Helper functions for Tests
    ///
    Future disconnectRelay() async {
      bcTest.bcWrapper.relayService.endMatch({});
      bcTest.bcWrapper.relayService.disconnect();
      bcTest.bcWrapper.rttService.disableRTT();
      // Allow time for the connection to close.
      await Future.delayed(Duration(seconds: 1));
    }

    void sendToWrongNetId() {
      int myNetId = BrainCloudRelay
          .maxPlayers; // Wrong net id, should be < 40 or ALL_PLAYERS (0x000000FFFFFFFFFF)
      Uint8List bytes = utf8.encode("To Bad Id");
      bcTest.bcWrapper.relayService.send(bytes, myNetId,
          reliable: true,
          ordered: true,
          channel: BrainCloudRelay.channelHighPriority_1);
    }

    void onRelayConnected(Map<String, dynamic> jsonResponse) {
      bcTest.bcWrapper.relayService.setPingInterval(2);
      String profileId = bcTest.bcWrapper.getStoredProfileId();
      currentNetId =
          bcTest.bcWrapper.relayService.getNetIdForProfileId(profileId);

      Uint8List bytes = utf8.encode(testHelloString);
      bcTest.bcWrapper.relayService.send(bytes, currentNetId,
          reliable: true,
          ordered: true,
          channel: BrainCloudRelay.channelHighPriority_1);
    }

    void onFailed(int status, int reasonCode, dynamic jsonError) async {
      dynamic errorMap =
          (jsonError is String) ? json.decode(jsonError) : jsonError;
      if (errorMap['status'] == 403 &&
          errorMap['reason_code'] == 90300 &&
          errorMap['status_message'] == "Invalid NetId: 40") {
        // This one was on purpose
        successCount++;
      } else {
        print("${DateTime.now()}:TST-> onFailed for other reason: $jsonError");
        var errorMap = jsonError;
        if (errorMap['reason_code'] == 90300 &&
            errorMap['status_message'] == 'Relay: Disconnected by server')
          failureCount++;
        disconnectRelay();
        await Future.delayed(
            Duration(seconds: 2)); // let the connection be fully closed
      }
      // We should only get an error on the last action of Invalid Net Id, so mark test as complete either way
      if (!readyCompleter.isCompleted) readyCompleter.complete();
    }

    void systemCallback(Map<String, dynamic>? json) async {
      // Map<String, dynamic> parsedDict = jsonDecode(json);
      Map<String, dynamic> parsedDict = json ?? {};
      if (parsedDict["op"] == "CONNECT") {
        successCount++;
        print(
            "${DateTime.now()}:TST-> systemCallback: ${"<".padLeft(successCount + 1, "✅")}");
      } else {
        print(">>>> Received an un-expected message $json");
        disconnectRelay();
        await Future.delayed(
            Duration(seconds: 2)); // let the connection be fully closed
      }
    }

    void relayCallback(int netId, Uint8List data) {
      String message = utf8.decode(data);
      print("${DateTime.now()}:TST-> relayCallback:($netId)   $message");
      String profileId = bcTest.bcWrapper.getStoredProfileId();
      currentNetId =
          bcTest.bcWrapper.relayService.getNetIdForProfileId(profileId);

      if (message == testHelloString && netId == currentNetId) {
        successCount++;
        bcTest.bcWrapper.relayService.sendToPlayers(
            playerMask: BrainCloudRelay.toAllPlayers,
            data: utf8.encode(testWelcomeString),
            channel: BrainCloudRelay.channelLowPriority);
      } else if (message == testWelcomeString) {
        successCount++;
        if (successCount >= 2) sendToWrongNetId();
        print(
            "${DateTime.now()}:TST-> relayCallback: ${"<".padLeft(successCount + 1, "✅")}");
      }
      if (successCount == 4) readyCompleter.complete();
    }

    // Will send a bad Ack once the first msg as been received
    void badRelayCallback(int netId, Uint8List data) {
      String message = utf8.decode(data);
      print("${DateTime.now()}:TST-> badRelayCallback:($netId)   $message");
      String profileId = bcTest.bcWrapper.getStoredProfileId();
      currentNetId =
          bcTest.bcWrapper.relayService.getNetIdForProfileId(profileId);

      if (message == testHelloString && netId == currentNetId) {
        successCount++;
        // This is a bad Ack
        bcTest.bcWrapper.brainCloudClient.rsComms.rawSend(
            Uint8List.fromList([3, 192, 0, 128, 0, 0, 2, 2, 2, 72, 101, 108]));
        if (successCount == 4) readyCompleter.complete();
      }
    }

    void connectToRelay({Function(int netId, Uint8List data)? rcb}) async {
      if (connectOptions != null) {
        bcTest.bcWrapper.relayService.registerSystemCallback(systemCallback);
        bcTest.bcWrapper.relayService
            .registerRelayCallback(rcb ?? relayCallback);
        bcTest.bcWrapper.relayService.connect(
            connectionType, connectOptions!, onRelayConnected, onFailed);
      }
    }

    void onRTTEnabled(RTTCommandResponse data) {
      Map<String, dynamic> algo = {};
      algo["strategy"] = "ranged-absolute";
      algo["alignment"] = "center";
      List<int> ranges = [];
      ranges.add(1000);
      algo["ranges"] = ranges;

      bcTest.bcWrapper.lobbyService.findOrCreateLobby(
          roomType: "READY_START_V2",
          rating: 0,
          maxSteps: 1,
          algo: algo,
          isReady: true,
          extraJson: {},
          settings: {});
    }

    onLobbyEvent({Function(int netId, Uint8List data)? rcb}) =>
        (RTTCommandResponse json) {
          // var response = jsonDecode(json);
          // var response = json ?? {};
          var data = json.data ?? {};

          switch (json.operation) {
            case "DISBANDED":
              var reason = data["reason"];
              var reasonCode = reason["code"];
              if (reasonCode == ReasonCodes.rttRoomReady)
                connectToRelay(rcb: rcb);
              else
                onFailed(0, 0, "DISBANDED != RTT_ROOM_READY");
              break;

            // ROOM_READY contains information on how to connect to the relay server.
            case "ROOM_READY":
              var connectData = data["connectData"];
              var ports = connectData["ports"];

              int port = 0;
              if (connectionType == RelayConnectionType.websocket) {
                port = ports["ws"];
              } else if (connectionType == RelayConnectionType.tcp) {
                port = ports["tcp"];
              } else if (connectionType == RelayConnectionType.udp) {
                port = ports["udp"];
              }

              connectOptions = RelayConnectOptions(
                  false,
                  connectData["address"],
                  port,
                  data["passcode"],
                  data["lobbyId"]);

              break;
          }
        };

    Future fullFlow(RelayConnectionType type,
        {bool shouldDisconnect = true,
        Function(int netId, Uint8List data)? rcb}) async {
      // Use a future to wait for callbacks to complete.
      readyCompleter = Completer();
      successCount = 0;
      failureCount = 0;
      connectionType = type; //

      expect(bcTest.bcWrapper.rttService.isRTTEnabled(), false,
          reason: "RTT should be disabled");

      bcTest.bcWrapper.brainCloudClient.enableLogging(true);
      bcTest.bcWrapper.rttService
          .registerRTTLobbyCallback(onLobbyEvent(rcb: rcb));

      final Completer completer = Completer();
      bcTest.bcWrapper.rttService.enableRTT(successCallback: (response) {
        print(
            "${DateTime.now()}:TST-> rttService.enableRTT returned $response");
        expect(response.data?['operation'], 'CONNECT');
        onRTTEnabled(response);
        completer.complete();
      }, failureCallback: (error) {
        print(
            "${DateTime.now()}:TST-> rttService.enableRTT for $type returned ERROR $error");
        // fail("Got an error trying to Enable  $type RTT");
      });

      await completer.future;

      // Put a time limit on this Future completer so we do not wait forever.
      await readyCompleter.future.timeout(Duration(seconds: 90), onTimeout: () {
        print("${DateTime.now()}:TST-> Failing $type Test due to 90 timeout");
        fail("Relay $type test timed out");
      });

      print("${DateTime.now()}:TST-> $type Test almost completed");

      if (bcTest.bcWrapper.relayService.getPing() >= 999)
        await Future.delayed(Duration(seconds: 3));
      expect(bcTest.bcWrapper.relayService.getPing(), lessThan(999));

      if (shouldDisconnect) {
        await disconnectRelay();
      }
      print("${DateTime.now()}:TST-> $type Test completely done.");
    }

    /// ========================================================================================================
    /// Tests
    ///
    setUpAll(bcTest.setupBC);

   test("Mask encoding", () async {
    int mask = (1 << 0);  // player 1
    mask = mask + (1 << 5);    // player 6
    mask = mask + (1 << 12);    // player 13
    mask = mask +  (1 << 31);    // player 32
    mask = mask +  (1 << 34);    // player 35
    mask = mask +  (1 << 39);    // player 40

    // int mask = 1135245755678720;

print(" mask is $mask");

    List<int> bytes = bcTest.bcWrapper.brainCloudClient.rsComms.splitToBytes40(mask);
print(" converted bytes is $bytes");
    
    int reloadedMask = bcTest.bcWrapper.brainCloudClient.rsComms.bytesToInt40(bytes);
print(" converted bytes is $reloadedMask");

    expect(reloadedMask, mask, reason: "Mask conversion fails");


    // },onPlatform: {
    //   '!browser': [Skip('Only Browser supported, skipping')]
    });


    test("FullFlow TCP", () async {
      if (bcTest.bcWrapper.rttService.isRTTEnabled())  await disconnectRelay();
      
      await fullFlow(RelayConnectionType.tcp);

      expect(successCount, 4);
      expect(failureCount, 0);
    }, timeout: Timeout.parse("120s"), onPlatform: {
      'browser': [Skip('Browser does not support Relay TCP connection, skipping')]
    });

    // Purposefully set this in the middle of other test to ensure proper cleanup
    test("Invalid ACK", () async {
      if (bcTest.bcWrapper.rttService.isRTTEnabled())  await disconnectRelay();

      await fullFlow(RelayConnectionType.udp, rcb: badRelayCallback);

      expect(successCount, 2);
      expect(failureCount, 1);
    }, timeout: Timeout.parse("90s"),onPlatform: {
      'browser': [Skip('Browser does not support Relay UDP connection, skipping')]
    });

    test("FullFlow UDP", () async {
      if (bcTest.bcWrapper.rttService.isRTTEnabled())  await disconnectRelay();

      await fullFlow(RelayConnectionType.udp);

      expect(successCount, 4);
      expect(failureCount, 0);
    }, timeout: Timeout.parse("90s"),onPlatform: {
      'browser': [Skip('Browser does not support Relay UDP connection, skipping')]
    });

    test("FullFlow WebSocket", () async {
      if (bcTest.bcWrapper.rttService.isRTTEnabled())  await disconnectRelay();

      // do not disconnect in the fullFlow as we want to test other cmds while the connection is still alive
      await fullFlow(RelayConnectionType.websocket, shouldDisconnect: false);

      expect(successCount, 4);
      expect(failureCount, 0);

      // Exercise some of the other api while we have it ready.
      expect(bcTest.bcWrapper.relayService.getProfileIdForNetId(0),
          userA.profileId,
          reason: "Wrong owner profileId for netId 0");
      expect(bcTest.bcWrapper.relayService.getOwnerProfileId(), userA.profileId,
          reason: "Wrong owner profileId");
      expect(bcTest.bcWrapper.relayService.ownerProfileId, userA.profileId,
          reason: "Wrong owner profileId");
      expect(bcTest.bcWrapper.relayService.getOwnerCxId(),
          bcTest.bcWrapper.relayService.ownerCxId,
          reason: "Wrong ownerCXid");
      expect(bcTest.bcWrapper.relayService.getCxIdForNetId(0),
          bcTest.bcWrapper.relayService.ownerCxId,
          reason: "Wrong ownerCXid");
      expect(bcTest.bcWrapper.relayService.isConnected(), true,
          reason: "Relay should still be connected");
      expect(
          bcTest.bcWrapper.relayService
              .getNetIdForCxId(bcTest.bcWrapper.relayService.ownerCxId),
          0,
          reason: "NetId should be 0");

      // only exercise code, no check as this is not echoed back.
      bcTest.bcWrapper.relayService
          .sendToAll(data: utf8.encode(testWelcomeString));

      expect(connectOptions.toString(), startsWith("RelayConnectOptions"));

      // since we did not let the FullFlow disconnect do it now.
      bcTest.bcWrapper.relayService.endMatch({});
      bcTest.bcWrapper.relayService.disconnect();
      bcTest.bcWrapper.rttService.disableRTT();

      print("${DateTime.now()}:TST-> TCP Websocket completely done.");
    }, timeout: Timeout.parse("90s"));

    tearDownAll(() {
      bcTest.bcWrapper.relayService.disconnect();
      bcTest.bcWrapper.relayService.deregisterRelayCallback();
      bcTest.bcWrapper.relayService.deregisterSystemCallback();
      bcTest.bcWrapper.brainCloudClient.enableLogging(false);
    });
  });
}
