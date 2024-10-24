import 'dart:async';

import 'package:braincloud_dart/src/common/authentication_ids.dart';
import 'package:braincloud_dart/src/common/authentication_type.dart';
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

  /// Used to create the anonymous installation id for the brainCloud profile.
  ///
  /// returns A unique Anonymous ID
  String generateAnonymousId() {
    return const Uuid().v4();
  }

  /// Initialize - initializes the identity service with a saved
  /// anonymous installation id and most recently used profile id
  ///
  /// @param pId
  /// The id of the profile id that was most recently used by the app (on this device)
  ///
  /// @param aId
  /// The anonymous installation id that was generated for this device
  void initialize({required String pId, required String aId}) {
    profileId = pId;
    _anonymousId = aId;
    compressResponse = true;
  }

  /// Used to clear the saved profile id - to use in cases when the user is
  /// attempting to switch to a different app profile.
  void clearSavedProfileID() {
    profileId = null;
  }

  /// Authenticate a user anonymously with brainCloud - used for apps that don't want to bother
  /// the user to login, or for users who are sensitive to their privacy
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param anonymousId
  /// provide an externalId, can be anything to keep anonymous
  ///
  /// @param forceCreate
  /// Should a new profile be created if it does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateAnonymous(
      {required bool forceCreate}) async {
    return authenticate(
        externalId: _anonymousId,
        authenticationToken: "",
        authenticationType: AuthenticationType.anonymous,
        forceCreate: forceCreate);
  }

  /// Authenticate the user with a custom Email and Password.  Note that the client app
  /// is responsible for collecting (and storing) the e-mail and potentially password
  /// (for convenience) in the client data.  For the greatest security,
  /// force the user to re-enter their password at each login.
  /// (Or at least give them that option).
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// Note that the password sent from the client to the server is protected via SSL.
  ///
  /// @param email
  /// The e-mail address of the user
  ///
  /// @param password
  /// The password of the user
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateEmailPassword(
      {required String email,
      required String password,
      required bool forceCreate}) async {
    return authenticate(
        externalId: email,
        authenticationToken: password,
        authenticationType: AuthenticationType.email,
        forceCreate: forceCreate);
  }

  /// Authenticate the user using a userId and password (without any validation on the userId).
  /// Similar to AuthenticateEmailPassword - except that that method has additional features to
  /// allow for e-mail validation, password resets, etc.
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param email
  /// The e-mail address of the user
  ///
  /// @param password
  /// The password of the user
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateUniversal(
      {required String userId,
      required String password,
      required bool forceCreate}) {
    return authenticate(
        externalId: userId,
        authenticationToken: password,
        authenticationType: AuthenticationType.universal,
        forceCreate: forceCreate);
  }

  /// Authenticate the user with brainCloud using their Facebook Credentials
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param externalId
  /// The facebook id of the user
  ///
  /// @param authenticationToken
  /// The validated token from the Facebook SDK (that will be further
  /// validated when sent to the bC service)
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateFacebook(
      {required String externalId,
      required String authenticationToken,
      required bool forceCreate}) {
    return authenticate(
        externalId: externalId,
        authenticationToken: authenticationToken,
        authenticationType: AuthenticationType.facebook,
        forceCreate: forceCreate);
  }

  /// Authenticate the user with brainCloud using their Facebook Limited Credentials
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param externalId
  /// The facebook Limited id of the user
  ///
  /// @param authenticationToken
  /// The validated token from the Facebook SDK (that will be further
  /// validated when sent to the bC service)
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateFacebookLimited(
      {required String externalId,
      required String authenticationToken,
      required bool forceCreate}) async {
    return authenticate(
      externalId: externalId,
      authenticationToken: authenticationToken,
      authenticationType: AuthenticationType.facebookLimited,
      forceCreate: forceCreate,
    );
  }

  /// Authenticate the user with brainCloud using their Facebook Credentials
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param oculuslId
  /// The Oculus id of the user
  ///
  /// @param oculusNonce
  /// Validation token from oculus gotten through the oculus sdk
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateOculus(
      {required String oculusId,
      required String oculusNonce,
      required bool forceCreate}) {
    return authenticate(
        externalId: oculusId,
        authenticationToken: oculusNonce,
        authenticationType: AuthenticationType.oculus,
        forceCreate: forceCreate);
  }

  /// Authenticate the user using their psn account id and an auth token
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param accountId
  /// The user's PSN account id
  ///
  /// @param authToken
  /// The user's PSN auth token
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticatePlaystationNetwork(
      {required String accountId,
      required String authToken,
      required bool forceCreate}) async {
    return authenticate(
        externalId: accountId,
        authenticationToken: authToken,
        authenticationType: AuthenticationType.playstationNetwork,
        forceCreate: forceCreate);
  }

  /// Authenticate the user using their psn account id and an auth token
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param accountId
  /// The user's PSN account id
  ///
  /// @param authToken
  /// The user's PSN auth token
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticatePlaystation5(
      {required String accountId,
      required String authToken,
      required bool forceCreate}) async {
    return authenticate(
        externalId: accountId,
        authenticationToken: authToken,
        authenticationType: AuthenticationType.playstationNetwork5,
        forceCreate: forceCreate);
  }

  /// Authenticate the user using their Game Center id
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param gameCenterId
  /// The user's game center id  (use the profileID property from the local GKPlayer object)
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateGameCenter(
      {required String gameCenterId, required bool forceCreate}) async {
    return authenticate(
        externalId: gameCenterId,
        authenticationToken: "",
        authenticationType: AuthenticationType.gameCenter,
        forceCreate: forceCreate);
  }

  /// Authenticate the user using a steam userId and session ticket (without any validation on the userId).
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param userId
  /// String representation of 64 bit steam id
  ///
  /// @param sessionticket
  /// The session ticket of the user (hex encoded)
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateSteam(
      {required String userId,
      required String sessionticket,
      required bool forceCreate}) {
    return authenticate(
        externalId: userId,
        authenticationToken: sessionticket,
        authenticationType: AuthenticationType.steam,
        forceCreate: forceCreate);
  }

  /// Authenticate the user using an apple id
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param appleUserId
  /// This can be the user id OR the email of the user for the account
  ///
  /// @param identityToken
  /// The token confirming the user's identity
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateApple(
      {required String appleUserId,
      required String identityToken,
      required bool forceCreate}) {
    return authenticate(
        externalId: appleUserId,
        authenticationToken: identityToken,
        authenticationType: AuthenticationType.apple,
        forceCreate: forceCreate);
  }

  /// Authenticate the user using a google userId and google server authentication code.
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param googleUserId
  /// String representation of google+ userId. Gotten with calls like RequestUserId
  ///
  /// @param serverAuthCode
  /// The server authentication token derived via the google apis. Gotten with calls like RequestServerAuthCode
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateGoogle(
      {required String googleUserId,
      required String serverAuthCode,
      required bool forceCreate}) async {
    return authenticate(
        externalId: googleUserId,
        authenticationToken: serverAuthCode,
        authenticationType: AuthenticationType.google,
        forceCreate: forceCreate);
  }

  /// Authenticate the user using a google openId.
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param googleUserAccountEmail
  /// The email associated with the google user
  ///
  /// @param idToken
  /// The id token of the google account. Can get with calls like requestidToken
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateGoogleOpenId(
      {required String googleUserAccountEmail,
      required String idToken,
      required bool forceCreate}) async {
    return authenticate(
        externalId: googleUserAccountEmail,
        authenticationToken: idToken,
        authenticationType: AuthenticationType.googleOpenId,
        forceCreate: forceCreate);
  }

  /// Authenticate the user using a Twitter userId, authentication token, and secret from twitter.
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param userId
  /// String representation of a Twitter user ID
  ///
  /// @param token
  /// The authentication token derived via the Twitter apis
  ///
  /// @param secret
  /// The secret given when attempting to link with Twitter
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateTwitter(
      {required String userId,
      required String token,
      required String secret,
      required bool forceCreate}) async {
    return authenticate(
        externalId: userId,
        authenticationToken: "$token:$secret",
        authenticationType: AuthenticationType.twitter,
        forceCreate: forceCreate);
  }

  /// Authenticate the user using a Pase userId and authentication token
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param userId
  /// String representation of Parse user ID
  ///
  /// @param token
  /// The authentication token
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateParse(
      {required String userId,
      required String token,
      required bool forceCreate}) async {
    return authenticate(
        externalId: userId,
        authenticationToken: token,
        authenticationType: AuthenticationType.parse,
        forceCreate: forceCreate);
  }

  /// Authenticate the user using a SettopHandoffId and authentication token
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param handoffCode
  /// brainCloud handoffId that is generated from cloud script createSettopHandoffCode
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateSettopHandoff(
      {required String handoffCode}) async {
    return authenticate(
        externalId: handoffCode,
        authenticationToken: "",
        authenticationType: AuthenticationType.settopHandoff,
        forceCreate: false);
  }

  /// Authenticate the user using a handoffId and authentication token
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param handoffId
  /// brainCloud handoffId that is generated from cloud script createHandoffId()
  /// @param securityToken
  /// brainCloud securityToken that is generated from cloud script createHandoffId()
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateHandoff(
      {required String handoffId, required String securityToken}) async {
    return authenticate(
        externalId: handoffId,
        authenticationToken: securityToken,
        authenticationType: AuthenticationType.handoff,
        forceCreate: false);
  }

  /// Authenticate the user via cloud code (which in turn validates the supplied credentials against an external system).
  /// This allows the developer to extend brainCloud authentication to support other backend authentication systems.
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param userId
  /// The user id
  ///
  /// @param token
  /// The user token (password etc)
  ///
  /// @param externalAuthName
  /// The name of the cloud script to call for external authentication
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateExternal(
      {required String userId,
      required String token,
      required String externalAuthName,
      required bool forceCreate}) async {
    return authenticate(
        externalId: userId,
        authenticationToken: token,
        authenticationType: AuthenticationType.external,
        externalAuthName: externalAuthName,
        forceCreate: forceCreate);
  }

  /// A generic Authenticate method that translates to the same as calling a specific one, except it takes an extraJson
  /// that will be passed along to pre-post hooks.
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param authenticationType
  ///  Universal, Email, Facebook, etc
  ///
  /// @param ids
  /// Auth IDs structure
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// @param extraJson
  /// Additional to piggyback along with the call, to be picked up by pre- or post- hooks. Leave an empty Map for no extraJson.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateAdvanced(
      {required AuthenticationType authenticationType,
      required AuthenticationIds ids,
      required bool forceCreate,
      required Map<String, dynamic> extraJson}) async {
    return authenticate(
        externalId: ids.externalId,
        authenticationToken: ids.authenticationToken,
        authenticationType: authenticationType,
        externalAuthName: ids.authenticationSubType,
        forceCreate: forceCreate,
        extraJson: extraJson);
  }

  /// Authenticate the user for Ultra.
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param ultraUsername
  /// It's what the user uses to log into the Ultra endpoint initially
  ///
  /// @param ultraidToken
  /// The "id_token" taken from Ultra's JWT.
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateUltra(
      {required String ultraUsername,
      required String ultraidToken,
      required bool forceCreate}) async {
    return authenticate(
        externalId: ultraUsername,
        authenticationToken: ultraidToken,
        authenticationType: AuthenticationType.ultra,
        forceCreate: forceCreate);
  }

  /// Authenticate the user using their Nintendo account id and an auth token
  ///
  /// Service Name - Authenticate
  /// Service Operation - Authenticate
  ///
  /// @param accountId
  /// The user's Nintendo account id
  ///
  /// @param authToken
  /// The user's Nintendo auth token
  ///
  /// @param forceCreate
  /// Should a new profile be created for this user if the account does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticateNintendo(
      {required String accountId,
      required String authToken,
      required bool forceCreate}) async {
    return authenticate(
        externalId: accountId,
        authenticationToken: authToken,
        authenticationType: AuthenticationType.nintendo,
        forceCreate: forceCreate);
  }

  /// Reset Email password - Sends a password reset email to the specified address
  ///
  /// Service Name - Authenticate
  /// Operation - ResetEmailPassword
  ///
  /// @param externalId
  /// The email address to send the reset email to.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> resetEmailPassword(
      {required String externalId}) async {
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
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetEmailPassword, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Reset Email password - Sends a password reset email to the specified address with expiry
  ///
  /// Service Name - Authenticate
  /// Operation - ResetEmailPassword
  ///
  /// @param externalId
  /// The email address to send the reset email to.
  ///
  /// @param expiryTimeInMin
  /// expiry time in mins
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> resetEmailPasswordWithExpiry(
      {required String externalId, required int tokenTtlInMinutes}) async {
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
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetEmailPasswordWithExpiry, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Reset Email password with service parameters - sends a password reset email to
  ///the specified addresses.
  ///
  /// Service Name - Authenticate
  /// Operation - ResetEmailPasswordAdvanced
  ///
  /// @param emailAddress
  /// The email address to send the reset email to
  ///
  /// @param serviceParams
  /// The parameters to send the email service. See documentation for full list
  /// http://getbraincloud.com/apidocs/apiref/#capi-mail
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> resetEmailPasswordAdvanced(
      {required String emailAddress,
      required Map<String, dynamic> serviceParams}) async {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.authenticateServiceAuthenticateGameId.value] =
        _clientRef.appId;
    data[OperationParam.authenticateServiceAuthenticateEmailAddress.value] =
        emailAddress;

    data[OperationParam.authenticateServiceAuthenticateServiceParams.value] =
        serviceParams;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetEmailPasswordAdvanced, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Reset Email password with service parameters - sends a password reset email to
  ///the specified addresses with expiry
  ///
  /// Service Name - Authenticate
  /// Operation - ResetEmailPasswordAdvanced
  ///
  /// @param emailAddress
  /// The email address to send the reset email to
  ///
  /// @param serviceParams
  /// The parameters to send the email service. See documentation for full list
  /// http://getbraincloud.com/apidocs/apiref/#capi-mail
  ///
  /// @param expiryTimeInMin
  /// expiry time in mins
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> resetEmailPasswordAdvancedWithExpiry(
      {required String emailAddress,
      required Map<String, dynamic> serviceParams,
      required int tokenTtlInMinutes}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.authenticateServiceAuthenticateGameId.value] =
        _clientRef.appId;
    data[OperationParam.authenticateServiceAuthenticateEmailAddress.value] =
        emailAddress;

    data[OperationParam.authenticateServiceAuthenticateServiceParams.value] =
        serviceParams;

    data[OperationParam.authenticateServiceAuthenticateTokenTtlInMinutes
        .value] = tokenTtlInMinutes;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetEmailPasswordAdvancedWithExpiry, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Reset Universal ID password.
  ///
  /// Service Name - Authenticate
  /// Operation - ResetUniversalIdPassword
  ///
  /// @param universalId
  /// The universalId that you want to have change password.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> resetUniversalIdPassword(
      {required String universalId}) async {
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
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetUniversalIdPassword, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Reset Universal ID password with expiry
  ///
  /// Service Name - Authenticate
  /// Operation - ResetUniversalIdPassword
  ///
  /// @param universalId
  /// The universalId that you want to have change password.
  ///
  /// @param expiryTimeInMin
  /// takes in an Expiry time in mins
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> resetUniversalIdPasswordWithExpiry(
      {required String universalId, required int tokenTtlInMinutes}) async {
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
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetUniversalIdPasswordWithExpiry, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Advanced universalId password reset using templates
  ///
  /// Service Name - Authenticate
  /// Operation - ResetUniversalIdPasswordAdvanced
  ///
  /// @param universalId
  /// The email address to send the reset email to
  ///
  /// @param serviceParams
  /// The parameters to send the email service. See documentation for full list
  /// http://getbraincloud.com/apidocs/apiref/#capi-mail
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> resetUniversalIdPasswordAdvanced(
      {required String universalId,
      required Map<String, dynamic> serviceParams}) async {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.authenticateServiceAuthenticateGameId.value] =
        _clientRef.appId;
    data[OperationParam.authenticateServiceAuthenticateUniversalId.value] =
        universalId;

    data[OperationParam.authenticateServiceAuthenticateServiceParams.value] =
        serviceParams;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.authenticate,
        ServiceOperation.resetUniversalIdPasswordAdvanced, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Advanced universalId password reset using templates with expiry
  ///
  /// Service Name - Authenticate
  /// Operation - ResetUniversalIdPasswordAdvanced
  ///
  /// @param universalId
  /// The email address to send the reset email to
  ///
  /// @param serviceParams
  /// The parameters to send the email service. See documentation for full list
  /// http://getbraincloud.com/apidocs/apiref/#capi-mail
  ///
  /// @param expiryTimeInMin
  /// takes in an Expiry time to determine how long it will stay available
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> resetUniversalIdPasswordAdvancedWithExpiry(
      {required String universalId,
      required Map<String, dynamic> serviceParams,
      required int tokenTtlInMinutes}) async {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.authenticateServiceAuthenticateGameId.value] =
        _clientRef.appId;
    data[OperationParam.authenticateServiceAuthenticateUniversalId.value] =
        universalId;

    data[OperationParam.authenticateServiceAuthenticateServiceParams.value] =
        serviceParams;

    data[OperationParam.authenticateServiceAuthenticateTokenTtlInMinutes
        .value] = tokenTtlInMinutes;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
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

  /// returns Future<ServerResponse>
  Future<ServerResponse> authenticate(
      {required String externalId,
      required String authenticationToken,
      required AuthenticationType authenticationType,
      String? externalAuthName,
      required bool forceCreate,
      Map<String, dynamic>? extraJson}) {
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
      completer.complete(ServerResponse(
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
