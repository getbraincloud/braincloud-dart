import 'dart:convert';

import 'package:braincloud_dart/src/Common/authentication_ids.dart';
import 'package:braincloud_dart/src/Common/authentication_type.dart';
import 'package:braincloud_dart/src/Common/platform.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/server_callback.dart';
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateAnonymous(String? anonymousId, bool forceCreate,
      SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    _anonymousId = anonymousId ?? "";
    authenticate(_anonymousId, "", AuthenticationType.anonymous, null,
        forceCreate, null, success, failure, cbObject);
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
    authenticate(email, password, AuthenticationType.email, null, forceCreate,
        null, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateUniversal(String userId, String password, bool forceCreate,
      SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    authenticate(userId, password, AuthenticationType.universal, null,
        forceCreate, null, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateFacebook(String externalId, String authenticationToken,
      bool forceCreate, SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    authenticate(externalId, authenticationToken, AuthenticationType.facebook,
        null, forceCreate, null, success, failure, cbObject);
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
      String externalId,
      String authenticationToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticate(
        externalId,
        authenticationToken,
        AuthenticationType.facebookLimited,
        null,
        forceCreate,
        null,
        success,
        failure,
        cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateOculus(String oculusId, String oculusNonce, bool forceCreate,
      SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    authenticate(oculusId, oculusNonce, AuthenticationType.oculus, null,
        forceCreate, null, success, failure, cbObject);
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
    authenticate(accountId, authToken, AuthenticationType.playstationNetwork,
        null, forceCreate, null, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticatePlaystation5(String accountId, String authToken,
      bool forceCreate, SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    authenticate(accountId, authToken, AuthenticationType.playstationNetwork5,
        null, forceCreate, null, success, failure, cbObject);
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
      SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    authenticate(gameCenterId, "", AuthenticationType.gameCenter, null,
        forceCreate, null, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateSteam(String userId, String sessionticket, bool forceCreate,
      SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    authenticate(userId, sessionticket, AuthenticationType.steam, null,
        forceCreate, null, success, failure, cbObject);
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
    authenticate(appleUserId, identityToken, AuthenticationType.apple, null,
        forceCreate, null, success, failure, cbObject);
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
    authenticate(googleUserId, serverAuthCode, AuthenticationType.google, null,
        forceCreate, null, success, failure, cbObject);
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
    authenticate(
        googleUserAccountEmail,
        idToken,
        AuthenticationType.googleOpenId,
        null,
        forceCreate,
        null,
        success,
        failure,
        cbObject);
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
      String userId,
      String token,
      String secret,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticate(userId, "$token:$secret", AuthenticationType.twitter, null,
        forceCreate, null, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateParse(String userId, String token, bool forceCreate,
      SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    authenticate(userId, token, AuthenticationType.parse, null, forceCreate,
        null, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateSettopHandoff(
      String handoffCode, SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    authenticate(handoffCode, "", AuthenticationType.settopHandoff, null, false,
        null, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void authenticateHandoff(String handoffId, String securityToken,
      SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    authenticate(handoffId, securityToken, AuthenticationType.handoff, null,
        false, null, success, failure, cbObject);
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
      String userId,
      String token,
      String externalAuthName,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      {dynamic cbObject}) {
    authenticate(userId, token, AuthenticationType.external, externalAuthName,
        forceCreate, null, success, failure, cbObject);
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
    authenticate(
        ids.externalId,
        ids.authenticationToken,
        authenticationType,
        ids.authenticationSubType,
        forceCreate,
        extraJson,
        success,
        failure,
        cbObject);
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
      String ultraidToken,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    authenticate(ultraUsername, ultraidToken, AuthenticationType.ultra, null,
        forceCreate, null, success, failure, cbObject);
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
    authenticate(accountId, authToken, AuthenticationType.nintendo, null,
        forceCreate, null, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of success
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void resetEmailPassword(
      String externalId, SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    Map<String, dynamic> data = {};
    data[OperationParam.AuthenticateServiceAuthenticateExternalId.Value] =
        externalId;
    data[OperationParam.AuthenticateServiceAuthenticateGameId.Value] =
        _clientRef.appId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetEmailPassword, data, callback);
    _clientRef.sendRequest(sc);
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
      SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.AuthenticateServiceAuthenticateExternalId.Value] =
        externalId;
    data[OperationParam.AuthenticateServiceAuthenticateGameId.Value] =
        _clientRef.appId;

    data[OperationParam.AuthenticateServiceAuthenticateTokenTtlInMinutes
        .Value] = tokenTtlInMinutes;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetEmailPasswordWithExpiry, data, callback);
    _clientRef.sendRequest(sc);
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
      //Map<String, object> serviceParams,
      String serviceParams,
      SuccessCallback? success,
      FailureCallback? failure,
      {dynamic cbObject}) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.AuthenticateServiceAuthenticateGameId.Value] =
        _clientRef.appId;
    data[OperationParam.AuthenticateServiceAuthenticateEmailAddress.Value] =
        emailAddress;

    var jsonParams = jsonDecode(serviceParams);
    data[OperationParam.AuthenticateServiceAuthenticateServiceParams.Value] =
        jsonParams;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetEmailPasswordAdvanced, data, callback);
    _clientRef.sendRequest(sc);
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
      //Map<String, dynamic> serviceParams,
      String serviceParams,
      int tokenTtlInMinutes,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.AuthenticateServiceAuthenticateGameId.Value] =
        _clientRef.appId;
    data[OperationParam.AuthenticateServiceAuthenticateEmailAddress.Value] =
        emailAddress;

    var jsonParams = jsonDecode(serviceParams);
    data[OperationParam.AuthenticateServiceAuthenticateServiceParams.Value] =
        jsonParams;

    data[OperationParam.AuthenticateServiceAuthenticateTokenTtlInMinutes
        .Value] = tokenTtlInMinutes;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetEmailPasswordAdvancedWithExpiry, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The method to call in event of success
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void resetUniversalIdPassword(
      String universalId, SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    Map<String, dynamic> data = {};
    data[OperationParam.AuthenticateServiceAuthenticateGameId.Value] =
        _clientRef.appId;
    data[OperationParam.AuthenticateServiceAuthenticateUniversalId.Value] =
        universalId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetUniversalIdPassword, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The method to call in event of success
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void resetUniversalIdPasswordWithExpiry(String universalId,
      int tokenTtlInMinutes, SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.AuthenticateServiceAuthenticateGameId.Value] =
        _clientRef.appId;
    data[OperationParam.AuthenticateServiceAuthenticateUniversalId.Value] =
        universalId;
    data[OperationParam.AuthenticateServiceAuthenticateTokenTtlInMinutes
        .Value] = tokenTtlInMinutes;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetUniversalIdPasswordWithExpiry, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The method to call in event of success
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error
  /// </param>
  /// <param name="cbObject">
  /// The user supplied callback object
  /// </param>
  void resetUniversalIdPasswordAdvanced(String universalId,
      String serviceParams, SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.AuthenticateServiceAuthenticateGameId.Value] =
        _clientRef.appId;
    data[OperationParam.AuthenticateServiceAuthenticateUniversalId.Value] =
        universalId;

    var jsonParams = jsonDecode(serviceParams);
    data[OperationParam.AuthenticateServiceAuthenticateServiceParams.Value] =
        jsonParams;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetUniversalIdPasswordAdvanced, data, callback);
    _clientRef.sendRequest(sc);
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
      String universalId,
      String serviceParams,
      int tokenTtlInMinutes,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.AuthenticateServiceAuthenticateGameId.Value] =
        _clientRef.appId;
    data[OperationParam.AuthenticateServiceAuthenticateUniversalId.Value] =
        universalId;

    var jsonParams = jsonDecode(serviceParams);
    data[OperationParam.AuthenticateServiceAuthenticateServiceParams.Value] =
        jsonParams;

    data[OperationParam.AuthenticateServiceAuthenticateTokenTtlInMinutes
        .Value] = tokenTtlInMinutes;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.authenticate,
        ServiceOperation.resetUniversalIdPasswordAdvancedWithExpiry,
        data,
        callback);
    _clientRef.sendRequest(sc);
  }

  void authenticate(
      String externalId,
      String authenticationToken,
      AuthenticationType authenticationType,
      String? externalAuthName,
      bool forceCreate,
      Map<String, dynamic>? extraJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    String languageCode = _clientRef.languageCode;
    int utcOffset = Util.getUTCOffsetForCurrentTimeZone();
    String countryCode = _clientRef.countryCode;

    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.AuthenticateServiceAuthenticateExternalId.Value] =
        externalId;
    data[OperationParam.AuthenticateServiceAuthenticateAuthenticationToken
        .Value] = authenticationToken;
    data[OperationParam.AuthenticateServiceAuthenticateAuthenticationType
        .Value] = authenticationType.toShortString();
    data[OperationParam.AuthenticateServiceAuthenticateForceCreate.Value] =
        forceCreate;
    data[OperationParam.AuthenticateServiceAuthenticateCompressResponses
        .Value] = compressResponse;

    data[OperationParam.AuthenticateServiceAuthenticateProfileId.Value] =
        profileId;
    data[OperationParam.AuthenticateServiceAuthenticateAnonymousId.Value] =
        _anonymousId;
    data[OperationParam.AuthenticateServiceAuthenticateGameId.Value] =
        _clientRef.appId;
    data[OperationParam.AuthenticateServiceAuthenticateReleasePlatform.Value] =
        _clientRef.releasePlatform.toShortString();
    data[OperationParam.AuthenticateServiceAuthenticateGameVersion.Value] =
        _clientRef.appVersion;
    data[OperationParam.AuthenticateServiceAuthenticateBrainCloudVersion
        .Value] = Version.getVersion();

    data["clientLib"] = "dart";

    if (Util.isOptionalParameterValid(externalAuthName)) {
      data[OperationParam.AuthenticateServiceAuthenticateExternalAuthName
          .Value] = externalAuthName;
    }

    if (extraJson != null) {
      data[OperationParam.AuthenticateServiceAuthenticateExtraJson.Value] =
          extraJson;
    }

    data[OperationParam.AuthenticateServiceAuthenticateCountryCode.Value] =
        countryCode;
    data[OperationParam.AuthenticateServiceAuthenticateLanguageCode.Value] =
        languageCode;
    data[OperationParam.AuthenticateServiceAuthenticateTimeZoneOffset.Value] =
        utcOffset;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.authenticate, data, callback);
    if (_clientRef.comms != null &&
        _clientRef.comms!.isAuthenticateRequestInProgress()) {
      _clientRef.comms?.addCallbackToAuthenticateRequest(callback);
      return;
    }
    _clientRef.sendRequest(sc);
  }
}
