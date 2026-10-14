
# brainCloud Dart Client Library

Thanks for checking out [brainCloud](https://getbraincloud.com/)! This repository contains the client library for brainCloud projects that make use of the Flutter framework.

Here are a few handy links to get you started:

- You can learn all about brainCloud and find a few tutorials here:
    - https://docs.braincloudservers.com/learn/introduction/
- The brainCloud API Reference can be found here:
    - https://docs.braincloudservers.com/api/introduction
## Installation

Install the plugin by adding it to your project's pubspec.yaml, under the dependencies section.

```bash
dependencies:
  braincloud: ^5.5.0
  braincloud_data_persistence: : ^5.5.0
```

NOTE: The package `braincloud_data_persistence` provides persistence support for the brainCloud Dart SDK by integrating platform preferences using SharedPreferencesAsync. 
It is optional and you can create your own if you desire.

## App Setup

Requires Dart 3.10+ (Flutter 3.38+). From your project root, run:

```bash
dart run braincloud:setup
```

This opens the brainCloud setup page in your browser. Log in, pick (or create) your app, and it writes `bc_config.json` to your project (and adds it to `.gitignore`). The app id and secret are stored encoded, never in plain text. Then build or run with the config:

```bash
flutter run --dart-define-from-file=bc_config.json
```

and initialize with `await _bcWrapper.initFromConfig();`. Child apps picked in the setup page are registered automatically.

Options: `--out <path>` (config location), `--server <url>` (private brainCloud server), `--no-browser`, and `--refresh` to rewrite the config without the browser (for CI, set `BRAINCLOUD_APP_ID`, `BRAINCLOUD_BUILDER_EMAIL`, `BRAINCLOUD_BUILDER_API_KEY` and `BRAINCLOUD_TEAM_ID`).

## Usage/Examples

Here's an example on how to initiate the client wrapper and start an update timer. The example also shows how to restore session and update the route accordingly. 

```dart
import 'dart:async';

import 'package:braincloud_data_persistence/braincloud_data_persistence.dart';
import 'package:braincloud/braincloud.dart';
import 'package:flutter/material.dart';

final _bcWrapper =
    BrainCloudWrapper(wrapperName: "<Your_Project_Wrapper_Name>",persistence: DataPersistence());

const routeHome = '/home';
const routeSignIn = '/signIn';

void main() => runApp(const MyApp());

///Main App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  /// Future to init the BrainCloud Client
  Future<String> _initAndUpdateRoute() async {
    // Reads bc_config.json (see App Setup). Without the setup tool, call
    // _bcWrapper.init(secretKey: ..., appId: ..., version: ..., url: ..., updateTick: 50) instead.
    await _bcWrapper.initFromConfig();

    /// Check if there was a session
    bool hasSession = false;
    if (_bcWrapper.canReconnect()) {
      ServerResponse response = await _bcWrapper.reconnect();
      hasSession = (response.statusCode == 200);
    }

    ///return the route name base on existing session
    return Future<String>.delayed(
        Duration.zero, () => hadSession ? routeHome : routeSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initAndUpdateRoute(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget page = Container();
          if (snapshot.hasData) {
            page = MaterialApp(

                /// build your app here
                );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasError) {
            /// Display error
            page = Text(snapshot.error.toString());
          }

          return page;
        });
  }
}

```

## Custom Data Persistence

 Here's an example of a simple data persistacen implementation that just saves to memory.

 ```dart
 import 'package:braincloud/data_persistence.dart';

class DataPersistence implements DataPersistenceBase {

  Map<String, String> playerPrefs = {};

  /// Set a String value
  Future setString(String key, String value) async {
    playerPrefs[key] = value;
  }

  /// Get a String value
  Future<String?> getString(String key) {
    return Future.value(playerPrefs[key]);
  }
}
```