## 6.1.0

* New EpicGames APIs:
  * Added `authenticateEpicGames` to the Authentication service
  * Added `attachEpicGamesIdentity`, `attachEpicGamesIdentity`, and `attachEpicGamesIdentity` to Identity service
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
