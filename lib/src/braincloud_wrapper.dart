//----------------------------------------------------
// brainCloud client source code
// Copyright 2024 bitHeads, inc.
//----------------------------------------------------
import 'dart:async';

import 'package:braincloud_dart/src/server_response.dart';
import 'package:dart_extensions/dart_extensions.dart';

import 'package:braincloud_dart/src/common/authentication_ids.dart';
import 'package:braincloud_dart/src/common/authentication_type.dart';
import 'package:braincloud_dart/src/braincloud_app_store.dart';
import 'package:braincloud_dart/src/braincloud_async_match.dart';
import 'package:braincloud_dart/src/braincloud_chat.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

/// The BrainCloudWrapper class provides some glue between the Unity environment and the
/// brainCloud C# library. Specifically the BrainCloudWrapper does the following:
///
/// 1) Creates and uses a global singleton GameObject to manage it's lifetime across the game
/// 2) Provides an Initialize method which uses the game id, secret, version, and server url
///    defined in the brainCloud settings Unity window.
/// 3) Provides a few of the authentication types that are supported by brainCloud.
/// 4) For Anonymous authentication, stores the anonymous id and profile id to the Unity player prefs
///    upon successful authentication. This is important as once an anonymous account is created,
///    both the anonymous id and profile id of the account are required to authenticate.
///
/// Note that this class is *not* required to use brainCloud - you are free to reimplement the
/// functionality as you see fit. It is simply used as a starting point to get developers off the
/// ground - especially with authentications.
///
/// See http://getbraincloud.com/apidocs/ for the full list of brainCloud APIs.
class BrainCloudWrapper {
  /// The key for the user prefs profile id
  static String prefsProfileId = "brainCloud.profileId";

  /// The key for the user prefs anonymous id
  static String prefsAnonymousId = "brainCloud.anonymousId";

  /// The key for the user prefs authentication type
  static String prefsAuthenticationType = "brainCloud.authenticationType";

  /// The key for the user prefs session id
  static String prefsSessionId = "brainCloud.authenticationType";

  /// The key for the user prefs session id
  static String prefsLastPacketId = "brainCloud.lastPacketId";

  /// The name of the singleton brainCloud game object
  static String gameobjectBraincloud = "BrainCloudWrapper";

  static String authenticationAnonymous = "anonymous";

  String _lastUrl = "";
  String _lastSecretKey = "";
  String _lastAppId = "";
  String _lastAppVersion = "";

  bool _alwaysAllowProfileSwitch = true;

  WrapperData _wrapperData = WrapperData();

  late BrainCloudClient _client;
  BrainCloudClient get brainCloudClient => _client;

  getAllowProfileSwitch() {
    return _alwaysAllowProfileSwitch;
  }

  setAllowProfileSwitch(bool value) {
    _alwaysAllowProfileSwitch = value;
  }

  void onDestroy() {
    _updateTimer?.cancel();
    //StopAllCoroutines();
    rTTService.disableRTT();
    relayService.disconnect();
    _client.update();
  }

  /// Name of this wrapper instance. Used for data loading

  String? wrapperName;

  BrainCloudEntity get entityService => _client.entityService;

  BrainCloudGlobalEntity get globalEntityService => _client.globalEntityService;

  BrainCloudGlobalApp get globalAppService => _client.globalAppService;

  BrainCloudVirtualCurrency get virtualCurrencyService =>
      _client.virtualCurrencyService;

  BrainCloudAppStore get appStoreService => _client.appStoreService;

  BrainCloudPlayerStatistics get playerStatisticsService =>
      _client.playerStatisticsService;

  BrainCloudGlobalStatistics get globalStatisticsService =>
      _client.globalStatisticsService;

  BrainCloudIdentity get identityService => _client.identityService;

  BrainCloudItemCatalog get itemCatalogService => _client.itemCatalogService;

  BrainCloudUserItems get userItemsService => _client.userItemsService;

  BrainCloudScript get scriptService => _client.scriptService;

  BrainCloudMatchMaking get matchMakingService => _client.matchMakingService;

  BrainCloudOneWayMatch get oneWayMatchService => _client.oneWayMatchService;

  BrainCloudPlaybackStream get playbackStreamService =>
      _client.playbackStreamService;

  BrainCloudPresence get presenceService => _client.presenceService;

  BrainCloudGamification get gamificationService => _client.gamificationService;

  BrainCloudPlayerState get playerStateService => _client.playerStateService;

  BrainCloudFriend get friendService => _client.friendService;

  BrainCloudEvent get eventService => _client.eventService;

  BrainCloudSocialLeaderboard get socialLeaderboardService =>
      _client.socialLeaderboardService;

  BrainCloudSocialLeaderboard get leaderboardService =>
      _client.leaderboardService;

  BrainCloudAsyncMatch get asyncMatchService => _client.asyncMatchService;

  BrainCloudTime get timeService => _client.timeService;

  BrainCloudTournament get tournamentService => _client.tournamentService;

  BrainCloudGlobalFile get globalFileService => _client.globalFileService;

  BrainCloudCustomEntity get customEntityService => _client.customEntityService;

  BrainCloudPushNotification get pushNotificationService =>
      _client.pushNotificationService;

  BrainCloudPlayerStatisticsEvent get playerStatisticsEventService =>
      _client.playerStatisticsEventService;

  BrainCloudRedemptionCode get redemptionCodeService =>
      _client.redemptionCodeService;

  BrainCloudDataStream get dataStreamService => _client.dataStreamService;

  BrainCloudProfanity get profanityService => _client.profanityService;

  BrainCloudFile get fileService => _client.fileService;

  BrainCloudGroup get groupService => _client.groupService;

  BrainCloudMail get mailService => _client.mailService;

  BrainCloudRTT get rTTService => _client.rttService;

  BrainCloudLobby get lobbyService => _client.lobbyService;

  BrainCloudChat get chatService => _client.chatService;

  BrainCloudMessaging get messagingService => _client.messagingService;

  BrainCloudRelay get relayService => _client.relayService;

  BrainCloudGroupFile get groupFileService => _client.groupFileService;

  Timer? _updateTimer;

  /// Create the brainCloud Wrapper, which has utility helpers for using the brainCloud API

  BrainCloudWrapper({BrainCloudClient? client, this.wrapperName}) {
    if (client != null) {
      _client = client;
      _client.wrapper = this;
    } else {
      _client = BrainCloudClient(this);
    }
  }

  void _startTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      Timer.periodic(const Duration(milliseconds: 50), (timer) {
        update();
      });
    });
  }

  void runCallbacks() {
    _client.update();

    if (_client.getReceivedPacketId() != getStoredPacketId()) {
      setStoredPacketId(_client.getReceivedPacketId());
    }
  }

  // MonoBehavior runs every update Tick
  void update() {
    runCallbacks();
  }

  /// Initialize the brainCloud client with the passed in parameters.

  /// @param urlThe brainCloud server url
  /// @param secretKeyThe app's secret
  /// @param appIdThe app's id
  /// @param versionThe app's version
  Future<void> init(
      {required String secretKey,
      required String appId,
      required String version,
      String? url}) async {
    resetWrapper();
    _lastUrl = url ?? "";
    _lastSecretKey = secretKey;
    _lastAppId = appId;
    _lastAppVersion = version;
    _client.initialize(
        serverURL: url,
        secretKey: secretKey,
        appId: appId,
        appVersion: version);

    await _loadData();
    _startTimer();
  }

  bool get isInitialized => _client.isInitialized();

  /// Initialize the brainCloud client with the passed in parameters. This version of Initialize
  /// overrides the parameters configured in the Unity brainCloud settings window.

  /// @param urlThe brainCloud server url
  /// @param secretKeyThe app's secret
  /// @param appIdThe app's id
  /// @param versionThe app's version
  Future<void> initWithApps(
      {required String url,
      required String defaultAppId,
      required Map<String, String> appIdSecretMap,
      required String version}) async {
    resetWrapper();
    _lastUrl = url;
    _lastSecretKey = appIdSecretMap[defaultAppId] ?? "";
    _lastAppId = defaultAppId;
    _lastAppVersion = version;
    _client.initializeWithApps(
        serverURL: url,
        defaultAppId: defaultAppId,
        appIdSecretMap: appIdSecretMap,
        appVersion: version);

    await _loadData();
    _startTimer();
  }

  /// Resets the wrapper.
  /// Since the WrapperName is set upon re-initialization of the wrapper, the name is reset by choice here. As the user
  /// may want to reset the wrapper's fields without also restting the name.

  void resetWrapper({bool resetWrapperName = false}) {
    _wrapperData = WrapperData();
    _client
        .resetCommunication(); // just to confirm this is being done on the client when the wrapper is reset.
    _client.wrapper = BrainCloudWrapper();
    _client = BrainCloudClient(this);
    _client.wrapper = this;

    if (resetWrapperName) {
      wrapperName = "";
    }
    _updateTimer?.cancel();
  }

  /// If set to true, profile id is never sent along with non-anonymous authenticates
  /// thereby ensuring that valid credentials always work but potentially cause a profile switch.
  /// If set to false, profile id is passed to the server (if it has been stored) and a profile id
  /// to non-anonymous credential mismatch will cause an error.

  /// @param enabledTrue if we always allow profile switch
  void setAlwaysAllowProfileSwitch(bool enabled) {
    _alwaysAllowProfileSwitch = enabled;
  }

  /// authenticate a user anonymously with brainCloud - used for apps that don't want to bother
  /// the user to login, or for users who are sensitive to their privacy
  ///
  /// Note that this method is special in that the anonymous id and profile id
  /// are persisted to the Unity player prefs cache if authentication is successful.
  /// Both pieces of information are required to successfully log into that account
  /// once the user has been created. Failure to store the profile id and anonymous id
  /// once the user has been created results in an inability to log into that account!
  /// For this reason, using other recoverable authentication methods (like email/password, Facebook)
  /// are encouraged.

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateAnonymous() {
    initializeIdentity(true);

    return _client.authenticationService
        .authenticateAnonymous(true)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user using a Pase userid and authentication token

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param handoffId
  /// The method to call in event of successful login

  /// @param securityToken
  /// The method to call in event of successful login

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateHandoff(
      {required String handoffId, required String securityToken}) {
    initializeIdentity(false);

    return _client.authenticationService
        .authenticateHandoff(handoffId, securityToken)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate user with handoffCode

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param handoffCode

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateSettopHandoff({
    required String handoffCode,
  }) {
    initializeIdentity(false);

    return _client.authenticationService
        .authenticateSettopHandoff(handoffCode)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user with a custom Email and Password.  Note that the client app
  /// is responsible for collecting (and storing) the e-mail and potentially password
  /// (for convenience) in the client data.  For the greatest security,
  /// force the user to re-enter their password at each login.
  /// (Or at least give them that option).

  /// Service Name - authenticate
  /// Service Operation - authenticate
  ///
  /// Note that the password sent from the client to the server is protected via SSL.

  /// @param email
  /// The e-mail address of the user

  /// @param password
  /// The password of the user

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateEmailPassword({
    required String email,
    required String password,
    required bool forceCreate,
  }) {
    initializeIdentity(false);

    return _client.authenticationService
        .authenticateEmailPassword(email, password, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user via cloud code (which in turn validates the supplied credentials against an external system).
  /// This allows the developer to extend brainCloud authentication to support other backend authentication systems.

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param userid
  /// The user id

  /// @param token
  /// The user token (password etc)

  /// /// @param externalAuthName
  /// The name of the cloud script to call for external authentication

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateExternal({
    required String userid,
    required String token,
    required String externalAuthName,
    required bool forceCreate,
  }) {
    initializeIdentity(false);

    return _client.authenticationService
        .authenticateExternal(userid, token, externalAuthName, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user with brainCloud using their Facebook Credentials

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param externalId
  /// The facebook id of the user

  /// @param authenticationToken
  /// The validated token from the Facebook SDK (that will be further
  /// validated when sent to the bC service)

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateFacebook(
      {required String fbUserId,
      required String fbAuthToken,
      required bool forceCreate}) {
    initializeIdentity(false);
    return _client.authenticationService
        .authenticateFacebook(fbUserId, fbAuthToken, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user with brainCloud using their FacebookLimited Credentials

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param externalId
  /// The facebookLimited id of the user

  /// @param authenticationToken
  /// The validated token from the FacebookLimited SDK (that will be further
  /// validated when sent to the bC service)

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateFacebookLimited(
      {required String fbLimitedUserId,
      required String fbAuthToken,
      required bool forceCreate}) {
    initializeIdentity(false);

    return _client.authenticationService
        .authenticateFacebookLimited(fbLimitedUserId, fbAuthToken, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user with brainCloud using their Oculus Credentials

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param oculusUserId
  /// The oculus id of the user

  /// @param oculusNonce
  /// Validation token from Oculus gotten through the Oculus sdk

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateOculus(
      {required String oculusUserId,
      required String oculusNonce,
      required bool forceCreate}) {
    initializeIdentity(false);

    return _client.authenticationService
        .authenticateOculus(oculusUserId, oculusNonce, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user using their psn account id and an auth token

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param accountId
  /// The user's PSN account id

  /// @param authToken
  /// The user's PSN auth token

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticatePlaystationNetwork(
      {required String accountId,
      required String authToken,
      required bool forceCreate}) {
    initializeIdentity(false);
    return _client.authenticationService
        .authenticatePlaystationNetwork(accountId, authToken, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user using their psn account id and an auth token

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param accountId
  /// The user's PSN account id

  /// @param authToken
  /// The user's PSN auth token

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticatePlaystation5(
      {required String accountId,
      required String authToken,
      required bool forceCreate}) {
    initializeIdentity(false);

    return _client.authenticationService
        .authenticatePlaystation5(accountId, authToken, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user using their Game Center id

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param gameCenterId
  /// The user's game center id  (use the playerID property from the local GKPlayer object)

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateGameCenter(
      {required String gameCenterId, required bool forceCreate}) {
    initializeIdentity(false);

    return _client.authenticationService
        .authenticateGameCenter(gameCenterId, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user using an apple id

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param appleUserId
  /// This can be the user id OR the email of the user for the account

  /// @param identityToken
  /// The token confirming the user's identity

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateApple(
      {required String appleUserId,
      required String identityToken,
      required bool forceCreate}) {
    initializeIdentity(false);

    return _client.authenticationService
        .authenticateApple(appleUserId, identityToken, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user using a google userId and google server authentication code.

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param googleUserId
  /// String representation of google+ userId. Gotten with calls like RequestUserId

  /// @param serverAuthCode
  /// The server authentication token derived via the google apis. Gotten with calls like RequestServerAuthCode

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateGoogle(
      {required String googleUserId,
      required String serverAuthCode,
      required bool forceCreate}) {
    initializeIdentity(false);

    return _client.authenticationService
        .authenticateGoogle(googleUserId, serverAuthCode, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user using a google openId.

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param googleUserAccountEmail
  /// The email associated with the google user

  /// @param IdToken
  /// The id token of the google account. Can get with calls like requestIdToken

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateGoogleOpenId(
      {required String googleUserAccountEmail,
      required String idToken,
      required bool forceCreate}) {
    initializeIdentity(false);

    return _client.authenticationService
        .authenticateGoogleOpenId(googleUserAccountEmail, idToken, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user using a steam userid and session ticket (without any validation on the userid).

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param userid
  /// String representation of 64 bit steam id

  /// @param sessionticket
  /// The session ticket of the user (hex encoded)

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateSteam(
      {required String userid,
      required String sessionticket,
      required bool forceCreate}) {
    initializeIdentity(false);

    return _client.authenticationService
        .authenticateSteam(userid, sessionticket, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user using a Twitter userid, authentication token, and secret from twitter.

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param userid
  /// String representation of a Twitter user ID

  /// @param token
  /// The authentication token derived via the Twitter apis

  /// @param secret
  /// The secret given when attempting to link with Twitter

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateTwitter(
      {required String userid,
      required String token,
      required String secret,
      required bool forceCreate}) {
    initializeIdentity(false);
    return _client.authenticationService
        .authenticateTwitter(userid, token, secret, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user using a userid and password (without any validation on the userid).
  /// Similar to authenticateEmailPassword - except that that method has additional features to
  /// allow for e-mail validation, password resets, etc.

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param email
  /// The e-mail address of the user

  /// @param password
  /// The password of the user

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateUniversal(
      {required String username,
      required String password,
      required bool forceCreate}) {
    initializeIdentity(false);

    return _client.authenticationService
        .authenticateUniversal(username, password, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// A generic authenticate method that translates to the same as calling a specific one, except it takes an extraJson
  /// that will be passed along to pre-post hooks.

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param authenticationType
  ///  Universal, Email, Facebook, etc

  /// @param ids
  /// Auth IDs structure

  /// /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// /// @param extraJson
  /// Additional to piggyback along with the call, to be picked up by pre- or post- hooks. Leave empty String for no extraJson.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateAdvanced(
      {required AuthenticationType authenticationType,
      required AuthenticationIds ids,
      required bool forceCreate,
      required Map<String, dynamic> extraJson}) {
    bool isAnonymous = authenticationType == AuthenticationType.anonymous;
    initializeIdentity(isAnonymous);

    ids.externalId =
        isAnonymous ? getStoredAnonymousId() ?? "" : ids.externalId;
    ids.authenticationToken = isAnonymous ? "" : ids.authenticationToken;

    return _client.authenticationService
        .authenticateAdvanced(authenticationType, ids, forceCreate, extraJson)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user for Ultra.

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param ultraUsername
  /// It's what the user uses to log into the Ultra endpoint initially

  /// @param ultraIdToken
  /// The "id_token" taken from Ultra's JWT.

  /// /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateUltra(
      {required String ultraUsername,
      required String ultraIdToken,
      required bool forceCreate}) {
    initializeIdentity(false);

    return _client.authenticationService
        .authenticateUltra(ultraUsername, ultraIdToken, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// authenticate the user using their Nintendo account id and an auth token

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param accountId
  /// The user's Nintendo account id

  /// @param authToken
  /// The user's Nintendo auth token

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> authenticateNintendo({
    required String accountId,
    required String authToken,
    required bool forceCreate,
  }) {
    initializeIdentity(false);

    return _client.authenticationService
        .authenticateNintendo(accountId, authToken, forceCreate)
        .then((response) {
      authSuccessCallback(json: response.toJson());
      return response;
    });
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user with a custom Email and Password.  Note that the client app
  /// is responsible for collecting (and storing) the e-mail and potentially password
  /// (for convenience) in the client data.  For the greatest security,
  /// force the user to re-enter their password at each login.
  /// (Or at least give them that option).

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param email
  /// The e-mail address of the user

  /// @param password
  /// The password of the user

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticateEmail({
    required String email,
    required String password,
    required bool forceCreate,
  }) async {
    await _smartSwitchAuthentication();
    return authenticateEmailPassword(
        email: email, password: password, forceCreate: forceCreate);
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user via cloud code (which in turn validates the supplied credentials against an external system).
  /// This allows the developer to extend brainCloud authentication to support other backend authentication systems.

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param userid
  /// The user id

  /// @param token
  /// The user token (password etc)

  /// /// @param externalAuthName
  /// The name of the cloud script to call for external authentication

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticateExternal(
      {required String userid,
      required String token,
      required String externalAuthName,
      required bool forceCreate}) async {
    await _smartSwitchAuthentication();
    return authenticateExternal(
        userid: userid,
        token: token,
        externalAuthName: externalAuthName,
        forceCreate: forceCreate);
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user with brainCloud using their Facebook Credentials

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param externalId
  /// The facebook id of the user

  /// @param authenticationToken
  /// The validated token from the Facebook SDK (that will be further
  /// validated when sent to the bC service)

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticateFacebook(
      {required String fbUserId,
      required String fbAuthToken,
      required bool forceCreate}) async {
    await _smartSwitchAuthentication();
    return authenticateFacebook(
        fbUserId: fbUserId, fbAuthToken: fbAuthToken, forceCreate: forceCreate);
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user with brainCloud using their FacebookLimited Credentials

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param externalId
  /// The facebookLimited id of the user

  /// @param authenticationToken
  /// The validated token from the Facebook SDK (that will be further
  /// validated when sent to the bC service)

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticateFacebookLimited(
      {required String fbLimitedUserId,
      required String fbAuthToken,
      required bool forceCreate}) async {
    await _smartSwitchAuthentication();
    return authenticateFacebookLimited(
        fbLimitedUserId: fbLimitedUserId,
        fbAuthToken: fbAuthToken,
        forceCreate: forceCreate);
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user with brainCloud using their Oculus Credentials

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param oculusUserId
  /// The Oculus id of the user

  /// @param oculusNonce
  /// Validation token from Oculus gotten through the Oculus sdk

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticateOculus(
      {required String oculusUserId,
      required String oculusNonce,
      required bool forceCreate}) async {
    await _smartSwitchAuthentication();

    return authenticateOculus(
        oculusUserId: oculusUserId,
        oculusNonce: oculusNonce,
        forceCreate: forceCreate);
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user with brainCloud using their PSN Credentials

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param psnAccountId
  /// The psn account id of the user

  /// @param psnAuthToken
  /// The validated token from the Playstation SDK (that will be further
  /// validated when sent to the bC service)

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticatePlaystationNetwork(
      {required String psnAccountId,
      required String psnAuthToken,
      required bool forceCreate}) async {
    await _smartSwitchAuthentication();
    return authenticatePlaystationNetwork(
        accountId: psnAccountId,
        authToken: psnAuthToken,
        forceCreate: forceCreate);
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user with brainCloud using their Apple Credentials

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param externalId
  /// The apple id of the user

  /// @param authenticationToken
  /// The validated token from the Apple SDK (that will be further
  /// validated when sent to the bC service)

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticateApple(
      {required String appleUserId,
      required String appleAuthToken,
      required bool forceCreate}) async {
    await _smartSwitchAuthentication();
    return authenticateApple(
        appleUserId: appleUserId,
        identityToken: appleAuthToken,
        forceCreate: forceCreate);
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user using their Game Center id

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param gameCenterId
  /// The user's game center id  (use the playerID property from the local GKPlayer object)

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticateGameCenter(
      {required String gameCenterId, required bool forceCreate}) async {
    await _smartSwitchAuthentication();
    return authenticateGameCenter(
        gameCenterId: gameCenterId, forceCreate: forceCreate);
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user using a google userid(email address) and google authentication token.

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param userid
  /// String representation of google+ userid (email)

  /// @param token
  /// The authentication token derived via the google apis.

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticateGoogle(
      {required String userid,
      required String token,
      required bool forceCreate}) async {
    await _smartSwitchAuthentication();
    return authenticateGoogle(
        googleUserId: userid, serverAuthCode: token, forceCreate: forceCreate);
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user using a google userid(email address) and google authentication token.

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param userid
  /// String representation of google+ userid (email)

  /// @param token
  /// The authentication token derived via the google apis.

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticateGoogleOpenId(
      {required String userid,
      required String token,
      required bool forceCreate}) async {
    await _smartSwitchAuthentication();
    return authenticateGoogleOpenId(
        googleUserAccountEmail: userid,
        idToken: token,
        forceCreate: forceCreate);
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user using a steam userid and session ticket (without any validation on the userid).

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param userid
  /// String representation of 64 bit steam id

  /// @param sessionticket
  /// The session ticket of the user (hex encoded)

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticateSteam(
      {required String userid,
      required String sessionticket,
      required bool forceCreate}) async {
    await _smartSwitchAuthentication();

    return authenticateSteam(
        userid: userid, sessionticket: sessionticket, forceCreate: forceCreate);
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user using a Twitter userid, authentication token, and secret from twitter.

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param userid
  /// String representation of a Twitter user ID

  /// @param token
  /// The authentication token derived via the Twitter apis

  /// @param secret
  /// The secret given when attempting to link with Twitter

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @param success
  /// The method to call in event of successful login

  /// @param failure
  /// The method to call in the event of an error during authentication

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticateTwitter(
      {required String userid,
      required String token,
      required String secret,
      required bool forceCreate}) async {
    await _smartSwitchAuthentication();
    return authenticateTwitter(
        userid: userid, token: token, secret: secret, forceCreate: forceCreate);
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user using a userid and password (without any validation on the userid).
  /// Similar to authenticateEmailPassword - except that that method has additional features to
  /// allow for e-mail validation, password resets, etc.

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param email
  /// The e-mail address of the user

  /// @param password
  /// The password of the user

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticateUniversal(
      {required String username,
      required String password,
      required bool forceCreate}) async {
    await _smartSwitchAuthentication();

    return authenticateUniversal(
        username: username, password: password, forceCreate: forceCreate);
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean design flow from anonymous to signed profiles
  ///
  /// A generic authenticate method that translates to the same as calling a specific one, except it takes an extraJson
  /// that will be passed along to pre- or post- hooks.

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param authenticationType
  /// Universal, Email, Facebook, etc

  /// @param ids
  /// Auth IDs structure

  /// /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// /// @param extraJson
  /// Additional to piggyback along with the call, to be picked up by pre- or post- hooks. Leave empty String for no extraJson.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticateAdvanced(
      {required AuthenticationType authenticationType,
      required AuthenticationIds ids,
      required bool forceCreate,
      required Map<String, dynamic> extraJson}) async {
    await _smartSwitchAuthentication();
    return authenticateAdvanced(
        authenticationType: authenticationType,
        ids: ids,
        forceCreate: forceCreate,
        extraJson: extraJson);
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user for Ultra.
  ///

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param ultraUsername
  /// It's what the user uses to log into the Ultra endpoint initially

  /// @param ultraIdToken
  /// The "id_token" taken from Ultra's JWT.

  /// /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticateUltra(
      {required String ultraUsername,
      required String ultraIdToken,
      required bool forceCreate}) async {
    await _smartSwitchAuthentication();
    return authenticateUltra(
        ultraUsername: ultraUsername,
        ultraIdToken: ultraIdToken,
        forceCreate: forceCreate);
  }

  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user with brainCloud using their Nintendo Credentials

  /// Service Name - authenticate
  /// Service Operation - authenticate

  /// @param nintendoAccountId
  /// The Nintendo account id of the user

  /// @param nintendoAuthToken
  /// The validated token from the Nintendo SDK (that will be further
  /// validated when sent to the bC service)

  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?

  /// @returns Future<ServerResponse>
  Future<ServerResponse> smartSwitchauthenticateNintendo(
      {required String nintendoAccountId,
      required String nintendoAuthToken,
      required bool forceCreate}) async {
    await _smartSwitchAuthentication();
    return authenticateNintendo(
        accountId: nintendoAccountId,
        authToken: nintendoAuthToken,
        forceCreate: forceCreate);
  }

  /// @returns Future<ServerResponse>
  Future<ServerResponse> _smartSwitchAuthentication() async {
    ServerResponse? response = await _client.identityService.getIdentities();
    if (_client.authenticated) {
      if (response.body?['identities'] is Map &&
          response.body?['identities'].isEmpty) {
        // was anonymous delete user
        return brainCloudClient.playerStateService.deleteUser();
      } else {
        // else just logout
        return brainCloudClient.playerStateService.logout();
      }
    } else {
      return brainCloudClient.playerStateService.logout();
    }
  }

  /// Re-authenticates the user with brainCloud

  ///
  /// @returns Future<ServerResponse>
  Future<ServerResponse> reconnect() async {
    initializeIdentity(true);
    return _client.authenticationService.authenticateAnonymous(false);
  }

  /// Method initializes the identity information from the player prefs cache.
  /// This is specifically useful for an Anonymous authentication as Anonymous authentications
  /// require both the anonymous id *and* the profile id. By using the BrainCloudWrapper
  /// authenticateAnonymous method, a success callback handler hook will be installed
  /// that will trap the return from the brainCloud server and persist the anonymous id
  /// and profile id.
  ///
  /// Note that clients are free to implement this logic on their own as well if they
  /// wish to store the information in another location and/or change the behaviour.

  void initializeIdentity(bool isAnonymousAuth) {
    // retrieve profile and anonymous ids out of the cache
    String? profileId = getStoredProfileId();
    String? anonymousId = getStoredAnonymousId();

    if ((anonymousId?.isEmpty ?? true) || (anonymousId?.isEmpty ?? true)) {
      anonymousId = _client.authenticationService.generateAnonymousId();
      profileId ??= "";
      setStoredAnonymousId(anonymousId);
      setStoredProfileId(profileId);
    }
    String? profileIdToauthenticateWith = profileId;
    if (!isAnonymousAuth && _alwaysAllowProfileSwitch) {
      profileIdToauthenticateWith = "";
    }
    setStoredAuthenticationType(isAnonymousAuth ? authenticationAnonymous : "");
    _client.initializeIdentity(
        profileIdToauthenticateWith ?? "", anonymousId ?? "");
  }

  /// Reset Email password - Sends a password reset email to the specified address

  /// Service Name - authenticate
  /// Operation - ResetEmailPassword

  /// @param externalId
  /// The email address to send the reset email to.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> resetEmailPassword({required String externalId}) {
    return _client.authenticationService.resetEmailPassword(externalId);
  }

  /// Reset Email password with service parameters - sends a password reset email to
  ///the specified addresses.

  /// Service Name - authenticate
  /// Operation - ResetEmailPasswordAdvanced

  /// @param appId
  /// The app id

  /// @param emailAddress
  /// The email address to send the reset email to

  /// @param serviceParams
  /// The parameters to send the email service. See documentation for full list
  /// http://getbraincloud.com/apidocs/apiref/#capi-mail

  /// @returns Future<ServerResponse>
  Future<ServerResponse> resetEmailPasswordAdvanced(
      {required String emailAddress, required String serviceParams}) async {
    return _client.authenticationService
        .resetEmailPasswordAdvanced(emailAddress, serviceParams);
  }

  /// Reset Email password - Sends a password reset email to the specified address

  /// Service Name - authenticate
  /// Operation - ResetEmailPassword

  /// @param externalId
  /// The email address to send the reset email to.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> resetEmailPasswordWithExpiry(
      {required String externalId, required int tokenTtlInMinutes}) {
    return _client.authenticationService
        .resetEmailPasswordWithExpiry(externalId, tokenTtlInMinutes);
  }

  /// Reset Email password with service parameters - sends a password reset email to
  ///the specified addresses.

  /// Service Name - authenticate
  /// Operation - ResetEmailPasswordAdvanced

  /// @param appId
  /// The app id

  /// @param emailAddress
  /// The email address to send the reset email to

  /// @param serviceParams
  /// The parameters to send the email service. See documentation for full list
  /// http://getbraincloud.com/apidocs/apiref/#capi-mail

  /// @returns Future<ServerResponse>
  Future<ServerResponse> resetEmailPasswordAdvancedWithExpiry(
      {required String emailAddress,
      required String serviceParams,
      required int tokenTtlInMinutes}) {
    return _client.authenticationService.resetEmailPasswordAdvancedWithExpiry(
        emailAddress, serviceParams, tokenTtlInMinutes);
  }

  /// Reset Email password - Sends a password reset email to the specified address

  /// Service Name - authenticate
  /// Operation - ResetEmailPassword

  /// @param externalId
  /// The email address to send the reset email to.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> resetUniversalIdPassword({
    required String externalId,
  }) {
    return _client.authenticationService.resetUniversalIdPassword(externalId);
  }

  /// Reset Email password with service parameters - sends a password reset email to
  ///the specified addresses.

  /// Service Name - authenticate
  /// Operation - ResetEmailPasswordAdvanced

  /// @param appId
  /// The app id

  /// @param emailAddress
  /// The email address to send the reset email to

  /// @param serviceParams
  /// The parameters to send the email service. See documentation for full list
  /// http://getbraincloud.com/apidocs/apiref/#capi-mail

  /// @returns Future<ServerResponse>
  Future<ServerResponse> resetUniversalIdPasswordAdvanced({
    required String emailAddress,
    required String serviceParams,
  }) {
    return _client.authenticationService
        .resetUniversalIdPasswordAdvanced(emailAddress, serviceParams);
  }

  /// Reset Email password - Sends a password reset email to the specified address

  /// Service Name - authenticate
  /// Operation - ResetEmailPassword

  /// @param externalId
  /// The email address to send the reset email to.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> resetUniversalIdPasswordWithExpiry(
      {required String externalId, required int tokenTtlInMinutes}) {
    return _client.authenticationService
        .resetUniversalIdPasswordWithExpiry(externalId, tokenTtlInMinutes);
  }

  /// Reset Email password with service parameters - sends a password reset email to
  ///the specified addresses.

  /// Service Name - authenticate
  /// Operation - ResetEmailPasswordAdvanced

  /// @param appId
  /// The app id

  /// @param emailAddress
  /// The email address to send the reset email to

  /// @param serviceParams
  /// The parameters to send the email service. See documentation for full list
  /// http://getbraincloud.com/apidocs/apiref/#capi-mail

  /// @returns Future<ServerResponse>
  Future<ServerResponse> resetUniversalIdPasswordAdvancedWithExpiry(
      {required String emailAddress,
      required String serviceParams,
      required int tokenTtlInMinutes}) {
    return _client.authenticationService
        .resetUniversalIdPasswordAdvancedWithExpiry(
            emailAddress, serviceParams, tokenTtlInMinutes);
  }

  /// Gets the stored profile id from user prefs.

  /// @returns The stored profile id.
  String? getStoredProfileId() {
    return _wrapperData.profileId;
  }

  /// sets the stored profile id to user prefs.

  /// @param profileIdProfile id.
  void setStoredProfileId(String profileId) {
    _wrapperData.profileId = profileId;
    _saveData();
  }

  /// Resets the stored profile id to empty string.

  void resetStoredProfileId() {
    _wrapperData.profileId = "";
    _saveData();
  }

  /// Gets the stored anonymous id from user prefs.

  /// @returns The stored anonymous id.
  String? getStoredAnonymousId() {
    return _wrapperData.anonymousId;
  }

  /// sets the stored anonymous id to user prefs.

  /// @param anonymousIdAnonymous id
  void setStoredAnonymousId(String anonymousId) {
    _wrapperData.anonymousId = anonymousId;
    _saveData();
  }

  /// Resets the stored anonymous id to empty string.

  void resetStoredAnonymousId() {
    _wrapperData.anonymousId = "";
    _saveData();
  }

  /// Gets the type of the stored authentication.

  /// @returns The stored authentication type.
  String? getStoredAuthenticationType() {
    return _wrapperData.authenticationType;
  }

  /// sets the type of the stored authentication.

  /// @param authenticationTypeAuthentication type.
  void setStoredAuthenticationType(String authenticationType) {
    _wrapperData.authenticationType = authenticationType;
    _saveData();
  }

  /// Resets the type of the stored authentication to empty string

  void resetStoredAuthenticationType() {
    _wrapperData.authenticationType = "";
    _saveData();
  }

  /// Gets the stored sessionId

  String getStoredSessionId() {
    return _wrapperData.sessionId;
  }

  /// sets the stored sessionId

  void setStoredSessionId(String sessionId) {
    _wrapperData.sessionId = sessionId;
    _saveData();
  }

  /// Resets the stored sessionId

  void resetStoredSessionId() {
    setStoredSessionId("");
  }

  /// Gets the stored lastPacketId

  int getStoredPacketId() {
    return _wrapperData.lastPacketId;
  }

  /// sets the stored lastPacketId

  void setStoredPacketId(int lastPacketId) {
    _wrapperData.lastPacketId = lastPacketId;
    _saveData();
  }

  /// Resets the stored lastPacketId

  void resetStoredPacketId() {
    setStoredPacketId(1);
  }

  void restorePacketId() {
    _wrapperData.lastPacketId++;
    _client.restorePacketId(_wrapperData.lastPacketId);
  }

  /// Provides a way to reauthenticate with the stored anonymous and profile id.
  /// Only works for Anonymous authentications.

  void reauthenticate() {
    init(
        secretKey: _lastSecretKey,
        appId: _lastAppId,
        version: _lastAppVersion,
        url: _lastUrl);
    String authType = getStoredAuthenticationType() ?? "";
    if (authType == authenticationAnonymous) {
      authenticateAnonymous();
    }
  }

  /// Logs user out of server.

  /// @param forgetUser{boolean} forgetUser Determines whether the stored profile ID should be reset or not
  /// @param responseHandler{*} responseHandler Function to invoke when request is processed
  /// @returns Future<ServerResponse>
  Future<ServerResponse> logout({bool forgetUser = false}) async {
    if (forgetUser) {
      resetStoredProfileId();
    }
    return _client.playerStateService.logout();
  }

  /// Callback for authentication success using the BrainCloudWrapper class.

  /// @param jsonThe returned json
  void authSuccessCallback({required Map<String, dynamic> json}) {
    // grab the profileId and save it in PlayerPrefs

    Map<String, dynamic> jsonData = json["data"];

    if (jsonData.containsKey("profileId")) {
      setStoredProfileId(jsonData["profileId"]);
    }

    if (jsonData.containsKey("sessionId")) {
      setStoredSessionId(jsonData["sessionId"]);
    }
  }

  Future<void> _saveData() async {
    String prefix = wrapperName.isEmptyOrNull ? "" : "$wrapperName.";
    SharedPreferences playerPrefs = await SharedPreferences.getInstance();

    await playerPrefs.setString(
        prefix + prefsProfileId, _wrapperData.profileId);
    await playerPrefs.setString(
        prefix + prefsAnonymousId, _wrapperData.anonymousId);
    await playerPrefs.setString(
        prefix + prefsAuthenticationType, _wrapperData.authenticationType);
    await playerPrefs.setString(
        prefix + prefsSessionId, _wrapperData.sessionId);
    await playerPrefs.setInt(
        prefix + prefsLastPacketId, _wrapperData.lastPacketId);
  }

  Future<void> _loadData() async {
    String prefix = wrapperName.isEmptyOrNull ? "" : "$wrapperName.";
    SharedPreferences playerPrefs = await SharedPreferences.getInstance();

    _wrapperData.profileId =
        playerPrefs.getString(prefix + prefsProfileId) ?? "";
    _wrapperData.anonymousId =
        playerPrefs.getString(prefix + prefsAnonymousId) ?? "";
    _wrapperData.authenticationType =
        playerPrefs.getString(prefix + prefsAuthenticationType) ?? "";
    _wrapperData.sessionId =
        playerPrefs.getString(prefix + prefsSessionId) ?? "";
    _wrapperData.lastPacketId =
        playerPrefs.getInt(prefix + prefsLastPacketId) ?? 1;

    _client.restorePacketId(_wrapperData.lastPacketId);
  }

  void restoreSession() {
    _client.comms?.restoreProfileAndSessionIds(_wrapperData);
  }
}

class WrapperData {
  String profileId = "";
  String anonymousId = "";
  String authenticationType = "";
  String sessionId = "";
  int lastPacketId = 1;

  @override
  String toString() {
    return "profileId: $profileId,  anonymousId: $anonymousId, authenticationType: $authenticationType, sessionId: $sessionId, lastPacketId: $lastPacketId";
  }
}
