class ServiceOperation {
  static ServiceOperation authenticate = ServiceOperation._("AUTHENTICATE");
  static ServiceOperation attach = ServiceOperation._("ATTACH");
  static ServiceOperation merge = ServiceOperation._("MERGE");
  static ServiceOperation detach = ServiceOperation._("DETACH");
  static ServiceOperation resetEmailPassword =
      ServiceOperation._("RESET_EMAIL_PASSWORD");
  static ServiceOperation resetEmailPasswordWithExpiry =
      ServiceOperation._("RESET_EMAIL_PASSWORD_WITH_EXPIRY");
  static ServiceOperation resetEmailPasswordAdvanced =
      ServiceOperation._("RESET_EMAIL_PASSWORD_ADVANCED");
  static ServiceOperation resetEmailPasswordAdvancedWithExpiry =
      ServiceOperation._("RESET_EMAIL_PASSWORD_ADVANCED_WITH_EXPIRY");
  static ServiceOperation resetUniversalIdPassword =
      ServiceOperation._("RESET_UNIVERSAL_ID_PASSWORD");
  static ServiceOperation resetUniversalIdPasswordWithExpiry =
      ServiceOperation._("RESET_UNIVERSAL_ID_PASSWORD_WITH_EXPIRY");
  static ServiceOperation resetUniversalIdPasswordAdvanced =
      ServiceOperation._("RESET_UNIVERSAL_ID_PASSWORD_ADVANCED");
  static ServiceOperation resetUniversalIdPasswordAdvancedWithExpiry =
      ServiceOperation._("RESET_UNIVERSAL_ID_PASSWORD_ADVANCED_WITH_EXPIRY");
  static ServiceOperation switchToChildProfile =
      ServiceOperation._("SWITCH_TO_CHILD_PROFILE");
  static ServiceOperation switchToParentProfile =
      ServiceOperation._("SWITCH_TO_PARENT_PROFILE");
  static ServiceOperation detachParent = ServiceOperation._("DETACH_PARENT");
  static ServiceOperation attachParentWithIdentity =
      ServiceOperation._("ATTACH_PARENT_WITH_IDENTITY");
  static ServiceOperation attachNonLoginUniversalId =
      ServiceOperation._("ATTACH_NONLOGIN_UNIVERSAL");
  static ServiceOperation updateUniversalIdLogin =
      ServiceOperation._("UPDATE_UNIVERSAL_LOGIN");

  static ServiceOperation attachBlockChain =
      ServiceOperation._("ATTACH_BLOCKCHAIN_IDENTITY");
  static ServiceOperation detachBlockChain =
      ServiceOperation._("DETACH_BLOCKCHAIN_IDENTITY");
  static ServiceOperation getBlockchainItems =
      ServiceOperation._("GET_BLOCKCHAIN_ITEMS");
  static ServiceOperation getUniqs = ServiceOperation._("GET_UNIQS");

  static ServiceOperation create = ServiceOperation._("CREATE");
  static ServiceOperation createWithIndexedId =
      ServiceOperation._("CREATE_WITH_INDEXED_ID");
  static ServiceOperation reset = ServiceOperation._("RESET");
  static ServiceOperation read = ServiceOperation._("READ");
  static ServiceOperation readSingleton = ServiceOperation._("READ_SINGLETON");
  static ServiceOperation readByType = ServiceOperation._("READ_BY_TYPE");
  static ServiceOperation verify = ServiceOperation._("VERIFY");
  static ServiceOperation readShared = ServiceOperation._("READ_SHARED");
  static ServiceOperation readSharedEntity =
      ServiceOperation._("READ_SHARED_ENTITY");
  static ServiceOperation updateEntityIndexedId =
      ServiceOperation._("UPDATE_INDEXED_ID");
  static ServiceOperation updateEntityOwnerAndAcl =
      ServiceOperation._("UPDATE_ENTITY_OWNER_AND_ACL");
  static ServiceOperation makeSystemEntity =
      ServiceOperation._("MAKE_SYSTEM_ENTITY");
  static ServiceOperation getServerVersion = ServiceOperation._("GET_SERVER_VERSION");

  // push notification
  static ServiceOperation deregisterAll = ServiceOperation._("DEREGISTER_ALL");
  static ServiceOperation deregister = ServiceOperation._("DEREGISTER");
  static ServiceOperation register = ServiceOperation._("REGISTER");
  static ServiceOperation sendSimple = ServiceOperation._("SEND_SIMPLE");
  static ServiceOperation sendRich = ServiceOperation._("SEND_RICH");
  static ServiceOperation sendRaw = ServiceOperation._("SEND_RAW");
  static ServiceOperation sendRawBatch = ServiceOperation._("SEND_RAW_BATCH");
  static ServiceOperation sendRawToGroup =
      ServiceOperation._("SEND_RAW_TO_GROUP");
  static ServiceOperation sendTemplatedToGroup =
      ServiceOperation._("SEND_TEMPLATED_TO_GROUP");
  static ServiceOperation sendNormalizedToGroup =
      ServiceOperation._("SEND_NORMALIZED_TO_GROUP");
  static ServiceOperation sendNormalized =
      ServiceOperation._("SEND_NORMALIZED");
  static ServiceOperation sendNormalizedBatch =
      ServiceOperation._("SEND_NORMALIZED_BATCH");
  static ServiceOperation scheduleRichNotification =
      ServiceOperation._("SCHEDULE_RICH_NOTIFICATION");
  static ServiceOperation scheduleNormalizedNotification =
      ServiceOperation._("SCHEDULE_NORMALIZED_NOTIFICATION");

  static ServiceOperation scheduleRawNotification =
      ServiceOperation._("SCHEDULE_RAW_NOTIFICATION");

  static ServiceOperation fullReset = ServiceOperation._("FULL_PLAYER_RESET");
  static ServiceOperation dataReset = ServiceOperation._("GAME_DATA_RESET");

  static ServiceOperation processStatistics =
      ServiceOperation._("PROCESS_STATISTICS");
  static ServiceOperation update = ServiceOperation._("UPDATE");
  static ServiceOperation updateShared = ServiceOperation._("UPDATE_SHARED");
  static ServiceOperation updateAcl = ServiceOperation._("UPDATE_ACL");
  static ServiceOperation updateTimeToLive =
      ServiceOperation._("UPDATE_TIME_TO_LIVE");
  static ServiceOperation updatePartial = ServiceOperation._("UPDATE_PARTIAL");
  static ServiceOperation updateSingleton =
      ServiceOperation._("UPDATE_SINGLETON");
  static ServiceOperation delete = ServiceOperation._("DELETE");
  static ServiceOperation deleteSingleton =
      ServiceOperation._("DELETE_SINGLETON");
  static ServiceOperation updateSummary = ServiceOperation._("UPDATE_SUMMARY");
  static ServiceOperation updateSetMinimum =
      ServiceOperation._("UPDATE_SET_MINIMUM");
  static ServiceOperation updateIncrementToMaximum =
      ServiceOperation._("UPDATE_INCREMENT_TO_MAXIMUM");
  static ServiceOperation getFriendProfileInfoForExternalId =
      ServiceOperation._("GET_FRIEND_PROFILE_INFO_FOR_EXTERNAL_ID");
  static ServiceOperation getProfileInfoForCredential =
      ServiceOperation._("GET_PROFILE_INFO_FOR_CREDENTIAL");
  static ServiceOperation getProfileInfoForCredentialIfExists =
      ServiceOperation._("GET_PROFILE_INFO_FOR_CREDENTIAL_IF_EXISTS");
  static ServiceOperation getProfileInfoForExternalAuthId =
      ServiceOperation._("GET_PROFILE_INFO_FOR_EXTERNAL_AUTH_ID");
  static ServiceOperation getProfileInfoForExternalAuthIdIfExists =
      ServiceOperation._("GET_PROFILE_INFO_FOR_EXTERNAL_AUTH_ID_IF_EXISTS");
  static ServiceOperation getExternalIdForProfileId =
      ServiceOperation._("GET_EXTERNAL_ID_FOR_PROFILE_ID");
  static ServiceOperation findPlayerByUniversalId =
      ServiceOperation._("FIND_PLAYER_BY_UNIVERSAL_ID");
  static ServiceOperation findUserByExactUniversalId =
      ServiceOperation._("FIND_USER_BY_EXACT_UNIVERSAL_ID");
  static ServiceOperation findUsersByNameStartingWith =
      ServiceOperation._("FIND_USERS_BY_NAME_STARTING_WITH");
  static ServiceOperation findUsersByUniversalIdStartingWith =
      ServiceOperation._("FIND_USERS_BY_UNIVERSAL_ID_STARTING_WITH");
  static ServiceOperation readFriends = ServiceOperation._("READ_FRIENDS");
  static ServiceOperation readFriendEntity =
      ServiceOperation._("READ_FRIEND_ENTITY");
  static ServiceOperation readFriendsEntities =
      ServiceOperation._("READ_FRIENDS_ENTITIES");
  static ServiceOperation readFriendsWithApplication =
      ServiceOperation._("READ_FRIENDS_WITH_APPLICATION");
  static ServiceOperation readFriendPlayerState =
      ServiceOperation._("READ_FRIEND_PLAYER_STATE");
  static ServiceOperation getSummaryDataForProfileId =
      ServiceOperation._("GET_SUMMARY_DATA_FOR_PROFILE_ID");
  static ServiceOperation findPlayerByName =
      ServiceOperation._("FIND_PLAYER_BY_NAME");
  static ServiceOperation findUsersByExactName =
      ServiceOperation._("FIND_USERS_BY_EXACT_NAME");
  static ServiceOperation findUsersBySubstrName =
      ServiceOperation._("FIND_USERS_BY_SUBSTR_NAME");
  static ServiceOperation listFriends = ServiceOperation._("LIST_FRIENDS");
  static ServiceOperation getMySocialInfo =
      ServiceOperation._("GET_MY_SOCIAL_INFO");
  static ServiceOperation addFriends = ServiceOperation._("ADD_FRIENDS");
  static ServiceOperation addFriendsFromPlatform =
      ServiceOperation._("ADD_FRIENDS_FROM_PLATFORM");
  static ServiceOperation removeFriends = ServiceOperation._("REMOVE_FRIENDS");
  static ServiceOperation getUsersOnlineStatus =
      ServiceOperation._("GET_USERS_ONLINE_STATUS");
  static ServiceOperation getSocialLeaderboard =
      ServiceOperation._("GET_SOCIAL_LEADERBOARD");
  static ServiceOperation GetSocialLeaderboardIfExists =
      ServiceOperation._("GET_SOCIAL_LEADERBOARD_IF_EXISTS");
  static ServiceOperation getSocialLeaderboardByVersion =
      ServiceOperation._("GET_SOCIAL_LEADERBOARD_BY_VERSION");
  static ServiceOperation getSocialLeaderboardByVersionIfExists =
      ServiceOperation._("GET_SOCIAL_LEADERBOARD_BY_VERSION_IF_EXISTS");
  static ServiceOperation getMultiSocialLeaderboard =
      ServiceOperation._("GET_MULTI_SOCIAL_LEADERBOARD");
  static ServiceOperation getGlobalLeaderboard =
      ServiceOperation._("GET_GLOBAL_LEADERBOARD");
  static ServiceOperation getGlobalLeaderboardPage =
      ServiceOperation._("GET_GLOBAL_LEADERBOARD_PAGE");
  static ServiceOperation getGlobalLeaderboardPageIfExists =
      ServiceOperation._("GET_GLOBAL_LEADERBOARD_PAGE_IF_EXISTS");
  static ServiceOperation getGlobalLeaderboardView =
      ServiceOperation._("GET_GLOBAL_LEADERBOARD_VIEW");
  static ServiceOperation getGlobalLeaderboardViewIfExists =
      ServiceOperation._("GET_GLOBAL_LEADERBOARD_VIEW_IF_EXISTS");
  static ServiceOperation getGlobalLeaderboardVersions =
      ServiceOperation._("GET_GLOBAL_LEADERBOARD_VERSIONS");
  static ServiceOperation postScore = ServiceOperation._("POST_SCORE");
  static ServiceOperation postScoreDynamic =
      ServiceOperation._("POST_SCORE_DYNAMIC");
  static ServiceOperation postScoreDynamicUsingConfig =
      ServiceOperation._("POST_SCORE_DYNAMIC_USING_CONFIG");
  static ServiceOperation postScoreToDynamicGroupLeaderboard =
      ServiceOperation._("POST_GROUP_SCORE_DYNAMIC");
  static ServiceOperation postScoreToDynamicGroupLeaderboardUsingConfig =
      ServiceOperation._("POST_GROUP_SCORE_DYNAMIC_USING_CONFIG");
  static ServiceOperation removePlayerScore =
      ServiceOperation._("REMOVE_PLAYER_SCORE");
  static ServiceOperation getCompletedTournament =
      ServiceOperation._("GET_COMPLETED_TOURNAMENT");
  static ServiceOperation rewardTournament =
      ServiceOperation._("REWARD_TOURNAMENT");
  static ServiceOperation getGroupSocialLeaderboard =
      ServiceOperation._("GET_GROUP_SOCIAL_LEADERBOARD");
  static ServiceOperation getGroupSocialLeaderboardByVersion =
      ServiceOperation._("GET_GROUP_SOCIAL_LEADERBOARD_BY_VERSION");
  static ServiceOperation getPlayersSocialLeaderboard =
      ServiceOperation._("GET_PLAYERS_SOCIAL_LEADERBOARD");
  static ServiceOperation GetPlayersSocialLeaderboardIfExists =
      ServiceOperation._("GET_PLAYERS_SOCIAL_LEADERBOARD_IF_EXISTS");
  static ServiceOperation getPlayersSocialLeaderboardByVersion =
      ServiceOperation._("GET_PLAYERS_SOCIAL_LEADERBOARD_BY_VERSION");
  static ServiceOperation getPlayersSocialLeaderboardByVersionIfExists =
      ServiceOperation._("GET_PLAYERS_SOCIAL_LEADERBOARD_BY_VERSION_IF_EXISTS");
  static ServiceOperation listAllLeaderboards =
      ServiceOperation._("LIST_ALL_LEADERBOARDS");
  static ServiceOperation getGlobalLeaderboardEntryCount =
      ServiceOperation._("GET_GLOBAL_LEADERBOARD_ENTRY_COUNT");
  static ServiceOperation getPlayerScore =
      ServiceOperation._("GET_PLAYER_SCORE");
  static ServiceOperation getPlayerScores =
      ServiceOperation._("GET_PLAYER_SCORES");
  static ServiceOperation getPlayerScoresFromLeaderboards =
      ServiceOperation._("GET_PLAYER_SCORES_FROM_LEADERBOARDS");
  static ServiceOperation postScoreToGroupLeaderboard =
      ServiceOperation._("POST_GROUP_SCORE");
  static ServiceOperation removeGroupScore =
      ServiceOperation._("REMOVE_GROUP_SCORE");
  static ServiceOperation getGroupLeaderboardView =
      ServiceOperation._("GET_GROUP_LEADERBOARD_VIEW");

  static ServiceOperation readFriendsPlayerState =
      ServiceOperation._("READ_FRIEND_PLAYER_STATE");

  static ServiceOperation initThirdParty = ServiceOperation._("initThirdParty");
  static ServiceOperation postThirdPartyLeaderboardScore =
      ServiceOperation._("postThirdPartyLeaderboardScore");
  static ServiceOperation incrementThirdPartyLeaderboardScore =
      ServiceOperation._("incrementThirdPartyLeaderboardScore");
  static ServiceOperation launchAchievementUI =
      ServiceOperation._("launchAchievementUI");
  static ServiceOperation postThirdPartyLeaderboardAchievement =
      ServiceOperation._("postThirdPartyLeaderboardAchievement");
  static ServiceOperation isThirdPartyAchievementComplete =
      ServiceOperation._("isThirdPartyAchievementComplete");
  static ServiceOperation resetThirdPartyAchievements =
      ServiceOperation._("resetThirdPartyAchievements");
  static ServiceOperation queryThirdPartyAchievements =
      ServiceOperation._("queryThirdPartyAchievements");

  static ServiceOperation getInventory = ServiceOperation._("GET_INVENTORY");
  static ServiceOperation cashInReceipt =
      ServiceOperation._("OP_CASH_IN_RECEIPT");
  static ServiceOperation awardVC = ServiceOperation._("AWARD_VC");
  static ServiceOperation consumePlayerVC = ServiceOperation._("CONSUME_VC");
  static ServiceOperation getPlayerVC = ServiceOperation._("GET_PLAYER_VC");
  static ServiceOperation resetPlayerVC = ServiceOperation._("RESET_PLAYER_VC");

  static ServiceOperation awardParentCurrency =
      ServiceOperation._("AWARD_PARENT_VC");
  static ServiceOperation consumeParentCurrency =
      ServiceOperation._("CONSUME_PARENT_VC");
  static ServiceOperation getParentVC = ServiceOperation._("GET_PARENT_VC");
  static ServiceOperation resetParentCurrency =
      ServiceOperation._("RESET_PARENT_VC");

  static ServiceOperation getPeerVC = ServiceOperation._("GET_PEER_VC");
  static ServiceOperation startPurchase = ServiceOperation._("START_PURCHASE");
  static ServiceOperation finalizePurchase =
      ServiceOperation._("FINALIZE_PURCHASE");
  static ServiceOperation refreshPromotions =
      ServiceOperation._("REFRESH_PROMOTIONS");

  static ServiceOperation send = ServiceOperation._("SEND");
  static ServiceOperation sendEventToProfiles = ServiceOperation._("SEND_EVENT_TO_PROFILES");
  static ServiceOperation updateEventData =
      ServiceOperation._("UPDATE_EVENT_DATA");
  static ServiceOperation updateEventDataIfExists =
      ServiceOperation._("UPDATE_EVENT_DATA_IF_EXISTS");
  static ServiceOperation deleteSent = ServiceOperation._("DELETE_SENT");
  static ServiceOperation deleteIncoming =
      ServiceOperation._("DELETE_INCOMING");
  static ServiceOperation deleteIncomingEvents =
      ServiceOperation._("DELETE_INCOMING_EVENTS");
  static ServiceOperation deleteIncomingEventsOlderThan =
      ServiceOperation._("DELETE_INCOMING_EVENTS_OLDER_THAN");
  static ServiceOperation deleteIncomingEventsByTypeOlderThan =
      ServiceOperation._("DELETE_INCOMING_EVENTS_BY_TYPE_OLDER_THAN");
  static ServiceOperation getEvents = ServiceOperation._("GET_EVENTS");

  static ServiceOperation updateIncrement =
      ServiceOperation._("UPDATE_INCREMENT");
  static ServiceOperation readNextXpLevel =
      ServiceOperation._("READ_NEXT_XPLEVEL");
  static ServiceOperation readXpLevels = ServiceOperation._("READ_XP_LEVELS");
  static ServiceOperation setXpPoints = ServiceOperation._("SET_XPPOINTS");
  static ServiceOperation readSubset = ServiceOperation._("READ_SUBSET");

  //GlobalFile
  static ServiceOperation getFileInfo = ServiceOperation._("GET_FILE_INFO");
  static ServiceOperation getFileInfoSimple =
      ServiceOperation._("GET_FILE_INFO_SIMPLE");
  static ServiceOperation getGlobalCDNUrl =
      ServiceOperation._("GET_GLOBAL_CDN_URL");
  static ServiceOperation getGlobalFileList =
      ServiceOperation._("GET_GLOBAL_FILE_LIST");

  static ServiceOperation run = ServiceOperation._("RUN");
  static ServiceOperation tweet = ServiceOperation._("TWEET");

  static ServiceOperation awardAchievements =
      ServiceOperation._("AWARD_ACHIEVEMENTS");
  static ServiceOperation readAchievements =
      ServiceOperation._("READ_ACHIEVEMENTS");
  static ServiceOperation readAchievedAchievements =
      ServiceOperation._("READ_ACHIEVED_ACHIEVEMENTS");

  static ServiceOperation setPlayerRating =
      ServiceOperation._("SET_PLAYER_RATING");
  static ServiceOperation resetPlayerRating =
      ServiceOperation._("RESET_PLAYER_RATING");
  static ServiceOperation incrementPlayerRating =
      ServiceOperation._("INCREMENT_PLAYER_RATING");
  static ServiceOperation decrementPlayerRating =
      ServiceOperation._("DECREMENT_PLAYER_RATING");
  static ServiceOperation shieldOn = ServiceOperation._("SHIELD_ON");
  static ServiceOperation shieldOnFor = ServiceOperation._("SHIELD_ON_FOR");
  static ServiceOperation shieldOff = ServiceOperation._("SHIELD_OFF");
  static ServiceOperation incrementShieldOnFor =
      ServiceOperation._("INCREMENT_SHIELD_ON_FOR");
  static ServiceOperation getShieldExpiry =
      ServiceOperation._("GET_SHIELD_EXPIRY");
  static ServiceOperation findPlayers = ServiceOperation._("FIND_PLAYERS");
  static ServiceOperation findPlayersUsingFilter =
      ServiceOperation._("FIND_PLAYERS_USING_FILTER");

  static ServiceOperation submitTurn = ServiceOperation._("SUBMIT_TURN");
  static ServiceOperation updateMatchSummary =
      ServiceOperation._("UPDATE_SUMMARY");
  static ServiceOperation updateMatchStateCurrentTurn =
      ServiceOperation._("UPDATE_MATCH_STATE_CURRENT_TURN");
  static ServiceOperation abandon = ServiceOperation._("ABANDON");
  static ServiceOperation abandonMatchWithSummaryData =
      ServiceOperation._("ABANDON_MATCH_WITH_SUMMARY_DATA");
  static ServiceOperation completeMatchWithSummaryData =
      ServiceOperation._("COMPLETE_MATCH_WITH_SUMMARY_DATA");
  static ServiceOperation complete = ServiceOperation._("COMPLETE");
  static ServiceOperation readMatch = ServiceOperation._("READ_MATCH");
  static ServiceOperation readMatchHistory =
      ServiceOperation._("READ_MATCH_HISTORY");
  static ServiceOperation findMatches = ServiceOperation._("FIND_MATCHES");
  static ServiceOperation findMatchesCompleted =
      ServiceOperation._("FIND_MATCHES_COMPLETED");
  static ServiceOperation deleteMatch = ServiceOperation._("DELETE_MATCH");

  static ServiceOperation lastUploadStatus =
      ServiceOperation._("LAST_UPLOAD_STATUS");

  static ServiceOperation readQuests = ServiceOperation._("READ_QUESTS");
  static ServiceOperation readCompletedQuests =
      ServiceOperation._("READ_COMPLETED_QUESTS");
  static ServiceOperation readInProgressQuests =
      ServiceOperation._("READ_IN_PROGRESS_QUESTS");
  static ServiceOperation readNotStartedQuests =
      ServiceOperation._("READ_NOT_STARTED_QUESTS");
  static ServiceOperation readQuestsWithStatus =
      ServiceOperation._("READ_QUESTS_WITH_STATUS");
  static ServiceOperation readQuestsWithBasicPercentage =
      ServiceOperation._("READ_QUESTS_WITH_BASIC_PERCENTAGE");
  static ServiceOperation readQuestsWithComplexPercentage =
      ServiceOperation._("READ_QUESTS_WITH_COMPLEX_PERCENTAGE");
  static ServiceOperation readQuestsByCategory =
      ServiceOperation._("READ_QUESTS_BY_CATEGORY");
  static ServiceOperation resetMilestones =
      ServiceOperation._("RESET_MILESTONES");

  static ServiceOperation readForCategory =
      ServiceOperation._("READ_FOR_CATEGORY");

  static ServiceOperation readMilestones =
      ServiceOperation._("READ_MILESTONES");
  static ServiceOperation readMilestonesByCategory =
      ServiceOperation._("READ_MILESTONES_BY_CATEGORY");

  static ServiceOperation readCompletedMilestones =
      ServiceOperation._("READ_COMPLETED_MILESTONES");
  static ServiceOperation readInProgressMilestones =
      ServiceOperation._("READ_IN_PROGRESS_MILESTONES");

  static ServiceOperation trigger = ServiceOperation._("TRIGGER");
  static ServiceOperation triggerMultiple =
      ServiceOperation._("TRIGGER_MULTIPLE");

  static ServiceOperation logout = ServiceOperation._("LOGOUT");

  static ServiceOperation startMatch = ServiceOperation._("START_MATCH");
  static ServiceOperation cancelMatch = ServiceOperation._("CANCEL_MATCH");
  static ServiceOperation completeMatch = ServiceOperation._("COMPLETE_MATCH");
  static ServiceOperation enableMatchMaking =
      ServiceOperation._("ENABLE_FOR_MATCH");
  static ServiceOperation disableMatchMaking =
      ServiceOperation._("DISABLE_FOR_MATCH");
  static ServiceOperation updateName = ServiceOperation._("UPDATE_NAME");

  static ServiceOperation startStream = ServiceOperation._("START_STREAM");
  static ServiceOperation readStream = ServiceOperation._("READ_STREAM");
  static ServiceOperation endStream = ServiceOperation._("END_STREAM");
  static ServiceOperation deleteStream = ServiceOperation._("DELETE_STREAM");
  static ServiceOperation addEvent = ServiceOperation._("ADD_EVENT");
  static ServiceOperation getStreamSummariesForInitiatingPlayer =
      ServiceOperation._("GET_STREAM_SUMMARIES_FOR_INITIATING_PLAYER");
  static ServiceOperation getStreamSummariesForTargetPlayer =
      ServiceOperation._("GET_STREAM_SUMMARIES_FOR_TARGET_PLAYER");
  static ServiceOperation getRecentStreamsForInitiatingPlayer =
      ServiceOperation._("GET_RECENT_STREAMS_FOR_INITIATING_PLAYER");
  static ServiceOperation getRecentStreamsForTargetPlayer =
      ServiceOperation._("GET_RECENT_STREAMS_FOR_TARGET_PLAYER");

  static ServiceOperation getUserInfo = ServiceOperation._("GET_USER_INFO");
  static ServiceOperation initializeTransaction =
      ServiceOperation._("INITIALIZE_TRANSACTION");
  static ServiceOperation finalizeTransaction =
      ServiceOperation._("FINALIZE_TRANSACTION");

  static ServiceOperation verifyPurchase =
      ServiceOperation._("VERIFY_PURCHASE");
  static ServiceOperation startSteamTransaction =
      ServiceOperation._("START_STEAM_TRANSACTION");
  static ServiceOperation finalizeSteamTransaction =
      ServiceOperation._("FINALIZE_STEAM_TRANSACTION");
  static ServiceOperation verifyMicrosoftReceipt =
      ServiceOperation._("VERIFY_MICROSOFT_RECEIPT");
  static ServiceOperation eligiblePromotions =
      ServiceOperation._("ELIGIBLE_PROMOTIONS");

  static ServiceOperation readSharedEntitiesList =
      ServiceOperation._("READ_SHARED_ENTITIES_LIST");
  static ServiceOperation getList = ServiceOperation._("GET_LIST");
  static ServiceOperation getListWithHint =
      ServiceOperation._("GET_LIST_WITH_HINT");
  static ServiceOperation getListByIndexedId =
      ServiceOperation._("GET_LIST_BY_INDEXED_ID");
  static ServiceOperation getListCount = ServiceOperation._("GET_LIST_COUNT");
  static ServiceOperation getListCountWithHint =
      ServiceOperation._("GET_LIST_COUNT_WITH_HINT");
  static ServiceOperation getPage = ServiceOperation._("GET_PAGE");
  static ServiceOperation getPageOffset =
      ServiceOperation._("GET_PAGE_BY_OFFSET");
  static ServiceOperation incrementGlobalEntityData =
      ServiceOperation._("INCREMENT_GLOBAL_ENTITY_DATA");
  static ServiceOperation getRandomEntitiesMatching =
      ServiceOperation._("GET_RANDOM_ENTITIES_MATCHING");
  static ServiceOperation getRandomEntitiesMatchingWithHint =
      ServiceOperation._("GET_RANDOM_ENTITIES_MATCHING_WITH_HINT");
  static ServiceOperation incrementUserEntityData =
      ServiceOperation._("INCREMENT_USER_ENTITY_DATA");
  static ServiceOperation incrementSharedUserEntityData =
      ServiceOperation._("INCREMENT_SHARED_USER_ENTITY_DATA");

  static ServiceOperation updatePictureUrl =
      ServiceOperation._("UPDATE_PICTURE_URL");
  static ServiceOperation updateContactEmail =
      ServiceOperation._("UPDATE_CONTACT_EMAIL");
  static ServiceOperation updateLanguageCode =
      ServiceOperation._("UPDATE_LANGUAGE_CODE");
  static ServiceOperation updateTimeZoneOffset =
      ServiceOperation._("UPDATE_TIMEZONE_OFFSET");
  static ServiceOperation setUserStatus = ServiceOperation._("SET_USER_STATUS");
  static ServiceOperation getUserStatus = ServiceOperation._("GET_USER_STATUS");
  static ServiceOperation clearUserStatus =
      ServiceOperation._("CLEAR_USER_STATUS");
  static ServiceOperation extendUserStatus =
      ServiceOperation._("EXTEND_USER_STATUS");
  static ServiceOperation getAttributes = ServiceOperation._("GET_ATTRIBUTES");
  static ServiceOperation updateAttributes =
      ServiceOperation._("UPDATE_ATTRIBUTES");
  static ServiceOperation removeAttributes =
      ServiceOperation._("REMOVE_ATTRIBUTES");
  static ServiceOperation getChildProfiles =
      ServiceOperation._("GET_CHILD_PROFILES");
  static ServiceOperation getIdentities = ServiceOperation._("GET_IDENTITIES");
  static ServiceOperation getIdentityStatus = ServiceOperation._("GET_IDENTITY_STATUS");
  static ServiceOperation getExpiredIdentities =
      ServiceOperation._("GET_EXPIRED_IDENTITIES");
  static ServiceOperation refreshIdentity =
      ServiceOperation._("REFRESH_IDENTITY");
  static ServiceOperation changeEmailIdentity =
      ServiceOperation._("CHANGE_EMAIL_IDENTITY");

  static ServiceOperation fbConfirmPurchase =
      ServiceOperation._("FB_CONFIRM_PURCHASE");
  static ServiceOperation googlePlayConfirmPurchase =
      ServiceOperation._("CONFIRM_GOOGLEPLAY_PURCHASE");

  static ServiceOperation readProperties =
      ServiceOperation._("READ_PROPERTIES");
  static ServiceOperation readSelectedProperties =
      ServiceOperation._("READ_SELECTED_PROPERTIES");
  static ServiceOperation readPropertiesInCategories =
      ServiceOperation._("READ_PROPERTIES_IN_CATEGORIES");

  static ServiceOperation getUpdatedFiles =
      ServiceOperation._("GET_UPDATED_FILES");
  static ServiceOperation getFileList = ServiceOperation._("GET_FILE_LIST");

  static ServiceOperation scheduleCloudScript =
      ServiceOperation._("SCHEDULE_CLOUD_SCRIPT");
  static ServiceOperation getScheduledCloudScripts =
      ServiceOperation._("GET_SCHEDULED_CLOUD_SCRIPTS");
  static ServiceOperation getRunningOrQueuedCloudScripts =
      ServiceOperation._("GET_RUNNING_OR_QUEUED_CLOUD_SCRIPTS");
  static ServiceOperation runParentScript =
      ServiceOperation._("RUN_PARENT_SCRIPT");
  static ServiceOperation cancelScheduledScript =
      ServiceOperation._("CANCEL_SCHEDULED_SCRIPT");
  static ServiceOperation runPeerScript = ServiceOperation._("RUN_PEER_SCRIPT");
  static ServiceOperation runPeerScriptAsync =
      ServiceOperation._("RUN_PEER_SCRIPT_ASYNC");

  //RedemptionCode
  static ServiceOperation getRedeemedCodes =
      ServiceOperation._("GET_REDEEMED_CODES");
  static ServiceOperation redeemCode = ServiceOperation._("REDEEM_CODE");

  //DataStream
  static ServiceOperation customPageEvent =
      ServiceOperation._("CUSTOM_PAGE_EVENT");
  static ServiceOperation customScreenEvent =
      ServiceOperation._("CUSTOM_SCREEN_EVENT");
  static ServiceOperation customTrackEvent =
      ServiceOperation._("CUSTOM_TRACK_EVENT");
  static ServiceOperation submitCrashReport =
      ServiceOperation._("SEND_CRASH_REPORT");

  //Profanity
  static ServiceOperation profanityCheck =
      ServiceOperation._("PROFANITY_CHECK");
  static ServiceOperation profanityReplaceText =
      ServiceOperation._("PROFANITY_REPLACE_TEXT");
  static ServiceOperation profanityIdentifyBadWords =
      ServiceOperation._("PROFANITY_IDENTIFY_BAD_WORDS");

  //file upload
  static ServiceOperation prepareUserUpload =
      ServiceOperation._("PREPARE_USER_UPLOAD");
  static ServiceOperation listUserFiles = ServiceOperation._("LIST_USER_FILES");
  static ServiceOperation deleteUserFile =
      ServiceOperation._("DELETE_USER_FILE");
  static ServiceOperation deleteUserFiles =
      ServiceOperation._("DELETE_USER_FILES");
  static ServiceOperation getCdnUrl = ServiceOperation._("GET_CDN_URL");

  //group
  static ServiceOperation acceptGroupInvitation =
      ServiceOperation._("ACCEPT_GROUP_INVITATION");
  static ServiceOperation addGroupMember =
      ServiceOperation._("ADD_GROUP_MEMBER");
  static ServiceOperation approveGroupJoinRequest =
      ServiceOperation._("APPROVE_GROUP_JOIN_REQUEST");
  static ServiceOperation autoJoinGroup = ServiceOperation._("AUTO_JOIN_GROUP");
  static ServiceOperation autoJoinGroupMulti =
      ServiceOperation._("AUTO_JOIN_GROUP_MULTI");
  static ServiceOperation cancelGroupInvitation =
      ServiceOperation._("CANCEL_GROUP_INVITATION");
  static ServiceOperation deleteGroupJoinRequest =
      ServiceOperation._("DELETE_GROUP_JOIN_REQUEST");
  static ServiceOperation createGroup = ServiceOperation._("CREATE_GROUP");
  static ServiceOperation createGroupEntity =
      ServiceOperation._("CREATE_GROUP_ENTITY");
  static ServiceOperation deleteGroup = ServiceOperation._("DELETE_GROUP");
  static ServiceOperation deleteGroupEntity =
      ServiceOperation._("DELETE_GROUP_ENTITY");
  static ServiceOperation deleteGroupMemeber =
      ServiceOperation._("DELETE_MEMBER_FROM_GROUP");
  static ServiceOperation getMyGroups = ServiceOperation._("GET_MY_GROUPS");
  static ServiceOperation incrementGroupData =
      ServiceOperation._("INCREMENT_GROUP_DATA");
  static ServiceOperation incrementGroupEntityData =
      ServiceOperation._("INCREMENT_GROUP_ENTITY_DATA");
  static ServiceOperation inviteGroupMember =
      ServiceOperation._("INVITE_GROUP_MEMBER");
  static ServiceOperation joinGroup = ServiceOperation._("JOIN_GROUP");
  static ServiceOperation leaveGroup = ServiceOperation._("LEAVE_GROUP");
  static ServiceOperation leaveGroupAuto = ServiceOperation._("LEAVE_GROUP_AUTO");
  static ServiceOperation listGroupsPage =
      ServiceOperation._("LIST_GROUPS_PAGE");
  static ServiceOperation listGroupsPageByOffset =
      ServiceOperation._("LIST_GROUPS_PAGE_BY_OFFSET");
  static ServiceOperation listGroupsWithMember =
      ServiceOperation._("LIST_GROUPS_WITH_MEMBER");
  static ServiceOperation readGroup = ServiceOperation._("READ_GROUP");
  static ServiceOperation readGroupData = ServiceOperation._("READ_GROUP_DATA");
  static ServiceOperation readGroupEntitiesPage =
      ServiceOperation._("READ_GROUP_ENTITIES_PAGE");
  static ServiceOperation readGroupEntitiesPageByOffset =
      ServiceOperation._("READ_GROUP_ENTITIES_PAGE_BY_OFFSET");
  static ServiceOperation readGroupEntity =
      ServiceOperation._("READ_GROUP_ENTITY");
  static ServiceOperation readGroupMembers =
      ServiceOperation._("READ_GROUP_MEMBERS");
  static ServiceOperation rejectGroupInvitation =
      ServiceOperation._("REJECT_GROUP_INVITATION");
  static ServiceOperation rejectGroupJoinRequest =
      ServiceOperation._("REJECT_GROUP_JOIN_REQUEST");
  static ServiceOperation removeGroupMember =
      ServiceOperation._("REMOVE_GROUP_MEMBER");
  static ServiceOperation updateGroupData =
      ServiceOperation._("UPDATE_GROUP_DATA");
  static ServiceOperation updateGroupEntityAcl =
      ServiceOperation._("UPDATE_GROUP_ENTITY_ACL");
  static ServiceOperation updateGroupEntity =
      ServiceOperation._("UPDATE_GROUP_ENTITY_DATA");
  static ServiceOperation updateGroupMember =
      ServiceOperation._("UPDATE_GROUP_MEMBER");
  static ServiceOperation updateGroupAcl =
      ServiceOperation._("UPDATE_GROUP_ACL");
  static ServiceOperation updateGroupName =
      ServiceOperation._("UPDATE_GROUP_NAME");
  static ServiceOperation setGroupOpen = ServiceOperation._("SET_GROUP_OPEN");
  static ServiceOperation getRandomGroupsMatching =
      ServiceOperation._("GET_RANDOM_GROUPS_MATCHING");
  static ServiceOperation updateGroupSummaryData =
      ServiceOperation._("UPDATE_GROUP_SUMMARY_DATA");

  //mail
  static ServiceOperation sendBasicEmail =
      ServiceOperation._("SEND_BASIC_EMAIL");
  static ServiceOperation sendAdvancedEmail =
      ServiceOperation._("SEND_ADVANCED_EMAIL");
  static ServiceOperation sendAdvancedEmailByAddress =
      ServiceOperation._("SEND_ADVANCED_EMAIL_BY_ADDRESS");

  //peer
  static ServiceOperation attachPeerProfile =
      ServiceOperation._("ATTACH_PEER_PROFILE");
  static ServiceOperation detachPeer = ServiceOperation._("DETACH_PEER");
  static ServiceOperation getPeerProfiles =
      ServiceOperation._("GET_PEER_PROFILES");
  static ServiceOperation mergePeerProfiles =
      ServiceOperation._("MERGE_PEER_PROFILE");

  //presence
  static ServiceOperation forcePush = ServiceOperation._("FORCE_PUSH");
  static ServiceOperation getPresenceOfFriends =
      ServiceOperation._("GET_PRESENCE_OF_FRIENDS");
  static ServiceOperation getPresenceOfGroup =
      ServiceOperation._("GET_PRESENCE_OF_GROUP");
  static ServiceOperation getPresenceOfUsers =
      ServiceOperation._("GET_PRESENCE_OF_USERS");
  static ServiceOperation registerListenersForFriends =
      ServiceOperation._("REGISTER_LISTENERS_FOR_FRIENDS");
  static ServiceOperation registerListenersForGroup =
      ServiceOperation._("REGISTER_LISTENERS_FOR_GROUP");
  static ServiceOperation registerListenersForProfiles =
      ServiceOperation._("REGISTER_LISTENERS_FOR_PROFILES");
  static ServiceOperation setVisibility = ServiceOperation._("SET_VISIBILITY");
  static ServiceOperation stopListening = ServiceOperation._("STOP_LISTENING");
  static ServiceOperation updateActivity =
      ServiceOperation._("UPDATE_ACTIVITY");

  //tournament
  static ServiceOperation getTournamentStatus =
      ServiceOperation._("GET_TOURNAMENT_STATUS");
  static ServiceOperation getDivisionInfo =
      ServiceOperation._("GET_DIVISION_INFO");
  static ServiceOperation getMyDivisions =
      ServiceOperation._("GET_MY_DIVISIONS");
  static ServiceOperation joinDivision = ServiceOperation._("JOIN_DIVISION");
  static ServiceOperation joinTournament =
      ServiceOperation._("JOIN_TOURNAMENT");
  static ServiceOperation leaveDivisionInstance =
      ServiceOperation._("LEAVE_DIVISION_INSTANCE");
  static ServiceOperation leaveTournament =
      ServiceOperation._("LEAVE_TOURNAMENT");
  static ServiceOperation postTournamentScore =
      ServiceOperation._("POST_TOURNAMENT_SCORE");
  static ServiceOperation postTournamentScoreWithResults =
      ServiceOperation._("POST_TOURNAMENT_SCORE_WITH_RESULTS");
  static ServiceOperation viewCurrentReward =
      ServiceOperation._("VIEW_CURRENT_REWARD");
  static ServiceOperation viewReward = ServiceOperation._("VIEW_REWARD");
  static ServiceOperation claimTournamentReward =
      ServiceOperation._("CLAIM_TOURNAMENT_REWARD");

  // rtt
  static ServiceOperation requestClientConnection =
      ServiceOperation._("REQUEST_CLIENT_CONNECTION");

  // chat
  static ServiceOperation channelConnect =
      ServiceOperation._("CHANNEL_CONNECT");
  static ServiceOperation channelDisconnect =
      ServiceOperation._("CHANNEL_DISCONNECT");
  static ServiceOperation deleteChatMessage =
      ServiceOperation._("DELETE_CHAT_MESSAGE");
  static ServiceOperation getChannelId = ServiceOperation._("GET_CHANNEL_ID");
  static ServiceOperation getChannelInfo =
      ServiceOperation._("GET_CHANNEL_INFO");
  static ServiceOperation getChatMessage =
      ServiceOperation._("GET_CHAT_MESSAGE");
  static ServiceOperation getRecentChatMessages =
      ServiceOperation._("GET_RECENT_CHAT_MESSAGES");
  static ServiceOperation getSubscribedChannels =
      ServiceOperation._("GET_SUBSCRIBED_CHANNELS");
  static ServiceOperation postChatMessage =
      ServiceOperation._("POST_CHAT_MESSAGE");
  static ServiceOperation postChatMessageSimple =
      ServiceOperation._("POST_CHAT_MESSAGE_SIMPLE");
  static ServiceOperation updateChatMessage =
      ServiceOperation._("UPDATE_CHAT_MESSAGE");

  // messaging
  static ServiceOperation deleteMessages =
      ServiceOperation._("DELETE_MESSAGES");
  static ServiceOperation getMessageBoxes =
      ServiceOperation._("GET_MESSAGE_BOXES");
  static ServiceOperation getMessageCounts =
      ServiceOperation._("GET_MESSAGE_COUNTS");
  static ServiceOperation getMessages = ServiceOperation._("GET_MESSAGES");
  static ServiceOperation getMessagesPage =
      ServiceOperation._("GET_MESSAGES_PAGE");
  static ServiceOperation getMessagesPageOffset =
      ServiceOperation._("GET_MESSAGES_PAGE_OFFSET");
  static ServiceOperation markMessagesRead =
      ServiceOperation._("MARK_MESSAGES_READ");
  static ServiceOperation sendMessage = ServiceOperation._("SEND_MESSAGE");
  static ServiceOperation sendMessageSimple =
      ServiceOperation._("SEND_MESSAGE_SIMPLE");

  // lobby
  static ServiceOperation findLobby = ServiceOperation._("FIND_LOBBY");
  static ServiceOperation findLobbyWithPingData =
      ServiceOperation._("FIND_LOBBY_WITH_PING_DATA");
  static ServiceOperation createLobby = ServiceOperation._("CREATE_LOBBY");
  static ServiceOperation createLobbyWithPingData =
      ServiceOperation._("CREATE_LOBBY_WITH_PING_DATA");
  static ServiceOperation findOrCreateLobby =
      ServiceOperation._("FIND_OR_CREATE_LOBBY");
  static ServiceOperation findOrCreateLobbyWithPingData =
      ServiceOperation._("FIND_OR_CREATE_LOBBY_WITH_PING_DATA");
  static ServiceOperation getLobbyData = ServiceOperation._("GET_LOBBY_DATA");
  static ServiceOperation updateReady = ServiceOperation._("UPDATE_READY");
  static ServiceOperation updateSettings =
      ServiceOperation._("UPDATE_SETTINGS");
  static ServiceOperation switchTeam = ServiceOperation._("SWITCH_TEAM");
  static ServiceOperation sendSignal = ServiceOperation._("SEND_SIGNAL");
  static ServiceOperation joinLobby = ServiceOperation._("JOIN_LOBBY");
  static ServiceOperation joinLobbyWithPingData =
      ServiceOperation._("JOIN_LOBBY_WITH_PING_DATA");
  static ServiceOperation leaveLobby = ServiceOperation._("LEAVE_LOBBY");
  static ServiceOperation removeMember = ServiceOperation._("REMOVE_MEMBER");
  static ServiceOperation cancelFindRequest =
      ServiceOperation._("CANCEL_FIND_REQUEST");
  static ServiceOperation getRegionsForLobbies =
      ServiceOperation._("GET_REGIONS_FOR_LOBBIES");
  static ServiceOperation getLobbyInstances =
      ServiceOperation._("GET_LOBBY_INSTANCES");
  static ServiceOperation getLobbyInstancesWithPingData =
      ServiceOperation._("GET_LOBBY_INSTANCES_WITH_PING_DATA");

  //ItemCatalog
  static ServiceOperation getCatalogItemDefinition =
      ServiceOperation._("GET_CATALOG_ITEM_DEFINITION");
  static ServiceOperation getCatalogItemsPage =
      ServiceOperation._("GET_CATALOG_ITEMS_PAGE");
  static ServiceOperation getCatalogItemsPageOffset =
      ServiceOperation._("GET_CATALOG_ITEMS_PAGE_OFFSET");

  //CustomEntity

  static ServiceOperation deleteEntities =
      ServiceOperation._("DELETE_ENTITIES");
  static ServiceOperation createCustomEntity =
      ServiceOperation._("CREATE_ENTITY");
  static ServiceOperation getCustomEntityPage = ServiceOperation._("GET_PAGE");
  static ServiceOperation getCustomEntityPageOffset =
      ServiceOperation._("GET_ENTITY_PAGE_OFFSET");
  static ServiceOperation getEntityPage = ServiceOperation._("GET_ENTITY_PAGE");
  static ServiceOperation readCustomEntity = ServiceOperation._("READ_ENTITY");
  static ServiceOperation incrementData = ServiceOperation._("INCREMENT_DATA");
  static ServiceOperation incrementDataSharded =
      ServiceOperation._("INCREMENT_DATA_SHARDED");
  static ServiceOperation incrementSingletonData =
      ServiceOperation._("INCREMENT_SINGLETON_DATA");
  static ServiceOperation updateCustomEntity =
      ServiceOperation._("UPDATE_ENTITY");
  static ServiceOperation updateCustomEntityFields =
      ServiceOperation._("UPDATE_ENTITY_FIELDS");
  static ServiceOperation updateCustomEntityFieldsShards =
      ServiceOperation._("UPDATE_ENTITY_FIELDS_SHARDED");
  static ServiceOperation deleteCustomEntity =
      ServiceOperation._("DELETE_ENTITY");
  static ServiceOperation getCount = ServiceOperation._("GET_COUNT");
  static ServiceOperation updateSingletonFields =
      ServiceOperation._("UPDATE_SINGLETON_FIELDS");

  //UserItemsService

  static ServiceOperation awardUserItem = ServiceOperation._("AWARD_USER_ITEM");
  static ServiceOperation dropUserItem = ServiceOperation._("DROP_USER_ITEM");
  static ServiceOperation getUserItemsPage =
      ServiceOperation._("GET_USER_ITEMS_PAGE");
  static ServiceOperation getUserItemsPageOffset =
      ServiceOperation._("GET_USER_ITEMS_PAGE_OFFSET");
  static ServiceOperation getUserItem = ServiceOperation._("GET_USER_ITEM");
  static ServiceOperation giveUserItemTo =
      ServiceOperation._("GIVE_USER_ITEM_TO");
  static ServiceOperation purchaseUserItem =
      ServiceOperation._("PURCHASE_USER_ITEM");
  static ServiceOperation receiveUserItemFrom =
      ServiceOperation._("RECEIVE_USER_ITEM_FROM");
  static ServiceOperation sellUserItem = ServiceOperation._("SELL_USER_ITEM");
  static ServiceOperation updateUserItemData =
      ServiceOperation._("UPDATE_USER_ITEM_DATA");
  static ServiceOperation useUserItem = ServiceOperation._("USE_USER_ITEM");
  static ServiceOperation publishUserItemToBlockchain =
      ServiceOperation._("PUBLISH_USER_ITEM_TO_BLOCKCHAIN");
  static ServiceOperation refreshBlockchainUserItems =
      ServiceOperation._("REFRESH_BLOCKCHAIN_USER_ITEMS");
  static ServiceOperation removeUserItemFromBlockchain =
      ServiceOperation._("REMOVE_USER_ITEM_FROM_BLOCKCHAIN");

  //Group File Services
  static ServiceOperation checkFilenameExists =
      ServiceOperation._("CHECK_FILENAME_EXISTS");
  static ServiceOperation checkFullpathFilenameExists =
      ServiceOperation._("CHECK_FULLPATH_FILENAME_EXISTS");
  static ServiceOperation copyFile = ServiceOperation._("COPY_FILE");
  static ServiceOperation deleteFile = ServiceOperation._("DELETE_FILE");
  static ServiceOperation moveFile = ServiceOperation._("MOVE_FILE");
  static ServiceOperation moveUserToGroupFile =
      ServiceOperation._("MOVE_USER_TO_GROUP_FILE");
  static ServiceOperation updateFileInfo =
      ServiceOperation._("UPDATE_FILE_INFO");

  ServiceOperation._(this.value);
  String value = "";
}
