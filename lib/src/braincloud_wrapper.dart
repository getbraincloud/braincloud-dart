//----------------------------------------------------
// brainCloud client source code
// Copyright 2024 bitHeads, inc.
//----------------------------------------------------
import 'dart:convert';

import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/material.dart';

import 'package:braincloud_dart/src/Common/authentication_ids.dart';
import 'package:braincloud_dart/src/Common/authentication_type.dart';
import 'package:braincloud_dart/src/Entity/bc_entity_factory.dart';
import 'package:braincloud_dart/src/internal/wrapper_auth_callback_object.dart';
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
import 'package:braincloud_dart/src/braincloud_s3_handling.dart';
import 'package:braincloud_dart/src/braincloud_script.dart';
import 'package:braincloud_dart/src/braincloud_social_leaderboard.dart';
import 'package:braincloud_dart/src/braincloud_time.dart';
import 'package:braincloud_dart/src/braincloud_tournament.dart';
import 'package:braincloud_dart/src/braincloud_user_items.dart';
import 'package:braincloud_dart/src/braincloud_virtual_currency.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// <summary>
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
/// The meat of the BrainCloud api is available by using
///
/// BrainCloudWrapper.GetBC()
///
/// to grab an instance of the BrainCloudClient. From here you have access to all of the brainCloud
/// API service. So for instance, to execute a read player statistics API you would do the following:
///
/// BrainCloudWrapper.GetBC().PlayerStatisticsService.ReadAllUserStats()
///
/// Similar services exist for other APIs.
///
/// See http://getbraincloud.com/apidocs/ for the full list of brainCloud APIs.
/// </summary>

class BrainCloudWrapper {
  /// <summary>
  /// The key for the user prefs profile id
  /// </summary>
  static String prefsProfileId = "brainCloud.profileId";

  /// <summary>
  /// The key for the user prefs anonymous id
  /// </summary>
  static String prefsAnonymousId = "brainCloud.anonymousId";

  /// <summary>
  /// The key for the user prefs authentication type
  /// </summary>
  static String prefsAuthenticationType = "brainCloud.authenticationType";

  /// <summary>
  /// The key for the user prefs session id
  /// </summary>
  static String prefsSessionId = "brainCloud.authenticationType";

  /// <summary>
  /// The key for the user prefs session id
  /// </summary>
  static String prefsLastPacketId = "brainCloud.lastPacketId";

  /// <summary>
  /// The name of the singleton brainCloud game object
  /// </summary>
  static String gameobjectBraincloud = "BrainCloudWrapper";

  static String authenticationAnonymous = "anonymous";

  String _lastUrl = "";
  String _lastSecretKey = "";
  String _lastAppId = "";
  String _lastAppVersion = "";

  bool _alwaysAllowProfileSwitch = true;

  WrapperData _wrapperData = WrapperData();

  //Getting this error? - "An object reference is required for the non-static field, method, or property 'BrainCloudWrapper.Client'"
  //Switch to BrainCloudWrapper.GetBC();
  late BrainCloudClient _client;

  getAllowProfileSwitch() {
    return _alwaysAllowProfileSwitch;
  }

  setAllowProfileSwitch(bool value) {
    _alwaysAllowProfileSwitch = value;
  }

  void _onApplicationQuit() {
    rTTService?.disableRTT();
    relayService?.disconnect();
    _client.update();
  }

  void onDestroy() {
    //StopAllCoroutines();
  }

  /// <summary>
  /// Name of this wrapper instance. Used for data loading
  /// </summary>
  String? wrapperName;

  BrainCloudEntity get entityService => _client.entityService;

  BCEntityFactory get entityFactory => _client.entityFactory;

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

  BrainCloudS3Handling get s3HandlingService => _client.s3HandlingService;

  BrainCloudRedemptionCode get redemptionCodeService =>
      _client.redemptionCodeService;

  BrainCloudDataStream get dataStreamService => _client.dataStreamService;

  BrainCloudProfanity get profanityService => _client.profanityService;

  BrainCloudFile get fileService => _client.fileService;

  BrainCloudGroup get groupService => _client.groupService;

  BrainCloudMail get mailService => _client.mailService;

  BrainCloudRTT? get rTTService => _client.rttService;

  BrainCloudLobby? get lobbyService => _client.lobbyService;

  BrainCloudChat? get chatService => _client.chatService;

  BrainCloudMessaging get messagingService => _client.messagingService;

  BrainCloudRelay? get relayService => _client.relayService;

  BrainCloudGroupFile get groupFileService => _client.groupFileService;

  /// <summary>
  /// Create the brainCloud Wrapper, which has utility helpers for using the brainCloud API
  /// </summary>
  BrainCloudWrapper({BrainCloudClient? client, this.wrapperName}) {
    if (client != null) {
      _client = client;
      _client.wrapper = this;
    } else {
      _client = BrainCloudClient(this);
    }
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

  /// <summary>
  /// Initialize the brainCloud client with the passed in parameters. This version of Initialize
  /// overrides the parameters configured in the Unity brainCloud settings window.
  /// </summary>
  /// <param name="url">The brainCloud server url</param>
  /// <param name="secretKey">The app's secret</param>
  /// <param name="appId">The app's id</param>
  /// <param name="version">The app's version</param>
  Future<void> init(String secretKey, String appId, String version,
      {String? url}) async {
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
  }

  /// <summary>
  /// Initialize the brainCloud client with the passed in parameters. This version of Initialize
  /// overrides the parameters configured in the Unity brainCloud settings window.
  /// </summary>
  /// <param name="url">The brainCloud server url</param>
  /// <param name="secretKey">The app's secret</param>
  /// <param name="appId">The app's id</param>
  /// <param name="version">The app's version</param>
  Future<void> initWithApps(String url, String defaultAppId,
      Map<String, String> appIdSecretMap, String version) async {
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
  }

  /// <summary>
  /// Resets the wrapper.
  /// Since the WrapperName is set upon re-initialization of the wrapper, the name is reset by choice here. As the user
  /// may want to reset the wrapper's fields without also restting the name.
  /// </summary>
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
  }

  /// <summary>
  /// If set to true, profile id is never sent along with non-anonymous authenticates
  /// thereby ensuring that valid credentials always work but potentially cause a profile switch.
  /// If set to false, profile id is passed to the server (if it has been stored) and a profile id
  /// to non-anonymous credential mismatch will cause an error.
  /// </summary>
  /// <param name="enabled">True if we always allow profile switch</param>
  void setAlwaysAllowProfileSwitch(bool enabled) {
    _alwaysAllowProfileSwitch = enabled;
  }

  /// <summary>
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
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateAnonymous(SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    WrapperAuthCallbackObject aco = _makeWrapperAuthCallback(
        success, failure, cbObject,
        isAnonymousAuth: true);

    _client.authenticationService?.authenticateAnonymous(
        null,
        true,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user using a Pase userid and authentication token
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="handoffId">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="securityToken">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateHandoff(String handoffId, String securityToken,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticateHandoff(
        handoffId,
        securityToken,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate user with handoffCode
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="handoffCode">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticatesettopHandoff(String handoffCode, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticateSettopHandoff(
        handoffCode,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user with a custom Email and Password.  Note that the client app
  /// is responsible for collecting (and storing) the e-mail and potentially password
  /// (for convenience) in the client data.  For the greatest security,
  /// force the user to re-enter their password at each login.
  /// (Or at least give them that option).
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  ///
  /// Note that the password sent from the client to the server is protected via SSL.
  /// </remarks>
  /// <param name="email">
  /// The e-mail address of the user
  /// </param>
  /// <param name="password">
  /// The password of the user
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateEmailPassword(
      String email,
      String password,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    mergeSuccess(String response) {
      if (success != null) {
        success(response);
      }
      authSuccessCallback(response, cbObject);
    }

    mergeFailure(int statusCode, int reasonCode, String statusMessage) {
      if (failure != null) {
        failure(statusCode, reasonCode, statusMessage);
      }

      authFailureCallback(statusCode, reasonCode, statusMessage, cbObject);
    }

    _client.authenticationService?.authenticateEmailPassword(
        email, password, forceCreate, mergeSuccess, mergeFailure, aco);
  }

  /// <summary>
  /// authenticate the user via cloud code (which in turn validates the supplied credentials against an external system).
  /// This allows the developer to extend brainCloud authentication to support other backend authentication systems.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="userid">
  /// The user id
  /// </param>
  /// <param name="token">
  /// The user token (password etc)
  /// </param>
  /// /// <param name="externalAuthName">
  /// The name of the cloud script to call for external authentication
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateExternal(
      String userid,
      String token,
      String externalAuthName,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticateExternal(
        userid,
        token,
        externalAuthName,
        forceCreate,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user with brainCloud using their Facebook Credentials
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="externalId">
  /// The facebook id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the Facebook SDK (that will be further
  /// validated when sent to the bC service)
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateFacebook(
      String fbUserId,
      String fbAuthToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticateFacebook(
        fbUserId,
        fbAuthToken,
        forceCreate,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user with brainCloud using their FacebookLimited Credentials
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="externalId">
  /// The facebookLimited id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the FacebookLimited SDK (that will be further
  /// validated when sent to the bC service)
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateFacebookLimited(
      String fbLimitedUserId,
      String fbAuthToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticateFacebookLimited(
        fbLimitedUserId,
        fbAuthToken,
        forceCreate,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user with brainCloud using their Oculus Credentials
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="oculusUserId">
  /// The oculus id of the user
  /// </param>
  /// <param name="oculusNonce">
  /// Validation token from Oculus gotten through the Oculus sdk
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateOculus(
      String oculusUserId,
      String oculusNonce,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticateOculus(
        oculusUserId,
        oculusNonce,
        forceCreate,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user using their psn account id and an auth token
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="accountId">
  /// The user's PSN account id
  /// </param>
  /// <param name="authToken">
  /// The user's PSN auth token
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticatePlaystationNetwork(
      String accountId,
      String authToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticatePlaystationNetwork(
        accountId,
        authToken,
        forceCreate,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user using their psn account id and an auth token
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="accountId">
  /// The user's PSN account id
  /// </param>
  /// <param name="authToken">
  /// The user's PSN auth token
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticatePlaystation5(
      String accountId,
      String authToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticatePlaystation5(
        accountId,
        authToken,
        forceCreate,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user using their Game Center id
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="gameCenterId">
  /// The user's game center id  (use the playerID property from the local GKPlayer object)
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateGameCenter(String gameCenterId, bool forceCreate,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticateGameCenter(
        gameCenterId,
        forceCreate,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user using an apple id
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="appleUserId">
  /// This can be the user id OR the email of the user for the account
  /// </param>
  /// <param name="identityToken">
  /// The token confirming the user's identity
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateApple(
      String appleUserId,
      String identityToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticateApple(
        appleUserId,
        identityToken,
        forceCreate,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user using a google userId and google server authentication code.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="googleUserId">
  /// String representation of google+ userId. Gotten with calls like RequestUserId
  /// </param>
  /// <param name="serverAuthCode">
  /// The server authentication token derived via the google apis. Gotten with calls like RequestServerAuthCode
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateGoogle(
      String googleUserId,
      String serverAuthCode,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticateGoogle(
        googleUserId,
        serverAuthCode,
        forceCreate,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user using a google openId.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="googleUserAccountEmail"
  /// The email associated with the google user
  /// </param>
  /// <param name="IdToken">
  /// The id token of the google account. Can get with calls like requestIdToken
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateGoogleOpenId(
      String googleUserAccountEmail,
      String idToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticateGoogleOpenId(
        googleUserAccountEmail,
        idToken,
        forceCreate,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user using a steam userid and session ticket (without any validation on the userid).
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="userid">
  /// String representation of 64 bit steam id
  /// </param>
  /// <param name="sessionticket">
  /// The session ticket of the user (hex encoded)
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateSteam(String userid, String sessionticket, bool forceCreate,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticateSteam(
        userid,
        sessionticket,
        forceCreate,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user using a Twitter userid, authentication token, and secret from twitter.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="userid">
  /// String representation of a Twitter user ID
  /// </param>
  /// <param name="token">
  /// The authentication token derived via the Twitter apis
  /// </param>
  /// <param name="secret">
  /// The secret given when attempting to link with Twitter
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateTwitter(
      String userid,
      String token,
      String secret,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticateTwitter(
        userid,
        token,
        secret,
        forceCreate,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user using a userid and password (without any validation on the userid).
  /// Similar to authenticateEmailPassword - except that that method has additional features to
  /// allow for e-mail validation, password resets, etc.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="email">
  /// The e-mail address of the user
  /// </param>
  /// <param name="password">
  /// The password of the user
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateUniversal(String username, String password, bool forceCreate,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticateUniversal(
        username,
        password,
        forceCreate,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// A generic authenticate method that translates to the same as calling a specific one, except it takes an extraJson
  /// that will be passed along to pre-post hooks.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="authenticationType">
  ///  Universal, Email, Facebook, etc
  /// </param>
  /// <param name="ids">
  /// Auth IDs structure
  /// </param>
  /// /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// /// <param name="extraJson">
  /// Additional to piggyback along with the call, to be picked up by pre- or post- hooks. Leave empty String for no extraJson.
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateAdvanced(
      AuthenticationType authenticationType,
      AuthenticationIds ids,
      bool forceCreate,
      Map<String, dynamic> extraJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    bool isAnonymous = authenticationType == AuthenticationType.Anonymous;
    WrapperAuthCallbackObject aco = _makeWrapperAuthCallback(
        success, failure, cbObject,
        isAnonymousAuth: isAnonymous);

    ids.externalId =
        isAnonymous ? getStoredAnonymousId() ?? "" : ids.externalId;
    ids.authenticationToken = isAnonymous ? "" : ids.authenticationToken;

    _client.authenticationService?.authenticateAdvanced(
        authenticationType,
        ids,
        forceCreate,
        extraJson,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user for Ultra.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="ultraUsername">
  /// It's what the user uses to log into the Ultra endpoint initially
  /// </param>
  /// <param name="ultraIdToken">
  /// The "id_token" taken from Ultra's JWT.
  /// </param>
  /// /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateUltra(
      String ultraUsername,
      String ultraIdToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticateUltra(
        ultraUsername,
        ultraIdToken,
        forceCreate,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// authenticate the user using their Nintendo account id and an auth token
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="accountId">
  /// The user's Nintendo account id
  /// </param>
  /// <param name="authToken">
  /// The user's Nintendo auth token
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateNintendo(
      String accountId,
      String authToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    WrapperAuthCallbackObject aco =
        _makeWrapperAuthCallback(success, failure, cbObject);

    _client.authenticationService?.authenticateNintendo(
        accountId,
        authToken,
        forceCreate,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user with a custom Email and Password.  Note that the client app
  /// is responsible for collecting (and storing) the e-mail and potentially password
  /// (for convenience) in the client data.  For the greatest security,
  /// force the user to re-enter their password at each login.
  /// (Or at least give them that option).
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="email">
  /// The e-mail address of the user
  /// </param>
  /// <param name="password">
  /// The password of the user
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticateEmail(
      String email,
      String password,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    // SuccessCallback authenticateCallback = (response, o) =>
    // {
    //     authenticateEmailPassword(email, password, forceCreate, success, failure, cbObject);
    // };

    authenticateCallback(String response) {
      if (success != null) {
        success(response);
      }
      authenticateEmailPassword(
          email, password, forceCreate, success, failure, cbObject);
    }

    _smartSwitchAuthentication(authenticateCallback, failure);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user via cloud code (which in turn validates the supplied credentials against an external system).
  /// This allows the developer to extend brainCloud authentication to support other backend authentication systems.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="userid">
  /// The user id
  /// </param>
  /// <param name="token">
  /// The user token (password etc)
  /// </param>
  /// /// <param name="externalAuthName">
  /// The name of the cloud script to call for external authentication
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticateExternal(
      String userid,
      String token,
      String externalAuthName,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticateCallback(String response) {
      if (success != null) {
        success(response);
      }

      authenticateExternal(userid, token, externalAuthName, forceCreate,
          success, failure, cbObject);
    }

    _smartSwitchAuthentication(authenticateCallback, failure);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user with brainCloud using their Facebook Credentials
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="externalId">
  /// The facebook id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the Facebook SDK (that will be further
  /// validated when sent to the bC service)
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticateFacebook(
      String fbUserId,
      String fbAuthToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    mergedSuccess(String response) {
      if (success != null) {
        success(response);
      }

      authenticateFacebook(
          fbUserId, fbAuthToken, forceCreate, success, failure, cbObject);
    }

    _smartSwitchAuthentication(mergedSuccess, failure);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user with brainCloud using their FacebookLimited Credentials
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="externalId">
  /// The facebookLimited id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the Facebook SDK (that will be further
  /// validated when sent to the bC service)
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticateFacebookLimited(
      String fbLimitedUserId,
      String fbAuthToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticateCallback(String response) {
      if (success != null) {
        success(response);
      }
      authenticateFacebookLimited(fbLimitedUserId, fbAuthToken, forceCreate,
          success, failure, cbObject);
    }

    _smartSwitchAuthentication(authenticateCallback, failure);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user with brainCloud using their Oculus Credentials
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="oculusUserId">
  /// The Oculus id of the user
  /// </param>
  /// <param name="oculusNonce">
  /// Validation token from Oculus gotten through the Oculus sdk
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticateOculus(
      String oculusUserId,
      String oculusNonce,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticateCallback(String response) {
      if (success != null) {
        success(response);
      }
      authenticateOculus(
          oculusUserId, oculusNonce, forceCreate, success, failure, cbObject);
    }

    _smartSwitchAuthentication(authenticateCallback, failure);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user with brainCloud using their PSN Credentials
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="psnAccountId">
  /// The psn account id of the user
  /// </param>
  /// <param name="psnAuthToken">
  /// The validated token from the Playstation SDK (that will be further
  /// validated when sent to the bC service)
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticatePlaystationNetwork(
      String psnAccountId,
      String psnAuthToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticateCallback(String response) {
      if (success != null) {
        success(response);
      }
      authenticatePlaystationNetwork(
          psnAccountId, psnAuthToken, forceCreate, success, failure, cbObject);
    }

    _smartSwitchAuthentication(authenticateCallback, failure);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user with brainCloud using their Apple Credentials
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="externalId">
  /// The apple id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the Apple SDK (that will be further
  /// validated when sent to the bC service)
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticateApple(
      String appleUserId,
      String appleAuthToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticateCallback(String response) {
      if (success != null) {
        success(response);
      }
      authenticateApple(
          appleUserId, appleAuthToken, forceCreate, success, failure, cbObject);
    }

    _smartSwitchAuthentication(authenticateCallback, failure);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user using their Game Center id
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="gameCenterId">
  /// The user's game center id  (use the playerID property from the local GKPlayer object)
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticateGameCenter(String gameCenterId, bool forceCreate,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    authenticateCallback(String response) {
      if (success != null) {
        success(response);
      }
      authenticateGameCenter(
          gameCenterId, forceCreate, success, failure, cbObject);
    }

    _smartSwitchAuthentication(authenticateCallback, failure);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user using a google userid(email address) and google authentication token.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="userid">
  /// String representation of google+ userid (email)
  /// </param>
  /// <param name="token">
  /// The authentication token derived via the google apis.
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticateGoogle(
      String userid,
      String token,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticateCallback(String response) {
      if (success != null) {
        success(response);
      }
      authenticateGoogle(
          userid, token, forceCreate, success, failure, cbObject);
    }

    _smartSwitchAuthentication(authenticateCallback, failure);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user using a google userid(email address) and google authentication token.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="userid">
  /// String representation of google+ userid (email)
  /// </param>
  /// <param name="token">
  /// The authentication token derived via the google apis.
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticateGoogleOpenId(
      String userid,
      String token,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticateCallback(String response) {
      if (success != null) {
        success(response);
      }
      authenticateGoogleOpenId(
          userid, token, forceCreate, success, failure, cbObject);
    }

    _smartSwitchAuthentication(authenticateCallback, failure);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user using a steam userid and session ticket (without any validation on the userid).
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="userid">
  /// String representation of 64 bit steam id
  /// </param>
  /// <param name="sessionticket">
  /// The session ticket of the user (hex encoded)
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticateSteam(
      String userid,
      String sessionticket,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticateCallback(String response) {
      if (success != null) {
        success(response);
      }
      authenticateSteam(
          userid, sessionticket, forceCreate, success, failure, cbObject);
    }

    _smartSwitchAuthentication(authenticateCallback, failure);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user using a Twitter userid, authentication token, and secret from twitter.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="userid">
  /// String representation of a Twitter user ID
  /// </param>
  /// <param name="token">
  /// The authentication token derived via the Twitter apis
  /// </param>
  /// <param name="secret">
  /// The secret given when attempting to link with Twitter
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticateTwitter(
      String userid,
      String token,
      String secret,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticateCallback(String response) {
      if (success != null) {
        success(response);
      }
      authenticateTwitter(
          userid, token, secret, forceCreate, success, failure, cbObject);
    }

    _smartSwitchAuthentication(authenticateCallback, failure);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user using a userid and password (without any validation on the userid).
  /// Similar to authenticateEmailPassword - except that that method has additional features to
  /// allow for e-mail validation, password resets, etc.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="email">
  /// The e-mail address of the user
  /// </param>
  /// <param name="password">
  /// The password of the user
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticateUniversal(
      String username,
      String password,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticateCallback(String response) {
      if (success != null) {
        success(response);
      }
      authenticateUniversal(
          username, password, forceCreate, success, failure, cbObject);
    }

    _smartSwitchAuthentication(authenticateCallback, failure);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean design flow from anonymous to signed profiles
  ///
  /// A generic authenticate method that translates to the same as calling a specific one, except it takes an extraJson
  /// that will be passed along to pre- or post- hooks.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="authenticationType">
  /// Universal, Email, Facebook, etc
  /// </param>
  /// <param name="ids">
  /// Auth IDs structure
  /// </param>
  /// /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// /// <param name="extraJson">
  /// Additional to piggyback along with the call, to be picked up by pre- or post- hooks. Leave empty String for no extraJson.
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticateAdvanced(
      AuthenticationType authenticationType,
      AuthenticationIds ids,
      bool forceCreate,
      Map<String, dynamic> extraJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticateCallback(String response) {
      if (success != null) {
        success(response);
      }
      authenticateAdvanced(authenticationType, ids, forceCreate, extraJson,
          success, failure, cbObject);
    }

    _smartSwitchAuthentication(authenticateCallback, failure);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user for Ultra.
  ///
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="ultraUsername">
  /// It's what the user uses to log into the Ultra endpoint initially
  /// </param>
  /// <param name="ultraIdToken">
  /// The "id_token" taken from Ultra's JWT.
  /// </param>
  /// /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticateUltra(
      String ultraUsername,
      String ultraIdToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticateCallback(String response) {
      if (success != null) {
        success(response);
      }
      authenticateUltra(
          ultraUsername, ultraIdToken, forceCreate, success, failure, cbObject);
    }

    _smartSwitchAuthentication(authenticateCallback, failure);
  }

  /// <summary>
  /// Smart Switch authenticate will logout of the current profile, and switch to the new authentication type.
  /// In event the current session was previously an anonymous account, the smart switch will delete that profile.
  /// Use this function to keep a clean designflow from anonymous to signed profiles
  ///
  /// authenticate the user with brainCloud using their Nintendo Credentials
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Service Operation - authenticate
  /// </remarks>
  /// <param name="nintendoAccountId">
  /// The Nintendo account id of the user
  /// </param>
  /// <param name="nintendoAuthToken">
  /// The validated token from the Nintendo SDK (that will be further
  /// validated when sent to the bC service)
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void smartSwitchauthenticateNintendo(
      String nintendoAccountId,
      String nintendoAuthToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticateCallback(String response) {
      if (success != null) {
        success(response);
      }
      authenticateNintendo(nintendoAccountId, nintendoAuthToken, forceCreate,
          success, failure, cbObject);
    }

    _smartSwitchAuthentication(authenticateCallback, failure);
  }

  void _smartSwitchAuthentication(
      SuccessCallback? authenticateCallback, FailureCallback? failureCallback) {
    var callback = getIdentitiesCallback(authenticateCallback, failureCallback);

    if (_client.authenticated) {
      _client.identityService.getIdentities(callback, null, null);
    } else {
      authenticateCallback!("");
    }
  }

  SuccessCallback getIdentitiesCallback(
      SuccessCallback? success, FailureCallback? failure) {
    const String keyJsonData = "data";
    const String keyJsonIdentities = "identities";

    callback(String response) {
      if (success != null) {
        success(response);
      }
      Map<String, dynamic> jsonMessage = jsonDecode(response);
      Map<String, dynamic> jsonData = jsonMessage[keyJsonData];

      if (jsonData.containsKey(keyJsonIdentities)) {
        Map<String, dynamic> jsonIdentities = jsonData[keyJsonIdentities];
        if (jsonIdentities.isEmpty) {
          _client.playerStateService.deleteUser(success, failure, null);
        } else {
          _client.playerStateService.logout(success, failure, null);
        }
      }
    }

    return callback;
  }

  /// <summary>
  /// Re-authenticates the user with brainCloud
  /// </summary>
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void reconnect(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    WrapperAuthCallbackObject aco = _makeWrapperAuthCallback(
        success, failure, cbObject,
        isAnonymousAuth: true);

    _client.authenticationService?.authenticateAnonymous(
        null,
        false,
        authSuccessCallback as SuccessCallback,
        authFailureCallback as FailureCallback,
        aco);
  }

  /// <summary>
  /// Method initializes the identity information from the Unity player prefs cache.
  /// This is specifically useful for an Anonymous authentication as Anonymous authentications
  /// require both the anonymous id *and* the profile id. By using the BrainCloudWrapper
  /// authenticateAnonymous method, a success callback handler hook will be installed
  /// that will trap the return from the brainCloud server and persist the anonymous id
  /// and profile id.
  ///
  /// Note that clients are free to implement this logic on their own as well if they
  /// wish to store the information in another location and/or change the behaviour.
  /// </summary>
  void initializeIdentity(bool isAnonymousAuth) {
    // retrieve profile and anonymous ids out of the cache
    String? profileId = getStoredProfileId();
    String? anonymousId = getStoredAnonymousId();

    if ((anonymousId != "" && profileId == "") || anonymousId == "") {
      anonymousId = _client.authenticationService?.generateAnonymousId() ?? "";
      profileId = "";
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

  /// <summary>
  /// Reset Email password - Sends a password reset email to the specified address
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Operation - ResetEmailPassword
  /// </remarks>
  /// <param name="externalId">
  /// The email address to send the reset email to.
  /// </param>
  /// <param name="success">
  /// The method to call in event of success
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void resetEmailPassword(String externalId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    _client.authenticationService
        ?.resetEmailPassword(externalId, success, failure, cbObject);
  }

  /// <summary>
  /// Reset Email password with service parameters - sends a password reset email to
  ///the specified addresses.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Operation - ResetEmailPasswordAdvanced
  /// </remarks>
  /// <param name="appId">
  /// The app id
  /// </param>
  /// <param name="emailAddress">
  /// The email address to send the reset email to
  /// </param>
  /// <param name="serviceParams">
  /// The parameters to send the email service. See documentation for full list
  /// http://getbraincloud.com/apidocs/apiref/#capi-mail
  /// </param>
  /// <param name="success">
  /// The method to call in event of success
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void resetEmailPasswordAdvanced(
      String emailAddress,
      //Map<String, dynamic> serviceParams,
      String serviceParams,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _client.authenticationService?.resetEmailPasswordAdvanced(
        emailAddress, serviceParams, success, failure, cbObject);
  }

  /// <summary>
  /// Reset Email password - Sends a password reset email to the specified address
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Operation - ResetEmailPassword
  /// </remarks>
  /// <param name="externalId">
  /// The email address to send the reset email to.
  /// </param>
  /// <param name="success">
  /// The method to call in event of success
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void resetEmailPasswordWithExpiry(String externalId, int tokenTtlInMinutes,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _client.authenticationService?.resetEmailPasswordWithExpiry(
        externalId, tokenTtlInMinutes, success, failure, cbObject);
  }

  /// <summary>
  /// Reset Email password with service parameters - sends a password reset email to
  ///the specified addresses.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Operation - ResetEmailPasswordAdvanced
  /// </remarks>
  /// <param name="appId">
  /// The app id
  /// </param>
  /// <param name="emailAddress">
  /// The email address to send the reset email to
  /// </param>
  /// <param name="serviceParams">
  /// The parameters to send the email service. See documentation for full list
  /// http://getbraincloud.com/apidocs/apiref/#capi-mail
  /// </param>
  /// <param name="success">
  /// The method to call in event of success
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void resetEmailPasswordAdvancedWithExpiry(
      String emailAddress,
      String serviceParams,
      int tokenTtlInMinutes,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _client.authenticationService?.resetEmailPasswordAdvancedWithExpiry(
        emailAddress,
        serviceParams,
        tokenTtlInMinutes,
        success,
        failure,
        cbObject);
  }

  /// <summary>
  /// Reset Email password - Sends a password reset email to the specified address
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Operation - ResetEmailPassword
  /// </remarks>
  /// <param name="externalId">
  /// The email address to send the reset email to.
  /// </param>
  /// <param name="success">
  /// The method to call in event of success
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void resetUniversalIdPassword(String externalId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    _client.authenticationService
        ?.resetUniversalIdPassword(externalId, success, failure, cbObject);
  }

  /// <summary>
  /// Reset Email password with service parameters - sends a password reset email to
  ///the specified addresses.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Operation - ResetEmailPasswordAdvanced
  /// </remarks>
  /// <param name="appId">
  /// The app id
  /// </param>
  /// <param name="emailAddress">
  /// The email address to send the reset email to
  /// </param>
  /// <param name="serviceParams">
  /// The parameters to send the email service. See documentation for full list
  /// http://getbraincloud.com/apidocs/apiref/#capi-mail
  /// </param>
  /// <param name="success">
  /// The method to call in event of success
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void resetUniversalIdPasswordAdvanced(
      String emailAddress,
      //Map<String, dynamic> serviceParams,
      String serviceParams,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _client.authenticationService?.resetUniversalIdPasswordAdvanced(
        emailAddress, serviceParams, success, failure, cbObject);
  }

  /// <summary>
  /// Reset Email password - Sends a password reset email to the specified address
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Operation - ResetEmailPassword
  /// </remarks>
  /// <param name="externalId">
  /// The email address to send the reset email to.
  /// </param>
  /// <param name="success">
  /// The method to call in event of success
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void resetUniversalIdPasswordWithExpiry(
      String externalId,
      int tokenTtlInMinutes,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _client.authenticationService?.resetUniversalIdPasswordWithExpiry(
        externalId, tokenTtlInMinutes, success, failure, cbObject);
  }

  /// <summary>
  /// Reset Email password with service parameters - sends a password reset email to
  ///the specified addresses.
  /// </summary>
  /// <remarks>
  /// Service Name - authenticate
  /// Operation - ResetEmailPasswordAdvanced
  /// </remarks>
  /// <param name="appId">
  /// The app id
  /// </param>
  /// <param name="emailAddress">
  /// The email address to send the reset email to
  /// </param>
  /// <param name="serviceParams">
  /// The parameters to send the email service. See documentation for full list
  /// http://getbraincloud.com/apidocs/apiref/#capi-mail
  /// </param>
  /// <param name="success">
  /// The method to call in event of success
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void resetUniversalIdPasswordAdvancedWithExpiry(
      String emailAddress,
      String serviceParams,
      int tokenTtlInMinutes,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _client.authenticationService?.resetUniversalIdPasswordAdvancedWithExpiry(
        emailAddress,
        serviceParams,
        tokenTtlInMinutes,
        success,
        failure,
        cbObject);
  }

  /// <summary>
  /// Gets the stored profile id from user prefs.
  /// </summary>
  /// <returns>The stored profile id.</returns>
  String? getStoredProfileId() {
    return _wrapperData.profileId;
  }

  /// <summary>
  /// sets the stored profile id to user prefs.
  /// </summary>
  /// <param name="profileId">Profile id.</param>
  void setStoredProfileId(String profileId) {
    _wrapperData.profileId = profileId;
    _saveData();
  }

  /// <summary>
  /// Resets the stored profile id to empty string.
  /// </summary>
  void resetStoredProfileId() {
    _wrapperData.profileId = "";
    _saveData();
  }

  /// <summary>
  /// Gets the stored anonymous id from user prefs.
  /// </summary>
  /// <returns>The stored anonymous id.</returns>
  String? getStoredAnonymousId() {
    return _wrapperData.anonymousId;
  }

  /// <summary>
  /// sets the stored anonymous id to user prefs.
  /// </summary>
  /// <param name="anonymousId">Anonymous id</param>
  void setStoredAnonymousId(String anonymousId) {
    _wrapperData.anonymousId = anonymousId;
    _saveData();
  }

  /// <summary>
  /// Resets the stored anonymous id to empty string.
  /// </summary>
  void resetStoredAnonymousId() {
    _wrapperData.anonymousId = "";
    _saveData();
  }

  /// <summary>
  /// Gets the type of the stored authentication.
  /// </summary>
  /// <returns>The stored authentication type.</returns>
  String? getStoredAuthenticationType() {
    return _wrapperData.authenticationType;
  }

  /// <summary>
  /// sets the type of the stored authentication.
  /// </summary>
  /// <param name="authenticationType">Authentication type.</param>
  void setStoredAuthenticationType(String authenticationType) {
    _wrapperData.authenticationType = authenticationType;
    _saveData();
  }

  /// <summary>
  /// Resets the type of the stored authentication to empty string
  /// </summary>
  void resetStoredAuthenticationType() {
    _wrapperData.authenticationType = "";
    _saveData();
  }

  /// <summary>
  /// Gets the stored sessionId
  /// </summary>
  String getStoredSessionId() {
    return _wrapperData.sessionId;
  }

  /// <summary>
  /// sets the stored sessionId
  /// </summary>
  void setStoredSessionId(String sessionId) {
    _wrapperData.sessionId = sessionId;
    _saveData();
  }

  /// <summary>
  /// Resets the stored sessionId
  /// </summary>
  void resetStoredSessionId() {
    setStoredSessionId("");
  }

  /// <summary>
  /// Gets the stored lastPacketId
  /// </summary>
  int getStoredPacketId() {
    return _wrapperData.lastPacketId;
  }

  /// <summary>
  /// sets the stored lastPacketId
  /// </summary>
  void setStoredPacketId(int lastPacketId) {
    _wrapperData.lastPacketId = lastPacketId;
    _saveData();
  }

  /// <summary>
  /// Resets the stored lastPacketId
  /// </summary>
  void resetStoredPacketId() {
    setStoredPacketId(1);
  }

  void restorePacketId() {
    _wrapperData.lastPacketId++;
    _client.restorePacketId(_wrapperData.lastPacketId);
  }

  /// <summary>
  /// Provides a way to reauthenticate with the stored anonymous and profile id.
  /// Only works for Anonymous authentications.
  /// </summary>
  void reauthenticate() {
    init(_lastSecretKey, _lastAppId, _lastAppVersion, url: _lastUrl);
    String authType = getStoredAuthenticationType() ?? "";
    if (authType == authenticationAnonymous) {
      authenticateAnonymous(null, null);
    }
  }

  /// <summary>
  /// Callback for authentication success using the BrainCloudWrapper class.
  /// </summary>
  /// <param name="json">The returned json</param>
  /// <param name="cbObject">The returned callback object</param>
  void authSuccessCallback(String json, dynamic cbObject) {
    // grab the profileId and save it in PlayerPrefs
    Map<String, dynamic> jsonMessage = jsonDecode(json);
    Map<String, dynamic> jsonData = jsonMessage["data"];

    if (jsonData.containsKey("profileId")) {
      setStoredProfileId(jsonData["profileId"]);
    }

    if (jsonData.containsKey("sessionId")) {
      setStoredSessionId(jsonData["sessionId"]);
    }

    if (cbObject != null) {
      WrapperAuthCallbackObject aco = cbObject;
      if (aco.successCallback != null) {
        aco.successCallback!(json);
      }
    }
  }

  /// <summary>
  /// Callback for authentication failure using the BrainCloudWrapper class.
  /// </summary>
  /// <param name="statusCode">The status code</param>
  /// <param name="reasonCode">The reason code</param>
  /// <param name="errorJson">The error json</param>
  /// <param name="cbObject">The returned callback object</param>
  void authFailureCallback(
      int statusCode, int reasonCode, String errorJson, dynamic cbObject) {
    if (cbObject != null) {
      WrapperAuthCallbackObject? aco = cbObject;
      aco?.failureCallback!(statusCode, reasonCode, errorJson);
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

    debugPrint(_wrapperData.toString());
  }

  WrapperAuthCallbackObject _makeWrapperAuthCallback(
      SuccessCallback? successCallback,
      FailureCallback? failureCallback,
      dynamic cbObject,
      {bool isAnonymousAuth = false}) {
    WrapperAuthCallbackObject aco =
        WrapperAuthCallbackObject(successCallback, failureCallback, cbObject);

    initializeIdentity(isAnonymousAuth);
    return aco;
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
