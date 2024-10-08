import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);
  String channelId = "";

  group("Test Chat", () {
    test("getChannelId() with valid channel", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getChannelId(channeltype: "gl", channelsubid: "valid");

      channelId = response.body?["data"]["channelId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("getChannelId() with invalid channel", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getChannelId(channeltype: "gl", channelsubid: "invalid");

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("getChannelInfo()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getChannelInfo(channelId: channelId);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("channelConnect()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .channelConnect(channelId: channelId, maxtoreturn: 50);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSubscribedChannels()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getSubscribedChannels(channeltype: "gl");

      List<dynamic> channels = response.body?["data"]["channels"];
      channels.forEach((channel) {
        if (channel["id"] == channelId) {
          debugPrint("Found $channelId");
        }
      });

      expect(response.statusCode, StatusCodes.ok);
    });

    String msgId = "";

    test("postChatMessage()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .postChatMessage(
              channelId: channelId,
              contentJson: '{"text": "Hello World!", "rich": {"custom": 1}}');

      msgId = response.body?["data"]["msgId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("postChatMessageSimple()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .postChatMessageSimple(
              channelId: channelId,
              plain: "Hello World Simple!",
              recordInHistory: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    int msgVersion = 0;
    test("getChatMessage()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getChatMessage(channelId: channelId, messageid: msgId);

      expect(response.body?["data"]["content"]["text"], "Hello World!");
      if (response.body?["data"]["content"]["rich"].length > 1) {
        expect(response.body?["data"]["content"]["rich"]["custom"], "2");
      }
      msgVersion = response.body?["data"]["ver"];

      expect(response.statusCode, StatusCodes.ok);
    });

    test("updateChatMessage()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .updateChatMessage(
              channelId: channelId,
              messageid: msgId,
              version: msgVersion,
              contentjson:
                  '{"text": "Hello World! edited", "rich":{"custom": 2}}');

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getChatMessage()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getChatMessage(channelId: channelId, messageid: msgId);

      expect(response.body?["data"]["ver"], 2);
      expect(response.body?["data"]["content"]["text"], "Hello World! edited");
      if (response.body?["data"]["content"]["rich"].length > 0) {
        expect(response.body?["data"]["content"]["rich"]["custom"], 2);
      }
      msgVersion = response.body?["data"]["ver"];

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getRecentChatMessages()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getRecentChatMessages(channelId: channelId, maxToReturn: 50);

      List<dynamic> messages = response.body?["data"]["messages"];
      messages.forEach((message) {
        if (message["msgId"] == msgId) {
          expect(message["ver"], msgVersion);
        }
      });

      expect(response.statusCode, StatusCodes.ok);
    });

    test("deleteChatMessage()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .deleteChatMessage(
              channelId: channelId, messageid: msgId, version: msgVersion);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("channelDisconnect()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .channelDisconnect(channelId: channelId);
      expect(response.statusCode, StatusCodes.ok);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
