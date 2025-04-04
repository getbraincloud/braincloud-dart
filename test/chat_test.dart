import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);
  String channelId = "";

  group("Test Chat", () {
    test("getChannelId() with valid channel", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getChannelId(channelType: "gl", channelSubId: "valid");

      channelId = response.data?["channelId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("getChannelId() with invalid channel", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getChannelId(channelType: "gl", channelSubId: "invalid");

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("getChannelInfo()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getChannelInfo(channelId: channelId);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("channelConnect()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .channelConnect(channelId: channelId, maxToReturn: 50);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSubscribedChannels()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getSubscribedChannels(channelType: "gl");

      List<dynamic> channels = response.data?["channels"];
      channels.forEach((channel) {
        if (channel["id"] == channelId) {
          print("Found $channelId");
        }
      });

      expect(response.statusCode, StatusCodes.ok);
    });

    String msgId = "";

    test("postChatMessage()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .postChatMessage(channelId: channelId, contentJson: {
        "text": "Hello World!",
        "rich": {"custom": 1}
      });

      msgId = response.data?["msgId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("postChatMessageSimple()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .postChatMessageSimple(
              channelId: channelId,
              chatMessage: "Hello World Simple!",
              recordInHistory: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    int msgVersion = 0;
    test("getChatMessage()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getChatMessage(channelId: channelId, msgId: msgId);

      expect(response.data?["content"]["text"], "Hello World!");
      if (response.data?["content"]["rich"].length > 1) {
        expect(response.data?["content"]["rich"]["custom"], "2");
      }
      msgVersion = response.data?["ver"];

      expect(response.statusCode, StatusCodes.ok);
    });

    test("updateChatMessage()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .updateChatMessage(
              channelId: channelId,
              messageId: msgId,
              version: msgVersion,
              contentJson: {
            "text": "Hello World! edited",
            "rich": {"custom": 2}
          });

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getChatMessage()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getChatMessage(channelId: channelId, msgId: msgId);

      expect(response.data?["ver"], 2);
      expect(response.data?["content"]["text"], "Hello World! edited");
      if (response.data?["content"]["rich"].length > 0) {
        expect(response.data?["content"]["rich"]["custom"], 2);
      }
      msgVersion = response.data?["ver"];

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getRecentChatMessages()", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getRecentChatMessages(channelId: channelId, maxReturn: 50);

      List<dynamic> messages = response.data?["messages"];
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
              channelId: channelId, msgId: msgId, version: msgVersion);
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
