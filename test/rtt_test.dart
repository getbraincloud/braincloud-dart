import 'dart:async';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/v4.dart';
import 'stored_ids.dart';

main() {
  SharedPreferences.setMockInitialValues({});
  debugPrint('Braindcloud Dart Client unit tests');
  final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterTest");
  String email = "";
  String password = "";

  setUpAll(() async {
    // });
    // test("Init", () async {
    StoredIds ids = StoredIds('test/ids.txt');
    await ids.load();

    email = ids.email.isEmpty
        ? "${const UuidV4().generate()}@DartUnitTester"
        : ids.email;
    password = ids.password.isEmpty ? const UuidV4().generate() : ids.password;

    debugPrint('email: ${ids.email} in appId: ${ids.appId} at ${ids.url}');
    //start test

    bcWrapper
        .init(
            secretKey: ids.secretKey,
            appId: ids.appId,
            version: ids.version,
            url: ids.url)
        .then((_) {
      // expect(bcWrapper.isInitialized, false);

      bool hadSession = bcWrapper.getStoredSessionId().isNotEmpty;

      if (hadSession) {
        bcWrapper.restoreSession();
      }

      int packetId = bcWrapper.getStoredPacketId();
      if (packetId > BrainCloudComms.noPacketExpected) {
        bcWrapper.restorePacketId();
      }

      Timer.periodic(const Duration(milliseconds: 100), (timer) {
        bcWrapper.update();
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });
  });

  group("Test RTT", () {
    setUp(() async {
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcWrapper.authenticateUniversal(
            username: email, password: password, forceCreate: false);
      }
    });

    test("enableRTT", () async {
      bcWrapper.rTTService.disableRTT();

      ServerResponse? response = await bcWrapper.rTTService
          .enableRTT(connectiontype: RTTConnectionType.websocket);

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
        expect(response.body?['operation'], 'CONNECT');
      }
    });

    String channelId = "";

    test("getChannelId", () async {
      ServerResponse? response = await bcWrapper.chatService
          .getChannelId(channeltype: "gl", channelsubid: "valid");

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
        channelId = response.body?["data"]["channelId"];
        expect(channelId, isNotEmpty);
      }
    });

    test("getChannelInfo", () async {
      ServerResponse? response =
          await bcWrapper.chatService.getChannelInfo(channelId: channelId);

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
      }
    });

    test("channelConnect", () async {
      ServerResponse? response = await bcWrapper.chatService
          .channelConnect(channelId: channelId, maxtoreturn: 50);

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
      }
    });

    test("getSubscribedChannels", () async {
      ServerResponse response =
          await bcWrapper.chatService.getSubscribedChannels(channeltype: "gl");

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
        List channels = response.body?['data']['channels'];

        for (var chan in channels) {
          debugPrint(">> Channel Found << ");
          debugPrint(chan['id']);
          debugPrint(chan['type']);
          debugPrint(chan['name']);
          debugPrint(chan['desc']);
        }
      }
    });

    String msgId = "";

    String msgToSend = "Hello World!!";

    test("postChatMessageSimple", () async {
      ServerResponse response = await bcWrapper.chatService
          .postChatMessageSimple(channelId: channelId, plain: msgToSend);

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
        msgId = response.body?['data']['msgId'];
        debugPrint("Message sent: $msgId");
      }
    });

    test("getChatMessage", () async {
      ServerResponse response = await bcWrapper.chatService
          .getChatMessage(channelId: channelId, messageid: msgId);

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
        String txt = response.body?['data']['content']['text'];
        expect(txt, msgToSend);
      }
    });
  });
}
