## 6.1.0

* Fixed `authenticateGameCenter`/`attachGameCenterIdentity`/`mergeGameCenterIdentity` authenticationToken to encode the Game Center identity verification signature as `{timestamp, publicKeyUrl, signature, salt}`, matching what Apple's Game Center API provides; dropped the incorrect `teamPlayerId`/`playerId` field
* Removed the public `BrainCloudComms.getAppIdSecretMap`/`getSecretKey` and the wrapper's plain-text `_lastSecretKey` cache; app secrets are now held obfuscated in memory (`ProtectedSecret`) and only reconstructed transiently to sign a request

## 6.0.0

* Added Campaign service with `getMyCampaigns`
* Added `createLobbyWithConfig` and `createLobbyWithConfigAndPingData` to BrainCloudLobby
* Updated `authenticateGameCenter` to support modern Game Center identity verification signature (timestamp, publicKeyUrl, signature, salt, teamPlayerId)
* Updated `attachGameCenterIdentity` and `mergeGameCenterIdentity` to support Game Center identity verification signature
* brainCloud updates & release notes - [updates.braincloudservers.com](https://updates.braincloudservers.com/)

## 5.9.0

* brainCloud updates & release notes - [updates.braincloudservers.com](https://updates.braincloudservers.com/)
