import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/Common/authentication_ids.dart';
import 'package:braincloud_dart/src/Common/authentication_type.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:braincloud_dart/src/util.dart';
import 'package:braincloud_dart/src/version.dart';
import 'package:uuid/uuid.dart';

class BrainCloudAuthentication {
  final BrainCloudClient _clientRef;

  late String _anonymousId;
  String? profileId;

  bool compressResponse = true;

  BrainCloudAuthentication(this._clientRef);

  /// <summary>
  /// Used to create the anonymous installation id for the brainCloud profile.
  /// </summary>
  /// <returns>A unique Anonymous ID</returns>
  String generateAnonymousId() {
    return const Uuid().v4();
  }

  /// <summary>
  /// Initialize - initializes the identity service with a saved
  /// anonymous installation id and most recently used profile id
  /// </summary>
  /// <param name="pId">
  /// The id of the profile id that was most recently used by the app (on this device)
  /// </param>
  /// <param name="aId">
  /// The anonymous installation id that was generated for this device
  /// </param>
  void initialize(String pId, String aId) {
    profileId = pId;
    _anonymousId = aId;
    compressResponse = false;
  }

  /// <summary>
  /// Used to clear the saved profile id - to use in cases when the user is
  /// attempting to switch to a different app profile.
  /// </summary>
  void clearSavedProfileID() {
    profileId = null;
  }

  /// <summary>
  /// Authenticate a user anonymously with brainCloud - used for apps that don't want to bother
  /// the user to login, or for users who are sensitive to their privacy
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  /// </remarks>
  /// /// <param name="anonymousId">
  /// provide an externalId, can be anything to keep anonymous
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created if it does not exist?
  /// </param>
  Future<ServerResponse> authenticateAnonymous(
    bool forceCreate,
  ) async {
    return authenticate(_anonymousId, "", AuthenticationType.anonymous, null,
        forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user with a custom Email and Password.  Note that the client app
  /// is responsible for collecting (and storing) the e-mail and potentially password
  /// (for convenience) in the client data.  For the greatest security,
  /// force the user to re-enter their password at each login.
  /// (Or at least give them that option).
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
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
  Future<ServerResponse> authenticateEmailPassword(
      String email, String password, bool forceCreate) async {
    return authenticate(
        email, password, AuthenticationType.email, null, forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user using a userId and password (without any validation on the userId).
  /// Similar to AuthenticateEmailPassword - except that that method has additional features to
  /// allow for e-mail validation, password resets, etc.
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
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
  Future<ServerResponse> authenticateUniversal(
    String userId,
    String password,
    bool forceCreate,
  ) {
    return authenticate(userId, password, AuthenticationType.universal, null,
        forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user with brainCloud using their Facebook Credentials
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
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
  Future<ServerResponse> authenticateFacebook(
    String externalId,
    String authenticationToken,
    bool forceCreate,
  ) {
    return authenticate(externalId, authenticationToken,
        AuthenticationType.facebook, null, forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user with brainCloud using their Facebook Limited Credentials
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  /// </remarks>
  /// <param name="externalId">
  /// The facebook Limited id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the Facebook SDK (that will be further
  /// validated when sent to the bC service)
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  Future<ServerResponse> authenticateFacebookLimited(
      String externalId, String authenticationToken, bool forceCreate) async {
    return authenticate(externalId, authenticationToken,
        AuthenticationType.facebookLimited, null, forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user with brainCloud using their Facebook Credentials
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  /// </remarks>
  /// <param name="oculuslId">
  /// The Oculus id of the user
  /// </param>
  /// <param name="oculusNonce">
  /// Validation token from oculus gotten through the oculus sdk
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  Future<ServerResponse> authenticateOculus(
    String oculusId,
    String oculusNonce,
    bool forceCreate,
  ) {
    return authenticate(oculusId, oculusNonce, AuthenticationType.oculus, null,
        forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user using their psn account id and an auth token
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
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
  Future<ServerResponse> authenticatePlaystationNetwork(
      String accountId, String authToken, bool forceCreate) async {
    return authenticate(accountId, authToken,
        AuthenticationType.playstationNetwork, null, forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user using their psn account id and an auth token
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
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
  Future<ServerResponse> authenticatePlaystation5(
    String accountId,
    String authToken,
    bool forceCreate,
  ) async {
    return authenticate(accountId, authToken,
        AuthenticationType.playstationNetwork5, null, forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user using their Game Center id
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  /// </remarks>
  /// <param name="gameCenterId">
  /// The user's game center id  (use the profileID property from the local GKPlayer object)
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  Future<ServerResponse> authenticateGameCenter(
    String gameCenterId,
    bool forceCreate,
  ) async {
    return authenticate(gameCenterId, "", AuthenticationType.gameCenter, null,
        forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user using a steam userId and session ticket (without any validation on the userId).
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  /// </remarks>
  /// <param name="userId">
  /// String representation of 64 bit steam id
  /// </param>
  /// <param name="sessionticket">
  /// The session ticket of the user (hex encoded)
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  Future<ServerResponse> authenticateSteam(
    String userId,
    String sessionticket,
    bool forceCreate,
  ) {
    return authenticate(userId, sessionticket, AuthenticationType.steam, null,
        forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user using an apple id
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
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
  Future<ServerResponse> authenticateApple(
      String appleUserId, String identityToken, bool forceCreate) {
    return authenticate(appleUserId, identityToken, AuthenticationType.apple,
        null, forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user using a google userId and google server authentication code.
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
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
  Future<ServerResponse> authenticateGoogle(
      String googleUserId, String serverAuthCode, bool forceCreate) async {
    return authenticate(googleUserId, serverAuthCode, AuthenticationType.google,
        null, forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user using a google openId.
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  /// </remarks>
  /// <param name="googleUserAccountEmail"
  /// The email associated with the google user
  /// </param>
  /// <param name="idToken">
  /// The id token of the google account. Can get with calls like requestidToken
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  Future<ServerResponse> authenticateGoogleOpenId(
      String googleUserAccountEmail, String idToken, bool forceCreate) async {
    return authenticate(googleUserAccountEmail, idToken,
        AuthenticationType.googleOpenId, null, forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user using a Twitter userId, authentication token, and secret from twitter.
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  /// </remarks>
  /// <param name="userId">
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
  Future<ServerResponse> authenticateTwitter(
      String userId, String token, String secret, bool forceCreate) async {
    return authenticate(userId, "$token:$secret", AuthenticationType.twitter,
        null, forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user using a Pase userId and authentication token
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  /// </remarks>
  /// <param name="userId">
  /// String representation of Parse user ID
  /// </param>
  /// <param name="token">
  /// The authentication token
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  Future<ServerResponse> authenticateParse(
    String userId,
    String token,
    bool forceCreate,
  ) async {
    return authenticate(
        userId, token, AuthenticationType.parse, null, forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user using a SettopHandoffId and authentication token
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  /// </remarks>
  /// <param name="handoffCode">
  /// brainCloud handoffId that is generated from cloud script createSettopHandoffCode
  /// </param>
  Future<ServerResponse> authenticateSettopHandoff(
    String handoffCode,
  ) async {
    return authenticate(
        handoffCode, "", AuthenticationType.settopHandoff, null, false, null);
  }

  /// <summary>
  /// Authenticate the user using a handoffId and authentication token
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  /// </remarks>
  /// <param name="handoffId">
  /// brainCloud handoffId that is generated from cloud script createHandoffId()
  /// <param name="securityToken">
  /// brainCloud securityToken that is generated from cloud script createHandoffId()
  /// </param>
  Future<ServerResponse> authenticateHandoff(
    String handoffId,
    String securityToken,
  ) async {
    return authenticate(handoffId, securityToken, AuthenticationType.handoff,
        null, false, null);
  }

  /// <summary>
  /// Authenticate the user via cloud code (which in turn validates the supplied credentials against an external system).
  /// This allows the developer to extend brainCloud authentication to support other backend authentication systems.
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  /// </remarks>
  /// <param name="userId">
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
  Future<ServerResponse> authenticateExternal(String userId, String token,
      String externalAuthName, bool forceCreate) async {
    return authenticate(userId, token, AuthenticationType.external,
        externalAuthName, forceCreate, null);
  }

  /// <summary>
  /// A generic Authenticate method that translates to the same as calling a specific one, except it takes an extraJson
  /// that will be passed along to pre-post hooks.
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
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
  /// Additional to piggyback along with the call, to be picked up by pre- or post- hooks. Leave an empty Map for no extraJson.
  /// </param>
  Future<ServerResponse> authenticateAdvanced(
      AuthenticationType authenticationType,
      AuthenticationIds ids,
      bool forceCreate,
      Map<String, dynamic> extraJson) async {
    return authenticate(ids.externalId, ids.authenticationToken,
        authenticationType, ids.authenticationSubType, forceCreate, extraJson);
  }

  /// <summary>
  /// Authenticate the user for Ultra.
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  /// </remarks>
  /// <param name="ultraUsername">
  /// It's what the user uses to log into the Ultra endpoint initially
  /// </param>
  /// <param name="ultraidToken">
  /// The "id_token" taken from Ultra's JWT.
  /// </param>
  /// /// <param name="forceCreate">
  /// Should a new profile be created for this user if the account does not exist?
  /// </param>
  Future<ServerResponse> authenticateUltra(
      String ultraUsername, String ultraidToken, bool forceCreate) async {
    return authenticate(ultraUsername, ultraidToken, AuthenticationType.ultra,
        null, forceCreate, null);
  }

  /// <summary>
  /// Authenticate the user using their Nintendo account id and an auth token
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
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
  Future<ServerResponse> authenticateNintendo(
      String accountId, String authToken, bool forceCreate) async {
    return authenticate(accountId, authToken, AuthenticationType.nintendo, null,
        forceCreate, null);
  }

  /// <summary>
  /// Reset Email password - Sends a password reset email to the specified address
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Operation - ResetEmailPassword
  /// </remarks>
  /// <param name="externalId">
  /// The email address to send the reset email to.
  /// </param>
  Future<ServerResponse> resetEmailPassword(String externalId) async {
    Map<String, dynamic> data = {};
    data[OperationParam.authenticateServiceAuthenticateExternalId.value] =
        externalId;
    data[OperationParam.authenticateServiceAuthenticateGameId.value] =
        _clientRef.appId;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetEmailPassword, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Reset Email password - Sends a password reset email to the specified address with expiry
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Operation - ResetEmailPassword
  /// </remarks>
  /// <param name="externalId">
  /// The email address to send the reset email to.
  /// </param>
  /// <param name="expiryTimeInMin">
  /// expiry time in mins
  /// </param>
  Future<ServerResponse> resetEmailPasswordWithExpiry(
    String externalId,
    int tokenTtlInMinutes,
  ) async {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.authenticateServiceAuthenticateExternalId.value] =
        externalId;
    data[OperationParam.authenticateServiceAuthenticateGameId.value] =
        _clientRef.appId;

    data[OperationParam.authenticateServiceAuthenticateTokenTtlInMinutes
        .value] = tokenTtlInMinutes;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetEmailPasswordWithExpiry, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Reset Email password with service parameters - sends a password reset email to
  ///the specified addresses.
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
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
  Future<ServerResponse> resetEmailPasswordAdvanced(
    String emailAddress,
    //Map<String, object> serviceParams,
    String serviceParams,
  ) async {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.authenticateServiceAuthenticateGameId.value] =
        _clientRef.appId;
    data[OperationParam.authenticateServiceAuthenticateEmailAddress.value] =
        emailAddress;

    var jsonParams = jsonDecode(serviceParams);
    data[OperationParam.authenticateServiceAuthenticateServiceParams.value] =
        jsonParams;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetEmailPasswordAdvanced, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Reset Email password with service parameters - sends a password reset email to
  ///the specified addresses with expiry
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
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
  /// <param name="expiryTimeInMin">
  /// expiry time in mins
  /// </param>
  Future<ServerResponse> resetEmailPasswordAdvancedWithExpiry(
      String emailAddress,
      //Map<String, dynamic> serviceParams,
      String serviceParams,
      int tokenTtlInMinutes) async {
    Map<String, dynamic> data = {};
    data[OperationParam.authenticateServiceAuthenticateGameId.value] =
        _clientRef.appId;
    data[OperationParam.authenticateServiceAuthenticateEmailAddress.value] =
        emailAddress;

    var jsonParams = jsonDecode(serviceParams);
    data[OperationParam.authenticateServiceAuthenticateServiceParams.value] =
        jsonParams;

    data[OperationParam.authenticateServiceAuthenticateTokenTtlInMinutes
        .value] = tokenTtlInMinutes;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetEmailPasswordAdvancedWithExpiry, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Reset Universal ID password.
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Operation - ResetUniversalIdPassword
  /// </remarks>
  /// <param name="universalId">
  /// The universalId that you want to have change password.
  /// </param>
  Future<ServerResponse> resetUniversalIdPassword(
    String universalId,
  ) async {
    Map<String, dynamic> data = {};
    data[OperationParam.authenticateServiceAuthenticateGameId.value] =
        _clientRef.appId;
    data[OperationParam.authenticateServiceAuthenticateUniversalId.value] =
        universalId;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetUniversalIdPassword, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Reset Universal ID password with expiry
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Operation - ResetUniversalIdPassword
  /// </remarks>
  /// <param name="universalId">
  /// The universalId that you want to have change password.
  /// </param>
  /// <param name="expiryTimeInMin">
  /// takes in an Expiry time in mins
  Future<ServerResponse> resetUniversalIdPasswordWithExpiry(
    String universalId,
    int tokenTtlInMinutes,
  ) async {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.authenticateServiceAuthenticateGameId.value] =
        _clientRef.appId;
    data[OperationParam.authenticateServiceAuthenticateUniversalId.value] =
        universalId;
    data[OperationParam.authenticateServiceAuthenticateTokenTtlInMinutes
        .value] = tokenTtlInMinutes;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetUniversalIdPasswordWithExpiry, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Advanced universalId password reset using templates
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Operation - ResetUniversalIdPasswordAdvanced
  /// </remarks>
  /// <param name="appId">
  /// The app id
  /// </param>
  /// <param name="universalId">
  /// The email address to send the reset email to
  /// </param>
  /// <param name="serviceParams">
  /// The parameters to send the email service. See documentation for full list
  /// http://getbraincloud.com/apidocs/apiref/#capi-mail
  /// </param>
  Future<ServerResponse> resetUniversalIdPasswordAdvanced(
    String universalId,
    String serviceParams,
  ) async {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.authenticateServiceAuthenticateGameId.value] =
        _clientRef.appId;
    data[OperationParam.authenticateServiceAuthenticateUniversalId.value] =
        universalId;

    var jsonParams = jsonDecode(serviceParams);
    data[OperationParam.authenticateServiceAuthenticateServiceParams.value] =
        jsonParams;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetUniversalIdPasswordAdvanced, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Advanced universalId password reset using templates with expiry
  /// </summary>
  /// <remarks>
  /// Service Name - Authenticate
  /// Operation - ResetUniversalIdPasswordAdvanced
  /// </remarks>
  /// <param name="appId">
  /// The app id
  /// </param>
  /// <param name="universalId">
  /// The email address to send the reset email to
  /// </param>
  /// <param name="serviceParams">
  /// The parameters to send the email service. See documentation for full list
  /// http://getbraincloud.com/apidocs/apiref/#capi-mail
  /// </param>
  /// <param name="expiryTimeInMin">
  /// takes in an Expiry time to determine how long it will stay available
  /// </param>
  Future<ServerResponse> resetUniversalIdPasswordAdvancedWithExpiry(
      String universalId, String serviceParams, int tokenTtlInMinutes) async {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.authenticateServiceAuthenticateGameId.value] =
        _clientRef.appId;
    data[OperationParam.authenticateServiceAuthenticateUniversalId.value] =
        universalId;

    var jsonParams = jsonDecode(serviceParams);
    data[OperationParam.authenticateServiceAuthenticateServiceParams.value] =
        jsonParams;

    data[OperationParam.authenticateServiceAuthenticateTokenTtlInMinutes
        .value] = tokenTtlInMinutes;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(
        ServiceName.authenticate,
        ServiceOperation.resetUniversalIdPasswordAdvancedWithExpiry,
        data,
        callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  Future<ServerResponse> authenticate(
      String externalId,
      String authenticationToken,
      AuthenticationType authenticationType,
      String? externalAuthName,
      bool forceCreate,
      Map<String, dynamic>? extraJson) {
    String languageCode = _clientRef.languageCode;
    int utcOffset = Util.getUTCOffsetForCurrentTimeZone();
    String countryCode = _clientRef.countryCode;

    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.authenticateServiceAuthenticateExternalId.value] =
        externalId;
    data[OperationParam.authenticateServiceAuthenticateAuthenticationToken
        .value] = authenticationToken;
    data[OperationParam.authenticateServiceAuthenticateAuthenticationType
        .value] = authenticationType.toString();
    data[OperationParam.authenticateServiceAuthenticateForceCreate.value] =
        forceCreate;
    data[OperationParam.authenticateServiceAuthenticateCompressResponses
        .value] = compressResponse;

    data[OperationParam.authenticateServiceAuthenticateProfileId.value] =
        profileId;
    data[OperationParam.authenticateServiceAuthenticateAnonymousId.value] =
        _anonymousId;
    data[OperationParam.authenticateServiceAuthenticateGameId.value] =
        _clientRef.appId;
    data[OperationParam.authenticateServiceAuthenticateReleasePlatform.value] =
        _clientRef.releasePlatform.toString();
    data[OperationParam.authenticateServiceAuthenticateGameVersion.value] =
        _clientRef.appVersion;
    data[OperationParam.authenticateServiceAuthenticateBrainCloudVersion
        .value] = Version.getVersion();

    data["clientLib"] = "dart";

    if (Util.isOptionalParameterValid(externalAuthName)) {
      data[OperationParam.authenticateServiceAuthenticateExternalAuthName
          .value] = externalAuthName;
    }

    if (extraJson != null) {
      data[OperationParam.authenticateServiceAuthenticateExtraJson.value] =
          extraJson;
    }

    data[OperationParam.authenticateServiceAuthenticateCountryCode.value] =
        countryCode;
    data[OperationParam.authenticateServiceAuthenticateLanguageCode.value] =
        languageCode;
    data[OperationParam.authenticateServiceAuthenticateTimeZoneOffset.value] =
        utcOffset;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.authenticate, data, callback);
    if (_clientRef.comms != null &&
        _clientRef.comms!.isAuthenticateRequestInProgress()) {
      _clientRef.comms?.addCallbackToAuthenticateRequest(callback);
      return completer.future;
    }
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
