class OperationParam {
  //Push Notification Service - Register Params
  static OperationParam pushNotificationRegisterParamDeviceType =
      OperationParam("deviceType");
  static OperationParam pushNotificationRegisterParamDeviceToken =
      OperationParam("deviceToken");

  //Push Notification Service - Send Params
  static OperationParam pushNotificationSendParamToPlayerId =
      OperationParam("toPlayerId");
  static OperationParam pushNotificationSendParamProfileId =
      OperationParam("profileId");
  static OperationParam pushNotificationSendParamMessage =
      OperationParam("message");
  static OperationParam pushNotificationSendParamNotificationTemplateId =
      OperationParam("notificationTemplateId");
  static OperationParam pushNotificationSendParamSubstitutions =
      OperationParam("substitutions");
  static OperationParam pushNotificationSendParamProfileIds =
      OperationParam("profileIds");

  static OperationParam pushNotificationSendParamFcmContent =
      OperationParam("fcmContent");
  static OperationParam pushNotificationSendParamIosContent =
      OperationParam("iosContent");
  static OperationParam pushNotificationSendParamFacebookContent =
      OperationParam("facebookContent");

  static OperationParam alertContent = OperationParam("alertContent");
  static OperationParam customData = OperationParam("customData");

  static OperationParam startDateUTC = OperationParam("startDateUTC");
  static OperationParam minutesFromNow = OperationParam("minutesFromNow");

  // Twitter Service - Verify Params
  static OperationParam twitterServiceVerifyToken = OperationParam("token");
  static OperationParam twitterServiceVerifyVerifier =
      OperationParam("verifier");

  // Twitter Service - Tweet Params
  static OperationParam twitterServiceTweetToken = OperationParam("token");
  static OperationParam twitterServiceTweetSecret = OperationParam("secret");
  static OperationParam twitterServiceTweetTweet = OperationParam("tweet");
  static OperationParam twitterServiceTweetPic = OperationParam("pic");

  static OperationParam blockChainConfig = OperationParam("blockchainConfig");
  static OperationParam blockChainIntegrationId =
      OperationParam("integrationId");
  static OperationParam blockChainContext = OperationParam("contextJson");
  static OperationParam publicKey = OperationParam("publicKey");

  // Authenticate Service - Authenticate Params
  static OperationParam authenticateServiceAuthenticateAuthenticationType =
      OperationParam("authenticationType");
  static OperationParam authenticateServiceAuthenticateAuthenticationToken =
      OperationParam("authenticationToken");
  static OperationParam authenticateServiceAuthenticateExternalId =
      OperationParam("externalId");
  static OperationParam authenticateServiceAuthenticateUniversalId =
      OperationParam("universalId");
  static OperationParam authenticateServiceAuthenticateGameId =
      OperationParam("gameId");
  static OperationParam authenticateServiceAuthenticateDeviceId =
      OperationParam("deviceId");
  static OperationParam authenticateServiceAuthenticateForceMergeFlag =
      OperationParam("forceMergeFlag");
  static OperationParam authenticateServiceAuthenticateReleasePlatform =
      OperationParam("releasePlatform");
  static OperationParam authenticateServiceAuthenticateGameVersion =
      OperationParam("gameVersion");
  static OperationParam authenticateServiceAuthenticateBrainCloudVersion =
      OperationParam("clientLibVersion");
  static OperationParam authenticateServiceAuthenticateExternalAuthName =
      OperationParam("externalAuthName");
  static OperationParam authenticateServiceAuthenticateEmailAddress =
      OperationParam("emailAddress");
  static OperationParam authenticateServiceAuthenticateServiceParams =
      OperationParam("serviceParams");
  static OperationParam authenticateServiceAuthenticateTokenTtlInMinutes =
      OperationParam("tokenTtlInMinutes");

  static OperationParam authenticateServiceAuthenticateLevelName =
      OperationParam("levelName");
  static OperationParam authenticateServiceAuthenticatePeerCode =
      OperationParam("peerCode");

  static OperationParam authenticateServiceAuthenticateCountryCode =
      OperationParam("countryCode");
  static OperationParam authenticateServiceAuthenticateLanguageCode =
      OperationParam("languageCode");
  static OperationParam authenticateServiceAuthenticateTimeZoneOffset =
      OperationParam("timeZoneOffset");

  static OperationParam authenticateServiceAuthenticateAuthUpgradeID =
      OperationParam("upgradeAppId");
  static OperationParam authenticateServiceAuthenticateAnonymousId =
      OperationParam("anonymousId");
  static OperationParam authenticateServiceAuthenticateProfileId =
      OperationParam("profileId");
  static OperationParam authenticateServiceAuthenticateForceCreate =
      OperationParam("forceCreate");
  static OperationParam authenticateServiceAuthenticateCompressResponses =
      OperationParam("compressResponses");
  static OperationParam authenticateServicePlayerSessionExpiry =
      OperationParam("playerSessionExpiry");
  static OperationParam authenticateServiceAuthenticateExtraJson =
      OperationParam("extraJson");

  // Authenticate Service - Authenticate Params
  static OperationParam identityServiceExternalId =
      OperationParam("externalId");
  static OperationParam identityServiceAuthenticationType =
      OperationParam("authenticationType");
  static OperationParam identityServiceConfirmAnonymous =
      OperationParam("confirmAnonymous");

  static OperationParam identityServiceOldEmailAddress =
      OperationParam("oldEmailAddress");
  static OperationParam identityServiceNewEmailAddress =
      OperationParam("newEmailAddress");
  static OperationParam identityServiceUpdateContactEmail =
      OperationParam("updateContactEmail");

  // Peer
  static OperationParam peer = OperationParam("peer");

  // Entity Service
  static OperationParam entityServiceEntityId = OperationParam("entityId");
  static OperationParam entityServiceEntityType = OperationParam("entityType");
  static OperationParam entityServiceEntitySubtype =
      OperationParam("entitySubtype");
  static OperationParam entityServiceData = OperationParam("data");
  static OperationParam entityServiceAcl = OperationParam("acl");
  static OperationParam entityServiceFriendData = OperationParam("friendData");
  static OperationParam entityServiceVersion = OperationParam("version");
  static OperationParam entityServiceUpdateOps = OperationParam("updateOps");
  static OperationParam entityServiceTargetPlayerId =
      OperationParam("targetPlayerId");

  // Global Entity Service - Params
  static OperationParam globalEntityServiceEntityId =
      OperationParam("entityId");
  static OperationParam globalEntityServiceEntityType =
      OperationParam("entityType");
  static OperationParam globalEntityServiceIndexedId =
      OperationParam("entityIndexedId");
  static OperationParam globalEntityServiceTimeToLive =
      OperationParam("timeToLive");
  static OperationParam globalEntityServiceData = OperationParam("data");
  static OperationParam globalEntityServiceAcl = OperationParam("acl");
  static OperationParam globalEntityServiceVersion = OperationParam("version");
  static OperationParam globalEntityServiceMaxReturn =
      OperationParam("maxReturn");
  static OperationParam globalEntityServiceWhere = OperationParam("where");
  static OperationParam globalEntityServiceOrderBy = OperationParam("orderBy");
  static OperationParam globalEntityServiceContext = OperationParam("context");
  static OperationParam globalEntityServicePageOffset =
      OperationParam("pageOffset");
  static OperationParam globalEntityServiceHint = OperationParam("hintJson");
  static OperationParam ownerId = OperationParam("ownerId");

  // Event Service - Send Params
  static OperationParam eventServiceSendToId = OperationParam("toId");
  static OperationParam eventServiceSendEventType = OperationParam("eventType");
  static OperationParam eventServiceSendEventId = OperationParam("eventId");
  static OperationParam eventServiceSendEventData = OperationParam("eventData");
  static OperationParam eventServiceSendRecordLocally =
      OperationParam("recordLocally");

  // Event Service - Update Event Data Params
  static OperationParam eventServiceUpdateEventDataFromId =
      OperationParam("fromId");
  static OperationParam eventServiceUpdateEventDataEventId =
      OperationParam("eventId");
  static OperationParam eventServiceUpdateEventDataData =
      OperationParam("eventData");
  static OperationParam evId = OperationParam("evId");
  static OperationParam eventServiceEvIds = OperationParam("evIds");
  static OperationParam eventServiceDateMillis = OperationParam("dateMillis");
  static OperationParam eventServiceEventType = OperationParam("eventType");

  // Event Service - Delete Incoming Params
  static OperationParam eventServiceDeleteIncomingEventId =
      OperationParam("eventId");
  static OperationParam eventServiceDeleteIncomingFromId =
      OperationParam("fromId");

  // Event Service - Delete Sent Params
  static OperationParam eventServiceDeleteSentEventId =
      OperationParam("eventId");
  static OperationParam eventServiceDeleteSentToId = OperationParam("toId");
  static OperationParam eventServiceIncludeIncomingEvents =
      OperationParam("includeIncomingEvents");
  static OperationParam eventServiceIncludeSentEvents =
      OperationParam("includeSentEvents");

  // Friend Service - Params
  static OperationParam friendServiceEntityId = OperationParam("entityId");
  static OperationParam friendServiceExternalId = OperationParam("externalId");
  static OperationParam friendServiceExternalIds =
      OperationParam("externalIds");
  static OperationParam friendServiceProfileId = OperationParam("profileId");
  static OperationParam friendServiceFriendId = OperationParam("friendId");
  static OperationParam friendServiceAuthenticationType =
      OperationParam("authenticationType");
  static OperationParam externalAuthType = OperationParam("externalAuthType");
  static OperationParam friendServiceEntityType = OperationParam("entityType");
  static OperationParam friendServiceEntitySubtype =
      OperationParam("entitySubtype");
  static OperationParam friendServiceIncludeSummaryData =
      OperationParam("includeSummaryData");
  static OperationParam friendServiceFriendPlatform =
      OperationParam("friendPlatform");
  static OperationParam friendServiceProfileIds = OperationParam("profileIds");
  static OperationParam friendServiceMode = OperationParam("mode");

  // Friend Service operations
  //static Operation FriendServiceReadFriends = Operation("READ_FRIENDS");

  // Friend Service - Read Player State Params
  static OperationParam friendServiceReadPlayerStateFriendId =
      OperationParam("friendId");
  static OperationParam friendServiceSearchText = OperationParam("searchText");
  static OperationParam friendServiceMaxResults = OperationParam("maxResults");

  // Friend Data Service - Read Friends Params (C++ only?)
  //static Operation FriendDataServiceReadFriends = Operation("");
  //friendIdList;
  //friendIdCount;

  //Achievements Event Data Params
  static OperationParam gamificationServiceAchievementsName =
      OperationParam("achievements");
  static OperationParam gamificationServiceAchievementsData =
      OperationParam("data");
  static OperationParam gamificationServiceAchievementsGranted =
      OperationParam("achievementsGranted");
  static OperationParam gamificationServiceCategory =
      OperationParam("category");
  static OperationParam gamificationServiceMilestones =
      OperationParam("milestones");
  static OperationParam gamificationServiceIncludeMetaData =
      OperationParam("includeMetaData");

  // Player Statistic Event Params
  static OperationParam playerStatisticEventServiceEventName =
      OperationParam("eventName");
  static OperationParam playerStatisticEventServiceEventMultiplier =
      OperationParam("eventMultiplier");
  static OperationParam playerStatisticEventServiceEvents =
      OperationParam("events");

  // Presence Params
  static OperationParam presenceServicePlatform = OperationParam("platform");
  static OperationParam presenceServiceIncludeOffline =
      OperationParam("includeOffline");
  static OperationParam presenceServiceGroupId = OperationParam("groupId");
  static OperationParam presenceServiceProfileIds =
      OperationParam("profileIds");
  static OperationParam presenceServiceBidirectional =
      OperationParam("bidirectional");
  static OperationParam presenceServiceVisibile = OperationParam("visible");
  static OperationParam presenceServiceActivity = OperationParam("activity");

  // Player State Service - Read Params
  static OperationParam playerStateServiceReadEntitySubtype =
      OperationParam("entitySubType");

  // Player State Service - Update Summary Params
  static OperationParam playerStateServiceUpdateSummaryFriendData =
      OperationParam("summaryFriendData");
  static OperationParam playerStateServiceUpdateNameData =
      OperationParam("playerName");
  static OperationParam playerStateServiceTimeZoneOffset =
      OperationParam("timeZoneOffset");
  static OperationParam playerStateServiceLanguageCode =
      OperationParam("languageCode");

  // Player State Service - Atributes
  static OperationParam playerStateServiceAttributes =
      OperationParam("attributes");
  static OperationParam playerStateServiceWipeExisting =
      OperationParam("wipeExisting");

  static OperationParam playerStateServiceIncludeSummaryData =
      OperationParam("includePlayerSummaryData");

  // Player State Service - UPDATE_PICTURE_URL
  static OperationParam playerStateServicePlayerPictureUrl =
      OperationParam("playerPictureUrl");
  static OperationParam playerStateServiceContactEmail =
      OperationParam("contactEmail");

  // Player State Service - Reset Params
  //static Operation PlayerStateServiceReset = Operation("");

  // Player Statistics Service - Update Increment Params
  static OperationParam playerStatisticsServiceStats =
      OperationParam("statistics");
  static OperationParam playerStatisticsServiceStatNames =
      OperationParam("statNames");
  static OperationParam playerStatisticsExperiencePoints =
      OperationParam("xp_points");

  // Player Statistics Service - Status Param
  static OperationParam playerStateServiceStatusName =
      OperationParam("statusName");

  // Player Statistics Service - Extend User Status Params
  static OperationParam playerStateServiceAdditionalSecs =
      OperationParam("additionalSecs");
  static OperationParam playerStateServiceDetails = OperationParam("details");

  static OperationParam playerStateServiceDurationSecs =
      OperationParam("durationSecs");

  // Player Statistics Service - Read Params
  static OperationParam playerStatisticsServiceReadEntitySubType =
      OperationParam("entitySubType");

  //static Operation PlayerStatisticsServiceDelete = Operation("DELETE");

  // Push Notification Service operations (C++ only??)
  //static Operation PushNotificationServiceCreate = Operation("CREATE");
  //static Operation PushNotificationServiceRegister = Operation("REGISTER");

  // Social Leaderboard Service - general parameters
  static OperationParam socialLeaderboardServiceLeaderboardId =
      OperationParam("leaderboardId");
  static OperationParam socialLeaderboardServiceLeaderboardIds =
      OperationParam("leaderboardIds");
  static OperationParam socialLeaderboardServiceReplaceName =
      OperationParam("replaceName");
  static OperationParam socialLeaderboardServiceScore = OperationParam("score");
  static OperationParam socialLeaderboardServiceScoreData =
      OperationParam("scoreData");
  static OperationParam socialLeaderboardServiceConfigJson =
      OperationParam("configJson");
  static OperationParam socialLeaderboardServiceData = OperationParam("data");
  static OperationParam socialLeaderboardServiceEventName =
      OperationParam("eventName");
  static OperationParam socialLeaderboardServiceEventMultiplier =
      OperationParam("eventMultiplier");
  static OperationParam socialLeaderboardServiceLeaderboardType =
      OperationParam("leaderboardType");
  static OperationParam socialLeaderboardServiceRotationType =
      OperationParam("rotationType");
  static OperationParam socialLeaderboardServiceRotationReset =
      OperationParam("rotationReset");
  static OperationParam socialLeaderboardServiceRetainedCount =
      OperationParam("retainedCount");
  static OperationParam numDaysToRotate = OperationParam("numDaysToRotate");
  static OperationParam socialLeaderboardServiceFetchType =
      OperationParam("fetchType");
  static OperationParam socialLeaderboardServiceMaxResults =
      OperationParam("maxResults");
  static OperationParam socialLeaderboardServiceSort = OperationParam("sort");
  static OperationParam socialLeaderboardServiceStartIndex =
      OperationParam("startIndex");
  static OperationParam socialLeaderboardServiceEndIndex =
      OperationParam("endIndex");
  static OperationParam socialLeaderboardServiceBeforeCount =
      OperationParam("beforeCount");
  static OperationParam socialLeaderboardServiceAfterCount =
      OperationParam("afterCount");
  static OperationParam socialLeaderboardServiceIncludeLeaderboardSize =
      OperationParam("includeLeaderboardSize");
  static OperationParam socialLeaderboardServiceVersionId =
      OperationParam("versionId");
  static OperationParam socialLeaderboardServiceLeaderboardResultCount =
      OperationParam("leaderboardResultCount");
  static OperationParam socialLeaderboardServiceGroupId =
      OperationParam("groupId");
  static OperationParam socialLeaderboardServiceProfileIds =
      OperationParam("profileIds");
  static OperationParam socialLeaderboardServiceRotationResetTime =
      OperationParam("rotationResetTime");

  // Social Leaderboard Service - Reset Score Params
  //static Operation SocialLeaderboardServiceResetScore = Operation("");

  // Product Service
  static OperationParam productServiceCurrencyId = OperationParam("vc_id");
  static OperationParam productServiceCurrencyAmount =
      OperationParam("vc_amount");

  // AppStore
  static OperationParam appStoreServiceStoreId = OperationParam("storeId");
  static OperationParam appStoreServiceReceiptData =
      OperationParam("receiptData");
  static OperationParam appStoreServicePurchaseData =
      OperationParam("purchaseData");
  static OperationParam appStoreServiceTransactionId =
      OperationParam("transactionId");
  static OperationParam appStoreServiceTransactionData =
      OperationParam("transactionData");
  static OperationParam appStoreServicePriceInfoCriteria =
      OperationParam("priceInfoCriteria");
  static OperationParam appStoreServiceUserCurrency =
      OperationParam("userCurrency");
  static OperationParam appStoreServiceCategory = OperationParam("category");

  // Virtual Currency Service
  static OperationParam virtualCurrencyServiceCurrencyId =
      OperationParam("vcId");
  static OperationParam virtualCurrencyServiceCurrencyAmount =
      OperationParam("vcAmount");

  // Product Service - Get Inventory Params
  static OperationParam productServiceGetInventoryPlatform =
      OperationParam("platform");
  static OperationParam productServiceGetInventoryUserCurrency =
      OperationParam("user_currency");
  static OperationParam productServiceGetInventoryCategory =
      OperationParam("category");

  // Product Service - Op Cash In Receipt Params
  static OperationParam productServiceOpCashInReceiptReceipt =
      OperationParam("receipt"); //C++ only
  static OperationParam productServiceOpCashInReceiptUrl =
      OperationParam("url"); //C++ only

  // Product Service - Reset Player VC Params
  //static OperationParam productServiceResetPlayerVC = OperationParam("");

  // Heartbeat Service - Params
  //static OperationParam heartbeatService = OperationParam("");

  // Time Service - Params
  //static OperationParam timeService = OperationParam("");

  // Server Time Service - Read Params
  static OperationParam serverTimeServiceRead = OperationParam("");

  // data creation parms
  static OperationParam serviceMessageService = OperationParam("service");
  static OperationParam serviceMessageOperation = OperationParam("operation");
  static OperationParam serviceMessageData = OperationParam("data");

  // data bundle creation parms
  static OperationParam serviceMessagePacketId = OperationParam("packetId");
  static OperationParam serviceMessageSessionId = OperationParam("sessionId");
  static OperationParam serviceMessageGameId = OperationParam("gameId");
  static OperationParam serviceMessageMessages = OperationParam("messages");
  static OperationParam profileId = OperationParam("profileId");

  // Error Params
  static OperationParam serviceMessageReasonCode =
      OperationParam("reason_code");
  static OperationParam serviceMessageStatusMessage =
      OperationParam("status_message");

  static OperationParam deviceRegistrationTypeIos = OperationParam("IOS");
  static OperationParam deviceRegistrationTypeAndroid = OperationParam("ANG");

  static OperationParam scriptServiceRunScriptName =
      OperationParam("scriptName");
  static OperationParam scriptServiceRunScriptData =
      OperationParam("scriptData");
  static OperationParam scriptServiceStartDateUTC =
      OperationParam("startDateUTC");
  static OperationParam scriptServiceStartMinutesFromNow =
      OperationParam("minutesFromNow");
  static OperationParam scriptServiceParentLevel =
      OperationParam("parentLevel");
  static OperationParam scriptServiceJobId = OperationParam("jobId");

  static OperationParam matchMakingServicePlayerRating =
      OperationParam("playerRating");
  static OperationParam matchMakingServiceMinutes = OperationParam("minutes");
  static OperationParam matchMakingServiceRangeDelta =
      OperationParam("rangeDelta");
  static OperationParam matchMakingServiceNumMatches =
      OperationParam("numMatches");
  static OperationParam matchMakingServiceAttributes =
      OperationParam("attributes");
  static OperationParam matchMakingServiceExtraParams =
      OperationParam("extraParms");
  static OperationParam matchMakingServicePlayerId = OperationParam("playerId");
  static OperationParam matchMakingServicePlaybackStreamId =
      OperationParam("playbackStreamId");

  static OperationParam offlineMatchServicePlayerId =
      OperationParam("playerId");
  static OperationParam offlineMatchServiceRangeDelta =
      OperationParam("rangeDelta");
  static OperationParam offlineMatchServicePlaybackStreamId =
      OperationParam("playbackStreamId");

  static OperationParam playbackStreamServiceTargetPlayerId =
      OperationParam("targetPlayerId");
  static OperationParam playbackStreamServiceInitiatingPlayerId =
      OperationParam("initiatingPlayerId");
  static OperationParam playbackStreamServiceMaxNumberOfStreams =
      OperationParam("maxNumStreams");
  static OperationParam playbackStreamServiceIncludeSharedData =
      OperationParam("includeSharedData");
  static OperationParam playbackStreamServicePlaybackStreamId =
      OperationParam("playbackStreamId");
  static OperationParam playbackStreamServiceEventData =
      OperationParam("eventData");
  static OperationParam playbackStreamServiceSummary =
      OperationParam("summary");

  static OperationParam productServiceTransId = OperationParam("transId");
  static OperationParam productServiceOrderId = OperationParam("orderId");
  static OperationParam productServiceProductId = OperationParam("productId");
  static OperationParam productServiceLanguage = OperationParam("language");
  static OperationParam productServiceItemId = OperationParam("itemId");
  static OperationParam productServiceReceipt = OperationParam("receipt");
  static OperationParam productServiceSignedRequest =
      OperationParam("signed_request");
  static OperationParam productServiceToken = OperationParam("token");

  //S3 Service
  static OperationParam s3HandlingServiceFileCategory =
      OperationParam("category");
  static OperationParam s3HandlingServiceFileDetails =
      OperationParam("fileDetails");
  static OperationParam s3HandlingServiceFileId = OperationParam("fileId");

  //Shared Identity
  static OperationParam identityServiceForceSingleton =
      OperationParam("forceSingleton");

  //RedemptionCode
  static OperationParam redemptionCodeServiceScanCode =
      OperationParam("scanCode");
  static OperationParam redemptionCodeServiceCodeType =
      OperationParam("codeType");
  static OperationParam redemptionCodeServiceCustomRedemptionInfo =
      OperationParam("customRedemptionInfo");

  //DataStream
  static OperationParam dataStreamEventName = OperationParam("eventName");
  static OperationParam dataStreamEventProperties =
      OperationParam("eventProperties");
  static OperationParam dataStreamCrashType = OperationParam("crashType");
  static OperationParam dataStreamErrorMsg = OperationParam("errorMsg");
  static OperationParam dataStreamCrashInfo = OperationParam("crashJson");
  static OperationParam dataStreamCrashLog = OperationParam("crashLog");
  static OperationParam dataStreamUserName = OperationParam("userName");
  static OperationParam dataStreamUserEmail = OperationParam("userEmail");
  static OperationParam dataStreamUserNotes = OperationParam("userNotes");
  static OperationParam dataStreamUserSubmitted =
      OperationParam("userSubmitted");

  // Profanity
  static OperationParam profanityText = OperationParam("text");
  static OperationParam profanityReplaceSymbol =
      OperationParam("replaceSymbol");
  static OperationParam profanityFlagEmail = OperationParam("flagEmail");
  static OperationParam profanityFlagPhone = OperationParam("flagPhone");
  static OperationParam profanityFlagUrls = OperationParam("flagUrls");
  static OperationParam profanityLanguages = OperationParam("languages");

  //File upload
  static OperationParam uploadLocalPath = OperationParam("localPath");
  static OperationParam uploadCloudPath = OperationParam("cloudPath");
  static OperationParam uploadCloudFilename = OperationParam("cloudFilename");
  static OperationParam uploadShareable = OperationParam("shareable");
  static OperationParam uploadReplaceIfExists =
      OperationParam("replaceIfExists");
  static OperationParam uploadFileSize = OperationParam("fileSize");
  static OperationParam uploadRecurse = OperationParam("recurse");
  static OperationParam uploadPath = OperationParam("path");

  //group
  static OperationParam groupId = OperationParam("groupId");
  static OperationParam groupProfileId = OperationParam("profileId");
  static OperationParam groupRole = OperationParam("role");
  static OperationParam groupAttributes = OperationParam("attributes");
  static OperationParam groupName = OperationParam("name");
  static OperationParam groupType = OperationParam("groupType");
  static OperationParam groupTypes = OperationParam("groupTypes");
  static OperationParam groupEntityType = OperationParam("entityType");
  static OperationParam groupIsOpenGroup = OperationParam("isOpenGroup");
  static OperationParam groupAcl = OperationParam("acl");
  static OperationParam groupData = OperationParam("data");
  static OperationParam groupOwnerAttributes =
      OperationParam("ownerAttributes");
  static OperationParam groupDefaultMemberAttributes =
      OperationParam("defaultMemberAttributes");
  static OperationParam groupIsOwnedByGroupMember =
      OperationParam("isOwnedByGroupMember");
  static OperationParam groupSummaryData = OperationParam("summaryData");
  static OperationParam groupEntityId = OperationParam("entityId");
  static OperationParam groupVersion = OperationParam("version");
  static OperationParam groupContext = OperationParam("context");
  static OperationParam groupPageOffset = OperationParam("pageOffset");
  static OperationParam groupAutoJoinStrategy =
      OperationParam("autoJoinStrategy");
  static OperationParam groupWhere = OperationParam("where");
  static OperationParam groupMaxReturn = OperationParam("maxReturn");

  //group file
  static OperationParam folderPath = OperationParam("folderPath");
  static OperationParam fileName = OperationParam("filename");
  static OperationParam fullPathFilename = OperationParam("fullPathFilename");
  static OperationParam fileId = OperationParam("fileId");
  static OperationParam version = OperationParam("version");
  static OperationParam newTreeId = OperationParam("newTreeId");
  static OperationParam treeVersion = OperationParam("treeVersion");
  static OperationParam newFilename = OperationParam("newFilename");
  static OperationParam overwriteIfPresent =
      OperationParam("overwriteIfPresent");
  static OperationParam recurse = OperationParam("recurse");
  static OperationParam userCloudPath = OperationParam("userCloudPath");
  static OperationParam userCloudFilename = OperationParam("userCloudFilename");
  static OperationParam groupTreeId = OperationParam("groupTreeId");
  static OperationParam groupFilename = OperationParam("groupFilename");
  static OperationParam groupFileACL = OperationParam("groupFileAcl");
  static OperationParam newACL = OperationParam("newAcl");

  //GlobalFile
  static OperationParam globalFileServiceFileId = OperationParam("fileId");
  static OperationParam globalFileServiceFolderPath =
      OperationParam("folderPath");
  static OperationParam globalFileServiceFileName = OperationParam("filename");
  static OperationParam globalFileServiceRecurse = OperationParam("recurse");

  //mail
  static OperationParam subject = OperationParam("subject");
  static OperationParam body = OperationParam("body");
  static OperationParam serviceParams = OperationParam("serviceParams");
  static OperationParam emailAddress = OperationParam("emailAddress");

  static OperationParam leaderboardId = OperationParam("leaderboardId");
  static OperationParam divSetId = OperationParam("divSetId");
  static OperationParam versionId = OperationParam("versionId");
  static OperationParam tournamentCode = OperationParam("tournamentCode");
  static OperationParam initialScore = OperationParam("initialScore");
  static OperationParam score = OperationParam("score");
  static OperationParam roundStartedEpoch = OperationParam("roundStartedEpoch");
  static OperationParam data = OperationParam("data");

  // chat
  static OperationParam chatChannelId = OperationParam("channelId");
  static OperationParam chatMaxReturn = OperationParam("maxReturn");
  static OperationParam chatMessageId = OperationParam("msgId");
  static OperationParam chatVersion = OperationParam("version");

  static OperationParam chatChannelType = OperationParam("channelType");
  static OperationParam chatChannelSubId = OperationParam("channelSubId");
  static OperationParam chatContent = OperationParam("content");
  static OperationParam chatText = OperationParam("text");

  static OperationParam chatRich = OperationParam("rich");
  static OperationParam chatRecordInHistory = OperationParam("recordInHistory");

  // TODO:: do we enumerate these ? [smrj]
  // chat channel types
  static OperationParam allChannelType = OperationParam("all");
  static OperationParam globalChannelType = OperationParam("gl");
  static OperationParam groupChannelType = OperationParam("gr");

  // messaging
  static OperationParam messagingMessageBox = OperationParam("msgbox");
  static OperationParam messagingMessageIds = OperationParam("msgIds");
  static OperationParam messagingMarkAsRead = OperationParam("markAsRead");
  static OperationParam messagingContext = OperationParam("context");
  static OperationParam messagingPageOffset = OperationParam("pageOffset");
  static OperationParam messagingFromName = OperationParam("fromName");
  static OperationParam messagingToProfileIds = OperationParam("toProfileIds");
  static OperationParam messagingContent = OperationParam("contentJson");
  static OperationParam messagingSubject = OperationParam("subject");
  static OperationParam messagingText = OperationParam("text");

  static OperationParam inboxMessageType = OperationParam("inbox");
  static OperationParam sentMessageType = OperationParam("sent");

  // lobby
  static OperationParam lobbyRoomType = OperationParam("lobbyType");
  static OperationParam lobbyTypes = OperationParam("lobbyTypes");
  static OperationParam lobbyRating = OperationParam("rating");
  static OperationParam lobbyAlgorithm = OperationParam("algo");
  static OperationParam lobbyMaxSteps = OperationParam("maxSteps");
  static OperationParam lobbyStrategy = OperationParam("strategy");
  static OperationParam lobbyAlignment = OperationParam("alignment");
  static OperationParam lobbyRanges = OperationParam("ranges");
  static OperationParam lobbyFilterJson = OperationParam("filterJson");
  static OperationParam lobbySettings = OperationParam("settings");
  static OperationParam lobbyTimeoutSeconds = OperationParam("timeoutSecs");
  static OperationParam lobbyIsReady = OperationParam("isReady");
  static OperationParam lobbyOtherUserCxIds = OperationParam("otherUserCxIds");
  static OperationParam lobbyExtraJson = OperationParam("extraJson");
  static OperationParam lobbyTeamCode = OperationParam("teamCode");
  static OperationParam lobbyIdentifier = OperationParam("lobbyId");
  static OperationParam lobbyToTeamName = OperationParam("toTeamCode");
  static OperationParam lobbySignalData = OperationParam("signalData");
  static OperationParam lobbyConnectionId = OperationParam("cxId");
  static OperationParam pingData = OperationParam("pingData");
  static OperationParam lobbyMinRating = OperationParam("minRating");
  static OperationParam lobbyMaxRating = OperationParam("maxRating");

  static OperationParam compoundAlgos = OperationParam("algos");
  static OperationParam compoundRanges = OperationParam("compound-ranges");
  static OperationParam lobbyCritera = OperationParam("criteriaJson");
  static OperationParam criteraPing = OperationParam("ping");
  static OperationParam criteraRating = OperationParam("rating");
  static OperationParam strategyRangedPercent =
      OperationParam("ranged-percent");
  static OperationParam strategyRangedAbsolute =
      OperationParam("ranged-absolute");
  static OperationParam strategyAbsolute = OperationParam("absolute");
  static OperationParam strategyCompound = OperationParam("compound");
  static OperationParam alignmentCenter = OperationParam("center");
  //custom entity
  static OperationParam customEntityServiceEntityType =
      OperationParam("entityType");
  static OperationParam customEntityServiceDeleteCriteria =
      OperationParam("deleteCriteria");
  static OperationParam customEntityServiceEntityId =
      OperationParam("entityId");
  static OperationParam customEntityServiceVersion = OperationParam("version");
  static OperationParam customEntityServiceFieldsJson =
      OperationParam("fieldsJson");
  static OperationParam customEntityServiceWhereJson =
      OperationParam("whereJson");
  static OperationParam customEntityServiceRowsPerPage =
      OperationParam("rowsPerPage");
  static OperationParam customEntityServiceSearchJson =
      OperationParam("searchJson");
  static OperationParam customEntityServiceSortJson =
      OperationParam("sortJson");
  static OperationParam customEntityServiceDoCount = OperationParam("doCount");
  static OperationParam customEntityServiceContext = OperationParam("context");
  static OperationParam customEntityServicePageOffset =
      OperationParam("pageOffset");
  static OperationParam customEntityServiceTimeToLive =
      OperationParam("timeToLive");
  static OperationParam customEntityServiceAcl = OperationParam("acl");
  static OperationParam customEntityServiceDataJson =
      OperationParam("dataJson");
  static OperationParam customEntityServiceIsOwned = OperationParam("isOwned");
  static OperationParam customEntityServiceMaxReturn =
      OperationParam("maxReturn");
  static OperationParam customEntityServiceShardKeyJson =
      OperationParam("shardKeyJson");

  //item catalog
  static OperationParam itemCatalogServiceDefId = OperationParam("defId");
  static OperationParam itemCatalogServiceContext = OperationParam("context");
  static OperationParam itemCatalogServicePageOffset =
      OperationParam("pageOffset");

  //userInventory
  static OperationParam userItemsServiceDefId = OperationParam("defId");
  static OperationParam userItemsServiceQuantity = OperationParam("quantity");
  static OperationParam userItemsServiceIncludeDef =
      OperationParam("includeDef");
  static OperationParam userItemsServiceItemId = OperationParam("itemId");
  static OperationParam userItemsServiceCriteria = OperationParam("criteria");
  static OperationParam userItemsServiceContext = OperationParam("context");
  static OperationParam userItemsServicePageOffset =
      OperationParam("pageOffset");
  static OperationParam userItemsServiceVersion = OperationParam("version");
  static OperationParam userItemsServiceImmediate = OperationParam("immediate");
  static OperationParam userItemsServiceProfileId = OperationParam("profileId");
  static OperationParam userItemsServiceShopId = OperationParam("shopId");
  static OperationParam userItemsServiceNewItemData =
      OperationParam("newItemData");

  //global app
  static OperationParam globalAppPropertyNames =
      OperationParam("propertyNames");
  static OperationParam globalAppCategories = OperationParam("categories");

  OperationParam(String value) {
    _value = value;
  }

  late String _value;

  String get value => _value;
}
