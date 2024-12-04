import 'dart:async';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';
import 'utils/ws_proxy.dart';

main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);
 
  // helper fucntions for Disconnection test below
  String _getUrlQueryParameters(Map<String, dynamic> _rttHeaders) {
    String sToReturn = "?";
    int count = 0;
    _rttHeaders.forEach((key, value) {
      if (count > 0) sToReturn += "&";
      sToReturn += "$key=$value";
      ++count;
    });

    return sToReturn;
  }

  String _getConnectUrl(Map<String, dynamic> jsonResponse) {
    Map<String, dynamic> jsonData = jsonResponse["data"];
    List endpoints = jsonData["endpoints"];
    Map<String, dynamic> _endpoint = endpoints.first;
    String url =
        "wss://${_endpoint["host"]}:${_endpoint["port"]}${_getUrlQueryParameters(jsonData["auth"])}";
    return url;
  }

  group("Test RTT", () {
    String msgId = "";
    String msgToSend = "Hello World!!";

    test("enableRTT", () async {
      bcTest.bcWrapper.rttService.disableRTT();

      final Completer completer = Completer();

      bcTest.bcWrapper.rttService.enableRTT(
        connectiontype: RTTConnectionType.websocket,
        successCallback: (response) {
          if (response.reasonCode == ReasonCodes.featureNotEnabled) {
            markTestSkipped("Rtt not enable for this app.");
          } else {
            expect(response.data?['operation'], 'CONNECT');
            expect(bcTest.bcWrapper.rttService.isRTTEnabled(), true);
          }
          completer.complete();
        },
        failureCallback: (response) {
          fail("enableRTT failed with $response");
        },
      );

      await completer.future;
    });

    String channelId = "";

    test("registerRTT_etc", () async {
      bcTest.bcWrapper.rttService
          .registerRTTAsyncMatchCallback((jsonResponse) {});
      bcTest.bcWrapper.rttService
          .registerRTTBlockchainItemEvent((jsonResponse) {});
      bcTest.bcWrapper.rttService
          .registerRTTBlockchainRefresh((jsonResponse) {});
      bcTest.bcWrapper.rttService.registerRTTChatCallback((jsonResponse) {});
      bcTest.bcWrapper.rttService.registerRTTEventCallback((jsonResponse) {});
      bcTest.bcWrapper.rttService
          .registerRTTMessagingCallback((jsonResponse) {});
      bcTest.bcWrapper.rttService
          .registerRTTPresenceCallback((jsonResponse) {});

      bcTest.bcWrapper.rttService.deregisterRTTAsyncMatchCallback();
      bcTest.bcWrapper.rttService.deregisterRTTBlockchainItemEvent();
      bcTest.bcWrapper.rttService.deregisterRTTBlockchainRefresh();
      bcTest.bcWrapper.rttService.deregisterRTTChatCallback();
      bcTest.bcWrapper.rttService.deregisterRTTEventCallback();
      bcTest.bcWrapper.rttService.deregisterRTTMessagingCallback();
      bcTest.bcWrapper.rttService.deregisterRTTPresenceCallback();

      bcTest.bcWrapper.rttService.setRTTHeartBeatSeconds(1);

      expect(bcTest.bcWrapper.rttService.getRTTConnectionID(), isA<String?>());
    });

    test("getChannelId", () async {
      ServerResponse? response = await bcTest.bcWrapper.chatService
          .getChannelId(channelType: "gl", channelSubId: "valid");

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
        channelId = response.data?["channelId"];
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
      if (channelId.isEmpty) {
        ServerResponse? response = await bcTest.bcWrapper.chatService
            .getChannelId(channelType: "gl", channelSubId: "valid");
        channelId = response.data?["channelId"];
      }
      ServerResponse? response = await bcTest.bcWrapper.chatService
          .channelConnect(channelId: channelId, maxToReturn: 50);

      print("Channel Connect response $response");

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
      }
    });

    test("getSubscribedChannels", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getSubscribedChannels(channelType: "gl");

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
        List channels = response.data?['channels'];

        for (var chan in channels) {
          print(">> Channel Found << ");
          print(chan['id']);
          print(chan['type']);
          print(chan['name']);
          print(chan['desc']);
        }
      }
    });

    test("postChatMessageSimple", () async {
      if (channelId.isEmpty) {
        ServerResponse? response = await bcTest.bcWrapper.chatService
            .getChannelId(channelType: "gl", channelSubId: "valid");
        channelId = response.data?["channelId"];
      }
      ServerResponse response = await bcTest.bcWrapper.chatService
          .postChatMessageSimple(channelId: channelId, plain: msgToSend);

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
        msgId = response.data?['msgId'];
        print("Message sent: $msgId");
      }
    });

    test("getChatMessage", () async {
      ServerResponse response = await bcTest.bcWrapper.chatService
          .getChatMessage(channelId: channelId, messageId: msgId);

      if (response.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else {
        expect(response.statusCode, 200);
        String txt = response.data?['content']['text'];
        expect(txt, msgToSend);
      }
    });

    test("RTT websocket disconnect", () async {   

      Map<String, dynamic> localConnectionInfo = {
        'status': 200,
        'data': {
          'auth': {'X-APPID': 20001, 'X-RTT-SECRET': 'mysecret1'},
          'endpoints': [
            {
              "protocol": "ws",
              "port": bcTest.ids.WSProxyPort,
              "host": "localhost",
              "ssl": false,
              "ca": "GoDaddy"
            }
          ]
        }
      };

      Completer<Map<String, dynamic>> conncetionCompleted = Completer();
      Completer<bool> rttConnected = Completer();
      Completer<bool> testCompleted = Completer();

      print("[1] Starting test for websocket disconnect");

      if (bcTest.bcWrapper.rttService.isRTTEnabled()) {
        bcTest.bcWrapper.rttService.disableRTT();
      }
      void onRttSuccess(RTTCommandResponse data) {
        print("RTT Did get callback on success for RTT $data");
        rttConnected.complete(data.operation == "connect");
      }

      ;
      void onRttFailure(RTTCommandResponse data) {
        print("Did get callback on failure for RTT ${data.data}");
        String msg = (data.data?['error'] ?? "") as String;
        testCompleted.complete(msg.contains("Websocket closed."));
      }

      ;

      // Get the client connection data from RTT
      bcTest.bcWrapper.rttService.requestClientConnection(
          conncetionCompleted.complete,
          (statusCode, reasonCode, statusMessage) {});
      final connectionDetails = await conncetionCompleted.future;

      print("[2] Got a client connection response $connectionDetails");

      // Create the Proxy server
      String remoteUrl = _getConnectUrl(connectionDetails);
      final proxyWSServer = WebSocketProxy(remoteUrl);

      // Start proxy server
      proxyWSServer.startProxy(port:bcTest.ids.WSProxyPort);
      print(
          "[3] Got the proxyingWebSocket ready to interfere with it now.");

      // Register success and error callback manually as "enableRTT" is bypass here.
      bcTest.bcWrapper.brainCloudClient.rttComms.connectedSuccessCallback =
          onRttSuccess;
      bcTest.bcWrapper.brainCloudClient.rttComms.connectionFailureCallback =
          onRttFailure;
      bcTest.bcWrapper.brainCloudClient.rttComms.currentConnectionType =
          RTTConnectionType.websocket;

      bcTest.bcWrapper.brainCloudClient.rttComms
          .rttConnectionServerSuccess(localConnectionInfo);
      print(
          "[4] rttConnectionServerSuccess called with ${localConnectionInfo}");

      // Now wait for RTT to confirm connection.
      bool connectResult = await rttConnected.future;

      expect(connectResult, true, reason: "Did not get connected to RTT");

      print(
          "[5] TST did receive the proxyWS that can be close for testing purposes.");

      await Future.delayed(Duration(seconds: 2));

      // Tell the proxy to drop the connection. this will be viewed as the connection drop from the remote end.
      proxyWSServer.simulateConnectionDrop();

      bool result = await testCompleted.future;

      expect(result, true, reason: "Did not detect the webslocket closing.");
    },onPlatform: {'browser':Skip('Mock Proxy WS does not work on Web.')});

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
