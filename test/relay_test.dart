import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:braincloud_dart/src/braincloud_relay.dart';
import 'package:braincloud_dart/src/internal/relay_comms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  group("Test Relay", () {
    int successCount = 0;
    RelayConnectionType connectionType = RelayConnectionType.invalid;
    RelayConnectOptions? connectOptions;
    Completer readyCompleter = Completer();
    final String testString = "Hello World!";
    final String testString2 = "Welcome aboard";
    int currentNetId = 0;

    /// ========================================================================================================
    /// Helper functions for Tests
    ///

    void sendToWrongNetId() {
      int myNetId = BrainCloudRelay
          .maxPlayers; // Wrong net id, should be < 40 or ALL_PLAYERS (0x000000FFFFFFFFFF)
      Uint8List bytes = utf8.encode("To Bad Id");
      bcTest.bcWrapper.relayService.send(bytes, myNetId,
          inReliable: true,
          inOrdered: true,
          inChannel: BrainCloudRelay.channelHighPriority_1);
    }

    void onRelayConnected(Map<String, dynamic> jsonResponse) {
      bcTest.bcWrapper.relayService.setPingInterval(2);
      String profileId = bcTest.bcWrapper.getStoredProfileId() ?? "";
      currentNetId =
          bcTest.bcWrapper.relayService.getNetIdForProfileId(profileId);

      Uint8List bytes = utf8.encode(testString);
      bcTest.bcWrapper.relayService.send(bytes, currentNetId,
          inReliable: true,
          inOrdered: true,
          inChannel: BrainCloudRelay.channelHighPriority_1);
    }

    void onFailed(int status, int reasonCode, String jsonError) {
      dynamic errorMap = json.decode(jsonError);
      if (errorMap['status'] == 403 &&
          errorMap['reason_code'] == 90300 &&
          errorMap['status_message'] == "Invalid NetId: 40") {
        // This one was on purpose
        successCount++;
      } else {
        debugPrint(
            "${DateTime.now()}:TST-> onFailed for other reason: $jsonError");
      }
      // We should only get an error on the last action of Invalid Net Id, so mark test as complete either way
      if (!readyCompleter.isCompleted) readyCompleter.complete();
    }

    void systemCallback(String json) {
      Map<String, dynamic> parsedDict = jsonDecode(json);
      if (parsedDict["op"] == "CONNECT") {
        successCount++;
        debugPrint(
            "${DateTime.now()}:TST-> systemCallback: ${"<".padLeft(successCount + 1, "✅")}");
      }
    }

    void relayCallback(int netId, Uint8List data) {
      String message = utf8.decode(data);
      debugPrint("${DateTime.now()}:TST-> relayCallback:($netId)   $message");

      if (message == testString) {
        successCount++;
        bcTest.bcWrapper.relayService.sendToPlayers(
            inPlayerMask: BrainCloudRelay.toAllPlayers,
            inData: utf8.encode(testString2),
            inChannel: BrainCloudRelay.channelLowPriority);
      } else if (message == testString2) {
        successCount++;
        if (successCount >= 2) sendToWrongNetId();
        debugPrint(
            "${DateTime.now()}:TST-> relayCallback: ${"<".padLeft(successCount + 1, "✅")}");
      }
      if (successCount == 4) readyCompleter.complete();
    }

    void connectToRelay() async {
      if (connectOptions != null) {
        bcTest.bcWrapper.relayService.registerSystemCallback(systemCallback);
        bcTest.bcWrapper.relayService.registerRelayCallback(relayCallback);
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

    void onLobbyEvent(String json) {
      var response = jsonDecode(json);
      var data = response["data"];

      switch (response["operation"]) {
        case "DISBANDED":
          var reason = data["reason"];
          var reasonCode = reason["code"];
          if (reasonCode == ReasonCodes.rttRoomReady)
            connectToRelay();
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

          connectOptions = RelayConnectOptions(false, connectData["address"],
              port, data["passcode"], data["lobbyId"]);

          break;
      }
    }

    Future fullFlow(RelayConnectionType type,
        {bool shouldDisconnect = true}) async {
      // Use a future to wait for callbacks to complete.
      readyCompleter = Completer();
      successCount = 0;
      connectionType = type; //

      expect(bcTest.bcWrapper.rttService.isRTTEnabled(), false,
          reason: "RTT should be disabled");

      bcTest.bcWrapper.brainCloudClient.enableLogging(true);
      bcTest.bcWrapper.rttService.registerRTTLobbyCallback(onLobbyEvent);

      final Completer completer = Completer();      
      bcTest.bcWrapper.rttService.enableRTT(successCallback: (response ) {
        debugPrint(
            "${DateTime.now()}:TST-> rttService.enableRTT returned $response");
          expect(response.data?['operation'], 'CONNECT');
          onRTTEnabled(response);
          completer.complete();
      }
      ,failureCallback: (error) {
        debugPrint(
            "${DateTime.now()}:TST-> rttService.enableRTT returned ERROR $error");
            fail("Got an error trying to Enable RTT");
      });

      await completer.future;

      // Put a time limit on this Future completer so we do not wait forever.
      await readyCompleter.future.timeout(Duration(seconds: 90), onTimeout: () {
        debugPrint(
            "${DateTime.now()}:TST-> Failing $type Test due to 90 timeout");
        fail("Relay $type test timed out");
      });

      debugPrint("${DateTime.now()}:TST-> $type Test almost completed");

      expect(successCount, 4);

      if (bcTest.bcWrapper.relayService.getPing() >= 999)
        await Future.delayed(Duration(seconds: 3));
      expect(bcTest.bcWrapper.relayService.getPing(), lessThan(999));

      if (shouldDisconnect) {
        bcTest.bcWrapper.relayService.endMatch({});
        bcTest.bcWrapper.relayService.disconnect();
        bcTest.bcWrapper.rttService.disableRTT();
      }
      debugPrint("${DateTime.now()}:TST-> $type Test completely done.");
    }

    /// ========================================================================================================
    /// Tests
    ///
    setUpAll(bcTest.setupBC);

    test("FullFlow TCP", () async {
      await fullFlow(RelayConnectionType.tcp);
    }, timeout: Timeout.parse("120s"));

    test("FullFlow UDP", () async {
      await fullFlow(RelayConnectionType.udp);
    }, timeout: Timeout.parse("90s"));

    test("FullFlow WebSocket", () async {
      // do not disconnect in the fullFlow as we want to test other cmds while the connection is still alive
      await fullFlow(RelayConnectionType.websocket, shouldDisconnect: false);

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
      bcTest.bcWrapper.relayService.sendToAll(inData: utf8.encode(testString2));

      expect(connectOptions.toString(), startsWith("RelayConnectOptions"));

      // since we did not let the FullFlow disconnect do it now.
      bcTest.bcWrapper.relayService.endMatch({});
      bcTest.bcWrapper.relayService.disconnect();
      bcTest.bcWrapper.rttService.disableRTT();

      debugPrint("${DateTime.now()}:TST-> TCP Websocket completely done.");
    }, timeout: Timeout.parse("90s"));

    tearDownAll(() {
      bcTest.bcWrapper.relayService.disconnect();
      bcTest.bcWrapper.relayService.deregisterRelayCallback();
      bcTest.bcWrapper.relayService.deregisterSystemCallback();
      bcTest.bcWrapper.brainCloudClient.enableLogging(false);
    });
  });
}
