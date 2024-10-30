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

    // void onRelayConnected(String jsonResponse)
    void onRelayConnected(Map<String, dynamic> jsonResponse) {
      bcTest.bcWrapper.relayService.setPingInterval(2);
      String profileId = bcTest.bcWrapper.getStoredProfileId() ?? "";
      int myNetId =
          bcTest.bcWrapper.relayService.getNetIdForProfileId(profileId);
      Uint8List bytes = utf8.encode(testString);
      bcTest.bcWrapper.relayService.send(bytes, myNetId,
          inReliable: true,
          inOrdered: true,
          inChannel: BrainCloudRelay.channelHighPriority_1);
    }

    void onFailed(int status, int reasonCode, String jsonError) {
      if (jsonError ==
          "{\"status\":403,\"reason_code\":90300,\"status_message\":\"Invalid NetId: 40\",\"severity\":\"ERROR\"}") {
        // This one was on purpose
        successCount++;
        debugPrint("TST-> onFailed: ${"<".padLeft(successCount + 1, "✅")}");
        if (successCount == 4) readyCompleter.complete();
        return;
      } else {
        debugPrint("TST-> onFailed for other reason: $jsonError");
      }
      successCount = 0;
      if (!readyCompleter.isCompleted) readyCompleter.complete();
    }

    void systemCallback(String json) {
      Map<String, dynamic> parsedDict = jsonDecode(json);
      if (parsedDict["op"] == "CONNECT") {
        successCount++;
        debugPrint("TST-> systemCallback: ${"<".padLeft(successCount + 1, "✅")}");
        if (successCount >= 2) sendToWrongNetId();
        if (successCount == 3) readyCompleter.complete();
      }
    }

    void relayCallback(int netId, Uint8List data) {
      String message = utf8.decode(data);
      debugPrint("TST-> relayCallback:($netId)   $message");

      if (message == testString) {
        successCount++;
        bcTest.bcWrapper.relayService.sendToPlayers(
            inPlayerMask: BrainCloudRelay.toAllPlayers,
            inData: utf8.encode(testString2),
            inChannel: BrainCloudRelay.channelLowPriority);
      } else if (message == testString2) {
        successCount++;
        sendToWrongNetId();
        debugPrint("TST-> relayCallback: ${"<".padLeft(successCount + 1, "✅")}");
        if (successCount == 4) readyCompleter.complete();
      }
    }

    void connectToRelay() async {
      if (connectOptions != null) {
        bcTest.bcWrapper.relayService.registerSystemCallback(systemCallback);
        bcTest.bcWrapper.relayService.registerRelayCallback(relayCallback);
        bcTest.bcWrapper.relayService
            .connect(connectionType, connectOptions!, onRelayConnected, onFailed);
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

    /// ========================================================================================================
    /// Tests
    ///
    setUp(bcTest.setupBC);

    test("FullFlow TCP", () async {
      // Reset some values
      // bcTest.bcWrapper.rttService.disableRTT();
      successCount = 0;
      connectionType = RelayConnectionType.tcp;
      readyCompleter = Completer();
      bcTest.bcWrapper.brainCloudClient.enableLogging(true);
      bcTest.bcWrapper.rttService.registerRTTLobbyCallback(onLobbyEvent);

      RTTCommandResponse response = await bcTest.bcWrapper.rttService
          .enableRTT(connectiontype: RTTConnectionType.websocket);
      expect(response.data?['operation'], 'CONNECT');
      onRTTEnabled(response);

      await readyCompleter.future.timeout(Duration(seconds: 90), onTimeout: () {
        fail("Relay TCP test timed out");
      });

      expect(successCount, 4);

      // if (bcTest.bcWrapper.relayService.getPing() >= 999)
      //   await Future.delayed(Duration(seconds: 3));
      // expect(bcTest.bcWrapper.relayService.getPing(), lessThan(999));
    }, timeout: Timeout.parse("120s"));

    test("FullFlow UDP", () async {
      // Reset some values
      // bcTest.bcWrapper.rttService.disableRTT();
      successCount = 0;
      connectionType = RelayConnectionType.udp;
      // Use a future to wait for callbacks to complete.
      readyCompleter = Completer();
      bcTest.bcWrapper.rttService.registerRTTLobbyCallback(onLobbyEvent);
      RTTCommandResponse response = await bcTest.bcWrapper.rttService
          .enableRTT(connectiontype: RTTConnectionType.websocket);
      expect(response.data?['operation'], 'CONNECT');
      onRTTEnabled(response);
      await readyCompleter.future.timeout(Duration(seconds: 90), onTimeout: () {
        fail("Relay TCP test timed out");
      });
      expect(successCount, 4);

      if (bcTest.bcWrapper.relayService.getPing() >= 999)
        await Future.delayed(Duration(seconds: 3));
      expect(bcTest.bcWrapper.relayService.getPing(), lessThan(999));
    }, timeout: Timeout.parse("90s"));

    test("FullFlow WebSocket", () async {
      // Reset some values
      // bcTest.bcWrapper.rttService.disableRTT();
      successCount = 0;
      connectionType = RelayConnectionType.websocket;
      if (readyCompleter.isCompleted) readyCompleter = Completer();

      bcTest.bcWrapper.rttService.registerRTTLobbyCallback(onLobbyEvent);
      RTTCommandResponse response = await bcTest.bcWrapper.rttService
          .enableRTT(connectiontype: RTTConnectionType.websocket);
      expect(response.data?['operation'], 'CONNECT');

      onRTTEnabled(response);

      await readyCompleter.future.timeout(Duration(seconds: 90), onTimeout: () {
        fail("Relay TCP test timed out");
      });

      expect(successCount, 4);

      if (bcTest.bcWrapper.relayService.getPing() >= 999)
        await Future.delayed(Duration(seconds: 3));
      expect(bcTest.bcWrapper.relayService.getPing(), lessThan(999));
    }, timeout: Timeout.parse("90s"));

    tearDown(() {
      // in case one test fails ensure it does not impact others
      bcTest.bcWrapper.relayService.disconnect();
      bcTest.bcWrapper.relayService.deregisterRelayCallback();
      bcTest.bcWrapper.relayService.deregisterSystemCallback();
    });

    tearDownAll(() {
      bcTest.bcWrapper.brainCloudClient.enableLogging(false);
    });
  });
}
