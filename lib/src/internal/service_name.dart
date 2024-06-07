class ServiceName {
  // Services
  static ServiceName AsyncMatch = ServiceName._("asyncMatch");
  static ServiceName Authenticate = ServiceName._("authenticationV2");
  static ServiceName DataStream = ServiceName._("dataStream");
  static ServiceName Entity = ServiceName._("entity");
  static ServiceName Event = ServiceName._("event");
  static ServiceName File = ServiceName._("file");
  static ServiceName Friend = ServiceName._("friend");
  static ServiceName Gamification = ServiceName._("gamification");
  static ServiceName GlobalApp = ServiceName._("globalApp");
  static ServiceName GlobalEntity = ServiceName._("globalEntity");
  static ServiceName GlobalStatistics = ServiceName._("globalGameStatistics");
  static ServiceName Group = ServiceName._("group");
  static ServiceName HeartBeat = ServiceName._("heartbeat");
  static ServiceName Identity = ServiceName._("identity");
  static ServiceName ItemCatalog = ServiceName._("itemCatalog");
  static ServiceName UserItems = ServiceName._("userItems");
  static ServiceName Mail = ServiceName._("mail");
  static ServiceName MatchMaking = ServiceName._("matchMaking");
  static ServiceName OneWayMatch = ServiceName._("onewayMatch");
  static ServiceName PlaybackStream = ServiceName._("playbackStream");
  static ServiceName PlayerState = ServiceName._("playerState");
  static ServiceName PlayerStatistics = ServiceName._("playerStatistics");
  static ServiceName PlayerStatisticsEvent =
      ServiceName._("playerStatisticsEvent");
  static ServiceName Presence = ServiceName._("presence");
  static ServiceName Profanity = ServiceName._("profanity");
  static ServiceName PushNotification = ServiceName._("pushNotification");
  static ServiceName RedemptionCode = ServiceName._("redemptionCode");
  static ServiceName S3Handling = ServiceName._("s3Handling");
  static ServiceName Script = ServiceName._("script");
  static ServiceName ServerTime = ServiceName._("time");
  static ServiceName Leaderboard = ServiceName._("leaderboard");
  static ServiceName Twitter = ServiceName._("twitter");
  static ServiceName Time = ServiceName._("time");
  static ServiceName Tournament = ServiceName._("tournament");
  static ServiceName GlobalFile = ServiceName._("globalFileV3");
  static ServiceName CustomEntity = ServiceName._("customEntity");
  static ServiceName RTTRegistration = ServiceName._("rttRegistration");
  static ServiceName RTT = ServiceName._("rtt");
  static ServiceName Relay = ServiceName._("relay");
  static ServiceName Chat = ServiceName._("chat");
  static ServiceName Messaging = ServiceName._("messaging");
  static ServiceName Lobby = ServiceName._("lobby");
  static ServiceName VirtualCurrency = ServiceName._("virtualCurrency");
  static ServiceName AppStore = ServiceName._("appStore");
  static ServiceName BlockChain = ServiceName._("blockchain");
  static ServiceName GroupFile = ServiceName._("groupFile");

  ServiceName._(String value) {
    Value = value;
  }

  String Value = "";
}
