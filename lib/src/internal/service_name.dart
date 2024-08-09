class ServiceName {
  // Services
  static ServiceName asyncMatch = ServiceName._("asyncMatch");
  static ServiceName authenticate = ServiceName._("authenticationV2");
  static ServiceName dataStream = ServiceName._("dataStream");
  static ServiceName entity = ServiceName._("entity");
  static ServiceName event = ServiceName._("event");
  static ServiceName file = ServiceName._("file");
  static ServiceName friend = ServiceName._("friend");
  static ServiceName gamification = ServiceName._("gamification");
  static ServiceName globalApp = ServiceName._("globalApp");
  static ServiceName globalEntity = ServiceName._("globalEntity");
  static ServiceName globalStatistics = ServiceName._("globalGameStatistics");
  static ServiceName group = ServiceName._("group");
  static ServiceName heartBeat = ServiceName._("heartbeat");
  static ServiceName identity = ServiceName._("identity");
  static ServiceName itemCatalog = ServiceName._("itemCatalog");
  static ServiceName userItems = ServiceName._("userItems");
  static ServiceName mail = ServiceName._("mail");
  static ServiceName matchMaking = ServiceName._("matchMaking");
  static ServiceName oneWayMatch = ServiceName._("onewayMatch");
  static ServiceName playbackStream = ServiceName._("playbackStream");
  static ServiceName playerState = ServiceName._("playerState");
  static ServiceName playerStatistics = ServiceName._("playerStatistics");
  static ServiceName playerStatisticsEvent =
      ServiceName._("playerStatisticsEvent");
  static ServiceName presence = ServiceName._("presence");
  static ServiceName profanity = ServiceName._("profanity");
  static ServiceName pushNotification = ServiceName._("pushNotification");
  static ServiceName redemptionCode = ServiceName._("redemptionCode");
  static ServiceName s3Handling = ServiceName._("s3Handling");
  static ServiceName script = ServiceName._("script");
  static ServiceName serverTime = ServiceName._("time");
  static ServiceName leaderboard = ServiceName._("leaderboard");
  static ServiceName twitter = ServiceName._("twitter");
  static ServiceName time = ServiceName._("time");
  static ServiceName tournament = ServiceName._("tournament");
  static ServiceName globalFile = ServiceName._("globalFileV3");
  static ServiceName customEntity = ServiceName._("customEntity");
  static ServiceName rttRegistration = ServiceName._("rttRegistration");
  static ServiceName rtt = ServiceName._("rtt");
  static ServiceName relay = ServiceName._("relay");
  static ServiceName chat = ServiceName._("chat");
  static ServiceName messaging = ServiceName._("messaging");
  static ServiceName lobby = ServiceName._("lobby");
  static ServiceName virtualCurrency = ServiceName._("virtualCurrency");
  static ServiceName appStore = ServiceName._("appStore");
  static ServiceName blockChain = ServiceName._("blockchain");
  static ServiceName groupFile = ServiceName._("groupFile");

  ServiceName._(this.value);

  String value = "";
}
