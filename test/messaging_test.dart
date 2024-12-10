import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);
  String msgId = "";
  String pageContext = "";

  group("Test Messages", () {
    test("getMessageCounts()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.messagingService.getMessageCounts();
      expect(response.statusCode, StatusCodes.ok);
    });
  });
  group("Test Messages", () {
    test("getMessageBoxes()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.messagingService.getMessageBoxes();
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data?["items"], isList, reason: 'items should be a list');
      expect(response.data?["items"], contains('inbox'),
          reason: 'Message box should have an inbox');
    });
    test("sendMessageSimple()", () async {
      List<String> toprofileids = [];
      if (userA.profileId != null) toprofileids.add(userA.profileId!);

      ServerResponse response =
          await bcTest.bcWrapper.messagingService.sendMessageSimple(
        toProfileIds: toprofileids,
        messageText: "Test",
      );
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data?["actual"], 1);
      expect(response.data?["requested"], 1);
      expect(response.data?["msgId"], isA<String>());
      msgId = response.data?["msgId"];
    });
    test("deleteMessages()", () async {
      List<String> toprofileids = [];

      // ensure we have a message to delete
      if (msgId.isEmpty) {
        expect(userA.profileId, isNotEmpty,
            reason: "Need a profileId for messaging Tests.");
        toprofileids.add(userA.profileId!);
        ServerResponse newMsgResponse =
            await bcTest.bcWrapper.messagingService.sendMessageSimple(
          toProfileIds: toprofileids,
          messageText: "Test",
        );
        msgId = newMsgResponse.data?["msgId"];
        expect(msgId, isNotEmpty, reason: "Need a msg Id to test deletion");
      }

      ServerResponse response = await bcTest.bcWrapper.messagingService
          .deleteMessages(msgBox: 'inbox', msgsIds: [msgId]);
      msgId = ""; // clear the msgId as it has been deleted.
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data?["actual"], 1);
      expect(response.data?["requested"], 1);
    });

    test("getMessages()", () async {
      // Ensure we have a message to get
      if (msgId.isEmpty) {
        expect(userA.profileId, isNotEmpty,
            reason: "Need a profileId for messaging Tests.");
        ServerResponse newMsgResponse =
            await bcTest.bcWrapper.messagingService.sendMessageSimple(
          toProfileIds: [userA.profileId!],
          messageText: "Test",
        );
        msgId = newMsgResponse.data?["msgId"];
        expect(msgId, isNotEmpty, reason: "Need a msg Id to test deletion");
      }

      ServerResponse response = await bcTest.bcWrapper.messagingService
          .getMessages(inMsgbox: 'inbox', inMsgsids: [msgId], markAsRead: true);
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data?["requested"], 1,
          reason: 'should match requested 1 msg');
      expect(response.data?["actual"], 1,
          reason: 'should match have received 1 msg');
      expect(response.data?["items"], isList, reason: 'items should be a list');
    });
    test("getMessagesPage()", () async {
      var context = {
        "pagination": {"rowsPerPage": 10, "pageNumber": 1},
        "searchCriteria": {
          "msgbox": "inbox",
        },
        "sortCriteria": {"mbCr": 1, "mbUp": -1}
      };
      ServerResponse response = await bcTest.bcWrapper.messagingService
          .getMessagesPage(context: context);
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data?["context"], isA<String>(),
          reason: 'context should be a string');
      pageContext = response.data?["context"];
      expect(response.data?["results"], isNotNull,
          reason: 'should have results');
      expect(response.data?["results"]["count"], isA<int>(),
          reason: 'count should be a number');
      expect(response.data?["results"]["page"], 1,
          reason: 'should be on the first page');
      expect(response.data?["results"]["items"], isList,
          reason: 'items should be a list');
    });
    test("getMessagesPageOffset()", () async {
      // ensure we have a valid context
      if (pageContext.isEmpty) {
        var context = {
          "pagination": {"rowsPerPage": 10, "pageNumber": 1},
          "searchCriteria": {
            "msgbox": "inbox",
          },
          "sortCriteria": {"mbCr": 1, "mbUp": -1}
        };
        ServerResponse response = await bcTest.bcWrapper.messagingService
            .getMessagesPage(context: context);
        expect(response.data?["context"], isA<String>(),
            reason: 'context should be a string');
        pageContext = response.data?["context"];
      }
      ServerResponse response = await bcTest.bcWrapper.messagingService
          .getMessagesPageOffset(context: pageContext, pageOffset: 1);
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data?["context"], isA<String>(),
          reason: 'context should be a string');
      pageContext = response.data?["context"];
      expect(response.data?["results"], isNotNull,
          reason: 'should have results');
      expect(response.data?["results"]["count"], isA<int>(),
          reason: 'count should be a number');
      expect(response.data?["results"]["page"], 2,
          reason: 'should be on the first page');
      expect(response.data?["results"]["items"], isList,
          reason: 'items should be a list');
    });
    test("markMessagesRead()", () async {
      // Ensure we have a message to get
      if (msgId.isEmpty) {
        expect(userA.profileId, isNotEmpty,
            reason: "Need a profileId for messaging Tests.");
        ServerResponse newMsgResponse =
            await bcTest.bcWrapper.messagingService.sendMessageSimple(
          toProfileIds: [userA.profileId!],
          messageText: "Test",
        );
        msgId = newMsgResponse.data?["msgId"];
        expect(msgId, isNotEmpty, reason: "Need a msg Id to test deletion");
      }

      ServerResponse response = await bcTest.bcWrapper.messagingService
          .markMessagesRead(msgBox: 'inbox', msgsIds: [msgId]);
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data?["requested"], isA<int>(),
          reason: 'requested should be a int');
      expect(response.data?["actual"], isA<int>(),
          reason: 'actual should be a int');
    });
    test("sendMessage()", () async {
      List<String> toprofileids = [];
      if (userA.profileId != null) toprofileids.add(userA.profileId!);

      ServerResponse response = await bcTest.bcWrapper.messagingService
          .sendMessage(
              toProfileIds: toprofileids, contentJson: {"msg": "missed call"});
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data?["actual"], 1);
      expect(response.data?["requested"], 1);
      expect(response.data?["msgId"], isA<String>());
      msgId = response.data?["msgId"];
    });
  });
}
