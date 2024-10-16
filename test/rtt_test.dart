import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test RTT", () {
    test("enableRTT", () async {
      bcTest.bcWrapper.rttService.disableRTT();

      RTTCommandResponse? response = await bcTest.bcWrapper.rttService
          .enableRTT(connectiontype: RTTConnectionType.websocket);

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.data?['operation'], 'CONNECT');
      }
    }, tags: "rTTService");

    String channelId = "";

    test("getChannelId", () async {
      ServerResponse? response = await bcTest.bcWrapper.chatService
          .getChannelId(channeltype: "gl", channelsubid: "valid");

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
        channelId = response.data?["channelId"];
        expect(channelId, isNotEmpty);
      }
    }, tags: "rTTService");

    test("getChannelInfo", () async {
      ServerResponse? response = await bcTest.bcWrapper.chatService
          .getChannelInfo(channelId: channelId);

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
      }
    }, tags: "rTTService");

    test("channelConnect", () async {
      ServerResponse? response = await bcTest.bcWrapper.chatService
          .channelConnect(channelId: channelId, maxtoreturn: 50);

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
      }
    }, tags: "rTTService");

    test("getSubscribedChannels", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getSubscribedChannels(channeltype: "gl");

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
        List channels = response.data?['channels'];

        for (var chan in channels) {
          debugPrint(">> Channel Found << ");
          debugPrint(chan['id']);
          debugPrint(chan['type']);
          debugPrint(chan['name']);
          debugPrint(chan['desc']);
        }
      }
    }, tags: "rTTService");

    String msgId = "";

    String msgToSend = "Hello World!!";

    test("postChatMessageSimple", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .postChatMessageSimple(channelId: channelId, plain: msgToSend);

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
        msgId = response.data?['msgId'];
        debugPrint("Message sent: $msgId");
      }
    }, tags: "rTTService");

    test("getChatMessage", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getChatMessage(channelId: channelId, messageid: msgId);

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
        String txt = response.data?['content']['text'];
        expect(txt, msgToSend);
      }
    }, tags: "rTTService");

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
