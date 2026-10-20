
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
  braincloud: ^6.1.0
  braincloud_data_persistence: ^6.1.0
```

NOTE: The package `braincloud_data_persistence` provides persistence support for the brainCloud Dart SDK by integrating platform preferences using SharedPreferencesAsync. 
It is optional and you can create your own if you desire.

## App Setup

There are two ways to give the client your app's credentials. The setup tool is recommended; manual init still works if you'd rather manage the values yourself.

### Option 1: Setup tool (recommended)

Requires Dart 3.10+ (Flutter 3.38+). From your project root, run:

```bash
dart run braincloud:setup
```

This opens the brainCloud setup page in your browser. Log in, pick (or create) your app, and it writes `bc_config.json` to your project (and adds it to `.gitignore`).

Build or run with the config:

```bash
flutter run --dart-define-from-file=bc_config.json
flutter build <platform> --dart-define-from-file=bc_config.json
```

Then initialize with no parameters:

```dart
await _bcWrapper.initFromConfig();
```

Child apps picked in the setup page are registered automatically (same as `initWithApps`). `initFromConfig` takes an optional `updateTick` (default 50ms), or a `config:` you loaded yourself instead of reading the dart-defines.

Setup options:

| Option | Description |
|---|---|
| `--out <path>` | Where to write the config (default `bc_config.json`) |
| `--server <url>` | Use a private brainCloud server |
| `--no-browser` | Print the setup URL instead of opening a browser |
| `--timeout <minutes>` | How long to wait for the browser flow (default 30) |
| `--refresh` | Rewrite the config without the browser. For CI, set `BRAINCLOUD_APP_ID`, `BRAINCLOUD_BUILDER_EMAIL`, `BRAINCLOUD_BUILDER_API_KEY` and `BRAINCLOUD_TEAM_ID` |

### Option 2: Manual init

Pass your app id, secret and version directly. You can find them in the brainCloud portal under **Design > Core App Info > Application IDs**.

```dart
await _bcWrapper.init(
    secretKey: "<Your_App_Secret>",
    appId: "<Your_App_Id>",
    version: "1.0.0",
    url: "https://api.braincloudservers.com/dispatcherv2", // optional, defaults to the public server
    updateTick: 50); // ms; 0 = call _bcWrapper.update() yourself
```

For an app with child apps, use `initWithApps` and pass every app's secret:

```dart
await _bcWrapper.initWithApps(
    url: "https://api.braincloudservers.com/dispatcherv2",
    defaultAppId: "<Your_App_Id>",
    appIdSecretMap: {
      "<Your_App_Id>": "<Your_App_Secret>",
      "<Child_App_Id>": "<Child_App_Secret>",
    },
    version: "1.0.0",
    updateTick: 50);
```

No `--dart-define-from-file` flag is needed with manual init. Keep secrets out of source control.

`init` and `initWithApps` also take an `AppProfile` (`appProfile:` / `appProfiles:`) in place of the secret, e.g. `AppProfile.fromValue(secret)`, or `AppProfile((payload) => ...)` for your own signer.

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
    // Reads bc_config.json (App Setup, Option 1). For manual init, see Option 2.
    await _bcWrapper.initFromConfig();

    /// Check if there was a session
    bool hasSession = false;
    if (_bcWrapper.canReconnect()) {
      ServerResponse response = await _bcWrapper.reconnect();
      hasSession = (response.statusCode == 200);
    }

    ///return the route name base on existing session
    return Future<String>.delayed(
        Duration.zero, () => hasSession ? routeHome : routeSignIn);
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