## 6.1.0

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
