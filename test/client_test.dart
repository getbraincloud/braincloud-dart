
import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Client", () {
    
    setUpAll((){
      bcTest.bcWrapper.brainCloudClient.enableLogging(true);
    });

    test("Client Setters/Getters", () async {

      bcTest.bcWrapper.brainCloudClient.overrideCountryCode('US');
      bcTest.bcWrapper.brainCloudClient.overrideLanguageCode('FR');
      bcTest.bcWrapper.brainCloudClient.setUploadLowTransferRateThreshold(123);
      expect(bcTest.bcWrapper.brainCloudClient.getUploadLowTransferRateThreshold(),123);
      bcTest.bcWrapper.brainCloudClient.setAuthenticationPacketTimeout(456);
      expect(bcTest.bcWrapper.brainCloudClient.getAuthenticationPacketTimeout(),456);

      var pktTimeouts = bcTest.bcWrapper.brainCloudClient.getPacketTimeouts();
      bcTest.bcWrapper.brainCloudClient.setPacketTimeouts([21,31,41]);
      expect(bcTest.bcWrapper.brainCloudClient.getPacketTimeouts(), [21,31,41]);
      bcTest.bcWrapper.brainCloudClient.setPacketTimeoutsToDefault();
      expect(bcTest.bcWrapper.brainCloudClient.getPacketTimeouts(), pktTimeouts);

      expect(bcTest.bcWrapper.brainCloudClient.getUrl(), bcTest.ids.url);
      expect(bcTest.bcWrapper.brainCloudClient.getAppId(), bcTest.ids.appId);

      bcTest.bcWrapper.brainCloudClient.enableCompressedRequests = true;
      bcTest.bcWrapper.brainCloudClient.enableCompressedResponses = true;
      
      expect(bcTest.bcWrapper.brainCloudClient.getSessionId(), isA<String>());

      ServerResponse response = await bcTest.bcWrapper.brainCloudClient.sendHeartbeat();
      
      expect(response.statusCode, StatusCodes.ok);

      bcTest.bcWrapper.brainCloudClient.enableNetworkErrorMessageCaching(true);
      bcTest.bcWrapper.brainCloudClient.flushCachedMessages(false);
      bcTest.bcWrapper.brainCloudClient.retryCachedMessages();

      bcTest.bcWrapper.brainCloudClient.log("log");

    });

  
    tearDownAll(() {
      bcTest.bcWrapper.brainCloudClient.enableLogging(false);
    });
  });
}
