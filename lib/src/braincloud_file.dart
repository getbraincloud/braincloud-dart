import 'dart:typed_data';

import 'package:braincloud_dart/src/braincloud_client.dart';

class BrainCloudFile {
  final BrainCloudClient _clientRef;
  Map<String, Uint8List> fileStorage = {};

  BrainCloudFile(this._clientRef);
}
