import 'dart:async';
import 'dart:convert';

import 'dart:io' as io show Platform;

import 'package:braincloud_dart/src/reason_codes.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:braincloud_dart/src/status_codes.dart';
import 'package:braincloud_dart/src/common/platform.dart';
import 'package:braincloud_dart/src/internal/braincloud_comms.dart';
import 'package:braincloud_dart/src/internal/relay_comms.dart' if (dart.library.js_interop) 'package:braincloud_dart/src/internal/relay_comms_web.dart';
import 'package:braincloud_dart/src/internal/rtt_comms.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/braincloud_app_store.dart';
import 'package:braincloud_dart/src/braincloud_async_match.dart';
import 'package:braincloud_dart/src/braincloud_authentication.dart';
import 'package:braincloud_dart/src/braincloud_blockchain.dart';
import 'package:braincloud_dart/src/braincloud_chat.dart';
import 'package:braincloud_dart/src/braincloud_entity.dart';
import 'package:braincloud_dart/src/braincloud_custom_entity.dart';
import 'package:braincloud_dart/src/braincloud_data_stream.dart';
import 'package:braincloud_dart/src/braincloud_event.dart';
import 'package:braincloud_dart/src/braincloud_file.dart';
import 'package:braincloud_dart/src/braincloud_friend.dart';
import 'package:braincloud_dart/src/braincloud_gamification.dart';
import 'package:braincloud_dart/src/braincloud_global_app.dart';
import 'package:braincloud_dart/src/braincloud_global_entity.dart';
import 'package:braincloud_dart/src/braincloud_global_file.dart';
import 'package:braincloud_dart/src/braincloud_global_statistics.dart';
import 'package:braincloud_dart/src/braincloud_group.dart';
import 'package:braincloud_dart/src/braincloud_group_file.dart';
import 'package:braincloud_dart/src/braincloud_identity.dart';
import 'package:braincloud_dart/src/braincloud_item_catalog.dart';
import 'package:braincloud_dart/src/braincloud_lobby.dart';
import 'package:braincloud_dart/src/braincloud_mail.dart';
import 'package:braincloud_dart/src/braincloud_match_making.dart';
import 'package:braincloud_dart/src/braincloud_messaging.dart';
import 'package:braincloud_dart/src/braincloud_one_way_match.dart';
import 'package:braincloud_dart/src/braincloud_playback_stream.dart';
import 'package:braincloud_dart/src/braincloud_player_state.dart';
import 'package:braincloud_dart/src/braincloud_player_statistics.dart';
import 'package:braincloud_dart/src/braincloud_player_statistics_event.dart';
import 'package:braincloud_dart/src/braincloud_presence.dart';
import 'package:braincloud_dart/src/braincloud_profanity.dart';
import 'package:braincloud_dart/src/braincloud_push_notification.dart';
import 'package:braincloud_dart/src/braincloud_redemption_code.dart';
import 'package:braincloud_dart/src/braincloud_relay.dart';
import 'package:braincloud_dart/src/braincloud_rtt.dart';
import 'package:braincloud_dart/src/braincloud_script.dart';
import 'package:braincloud_dart/src/braincloud_social_leaderboard.dart';
import 'package:braincloud_dart/src/braincloud_time.dart';
import 'package:braincloud_dart/src/braincloud_tournament.dart';
import 'package:braincloud_dart/src/braincloud_user_items.dart';
import 'package:braincloud_dart/src/braincloud_virtual_currency.dart';
import 'package:braincloud_dart/src/braincloud_wrapper.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/util.dart';
import 'package:braincloud_dart/src/version.dart';
import 'package:intl/intl.dart';

class BrainCloudClient {
  static const String defaultServerURL =
      "https://api.braincloudservers.com/dispatcherv2";

  String _appVersion = "";
  PlatformID _platform = PlatformID.web;
  set platform(val) => _platform = val;

  String? _languageCode = "en";
  String? _countryCode = "US";
  bool _initialized = false;
  bool _loggingEnabled = false;
  bool get loggingEnabled => _loggingEnabled;

  LogCallback? _logDelegate;

  late BrainCloudComms _comms;
  late RTTComms _rttComms;
  late RelayComms _rsComms;

  late BrainCloudWrapper wrapper;

  late BrainCloudEntity _entityService;
  late BrainCloudGlobalEntity _globalEntityService;
  late BrainCloudGlobalApp _globalAppService;
  late BrainCloudPresence _presenceService;
  late BrainCloudVirtualCurrency _virtualCurrencyService;
  late BrainCloudAppStore _appStore;
  late BrainCloudPlayerStatistics _playerStatisticsService;
  late BrainCloudGlobalStatistics _globalStatisticsService;
  late BrainCloudIdentity _identityService;
  late BrainCloudItemCatalog _itemCatalogService;
  late BrainCloudUserItems _userItemsService;
  late BrainCloudScript _scriptService;
  late BrainCloudMatchMaking _matchMakingService;
  late BrainCloudOneWayMatch _oneWayMatchService;
  late BrainCloudPlaybackStream _playbackStreamService;
  late BrainCloudGamification _gamificationService;
  late BrainCloudPlayerState _playerStateService;
  late BrainCloudFriend _friendService;
  late BrainCloudEvent _eventService;
  late BrainCloudSocialLeaderboard _leaderboardService;
  late BrainCloudAsyncMatch _asyncMatchService;
  late BrainCloudTime _timeService;
  late BrainCloudTournament _tournamentService;
  late BrainCloudGlobalFile _globalFileService;
  late BrainCloudCustomEntity _customEntityService;
  late BrainCloudAuthentication _authenticationService;
  late BrainCloudPushNotification _pushNotificationService;
  late BrainCloudPlayerStatisticsEvent _playerStatisticsEventService;
  late BrainCloudRedemptionCode _redemptionCodeService;
  late BrainCloudDataStream _dataStreamService;
  late BrainCloudProfanity _profanityService;
  late BrainCloudFile _fileService;
  late BrainCloudGroup _groupService;
  late BrainCloudMail _mailService;
  late BrainCloudMessaging _messagingService;
  late BrainCloudBlockchain _blockchain;
  late BrainCloudGroupFile _groupFileService;

  // RTT service
  late BrainCloudLobby _lobbyService;
  late BrainCloudChat _chatService;
  late BrainCloudRTT _rttService;
  late BrainCloudRelay _rsService;

  static ServerCallback? createServerCallback(
    SuccessCallback? success,
    FailureCallback? failure,
  ) {
    ServerCallback? newCallback;

    if (success != null || failure != null) {
      newCallback = ServerCallback(success!, failure!);
    }

    return newCallback;
  }

  BrainCloudClient(BrainCloudWrapper? inWrapper) {
    if (inWrapper != null) {
      wrapper = inWrapper;
    }
    init();
  }

  void init() {
    _comms = BrainCloudComms(this);
    _rttComms = RTTComms(this);
    _rsComms = RelayComms(this);

    _entityService = BrainCloudEntity(this);

    _globalEntityService = BrainCloudGlobalEntity(this);

    _globalAppService = BrainCloudGlobalApp(this);
    _presenceService = BrainCloudPresence(this);
    _virtualCurrencyService = BrainCloudVirtualCurrency(this);
    _appStore = BrainCloudAppStore(this);

    _playerStatisticsService = BrainCloudPlayerStatistics(this);
    _globalStatisticsService = BrainCloudGlobalStatistics(this);

    _identityService = BrainCloudIdentity(this);
    _itemCatalogService = BrainCloudItemCatalog(this);
    _userItemsService = BrainCloudUserItems(this);
    _scriptService = BrainCloudScript(this);
    _matchMakingService = BrainCloudMatchMaking(this);
    _oneWayMatchService = BrainCloudOneWayMatch(this);

    _playbackStreamService = BrainCloudPlaybackStream(this);
    _gamificationService = BrainCloudGamification(this);
    _playerStateService = BrainCloudPlayerState(this);
    _friendService = BrainCloudFriend(this);

    _eventService = BrainCloudEvent(this);
    _leaderboardService = BrainCloudSocialLeaderboard(this);
    _asyncMatchService = BrainCloudAsyncMatch(this);
    _timeService = BrainCloudTime(this);
    _tournamentService = BrainCloudTournament(this);
    _globalFileService = BrainCloudGlobalFile(this);
    _customEntityService = BrainCloudCustomEntity(this);

    _authenticationService = BrainCloudAuthentication(this);
    _pushNotificationService = BrainCloudPushNotification(this);
    _playerStatisticsEventService = BrainCloudPlayerStatisticsEvent(this);

    _redemptionCodeService = BrainCloudRedemptionCode(this);
    _dataStreamService = BrainCloudDataStream(this);
    _profanityService = BrainCloudProfanity(this);
    _fileService = BrainCloudFile(this);
    _groupService = BrainCloudGroup(this);
    _mailService = BrainCloudMail(this);
    _messagingService = BrainCloudMessaging(this);
    _groupFileService = BrainCloudGroupFile(this);

    // RTT
    _lobbyService = BrainCloudLobby(this);
    _chatService = BrainCloudChat(this);
    _rttService = BrainCloudRTT(_rttComms, this);
    _rsService = BrainCloudRelay(_rsComms, this);

    _blockchain = BrainCloudBlockchain(this);
  }
  //---------------------------------------------------------------

  bool get authenticated => _comms.isAuthenticated;

  bool get initialized => _initialized;

  void enableCompressedRequests(bool isEnabled) =>
      _comms.enableCompression(isEnabled);

  void enableCompressedResponses(bool isEnabled) =>
      _authenticationService.compressResponse = isEnabled;

  /// returns the sessionId or empty String if no session present.
  String get sessionID => _comms.getSessionID;

  String get appId => _comms.getAppId;

  String getAppId() {
    return appId;
  }

  String? get profileId => authenticationService.profileId ?? "";

  String? get rttConnectionID => _rttComms.rttConnectionID;

  String? get rttEventServer => _rttComms.rttEventServer;

  String get appVersion => _appVersion;

  String getAppVersion() => appVersion;

  String get brainCloudClientVersion => Version.getVersion();

  PlatformID get releasePlatform => _platform;

  String get languageCode =>
      _languageCode ?? Util.getIsoCodeForCurrentLanguage();
  set languageCode(value) => _languageCode = value;

  String get countryCode => _countryCode ?? Util.getCurrentCountryCode();
  set countryCode(value) => _countryCode = value;

  BrainCloudComms get comms => _comms;
  // @visibleForTesting
  RTTComms get rttComms => _rttComms;
  // @visibleForTesting
  RelayComms get rsComms => _rsComms;

  BrainCloudEntity get entityService => _entityService;

  BrainCloudGlobalEntity get globalEntityService => _globalEntityService;

  BrainCloudGlobalApp get globalAppService => _globalAppService;

  BrainCloudPresence get presenceService => _presenceService;

  BrainCloudVirtualCurrency get virtualCurrencyService =>
      _virtualCurrencyService;

  BrainCloudAppStore get appStoreService => _appStore;

  BrainCloudPlayerStatistics get playerStatisticsService =>
      _playerStatisticsService;

  BrainCloudGlobalStatistics get globalStatisticsService =>
      _globalStatisticsService;

  BrainCloudIdentity get identityService => _identityService;

  BrainCloudItemCatalog get itemCatalogService => _itemCatalogService;

  BrainCloudUserItems get userItemsService => _userItemsService;

  BrainCloudScript get scriptService => _scriptService;

  BrainCloudMatchMaking get matchMakingService => _matchMakingService;

  BrainCloudOneWayMatch get oneWayMatchService => _oneWayMatchService;

  BrainCloudPlaybackStream get playbackStreamService => _playbackStreamService;

  BrainCloudGamification get gamificationService => _gamificationService;

  BrainCloudPlayerState get playerStateService => _playerStateService;

  BrainCloudFriend get friendService => _friendService;

  BrainCloudEvent get eventService => _eventService;

  BrainCloudSocialLeaderboard get socialLeaderboardService =>
      _leaderboardService;

  BrainCloudSocialLeaderboard get leaderboardService => _leaderboardService;

  BrainCloudAsyncMatch get asyncMatchService => _asyncMatchService;

  BrainCloudTime get timeService => _timeService;

  BrainCloudTournament get tournamentService => _tournamentService;

  BrainCloudGlobalFile get globalFileService => _globalFileService;

  BrainCloudCustomEntity get customEntityService => _customEntityService;

  BrainCloudAuthentication get authenticationService => _authenticationService;

  BrainCloudPushNotification get pushNotificationService =>
      _pushNotificationService;

  BrainCloudPlayerStatisticsEvent get playerStatisticsEventService =>
      _playerStatisticsEventService;

  BrainCloudRedemptionCode get redemptionCodeService => _redemptionCodeService;

  BrainCloudDataStream get dataStreamService => _dataStreamService;

  BrainCloudProfanity get profanityService => _profanityService;

  BrainCloudFile get fileService => _fileService;

  BrainCloudGroup get groupService => _groupService;

  BrainCloudMail get mailService => _mailService;

  BrainCloudRTT get rttService => _rttService;

  BrainCloudLobby get lobbyService => _lobbyService;

  BrainCloudChat get chatService => _chatService;

  BrainCloudMessaging get messagingService => _messagingService;

  BrainCloudRelay get relayService => _rsService;

  BrainCloudBlockchain get blockchainService => _blockchain;

  BrainCloudGroupFile get groupFileService => _groupFileService;

  /// returns the sessionId or empty String if no session present.
  String getSessionId() {
    return sessionID;
  }

  /// Returns true if the user is currently authenticated.
  /// If a session time out or session invalidation is returned from executing a
  /// sever API call, this flag will reset back to false.

  bool isAuthenticated() {
    return authenticated;
  }

  int getReceivedPacketId() {
    return _comms.getReceivedPacketId();
  }

  /// Returns true if brainCloud has been initialized.

  bool isInitialized() {
    return initialized;
  }

  /// Method initializes the BrainCloudClient.
  ///
  /// @param serverURLThe URL to the brainCloud server
  ///
  /// @param defaultAppId The app id
  ///
  /// @param appIdSecrectMap The map of appid to secret
  ///
  /// @param appVersion The app version
  void initializeWithApps(
      {String serverURL = defaultServerURL,
      required String defaultAppId,
      required Map<String, String> appIdSecretMap,
      required String appVersion}) {

    String? error = initializeHelper(
        serverURL, appIdSecretMap[defaultAppId] ?? "", defaultAppId, appVersion);

    if (error != null) throw(error);

    // set up braincloud which does the message handling
    _comms.initializeWithApps(serverURL, defaultAppId, appIdSecretMap);

    _initialized = true;
  }

  /// Method initializes the BrainCloudClient.
  ///
  /// @param serverURLThe URL to the brainCloud server
  ///
  /// @param secretKeyThe secret key for your app
  ///
  /// @param appId The app id
  ///
  /// @param appVersionThe app version
  ///
  void initialize(
      {String? serverURL = defaultServerURL,
      required secretKey,
      required appId,
      required appVersion}) {
    serverURL = serverURL ?? defaultServerURL;

    String? error = initializeHelper(serverURL, secretKey, appId, appVersion);

    if (error != null) throw(error);
    
    // set up braincloud which does the message handling
    _comms.initialize(serverURL, appId, secretKey);
    
    _initialized = true;

  }

  /// Initialize the identity aspects of brainCloud.
  ///
  /// @param profileIdThe profile id
  ///
  /// @param anonymousIdThe anonymous id
  void initializeIdentity(String profileId, String anonymousId) {
    authenticationService.initialize(profileId: profileId, anonymousId: anonymousId);
  }

  /// Shuts down all systems needed for BrainCloudClient
  ///
  /// Only call this from the main thread.
  ///
  /// Should be used at the end of the app, and opposite of Initialize Client
  void shutDown() {
    _comms.shutDown();
  }

  /// Update method needs to be called regularly in order
  /// to process incoming and outgoing messages.
  void runCallbacks(
      {BrainCloudUpdateType inUpdateType = BrainCloudUpdateType.all}) {
    update(inUpdateType: inUpdateType);
  }

  /// Update method needs to be called regularly in order
  /// to process incoming and outgoing messages.
  void update({BrainCloudUpdateType inUpdateType = BrainCloudUpdateType.all}) {
    switch (inUpdateType) {
      case BrainCloudUpdateType.rest:
        {
          _comms.update();
        }
        break;

      case BrainCloudUpdateType.rtt:
        {
          _rttComms.update();
        }
        break;

      case BrainCloudUpdateType.rs:
        {
          _rsComms.update();
        }
        break;

      case BrainCloudUpdateType.ping:
        {
          _lobbyService.update();
        }
        break;

      default:
        {
          _rttComms.update();
          _comms.update();
          _rsComms.update();
          _lobbyService.update();
        }
        break;
    }
  }

  /// Sets a callback handler for any out of band event messages that come from
  /// brainCloud.
  ///
  /// @param eventCallback A function which takes a JSON String as it's only parameter.
  ///
  ///  The JSON format looks like the following:
  /// ```{
  ///   "events": [{
  ///      "fromPlayerId": "178ed06a-d575-4591-8970-e23a5d35f9df",
  ///      "eventId": 3967,
  ///      "createdAt": 1441742105908,
  ///      "gameId": "123",
  ///      "toPlayerId": "178ed06a-d575-4591-8970-e23a5d35f9df",
  ///      "eventType": "test",
  ///      "eventData": {"testData": 117}
  ///    }],
  ///    ]
  ///  }
  void registerEventCallback(EventCallback eventCallback) {
    _comms.registerEventCallback(eventCallback);
  }

  /// De-registers the event callback.
  void deregisterEventCallback() {
    _comms.deregisterEventCallback();
  }

  /// Sets a reward handler for any API call results that return rewards.
  ///
  /// @param  eventCallback
  /// The reward callback handler.
  ///
  /// [ref link]: http://getbraincloud.com/apidocs
  /// The brainCloud API docs site for more information on the return JSON
  /// [ref link]
  void registerRewardCallback(RewardCallback eventCallback) {
    _comms.registerRewardCallback(eventCallback);
  }

  /// De-registers the reward callback.

  void deregisterRewardCallback() {
    _comms.deregisterRewardCallback();
  }

  /// Registers the file upload callbacks.
  ///
  /// returns Future<ServerResponse>
  void registerFileUploadCallback(Function(ServerResponse) callBack) {

    _comms.registerFileUploadCallbacks((a, b) {
      var response = jsonDecode(b);
      callBack(ServerResponse(statusCode: response['status'], data: response['data']));
    },
        (a, statusCode, reasonCode, statusMessage) => callBack(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
  }

  /// De-registers the file upload callbacks.
  void deregisterFileUploadCallback() {
    _comms.deregisterFileUploadCallbacks();
  }

  /// Failure callback invoked for all errors generated
  void registerGlobalErrorCallback(FailureGlobalCallback callback) {
    _comms.registerGlobalErrorCallback(callback);
  }

  /// De-registers the global error callback.
  void deregisterGlobalErrorCallback() {
    _comms.deregisterGlobalErrorCallback();
  }

  /// Registers a callback that is invoked for network errors.
  ///
  /// Note this is only called if EnableNetworkErrorMessageCaching
  /// has been set to true.
  void registerNetworkErrorCallback(NetworkErrorCallback callback) {
    _comms.registerNetworkErrorCallback(callback);
  }

  /// De-registers the network error callback.
  void deregisterNetworkErrorCallback() {
    _comms.deregisterNetworkErrorCallback();
  }

  /// Enable logging of brainCloud transactions (comms etc)
  ///
  /// @param enableTrue if logging is to be enabled
  void enableLogging(bool enable) {
    _loggingEnabled = enable;
  }

  /// Get the Server URL
  String getUrl() {
    return _comms.getServerURL;
  }

  /// Resets all messages and calls to the server
  void resetCommunication() {
    _comms.resetCommunication();
    _rttComms.disableRTT();
    _rsComms.disconnect();
    update();
    authenticationService.clearSavedProfileId();
  }

  /// Enable Communications with the server. By default this is true
  ///
  /// @param valueTrue to enable comms, false otherwise.
  void enableCommunications(bool value) {
    _comms.enableComms(value);
  }

  /// Sets the packet timeouts using a list of integers that
  /// represent timeout values for each packet retry. The
  /// first item in the list represents the timeout for the first packet
  /// attempt, the second for the second packet attempt, and so on.
  ///
  /// The number of entries in this array determines how many packet
  /// retries will occur.
  ///
  /// By default, the packet timeout array is {15, 20, 35, 50}
  ///
  /// Note that this method does not change the timeout for authentication
  /// packets (use SetAuthenticationPacketTimeout method).
  ///
  /// @param timeoutsAn array of packet timeouts.
  void setPacketTimeouts(List<int> timeouts) {
    _comms.packetTimeouts = timeouts;
  }

  /// Sets the packet timeouts back to default.
  void setPacketTimeoutsToDefault() {
    _comms.setPacketTimeoutsToDefault();
  }

  /// Returns the list of packet timeouts.
  List<int> getPacketTimeouts() {
    return _comms.packetTimeouts;
  }

  /// Sets the authentication packet timeout which is tracked separately
  /// from all other packets. Note that authentication packets are never
  /// retried and so this value represents the total time a client would
  /// wait to receive a reply to an authentication API call. By default
  /// this timeout is set to 15 seconds.
  ///
  /// @param valueSecsThe timeout in seconds.
  void setAuthenticationPacketTimeout(int timeoutSecs) {
    _comms.authenticationPacketTimeoutSecs = timeoutSecs;
  }

  /// gets the authentication packet timeout which is tracked separately
  /// from all other packets. Note that authentication packets are never
  /// retried and so this value represents the total time a client would
  /// wait to receive a reply to an authentication API call. By default
  /// this timeout is set to 15 seconds.
  int getAuthenticationPacketTimeout() {
    return _comms.authenticationPacketTimeoutSecs;
  }

  /// Returns the low transfer rate timeout in secs
  int getUploadLowTransferRateTimeout() {
    return _comms.uploadLowTransferRateTimeout;
  }

  /// Sets the timeout in seconds of a low speed upload
  /// (i.e. transfer rate which is underneath the low transfer rate threshold).
  /// By default this is set to 120 secs.Setting this value to 0 will
  /// turn off the timeout.
  ///
  /// @param timeoutSecs
  void setUploadLowTransferRateTimeout(int timeoutSecs) {
    _comms.uploadLowTransferRateTimeout = timeoutSecs;
  }

  /// Returns the low transfer rate threshold in bytes/sec
  int getUploadLowTransferRateThreshold() {
    return _comms.uploadLowTransferRateThreshold;
  }

  /// Sets the low transfer rate threshold of an upload in bytes/sec.
  /// If the transfer rate dips below the given threshold longer
  /// than the specified timeout, the transfer will fail.
  /// By default this is set to 50 bytes/sec.
  ///
  /// @param bytesPerSecThe low transfer rate threshold in bytes/sec
  void setUploadLowTransferRateThreshold(int bytesPerSec) {
    _comms.uploadLowTransferRateThreshold = bytesPerSec;
  }

  /// Enables the timeout message caching which is disabled by default.
  /// Once enabled, if a client side timeout is encountered
  /// (i.e. brainCloud server is unreachable presumably due to the client
  /// network being down) the SDK will do the following:
  ///
  /// 1. cache the currently queued messages to brainCloud
  /// 2. call the network error callback
  /// 3. then expect the app to call either:
  ///      * RetryCachedMessages() to retry sending to brainCloud
  ///      * FlushCachedMessages() to dump all messages in the queue.
  ///
  /// Between steps 2 & 3, the app can prompt the user to retry connecting
  /// to brainCloud to determine whether to follow path 3a or 3b.
  ///
  /// Note that if path 3a is followed, and another timeout is encountered,
  /// the process will begin all over again from step 1.
  ///
  /// WARNING - the brainCloud SDK will cache *all* API calls sent
  /// when a timeout is encountered if this mechanism is enabled.
  /// This effectively freezes all communication with brainCloud.
  /// Apps must call either RetryCachedMessages() or FlushCachedMessages()
  /// for the brainCloud SDK to resume sending messages.
  /// ResetCommunication() will also clear the message cache.
  ///
  /// @param enabledTrue if message should be cached on timeout
  void enableNetworkErrorMessageCaching(bool enabled) {
    _comms.enableNetworkErrorMessageCaching(enabled);
  }

  /// Attempts to resend any cached messages. If no messages are in the cache,
  /// this method does nothing.
  void retryCachedMessages() {
    _comms.retryCachedMessages();
  }

  /// Flushes the cached messages to resume API call processing. This will dump
  /// all of the cached messages in the queue.
  ///
  /// @param sendApiErrorCallbacksIf set to __true__ API error callbacks will
  /// be called for every cached message with statusCode [StatusCodes.clientNetworkError] and reasonCode [ReasonCodes.clientNetworkErrorTimeout].
  void flushCachedMessages(bool sendApiErrorCallbacks) {
    _comms.flushCachedMessages(sendApiErrorCallbacks);
  }

  /// Inserts a marker which will tell the brainCloud comms layer
  /// to close the message bundle off at this point. Any messages queued
  /// before this method was called will likely be bundled together in
  /// the next send to the server.
  ///
  /// To ensure that only a single message is sent to the server you would
  /// do something like this:
  ///
  /// InsertEndOfMessageBundleMarker()
  /// SomeApiCall()
  /// InsertEndOfMessageBundleMarker()
  ///
  void insertEndOfMessageBundleMarker() {
    _comms.insertEndOfMessageBundleMarker();
  }

  /// Sets the country code sent to brainCloud when a user authenticates.
  /// Will override any auto detected country.
  ///
  /// @param countryCodeISO 3166-1 two-letter country code
  void overrideCountryCode(String countryCode) {
    _countryCode = countryCode;
  }

  /// Sets the language code sent to brainCloud when a user authenticates.
  /// If the language is set to a non-ISO 639-1 standard value the game default will be used instead.
  /// Will override any auto detected language.
  ///
  /// @param languageCodeISO 639-1 two-letter language code
  void overrideLanguageCode(String languageCode) {
    _languageCode = languageCode;
  }

  /// Normally not needed as the brainCloud SDK sends heartbeats automatically.
  /// Regardless, this is a manual way to send a heartbeat.
   Future<ServerResponse>  sendHeartbeat() {
    final Completer<ServerResponse> completer = Completer();

    ServerCall sc = ServerCall(
        ServiceName.heartBeat,
        ServiceOperation.read,
        null,
        ServerCallback((response) {
          ServerResponse responseObject = ServerResponse.fromJson(response);
          completer.complete(responseObject);
        }, (statusCode, reasonCode, statusMessage) {
          completer.completeError(ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage));
        }));

    _comms.addToQueue(sc);
    
    return completer.future;
  }

  ///  Method writes log if logging is enabled
  void log(String log, {bool bypassLogEnabled = false}) {
    if (_loggingEnabled || bypassLogEnabled) {
      String formattedLog =
          "${DateFormat("HH:mm:ss.SSS").format(DateTime.now())} #BCC ${(log.length < 14000 ? log : log.substring(0, 14000) + " << (LOG TRUNCATED)")}";

      if (_logDelegate != null) {
        _logDelegate!({"msg":formattedLog});
      } else {
        print(formattedLog);
      }
    }
  }

  /// Sends a service request message to the server.
  ///
  /// @param serviceMessageThe message to send
  void sendRequest(ServerCall serviceMessage) {
    // pass this directly to the brainCloud Class
    // which will add it to its queue and send back responses accordingly
    _comms.addToQueue(serviceMessage);
  }

  String serializeJson(dynamic payLoad) {
    var retVal = "";
    try {
      retVal = _comms.serializeJson(payLoad);
    } catch (_) {
      retVal = "Error BrainCloudClient.SerializeJson _comms is null";
    }

    return retVal;
  }

  Map<String, dynamic> deserializeJson(String jsonData) {
    Map<String, dynamic> retVal = {};
    try {
      retVal = _comms.deserializeJson(jsonData);
    } catch (_) {
      retVal = {"Error": "BrainCloudClient.DeserializeJson _comms is null"};
    }

    return retVal;
  }

  String? initializeHelper(
      String serverURL, String secretKey, String appId, String appVersion) {
    //set platform... defaults to web
    const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

    if (!kIsWeb) {
      if (io.Platform.isIOS) {
        platform = PlatformID.iOS;
      }
      if (io.Platform.isWindows) {
        platform = PlatformID.windows;
      }
      if (io.Platform.isMacOS) {
        platform = PlatformID.mac;
      }
      if (io.Platform.isAndroid) {
        platform = PlatformID.googlePlayAndroid;
      }
      if (io.Platform.isLinux) {
        platform = PlatformID.linux;
      }
    }

    String? error;
    if (serverURL.isEmpty) {
      error = "serverURL was null or empty";
    } else if (secretKey.isEmpty) {
      error = "secretKey was null or empty";
    } else if (appId.isEmpty) {
      error = "appId was null or empty";
    } else if (appVersion.isEmpty) {
      error = "appVerson was null or empty";
    }

    if (error != null) {
      log("ERROR | Failed to initialize brainCloud - $error");
      return error;
    }

    _appVersion = appVersion;

    //setup region/country code
    if (Util.getCurrentCountryCode().isEmpty) {
      String locale = Intl.getCurrentLocale();
      String countryCode =
          locale.split('_').last; // Extract the country code from locale.
      Util.setCurrentCountryCode(countryCode);
    }
    return null;
  }
}

enum BrainCloudUpdateType {
  all("ALL"),
  rest("REST"),
  rtt("RTT"),
  rs("RS"),
  ping("PING"),
  max("MAX");

  const BrainCloudUpdateType(this.value);

  final String value;

  static BrainCloudUpdateType fromString(String s) {
    BrainCloudUpdateType type = BrainCloudUpdateType.values.firstWhere(
        (e) => e.value == s,
        orElse: () => BrainCloudUpdateType.all);

    return type;
  }

  @override
  String toString() => value;
}
