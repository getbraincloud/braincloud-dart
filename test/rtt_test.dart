import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test RTT", () {
    setUp(bcTest.auth);

    test("enableRTT", () async {
      bcTest.bcWrapper.rTTService.disableRTT();

      ServerResponse? response = await bcTest.bcWrapper.rTTService
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
      ServerResponse? response = await bcTest.bcWrapper.chatService
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
      ServerResponse? response = await bcTest.bcWrapper.chatService
          .getChannelInfo(channelId: channelId);

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
      }
    });

    test("channelConnect", () async {
      ServerResponse? response = await bcTest.bcWrapper.chatService
          .channelConnect(channelId: channelId, maxtoreturn: 50);

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
      }
    });

    test("getSubscribedChannels", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getSubscribedChannels(channeltype: "gl");

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
      ServerResponse response = await bcTest.bcWrapper.chatService
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
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getChatMessage(channelId: channelId, messageid: msgId);

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
        String txt = response.body?['data']['content']['text'];
        expect(txt, msgToSend);
      }
    });

    /// END TEST
    tearDown(() {
      bcTest.dispose();
    });
  });
}
