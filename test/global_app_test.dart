import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Global App", () {
    setUp(bcTest.auth);

    test("readProperties()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.globalAppService.readProperties();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("readSelectedProperties()", () async {
      ServerResponse response = await bcTest.bcWrapper.globalAppService
          .readSelectedProperties(propertyNames: ["prop1", "prop2", "prop3"]);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("readPropertiesInCategories()", () async {
      ServerResponse response = await bcTest.bcWrapper.globalAppService
          .readPropertiesInCategories(categories: ["test"]);

      expect(response.statusCode, StatusCodes.ok);
    });
  });
}
