class OperationParam {
  //Push Notification Service - Register Params
  static OperationParam PushNotificationRegisterParamDeviceType =
      OperationParam("deviceType");
  static OperationParam PushNotificationRegisterParamDeviceToken =
      OperationParam("deviceToken");

  //Push Notification Service - Send Params
  static OperationParam PushNotificationSendParamToPlayerId =
      OperationParam("toPlayerId");
  static OperationParam PushNotificationSendParamProfileId =
      OperationParam("profileId");
  static OperationParam PushNotificationSendParamMessage =
      OperationParam("message");
  static OperationParam PushNotificationSendParamNotificationTemplateId =
      OperationParam("notificationTemplateId");
  static OperationParam PushNotificationSendParamSubstitutions =
      OperationParam("substitutions");
  static OperationParam PushNotificationSendParamProfileIds =
      OperationParam("profileIds");

  static OperationParam PushNotificationSendParamFcmContent =
      OperationParam("fcmContent");
  static OperationParam PushNotificationSendParamIosContent =
      OperationParam("iosContent");
  static OperationParam PushNotificationSendParamFacebookContent =
      OperationParam("facebookContent");

  static OperationParam AlertContent = OperationParam("alertContent");
  static OperationParam CustomData = OperationParam("customData");

  static OperationParam StartDateUTC = OperationParam("startDateUTC");
  static OperationParam MinutesFromNow = OperationParam("minutesFromNow");

  // Twitter Service - Verify Params
  static OperationParam TwitterServiceVerifyToken = OperationParam("token");
  static OperationParam TwitterServiceVerifyVerifier =
      OperationParam("verifier");

  // Twitter Service - Tweet Params
  static OperationParam TwitterServiceTweetToken = OperationParam("token");
  static OperationParam TwitterServiceTweetSecret = OperationParam("secret");
  static OperationParam TwitterServiceTweetTweet = OperationParam("tweet");
  static OperationParam TwitterServiceTweetPic = OperationParam("pic");

  static OperationParam BlockChainConfig = OperationParam("blockchainConfig");
  static OperationParam BlockChainIntegrationId =
      OperationParam("integrationId");
  static OperationParam BlockChainContext = OperationParam("contextJson");
  static OperationParam PublicKey = OperationParam("publicKey");

  // Authenticate Service - Authenticate Params
  static OperationParam AuthenticateServiceAuthenticateAuthenticationType =
      OperationParam("authenticationType");
  static OperationParam AuthenticateServiceAuthenticateAuthenticationToken =
      OperationParam("authenticationToken");
  static OperationParam AuthenticateServiceAuthenticateExternalId =
      OperationParam("externalId");
  static OperationParam AuthenticateServiceAuthenticateUniversalId =
      OperationParam("universalId");
  static OperationParam AuthenticateServiceAuthenticateGameId =
      OperationParam("gameId");
  static OperationParam AuthenticateServiceAuthenticateDeviceId =
      OperationParam("deviceId");
  static OperationParam AuthenticateServiceAuthenticateForceMergeFlag =
      OperationParam("forceMergeFlag");
  static OperationParam AuthenticateServiceAuthenticateReleasePlatform =
      OperationParam("releasePlatform");
  static OperationParam AuthenticateServiceAuthenticateGameVersion =
      OperationParam("gameVersion");
  static OperationParam AuthenticateServiceAuthenticateBrainCloudVersion =
      OperationParam("clientLibVersion");
  static OperationParam AuthenticateServiceAuthenticateExternalAuthName =
      OperationParam("externalAuthName");
  static OperationParam AuthenticateServiceAuthenticateEmailAddress =
      OperationParam("emailAddress");
  static OperationParam AuthenticateServiceAuthenticateServiceParams =
      OperationParam("serviceParams");
  static OperationParam AuthenticateServiceAuthenticateTokenTtlInMinutes =
      OperationParam("tokenTtlInMinutes");

  static OperationParam AuthenticateServiceAuthenticateLevelName =
      OperationParam("levelName");
  static OperationParam AuthenticateServiceAuthenticatePeerCode =
      OperationParam("peerCode");

  static OperationParam AuthenticateServiceAuthenticateCountryCode =
      OperationParam("countryCode");
  static OperationParam AuthenticateServiceAuthenticateLanguageCode =
      OperationParam("languageCode");
  static OperationParam AuthenticateServiceAuthenticateTimeZoneOffset =
      OperationParam("timeZoneOffset");

  static OperationParam AuthenticateServiceAuthenticateAuthUpgradeID =
      OperationParam("upgradeAppId");
  static OperationParam AuthenticateServiceAuthenticateAnonymousId =
      OperationParam("anonymousId");
  static OperationParam AuthenticateServiceAuthenticateProfileId =
      OperationParam("profileId");
  static OperationParam AuthenticateServiceAuthenticateForceCreate =
      OperationParam("forceCreate");
  static OperationParam AuthenticateServiceAuthenticateCompressResponses =
      OperationParam("compressResponses");
  static OperationParam AuthenticateServicePlayerSessionExpiry =
      OperationParam("playerSessionExpiry");
  static OperationParam AuthenticateServiceAuthenticateExtraJson =
      OperationParam("extraJson");

  // Authenticate Service - Authenticate Params
  static OperationParam IdentityServiceExternalId =
      OperationParam("externalId");
  static OperationParam IdentityServiceAuthenticationType =
      OperationParam("authenticationType");
  static OperationParam IdentityServiceConfirmAnonymous =
      OperationParam("confirmAnonymous");

  static OperationParam IdentityServiceOldEmailAddress =
      OperationParam("oldEmailAddress");
  static OperationParam IdentityServiceNewEmailAddress =
      OperationParam("newEmailAddress");
  static OperationParam IdentityServiceUpdateContactEmail =
      OperationParam("updateContactEmail");

  // Peer
  static OperationParam Peer = OperationParam("peer");

  // Entity Service
  static OperationParam EntityServiceEntityId = OperationParam("entityId");
  static OperationParam EntityServiceEntityType = OperationParam("entityType");
  static OperationParam EntityServiceEntitySubtype =
      OperationParam("entitySubtype");
  static OperationParam EntityServiceData = OperationParam("data");
  static OperationParam EntityServiceAcl = OperationParam("acl");
  static OperationParam EntityServiceFriendData = OperationParam("friendData");
  static OperationParam EntityServiceVersion = OperationParam("version");
  static OperationParam EntityServiceUpdateOps = OperationParam("updateOps");
  static OperationParam EntityServiceTargetPlayerId =
      OperationParam("targetPlayerId");

  // Global Entity Service - Params
  static OperationParam GlobalEntityServiceEntityId =
      OperationParam("entityId");
  static OperationParam GlobalEntityServiceEntityType =
      OperationParam("entityType");
  static OperationParam GlobalEntityServiceIndexedId =
      OperationParam("entityIndexedId");
  static OperationParam GlobalEntityServiceTimeToLive =
      OperationParam("timeToLive");
  static OperationParam GlobalEntityServiceData = OperationParam("data");
  static OperationParam GlobalEntityServiceAcl = OperationParam("acl");
  static OperationParam GlobalEntityServiceVersion = OperationParam("version");
  static OperationParam GlobalEntityServiceMaxReturn =
      OperationParam("maxReturn");
  static OperationParam GlobalEntityServiceWhere = OperationParam("where");
  static OperationParam GlobalEntityServiceOrderBy = OperationParam("orderBy");
  static OperationParam GlobalEntityServiceContext = OperationParam("context");
  static OperationParam GlobalEntityServicePageOffset =
      OperationParam("pageOffset");
  static OperationParam OwnerId = OperationParam("ownerId");

  // Event Service - Send Params
  static OperationParam EventServiceSendToId = OperationParam("toId");
  static OperationParam EventServiceSendEventType = OperationParam("eventType");
  static OperationParam EventServiceSendEventId = OperationParam("eventId");
  static OperationParam EventServiceSendEventData = OperationParam("eventData");
  static OperationParam EventServiceSendRecordLocally =
      OperationParam("recordLocally");

  // Event Service - Update Event Data Params
  static OperationParam EventServiceUpdateEventDataFromId =
      OperationParam("fromId");
  static OperationParam EventServiceUpdateEventDataEventId =
      OperationParam("eventId");
  static OperationParam EventServiceUpdateEventDataData =
      OperationParam("eventData");
  static OperationParam EvId = OperationParam("evId");
  static OperationParam EventServiceEvIds = OperationParam("evIds");
  static OperationParam EventServiceDateMillis = OperationParam("dateMillis");
  static OperationParam EventServiceEventType = OperationParam("eventType");

  // Event Service - Delete Incoming Params
  static OperationParam EventServiceDeleteIncomingEventId =
      OperationParam("eventId");
  static OperationParam EventServiceDeleteIncomingFromId =
      OperationParam("fromId");

  // Event Service - Delete Sent Params
  static OperationParam EventServiceDeleteSentEventId =
      OperationParam("eventId");
  static OperationParam EventServiceDeleteSentToId = OperationParam("toId");
  static OperationParam EventServiceIncludeIncomingEvents =
      OperationParam("includeIncomingEvents");
  static OperationParam EventServiceIncludeSentEvents =
      OperationParam("includeSentEvents");

  // Friend Service - Params
  static OperationParam FriendServiceEntityId = OperationParam("entityId");
  static OperationParam FriendServiceExternalId = OperationParam("externalId");
  static OperationParam FriendServiceExternalIds =
      OperationParam("externalIds");
  static OperationParam FriendServiceProfileId = OperationParam("profileId");
  static OperationParam FriendServiceFriendId = OperationParam("friendId");
  static OperationParam FriendServiceAuthenticationType =
      OperationParam("authenticationType");
  static OperationParam ExternalAuthType = OperationParam("externalAuthType");
  static OperationParam FriendServiceEntityType = OperationParam("entityType");
  static OperationParam FriendServiceEntitySubtype =
      OperationParam("entitySubtype");
  static OperationParam FriendServiceIncludeSummaryData =
      OperationParam("includeSummaryData");
  static OperationParam FriendServiceFriendPlatform =
      OperationParam("friendPlatform");
  static OperationParam FriendServiceProfileIds = OperationParam("profileIds");
  static OperationParam FriendServiceMode = OperationParam("mode");

  // Friend Service operations
  //static Operation FriendServiceReadFriends = Operation("READ_FRIENDS");

  // Friend Service - Read Player State Params
  static OperationParam FriendServiceReadPlayerStateFriendId =
      OperationParam("friendId");
  static OperationParam FriendServiceSearchText = OperationParam("searchText");
  static OperationParam FriendServiceMaxResults = OperationParam("maxResults");

  // Friend Data Service - Read Friends Params (C++ only?)
  //static Operation FriendDataServiceReadFriends = Operation("");
  //friendIdList;
  //friendIdCount;

  //Achievements Event Data Params
  static OperationParam GamificationServiceAchievementsName =
      OperationParam("achievements");
  static OperationParam GamificationServiceAchievementsData =
      OperationParam("data");
  static OperationParam GamificationServiceAchievementsGranted =
      OperationParam("achievementsGranted");
  static OperationParam GamificationServiceCategory =
      OperationParam("category");
  static OperationParam GamificationServiceMilestones =
      OperationParam("milestones");
  static OperationParam GamificationServiceIncludeMetaData =
      OperationParam("includeMetaData");

  // Player Statistic Event Params
  static OperationParam PlayerStatisticEventServiceEventName =
      OperationParam("eventName");
  static OperationParam PlayerStatisticEventServiceEventMultiplier =
      OperationParam("eventMultiplier");
  static OperationParam PlayerStatisticEventServiceEvents =
      OperationParam("events");

  // Presence Params
  static OperationParam PresenceServicePlatform = OperationParam("platform");
  static OperationParam PresenceServiceIncludeOffline =
      OperationParam("includeOffline");
  static OperationParam PresenceServiceGroupId = OperationParam("groupId");
  static OperationParam PresenceServiceProfileIds =
      OperationParam("profileIds");
  static OperationParam PresenceServiceBidirectional =
      OperationParam("bidirectional");
  static OperationParam PresenceServiceVisibile = OperationParam("visible");
  static OperationParam PresenceServiceActivity = OperationParam("activity");

  // Player State Service - Read Params
  static OperationParam PlayerStateServiceReadEntitySubtype =
      OperationParam("entitySubType");

  // Player State Service - Update Summary Params
  static OperationParam PlayerStateServiceUpdateSummaryFriendData =
      OperationParam("summaryFriendData");
  static OperationParam PlayerStateServiceUpdateNameData =
      OperationParam("playerName");
  static OperationParam PlayerStateServiceTimeZoneOffset =
      OperationParam("timeZoneOffset");
  static OperationParam PlayerStateServiceLanguageCode =
      OperationParam("languageCode");

  // Player State Service - Atributes
  static OperationParam PlayerStateServiceAttributes =
      OperationParam("attributes");
  static OperationParam PlayerStateServiceWipeExisting =
      OperationParam("wipeExisting");

  static OperationParam PlayerStateServiceIncludeSummaryData =
      OperationParam("includePlayerSummaryData");

  // Player State Service - UPDATE_PICTURE_URL
  static OperationParam PlayerStateServicePlayerPictureUrl =
      OperationParam("playerPictureUrl");
  static OperationParam PlayerStateServiceContactEmail =
      OperationParam("contactEmail");

  // Player State Service - Reset Params
  //static Operation PlayerStateServiceReset = Operation("");

  // Player Statistics Service - Update Increment Params
  static OperationParam PlayerStatisticsServiceStats =
      OperationParam("statistics");
  static OperationParam PlayerStatisticsServiceStatNames =
      OperationParam("statNames");
  static OperationParam PlayerStatisticsExperiencePoints =
      OperationParam("xp_points");

  // Player Statistics Service - Status Param
  static OperationParam PlayerStateServiceStatusName =
      OperationParam("statusName");

  // Player Statistics Service - Extend User Status Params
  static OperationParam PlayerStateServiceAdditionalSecs =
      OperationParam("additionalSecs");
  static OperationParam PlayerStateServiceDetails = OperationParam("details");

  static OperationParam PlayerStateServiceDurationSecs =
      OperationParam("durationSecs");

  // Player Statistics Service - Read Params
  static OperationParam PlayerStatisticsServiceReadEntitySubType =
      OperationParam("entitySubType");

  //static Operation PlayerStatisticsServiceDelete = Operation("DELETE");

  // Push Notification Service operations (C++ only??)
  //static Operation PushNotificationServiceCreate = Operation("CREATE");
  //static Operation PushNotificationServiceRegister = Operation("REGISTER");

  // Social Leaderboard Service - general parameters
  static OperationParam SocialLeaderboardServiceLeaderboardId =
      OperationParam("leaderboardId");
  static OperationParam SocialLeaderboardServiceLeaderboardIds =
      OperationParam("leaderboardIds");
  static OperationParam SocialLeaderboardServiceReplaceName =
      OperationParam("replaceName");
  static OperationParam SocialLeaderboardServiceScore = OperationParam("score");
  static OperationParam SocialLeaderboardServiceData = OperationParam("data");
  static OperationParam SocialLeaderboardServiceEventName =
      OperationParam("eventName");
  static OperationParam SocialLeaderboardServiceEventMultiplier =
      OperationParam("eventMultiplier");
  static OperationParam SocialLeaderboardServiceLeaderboardType =
      OperationParam("leaderboardType");
  static OperationParam SocialLeaderboardServiceRotationType =
      OperationParam("rotationType");
  static OperationParam SocialLeaderboardServiceRotationReset =
      OperationParam("rotationReset");
  static OperationParam SocialLeaderboardServiceRetainedCount =
      OperationParam("retainedCount");
  static OperationParam NumDaysToRotate = OperationParam("numDaysToRotate");
  static OperationParam SocialLeaderboardServiceFetchType =
      OperationParam("fetchType");
  static OperationParam SocialLeaderboardServiceMaxResults =
      OperationParam("maxResults");
  static OperationParam SocialLeaderboardServiceSort = OperationParam("sort");
  static OperationParam SocialLeaderboardServiceStartIndex =
      OperationParam("startIndex");
  static OperationParam SocialLeaderboardServiceEndIndex =
      OperationParam("endIndex");
  static OperationParam SocialLeaderboardServiceBeforeCount =
      OperationParam("beforeCount");
  static OperationParam SocialLeaderboardServiceAfterCount =
      OperationParam("afterCount");
  static OperationParam SocialLeaderboardServiceIncludeLeaderboardSize =
      OperationParam("includeLeaderboardSize");
  static OperationParam SocialLeaderboardServiceVersionId =
      OperationParam("versionId");
  static OperationParam SocialLeaderboardServiceLeaderboardResultCount =
      OperationParam("leaderboardResultCount");
  static OperationParam SocialLeaderboardServiceGroupId =
      OperationParam("groupId");
  static OperationParam SocialLeaderboardServiceProfileIds =
      OperationParam("profileIds");
  static OperationParam SocialLeaderboardServiceRotationResetTime =
      OperationParam("rotationResetTime");

  // Social Leaderboard Service - Reset Score Params
  //static Operation SocialLeaderboardServiceResetScore = Operation("");

  // Product Service
  static OperationParam ProductServiceCurrencyId = OperationParam("vc_id");
  static OperationParam ProductServiceCurrencyAmount =
      OperationParam("vc_amount");

  // AppStore
  static OperationParam AppStoreServiceStoreId = OperationParam("storeId");
  static OperationParam AppStoreServiceReceiptData =
      OperationParam("receiptData");
  static OperationParam AppStoreServicePurchaseData =
      OperationParam("purchaseData");
  static OperationParam AppStoreServiceTransactionId =
      OperationParam("transactionId");
  static OperationParam AppStoreServiceTransactionData =
      OperationParam("transactionData");
  static OperationParam AppStoreServicePriceInfoCriteria =
      OperationParam("priceInfoCriteria");
  static OperationParam AppStoreServiceUserCurrency =
      OperationParam("userCurrency");
  static OperationParam AppStoreServiceCategory = OperationParam("category");

  // Virtual Currency Service
  static OperationParam VirtualCurrencyServiceCurrencyId =
      OperationParam("vcId");
  static OperationParam VirtualCurrencyServiceCurrencyAmount =
      OperationParam("vcAmount");

  // Product Service - Get Inventory Params
  static OperationParam ProductServiceGetInventoryPlatform =
      OperationParam("platform");
  static OperationParam ProductServiceGetInventoryUserCurrency =
      OperationParam("user_currency");
  static OperationParam ProductServiceGetInventoryCategory =
      OperationParam("category");

  // Product Service - Op Cash In Receipt Params
  static OperationParam ProductServiceOpCashInReceiptReceipt =
      OperationParam("receipt"); //C++ only
  static OperationParam ProductServiceOpCashInReceiptUrl =
      OperationParam("url"); //C++ only

  // Product Service - Reset Player VC Params
  //static OperationParam ProductServiceResetPlayerVC = OperationParam("");

  // Heartbeat Service - Params
  //static OperationParam HeartbeatService = OperationParam("");

  // Time Service - Params
  //static OperationParam TimeService = OperationParam("");

  // Server Time Service - Read Params
  static OperationParam ServerTimeServiceRead = OperationParam("");

  // data creation parms
  static OperationParam ServiceMessageService = OperationParam("service");
  static OperationParam ServiceMessageOperation = OperationParam("operation");
  static OperationParam ServiceMessageData = OperationParam("data");

  // data bundle creation parms
  static OperationParam ServiceMessagePacketId = OperationParam("packetId");
  static OperationParam ServiceMessageSessionId = OperationParam("sessionId");
  static OperationParam ServiceMessageGameId = OperationParam("gameId");
  static OperationParam ServiceMessageMessages = OperationParam("messages");
  static OperationParam ProfileId = OperationParam("profileId");

  // Error Params
  static OperationParam ServiceMessageReasonCode =
      OperationParam("reason_code");
  static OperationParam ServiceMessageStatusMessage =
      OperationParam("status_message");

  static OperationParam DeviceRegistrationTypeIos = OperationParam("IOS");
  static OperationParam DeviceRegistrationTypeAndroid = OperationParam("ANG");

  static OperationParam ScriptServiceRunScriptName =
      OperationParam("scriptName");
  static OperationParam ScriptServiceRunScriptData =
      OperationParam("scriptData");
  static OperationParam ScriptServiceStartDateUTC =
      OperationParam("startDateUTC");
  static OperationParam ScriptServiceStartMinutesFromNow =
      OperationParam("minutesFromNow");
  static OperationParam ScriptServiceParentLevel =
      OperationParam("parentLevel");
  static OperationParam ScriptServiceJobId = OperationParam("jobId");

  static OperationParam MatchMakingServicePlayerRating =
      OperationParam("playerRating");
  static OperationParam MatchMakingServiceMinutes = OperationParam("minutes");
  static OperationParam MatchMakingServiceRangeDelta =
      OperationParam("rangeDelta");
  static OperationParam MatchMakingServiceNumMatches =
      OperationParam("numMatches");
  static OperationParam MatchMakingServiceAttributes =
      OperationParam("attributes");
  static OperationParam MatchMakingServiceExtraParams =
      OperationParam("extraParms");
  static OperationParam MatchMakingServicePlayerId = OperationParam("playerId");
  static OperationParam MatchMakingServicePlaybackStreamId =
      OperationParam("playbackStreamId");

  static OperationParam OfflineMatchServicePlayerId =
      OperationParam("playerId");
  static OperationParam OfflineMatchServiceRangeDelta =
      OperationParam("rangeDelta");
  static OperationParam OfflineMatchServicePlaybackStreamId =
      OperationParam("playbackStreamId");

  static OperationParam PlaybackStreamServiceTargetPlayerId =
      OperationParam("targetPlayerId");
  static OperationParam PlaybackStreamServiceInitiatingPlayerId =
      OperationParam("initiatingPlayerId");
  static OperationParam PlaybackStreamServiceMaxNumberOfStreams =
      OperationParam("maxNumStreams");
  static OperationParam PlaybackStreamServiceIncludeSharedData =
      OperationParam("includeSharedData");
  static OperationParam PlaybackStreamServicePlaybackStreamId =
      OperationParam("playbackStreamId");
  static OperationParam PlaybackStreamServiceEventData =
      OperationParam("eventData");
  static OperationParam PlaybackStreamServiceSummary =
      OperationParam("summary");

  static OperationParam ProductServiceTransId = OperationParam("transId");
  static OperationParam ProductServiceOrderId = OperationParam("orderId");
  static OperationParam ProductServiceProductId = OperationParam("productId");
  static OperationParam ProductServiceLanguage = OperationParam("language");
  static OperationParam ProductServiceItemId = OperationParam("itemId");
  static OperationParam ProductServiceReceipt = OperationParam("receipt");
  static OperationParam ProductServiceSignedRequest =
      OperationParam("signed_request");
  static OperationParam ProductServiceToken = OperationParam("token");

  //S3 Service
  static OperationParam S3HandlingServiceFileCategory =
      OperationParam("category");
  static OperationParam S3HandlingServiceFileDetails =
      OperationParam("fileDetails");
  static OperationParam S3HandlingServiceFileId = OperationParam("fileId");

  //Shared Identity
  static OperationParam IdentityServiceForceSingleton =
      OperationParam("forceSingleton");

  //RedemptionCode
  static OperationParam RedemptionCodeServiceScanCode =
      OperationParam("scanCode");
  static OperationParam RedemptionCodeServiceCodeType =
      OperationParam("codeType");
  static OperationParam RedemptionCodeServiceCustomRedemptionInfo =
      OperationParam("customRedemptionInfo");

  //DataStream
  static OperationParam DataStreamEventName = OperationParam("eventName");
  static OperationParam DataStreamEventProperties =
      OperationParam("eventProperties");
  static OperationParam DataStreamCrashType = OperationParam("crashType");
  static OperationParam DataStreamErrorMsg = OperationParam("errorMsg");
  static OperationParam DataStreamCrashInfo = OperationParam("crashJson");
  static OperationParam DataStreamCrashLog = OperationParam("crashLog");
  static OperationParam DataStreamUserName = OperationParam("userName");
  static OperationParam DataStreamUserEmail = OperationParam("userEmail");
  static OperationParam DataStreamUserNotes = OperationParam("userNotes");
  static OperationParam DataStreamUserSubmitted =
      OperationParam("userSubmitted");

  // Profanity
  static OperationParam ProfanityText = OperationParam("text");
  static OperationParam ProfanityReplaceSymbol =
      OperationParam("replaceSymbol");
  static OperationParam ProfanityFlagEmail = OperationParam("flagEmail");
  static OperationParam ProfanityFlagPhone = OperationParam("flagPhone");
  static OperationParam ProfanityFlagUrls = OperationParam("flagUrls");
  static OperationParam ProfanityLanguages = OperationParam("languages");

  //File upload
  static OperationParam UploadLocalPath = OperationParam("localPath");
  static OperationParam UploadCloudPath = OperationParam("cloudPath");
  static OperationParam UploadCloudFilename = OperationParam("cloudFilename");
  static OperationParam UploadShareable = OperationParam("shareable");
  static OperationParam UploadReplaceIfExists =
      OperationParam("replaceIfExists");
  static OperationParam UploadFileSize = OperationParam("fileSize");
  static OperationParam UploadRecurse = OperationParam("recurse");
  static OperationParam UploadPath = OperationParam("path");

  //group
  static OperationParam GroupId = OperationParam("groupId");
  static OperationParam GroupProfileId = OperationParam("profileId");
  static OperationParam GroupRole = OperationParam("role");
  static OperationParam GroupAttributes = OperationParam("attributes");
  static OperationParam GroupName = OperationParam("name");
  static OperationParam GroupType = OperationParam("groupType");
  static OperationParam GroupTypes = OperationParam("groupTypes");
  static OperationParam GroupEntityType = OperationParam("entityType");
  static OperationParam GroupIsOpenGroup = OperationParam("isOpenGroup");
  static OperationParam GroupAcl = OperationParam("acl");
  static OperationParam GroupData = OperationParam("data");
  static OperationParam GroupOwnerAttributes =
      OperationParam("ownerAttributes");
  static OperationParam GroupDefaultMemberAttributes =
      OperationParam("defaultMemberAttributes");
  static OperationParam GroupIsOwnedByGroupMember =
      OperationParam("isOwnedByGroupMember");
  static OperationParam GroupSummaryData = OperationParam("summaryData");
  static OperationParam GroupEntityId = OperationParam("entityId");
  static OperationParam GroupVersion = OperationParam("version");
  static OperationParam GroupContext = OperationParam("context");
  static OperationParam GroupPageOffset = OperationParam("pageOffset");
  static OperationParam GroupAutoJoinStrategy =
      OperationParam("autoJoinStrategy");
  static OperationParam GroupWhere = OperationParam("where");
  static OperationParam GroupMaxReturn = OperationParam("maxReturn");

  //group file
  static OperationParam FolderPath = OperationParam("folderPath");
  static OperationParam FileName = OperationParam("filename");
  static OperationParam FullPathFilename = OperationParam("fullPathFilename");
  static OperationParam FileId = OperationParam("fileId");
  static OperationParam Version = OperationParam("version");
  static OperationParam NewTreeId = OperationParam("newTreeId");
  static OperationParam TreeVersion = OperationParam("treeVersion");
  static OperationParam NewFilename = OperationParam("newFilename");
  static OperationParam OverwriteIfPresent =
      OperationParam("overwriteIfPresent");
  static OperationParam Recurse = OperationParam("recurse");
  static OperationParam UserCloudPath = OperationParam("userCloudPath");
  static OperationParam UserCloudFilename = OperationParam("userCloudFilename");
  static OperationParam GroupTreeId = OperationParam("groupTreeId");
  static OperationParam GroupFilename = OperationParam("groupFilename");
  static OperationParam GroupFileACL = OperationParam("groupFileAcl");
  static OperationParam NewACL = OperationParam("newAcl");

  //GlobalFile
  static OperationParam GlobalFileServiceFileId = OperationParam("fileId");
  static OperationParam GlobalFileServiceFolderPath =
      OperationParam("folderPath");
  static OperationParam GlobalFileServiceFileName = OperationParam("filename");
  static OperationParam GlobalFileServiceRecurse = OperationParam("recurse");

  //mail
  static OperationParam Subject = OperationParam("subject");
  static OperationParam Body = OperationParam("body");
  static OperationParam ServiceParams = OperationParam("serviceParams");
  static OperationParam EmailAddress = OperationParam("emailAddress");

  static OperationParam LeaderboardId = OperationParam("leaderboardId");
  static OperationParam DivSetId = OperationParam("divSetId");
  static OperationParam VersionId = OperationParam("versionId");
  static OperationParam TournamentCode = OperationParam("tournamentCode");
  static OperationParam InitialScore = OperationParam("initialScore");
  static OperationParam Score = OperationParam("score");
  static OperationParam RoundStartedEpoch = OperationParam("roundStartedEpoch");
  static OperationParam Data = OperationParam("data");

  // chat
  static OperationParam ChatChannelId = OperationParam("channelId");
  static OperationParam ChatMaxReturn = OperationParam("maxReturn");
  static OperationParam ChatMessageId = OperationParam("msgId");
  static OperationParam ChatVersion = OperationParam("version");

  static OperationParam ChatChannelType = OperationParam("channelType");
  static OperationParam ChatChannelSubId = OperationParam("channelSubId");
  static OperationParam ChatContent = OperationParam("content");
  static OperationParam ChatText = OperationParam("text");

  static OperationParam ChatRich = OperationParam("rich");
  static OperationParam ChatRecordInHistory = OperationParam("recordInHistory");

  // TODO:: do we enumerate these ? [smrj]
  // chat channel types
  static OperationParam AllChannelType = OperationParam("all");
  static OperationParam GlobalChannelType = OperationParam("gl");
  static OperationParam GroupChannelType = OperationParam("gr");

  // messaging
  static OperationParam MessagingMessageBox = OperationParam("msgbox");
  static OperationParam MessagingMessageIds = OperationParam("msgIds");
  static OperationParam MessagingMarkAsRead = OperationParam("markAsRead");
  static OperationParam MessagingContext = OperationParam("context");
  static OperationParam MessagingPageOffset = OperationParam("pageOffset");
  static OperationParam MessagingFromName = OperationParam("fromName");
  static OperationParam MessagingToProfileIds = OperationParam("toProfileIds");
  static OperationParam MessagingContent = OperationParam("contentJson");
  static OperationParam MessagingSubject = OperationParam("subject");
  static OperationParam MessagingText = OperationParam("text");

  static OperationParam InboxMessageType = OperationParam("inbox");
  static OperationParam SentMessageType = OperationParam("sent");

  // lobby
  static OperationParam LobbyRoomType = OperationParam("lobbyType");
  static OperationParam LobbyTypes = OperationParam("lobbyTypes");
  static OperationParam LobbyRating = OperationParam("rating");
  static OperationParam LobbyAlgorithm = OperationParam("algo");
  static OperationParam LobbyMaxSteps = OperationParam("maxSteps");
  static OperationParam LobbyStrategy = OperationParam("strategy");
  static OperationParam LobbyAlignment = OperationParam("alignment");
  static OperationParam LobbyRanges = OperationParam("ranges");
  static OperationParam LobbyFilterJson = OperationParam("filterJson");
  static OperationParam LobbySettings = OperationParam("settings");
  static OperationParam LobbyTimeoutSeconds = OperationParam("timeoutSecs");
  static OperationParam LobbyIsReady = OperationParam("isReady");
  static OperationParam LobbyOtherUserCxIds = OperationParam("otherUserCxIds");
  static OperationParam LobbyExtraJson = OperationParam("extraJson");
  static OperationParam LobbyTeamCode = OperationParam("teamCode");
  static OperationParam LobbyIdentifier = OperationParam("lobbyId");
  static OperationParam LobbyToTeamName = OperationParam("toTeamCode");
  static OperationParam LobbySignalData = OperationParam("signalData");
  static OperationParam LobbyConnectionId = OperationParam("cxId");
  static OperationParam PingData = OperationParam("pingData");
  static OperationParam LobbyMinRating = OperationParam("minRating");
  static OperationParam LobbyMaxRating = OperationParam("maxRating");

  static OperationParam CompoundAlgos = OperationParam("algos");
  static OperationParam CompoundRanges = OperationParam("compound-ranges");
  static OperationParam LobbyCritera = OperationParam("criteriaJson");
  static OperationParam CriteraPing = OperationParam("ping");
  static OperationParam CriteraRating = OperationParam("rating");
  static OperationParam StrategyRangedPercent =
      OperationParam("ranged-percent");
  static OperationParam StrategyRangedAbsolute =
      OperationParam("ranged-absolute");
  static OperationParam StrategyAbsolute = OperationParam("absolute");
  static OperationParam StrategyCompound = OperationParam("compound");
  static OperationParam AlignmentCenter = OperationParam("center");
  //custom entity
  static OperationParam CustomEntityServiceEntityType =
      OperationParam("entityType");
  static OperationParam CustomEntityServiceDeleteCriteria =
      OperationParam("deleteCriteria");
  static OperationParam CustomEntityServiceEntityId =
      OperationParam("entityId");
  static OperationParam CustomEntityServiceVersion = OperationParam("version");
  static OperationParam CustomEntityServiceFieldsJson =
      OperationParam("fieldsJson");
  static OperationParam CustomEntityServiceWhereJson =
      OperationParam("whereJson");
  static OperationParam CustomEntityServiceRowsPerPage =
      OperationParam("rowsPerPage");
  static OperationParam CustomEntityServiceSearchJson =
      OperationParam("searchJson");
  static OperationParam CustomEntityServiceSortJson =
      OperationParam("sortJson");
  static OperationParam CustomEntityServiceDoCount = OperationParam("doCount");
  static OperationParam CustomEntityServiceContext = OperationParam("context");
  static OperationParam CustomEntityServicePageOffset =
      OperationParam("pageOffset");
  static OperationParam CustomEntityServiceTimeToLive =
      OperationParam("timeToLive");
  static OperationParam CustomEntityServiceAcl = OperationParam("acl");
  static OperationParam CustomEntityServiceDataJson =
      OperationParam("dataJson");
  static OperationParam CustomEntityServiceIsOwned = OperationParam("isOwned");
  static OperationParam CustomEntityServiceMaxReturn =
      OperationParam("maxReturn");
  static OperationParam CustomEntityServiceShardKeyJson =
      OperationParam("shardKeyJson");

  //item catalog
  static OperationParam ItemCatalogServiceDefId = OperationParam("defId");
  static OperationParam ItemCatalogServiceContext = OperationParam("context");
  static OperationParam ItemCatalogServicePageOffset =
      OperationParam("pageOffset");

  //userInventory
  static OperationParam UserItemsServiceDefId = OperationParam("defId");
  static OperationParam UserItemsServiceQuantity = OperationParam("quantity");
  static OperationParam UserItemsServiceIncludeDef =
      OperationParam("includeDef");
  static OperationParam UserItemsServiceItemId = OperationParam("itemId");
  static OperationParam UserItemsServiceCriteria = OperationParam("criteria");
  static OperationParam UserItemsServiceContext = OperationParam("context");
  static OperationParam UserItemsServicePageOffset =
      OperationParam("pageOffset");
  static OperationParam UserItemsServiceVersion = OperationParam("version");
  static OperationParam UserItemsServiceImmediate = OperationParam("immediate");
  static OperationParam UserItemsServiceProfileId = OperationParam("profileId");
  static OperationParam UserItemsServiceShopId = OperationParam("shopId");
  static OperationParam UserItemsServiceNewItemData =
      OperationParam("newItemData");

  //global app
  static OperationParam GlobalAppPropertyNames =
      OperationParam("propertyNames");
  static OperationParam GlobalAppCategories = OperationParam("categories");

  OperationParam(String value) {
    _value = value;
  }

  late String _value;

  String get Value => _value;
}
