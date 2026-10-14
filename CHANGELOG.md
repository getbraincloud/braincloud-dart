## 6.1.0

* Added `dart run braincloud:setup`: log in to brainCloud in the browser, pick or create an app, and write an encoded `bc_config.json` to your project
* Added `BrainCloudWrapper.initFromConfig()` and `BrainCloudAppConfig` to initialize from `bc_config.json` (via `--dart-define-from-file`), including child apps
* Minimum Dart SDK is now 3.10 (Flutter 3.38) for the bundled native config decoder
* Fixed `authenticateGameCenter`/`attachGameCenterIdentity`/`mergeGameCenterIdentity` authenticationToken to encode the Game Center identity verification signature as `{timestamp, publicKeyUrl, signature, salt}`, matching what Apple's Game Center API provides; dropped the incorrect `teamPlayerId`/`playerId` field
* Updated client config optimizations
* New EpicGames APIs:
  * Added `authenticateEpicGames` to the Authentication service
  * Added `attachEpicGamesIdentity`, `mergeEpicGamesIdentity`, and `detachEpicGamesIdentity` to Identity service
  * Added `authenticateEpicGames` and `smartSwitchAuthenticateEpicGames` to the brainCloud Wrapper
* `epicGames` and `xsolla` are now accepted as a `storeId` in various AppStore service operations

## 6.0.0

* Added Campaign service with `getMyCampaigns`
* Added `createLobbyWithConfig` and `createLobbyWithConfigAndPingData` to BrainCloudLobby
* Updated `authenticateGameCenter` to support modern Game Center identity verification signature (timestamp, publicKeyUrl, signature, salt, teamPlayerId)
* Updated `attachGameCenterIdentity` and `mergeGameCenterIdentity` to support Game Center identity verification signature
* brainCloud updates & release notes - [updates.braincloudservers.com](https://updates.braincloudservers.com/)

## 5.9.0

* brainCloud updates & release notes - [updates.braincloudservers.com](https://updates.braincloudservers.com/)
