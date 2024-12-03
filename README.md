
# Braincloud Dart Client Library

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
  braincloud_dart:
    git: git@github.com:getbraincloud/braincloud-dart.git
```
This will eventually live on pub.dev, but we can link it like this for now. 
## Usage/Examples

Here's an example on how to initiate the client wrapper and start an update timer. The example also shows how to restore session and update the route accordingly. 

```dart
import 'dart:async';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/material.dart';

final _bcWrapper =
    BrainCloudWrapper(wrapperName: "<Your_Project_Wrapper_Name>");

const routeHome = '/home';
const routeSignIn = '/signIn';

void main() => runApp(const MyApp());

///Main App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  /// Future to init the BrainCloud Client
  Future<String> _initAndUpdateRoute() async {
    await _bcWrapper.init(
        secretKey: "<YOUR_SECRET_KEY>", 
        appId: "<YOUR_APP_ID>", 
        version: "<YOUR_APP_VERSION>",
        url: "https://api.braincloudservers.com/dispatcherv2");

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

