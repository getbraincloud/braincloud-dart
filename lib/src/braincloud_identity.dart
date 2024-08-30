import 'dart:async';

import 'package:braincloud_dart/src/Common/authentication_ids.dart';
import 'package:braincloud_dart/src/Common/authentication_type.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudIdentity {
  final BrainCloudClient _clientRef;

  BrainCloudIdentity(this._clientRef);

  /// <summary>
  /// Attach the user's Facebook credentials to the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Attach
  /// </remarks>
  /// <param name="facebookId">
  /// The facebook id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the Facebook SDK
  ///   (that will be further validated when sent to the bC service)
  /// </param>
  Future<ServerResponse> attachFacebookIdentity(
      String facebookId, String authenticationToken) async {
    return _attachIdentity(
        facebookId, authenticationToken, AuthenticationType.facebook);
  }

  /// <summary>
  /// Merge the profile associated with the provided Facebook credentials with the
  /// current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Merge
  /// </remarks>
  /// <param name="facebookId">
  /// The facebook id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the Facebook SDK
  /// (that will be further validated when sent to the bC service)
  /// </param>

  Future<ServerResponse> mergeFacebookIdentity(
      String facebookId, String authenticationToken) async {
    return _mergeIdentity(
        facebookId, authenticationToken, AuthenticationType.facebook);
  }

  /// <summary>
  /// Detach the Facebook identity from this profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Detach
  /// </remarks>
  /// <param name="facebookId">
  /// The facebook id of the user
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachFacebookIdentity(
      String facebookId, bool continueAnon) async {
    return _detachIdentity(
        facebookId, AuthenticationType.facebook, continueAnon);
  }

  /// <summary>
  /// Attach the user's credentials to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// Errors to watch for:  SWITCHING_PROFILES - this means that the identity you provided
  /// already points to a different profile.  You will likely want to offer the user the
  /// choice to *SWITCH* to that profile, or *MERGE* the profiles.
  ///
  /// To switch profiles, call ClearSavedProfileID() and call AuthenticateAdvanced().
  /// </summary>
  /// <param name="authenticationType">
  /// Universal, Email, Facebook, etc
  /// </param>
  /// <param name="ids">
  /// Authentication IDs structure
  /// </param>
  /// <param name="extraJson">
  /// Additional to piggyback along with the call, to be picked up by pre- or post- hooks. Leave an empty Map for no extraJson.
  /// </param>

  Future<ServerResponse> attachAdvancedIdentity(
      AuthenticationType authenticationType,
      AuthenticationIds ids,
      Map<String, dynamic>? extraJson) async {
    Map<String, dynamic> data = {};
    data[OperationParam.identityServiceExternalId.value] = ids.externalId;
    data[OperationParam.identityServiceAuthenticationType.value] =
        authenticationType.value;
    data[OperationParam.authenticateServiceAuthenticateAuthenticationToken
        .value] = ids.authenticationToken;

    if (Util.isOptionalParameterValid(ids.authenticationSubType)) {
      data[OperationParam.authenticateServiceAuthenticateExternalId.value] =
          ids.authenticationSubType;
    }

    if (extraJson != null) {
      data[OperationParam.authenticateServiceAuthenticateExtraJson.value] =
          extraJson;
    }

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
        ServiceName.identity, ServiceOperation.attach, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Merge the profile associated with the provided credentials with the current profile.
  /// </summary>
  /// <param name="authenticationType">
  /// Universal, Email, Facebook, etc
  /// </param>
  /// <param name="ids">
  /// Authentication IDs structure
  /// </param>
  /// <param name="extraJson">
  /// Additional to piggyback along with the call, to be picked up by pre- or post- hooks. Leave an empty Map for no extraJson.
  /// </param>

  Future<ServerResponse> mergeAdvancedIdentity(
      AuthenticationType authenticationType,
      AuthenticationIds ids,
      Map<String, dynamic>? extraJson) async {
    Map<String, dynamic> data = {};
    data[OperationParam.identityServiceExternalId.value] = ids.externalId;
    data[OperationParam.identityServiceAuthenticationType.value] =
        authenticationType.value;
    data[OperationParam.authenticateServiceAuthenticateAuthenticationToken
        .value] = ids.authenticationToken;

    if (Util.isOptionalParameterValid(ids.authenticationSubType)) {
      data[OperationParam.authenticateServiceAuthenticateExternalId.value] =
          ids.authenticationSubType;
    }

    if (extraJson != null) {
      data[OperationParam.authenticateServiceAuthenticateExtraJson.value] =
          extraJson;
    }

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
        ServiceName.identity, ServiceOperation.merge, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Detach the identity from this profile.
  ///
  /// Watch for DOWNGRADING_TO_ANONYMOUS_ERROR - occurs if you set in_continueAnon to false, and
  /// disconnecting this identity would result in the profile being anonymous (which means that
  /// the profile wouldn't be retrievable if the user loses their device)
  /// </summary>
  /// <param name="authenticationType">
  /// Universal, Email, Facebook, etc
  /// </param>
  /// <param name="externalId">
  /// User ID
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>
  /// <param name="extraJson">
  /// Additional to piggyback along with the call, to be picked up by pre- or post- hooks. Leave an empty Map for no extraJson.
  /// </param>

  Future<ServerResponse> detachAdvancedIdentity(
      AuthenticationType authenticationType,
      String externalId,
      bool continueAnon,
      Map<String, dynamic>? extraJson) async {
    Map<String, dynamic> data = {};
    data[OperationParam.identityServiceExternalId.value] = externalId;
    data[OperationParam.identityServiceAuthenticationType.value] =
        authenticationType.value;
    data[OperationParam.identityServiceConfirmAnonymous.value] = continueAnon;

    if (extraJson != null) {
      data[OperationParam.authenticateServiceAuthenticateExtraJson.value] =
          extraJson;
    }

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
        ServiceName.identity, ServiceOperation.detach, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Attach the user's Ultra credentials to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// Errors to watch for:  SWITCHING_PROFILES - this means that the Ultra identity you provided
  /// already points to a different profile.  You will likely want to offer the user the
  /// choice to *SWITCH* to that profile, or *MERGE* the profiles.
  ///
  /// To switch profiles, call ClearSavedProfileID() and call AuthenticateUltra().
  /// </summary>
  /// <param name="ultraUsername">
  /// it's what the user uses to log into the Ultra endpoint initially
  /// </param>
  /// <param name="ultraIdToken">
  /// The "id_token" taken from Ultra's JWT.
  /// </param>
  Future<ServerResponse> attachUltraIdentity(
      String ultraUsername, String ultraIdToken) async {
    return _attachIdentity(
        ultraUsername, ultraIdToken, AuthenticationType.ultra);
  }

  /// <summary>
  /// Merge the profile associated with the provided Ultra credentials with the current profile
  ///
  /// Service Name - Identity
  /// Service Operation - Merge
  ///
  /// </summary>
  /// <param name="ultraUsername">
  /// It's what the user uses to log into the Ultra endpoint initially
  /// </param>
  /// <param name="ultraIdToken">
  /// The "id_token" taken from Ultra's JWT.
  /// </param>

  Future<ServerResponse> mergeUltraIdentity(
      String ultraUsername, String ultraIdToken) async {
    return _mergeIdentity(
        ultraUsername, ultraIdToken, AuthenticationType.ultra);
  }

  /// <summary>
  /// Detach the Ultra identity from this profile.
  ///
  /// Watch for DOWNGRADING_TO_ANONYMOUS_ERROR - occurs if you set in_continueAnon to false, and
  /// disconnecting this identity would result in the profile being anonymous (which means that
  /// the profile wouldn't be retrievable if the user loses their device)
  ///
  /// Service Name - Identity
  /// Service Operation - Detach
  ///
  /// </summary>
  /// <param name="ultraUsername">
  /// It's what the user uses to log into the Ultra endpoint initially
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachUltraIdentity(
      String ultraUsername, bool continueAnon) async {
    return _detachIdentity(
        ultraUsername, AuthenticationType.ultra, continueAnon);
  }

  /// <summary>
  /// Attach the user's Oculus credentials to the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Attach
  /// </remarks>
  /// <param name="oculusId">
  /// The oculus id of the user
  /// </param>
  /// <param name="oculusNonce">
  /// token from the Oculus SDK
  /// </param>

  Future<ServerResponse> attachOculusIdentity(
      String oculusId, String oculusNonce) async {
    return _attachIdentity(oculusId, oculusNonce, AuthenticationType.oculus);
  }

  /// <summary>
  /// Merge the profile associated with the provided Oculus credentials with the
  /// current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Merge
  /// </remarks>
  /// <param name="oculusId">
  /// The oculus id of the user
  /// </param>
  /// <param name="oculusNonce">
  /// token from the Oculus SDK
  /// </param>

  Future<ServerResponse> mergeOculusIdentity(
      String oculusId, String oculusNonce) async {
    return _mergeIdentity(oculusId, oculusNonce, AuthenticationType.oculus);
  }

  /// <summary>
  /// Detach the Facebook identity from this profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Detach
  /// </remarks>
  /// <param name="oculusId">
  /// The facebook id of the user
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachOculusIdentity(
      String oculusId, bool continueAnon) {
    return _detachIdentity(oculusId, AuthenticationType.oculus, continueAnon);
  }

  /// <summary>
  /// Attach the user's FacebookLimited credentials to the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Attach
  /// </remarks>
  /// <param name="facebookLimitedId">
  /// The facebook Limited id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the Facebook SDK
  ///   (that will be further validated when sent to the bC service)
  /// </param>

  Future<ServerResponse> attachFacebookLimitedIdentity(
      String facebookLimitedId, String authenticationToken) async {
    return _attachIdentity(facebookLimitedId, authenticationToken,
        AuthenticationType.facebookLimited);
  }

  /// <summary>
  /// Merge the profile associated with the provided Facebook Limited credentials with the
  /// current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Merge
  /// </remarks>
  /// <param name="facebookLimitedId">
  /// The facebook Limited id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the Facebook SDK
  /// (that will be further validated when sent to the bC service)
  /// </param>
  Future<ServerResponse> mergeFacebookLimitedIdentity(
      String facebookLimitedId, String authenticationToken) async {
    return _mergeIdentity(facebookLimitedId, authenticationToken,
        AuthenticationType.facebookLimited);
  }

  /// <summary>
  /// Detach the FacebookLimited identity from this profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Detach
  /// </remarks>
  /// <param name="facebookLimitedId">
  /// The facebook Limited id of the user
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachFacebookLimitedIdentity(
      String facebookLimitedId, bool continueAnon) async {
    return _detachIdentity(
        facebookLimitedId, AuthenticationType.facebookLimited, continueAnon);
  }

  /// <summary>
  /// Attach the user's PSN credentials to the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Attach
  /// </remarks>
  /// <param name="psnAccountId">
  /// The PSN account id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the Playstation SDK
  ///   (that will be further validated when sent to the bC service)
  /// </param>

  Future<ServerResponse> attachPlaystationNetworkIdentity(
      String psnAccountId, String authenticationToken) async {
    return _attachIdentity(psnAccountId, authenticationToken,
        AuthenticationType.playstationNetwork);
  }

  /// <summary>
  /// Merge the profile associated with the provided PSN credentials with the
  /// current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Merge
  /// </remarks>
  /// <param name="psnAccountId">
  /// The psn account id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the Playstation SDK
  /// (that will be further validated when sent to the bC service)
  /// </param>

  Future<ServerResponse> mergePlaystationNetworkIdentity(
      String psnAccountId, String authenticationToken) async {
    return _mergeIdentity(psnAccountId, authenticationToken,
        AuthenticationType.playstationNetwork);
  }

  /// <summary>
  /// Detach the PSN identity from this profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Detach
  /// </remarks>
  /// <param name="psnAccountId">
  /// The PSN Account id of the user
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachPlaystationNetworkIdentity(
      String psnAccountId, bool continueAnon) async {
    return _detachIdentity(
        psnAccountId, AuthenticationType.playstationNetwork, continueAnon);
  }

  /// <summary>
  /// Attach the user's PSN credentials to the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Attach
  /// </remarks>
  /// <param name="psnAccountId">
  /// The PSN account id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the Playstation SDK
  ///   (that will be further validated when sent to the bC service)
  /// </param>

  Future<ServerResponse> attachPlaystation5Identity(
      String psnAccountId, String authenticationToken) async {
    return _attachIdentity(psnAccountId, authenticationToken,
        AuthenticationType.playstationNetwork5);
  }

  /// <summary>
  /// Merge the profile associated with the provided PSN credentials with the
  /// current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Merge
  /// </remarks>
  /// <param name="psnAccountId">
  /// The psn account id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the Playstation SDK
  /// (that will be further validated when sent to the bC service)
  /// </param>

  Future<ServerResponse> mergePlaystation5Identity(
      String psnAccountId, String authenticationToken) async {
    return _mergeIdentity(psnAccountId, authenticationToken,
        AuthenticationType.playstationNetwork5);
  }

  /// <summary>
  /// Detach the PSN identity from this profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Detach
  /// </remarks>
  /// <param name="psnAccountId">
  /// The PSN Account id of the user
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachPlaystation5Identity(
      String psnAccountId, bool continueAnon) async {
    return _detachIdentity(
        psnAccountId, AuthenticationType.playstationNetwork5, continueAnon);
  }

  /// <summary>
  /// Attach a Game Center identity to the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Attach
  /// </remarks>
  /// <param name="gameCenterId">
  /// The user's game center id  (use the playerID property from the local GKPlayer dynamic)
  /// </param>

  Future<ServerResponse> attachGameCenterIdentity(String gameCenterId,
      SuccessCallback? success, FailureCallback? failure) async {
    return _attachIdentity(gameCenterId, "", AuthenticationType.gameCenter);
  }

  /// <summary>Merge the profile associated with the specified Game Center identity with the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Merge
  /// </remarks>
  /// <param name="gameCenterId">
  /// The user's game center id  (use the playerID property from the local GKPlayer dynamic)
  /// </param>

  Future<ServerResponse> mergeGameCenterIdentity(String gameCenterId) async {
    return _mergeIdentity(gameCenterId, "", AuthenticationType.gameCenter);
  }

  /// <summary>Detach the Game Center identity from the current profile.</summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Detach
  /// </remarks>
  /// <param name="gameCenterId">
  /// The user's game center id  (use the playerID property from the local GKPlayer dynamic)
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachGameCenterIdentity(
      String gameCenterId, bool continueAnon) async {
    return _detachIdentity(
        gameCenterId, AuthenticationType.gameCenter, continueAnon);
  }

  /// <summary>
  /// Attach a Email and Password identity to the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Attach
  /// </remarks>
  /// <param name="email">
  /// The user's e-mail address
  /// </param>
  /// <param name="password">
  /// The user's password
  /// </param>

  Future<ServerResponse> attachEmailIdentity(
      String email, String password) async {
    return _attachIdentity(email, password, AuthenticationType.email);
  }

  /// <summary>
  // Merge the profile associated with the provided e=mail with the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Merge
  /// </remarks>
  /// <param name="email">
  /// The user's e-mail address
  /// </param>
  /// <param name="password">
  /// The user's password
  /// </param>

  Future<ServerResponse> mergeEmailIdentity(
      String email, String password) async {
    return _mergeIdentity(email, password, AuthenticationType.email);
  }

  /// <summary>Detach the e-mail identity from the current profile
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Detach
  /// </remarks>
  /// <param name="email">
  /// The user's e-mail address
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachEmailIdentity(
      String email, bool continueAnon) async {
    return _detachIdentity(email, AuthenticationType.email, continueAnon);
  }

  /// <summary>
  /// Attach a Universal (userId + password) identity to the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Attach
  /// </remarks>
  /// <param name="userId">
  /// The user's userId
  /// </param>
  /// <param name="password">
  /// The user's password
  /// </param>
  Future<ServerResponse> attachUniversalIdentity(
      String userId, String password) async {
    return _attachIdentity(userId, password, AuthenticationType.universal);
  }

  /// <summary>
  /// Merge the profile associated with the provided e=mail with the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Merge
  /// </remarks>
  /// <param name="userId">
  /// The user's userId
  /// </param>
  /// <param name="password">
  /// The user's password
  /// </param>

  Future<ServerResponse> mergeUniversalIdentity(
      String userId, String password) {
    return _mergeIdentity(userId, password, AuthenticationType.universal);
  }

  /// <summary>Detach the universal identity from the current profile
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Detach
  /// </remarks>
  /// <param name="userId">
  /// The user's userId
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachUniversalIdentity(
      String userId, bool continueAnon) async {
    return _detachIdentity(userId, AuthenticationType.universal, continueAnon);
  }

  /// <summary>
  /// Attach a Steam (userId + steamsessionticket) identity to the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Attach
  /// </remarks>
  /// <param name="steamId">
  /// String representation of 64 bit steam id
  /// </param>
  /// <param name="sessionTicket">
  /// The user's session ticket (hex encoded)
  /// </param>

  Future<ServerResponse> attachSteamIdentity(
      String steamId, String sessionTicket) {
    return _attachIdentity(steamId, sessionTicket, AuthenticationType.steam);
  }

  /// <summary>
  /// Merge the profile associated with the provided steam userId with the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Merge
  /// </remarks>
  /// <param name="steamId">
  /// String representation of 64 bit steam id
  /// </param>
  /// <param name="sessionTicket">
  /// The user's session ticket (hex encoded)
  /// </param>

  Future<ServerResponse> mergeSteamIdentity(
      String steamId, String sessionTicket) async {
    return _mergeIdentity(steamId, sessionTicket, AuthenticationType.steam);
  }

  /// <summary>Detach the steam identity from the current profile
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Detach
  /// </remarks>
  /// <param name="steamId">
  /// String representation of 64 bit steam id
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachSteamIdentity(
      String steamId, bool continueAnon) async {
    return _detachIdentity(steamId, AuthenticationType.steam, continueAnon);
  }

  /// <summary>
  /// Attach the user's Google credentials to the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Attach
  /// </remarks>
  /// <param name="googleUserId">
  /// String representation of google+ userId. Gotten with calls like RequestUserId
  /// </param>
  /// <param name="serverAuthCode">
  /// The validated token from the Google SDK
  ///   (that will be further validated when sent to the bC service)
  /// </param>

  Future<ServerResponse> attachGoogleIdentity(
      String googleUserId, String serverAuthCode) async {
    return _attachIdentity(
        googleUserId, serverAuthCode, AuthenticationType.google);
  }

  /// <summary>
  /// Merge the profile associated with the provided Google credentials with the
  /// current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Merge
  /// </remarks>
  /// <param name="googleUserId">
  /// String representation of google+ userId. Gotten with calls like RequestUserId
  /// </param>
  /// <param name="serverAuthCode">
  /// The validated token from the Google SDK
  /// (that will be further validated when sent to the bC service)
  /// </param>

  Future<ServerResponse> mergeGoogleIdentity(
      String googleUserId, String serverAuthCode) async {
    return _mergeIdentity(
        googleUserId, serverAuthCode, AuthenticationType.google);
  }

  /// <summary>
  /// Detach the Google identity from this profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Detach
  /// </remarks>
  /// <param name="googleUserId">
  /// String representation of google+ userId. Gotten with calls like RequestUserId
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachGoogleIdentity(
      String googleUserId, bool continueAnon) async {
    return _detachIdentity(
        googleUserId, AuthenticationType.google, continueAnon);
  }

  /// <summary>
  /// Attach the user's Google credentials to the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Attach
  /// </remarks>
  /// <param name="googleUserAccountEmail">
  /// The email associated with the google user
  /// </param>
  /// <param name="IdToken">
  /// The id token of the google account. Can get with calls like requestIdToken
  /// </param>
  Future<ServerResponse> attachGoogleOpenIdIdentity(
      String googleUserAccountEmail, String idToken) async {
    return _attachIdentity(
        googleUserAccountEmail, idToken, AuthenticationType.googleOpenId);
  }

  /// <summary>
  /// Merge the profile associated with the provided Google credentials with the
  /// current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Merge
  /// </remarks>
  /// <param name="googleUserAccountEmail">
  /// The email associated with the google user
  /// </param>
  /// <param name="IdToken">
  /// The id token of the google account. Can get with calls like requestIdToken
  /// </param>

  Future<ServerResponse> mergeGoogleOpenIdIdentity(
      String googleUserAccountEmail, String idToken) async {
    return _mergeIdentity(
        googleUserAccountEmail, idToken, AuthenticationType.googleOpenId);
  }

  /// <summary>
  /// Detach the Google identity from this profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Detach
  /// </remarks>
  /// <param name="googleUserAccountEmail">
  /// The email associated with the google user
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachGoogleOpenIdIdentity(
      String googleUserAccountEmail, bool continueAnon) async {
    return _detachIdentity(
        googleUserAccountEmail, AuthenticationType.googleOpenId, continueAnon);
  }

  /// <summary>
  /// Attach the user's Apple credentials to the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Attach
  /// </remarks>
  /// <param name="appleUserId">
  /// This can be the user id OR the email of the user for the account
  /// </param>
  /// <param name="identityToken">
  /// The token confirming the user's identity
  /// </param>
  Future<ServerResponse> attachAppleIdentity(
      String appleUserId, String identityToken) async {
    return _attachIdentity(
        appleUserId, identityToken, AuthenticationType.apple);
  }

  /// <summary>
  /// Merge the profile associated with the provided Apple credentials with the
  /// current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Merge
  /// </remarks>
  /// <param name="appleUserId">
  /// This can be the user id OR the email of the user for the account
  /// </param>
  /// <param name="identityToken">
  /// The token confirming the user's identity
  /// </param>

  Future<ServerResponse> mergeAppleIdentity(
      String appleUserId, String identityToken) {
    return _mergeIdentity(appleUserId, identityToken, AuthenticationType.apple);
  }

  /// <summary>
  /// Detach the Apple identity from this profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Detach
  /// </remarks>
  /// <param name="appleUserId">
  /// This can be the user id OR the email of the user for the account
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachAppleIdentity(
      String appleUserId, bool continueAnon) async {
    return _detachIdentity(appleUserId, AuthenticationType.apple, continueAnon);
  }

  /// <summary>
  /// Attach the user's Twitter credentials to the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Attach
  /// </remarks>
  /// <param name="twitterId">
  /// String representation of a Twitter user ID
  /// </param>
  /// <param name="authenticationToken">
  /// The authentication token derived via the Twitter apis
  /// </param>
  /// <param name="secret">
  /// The secret given when attempting to link with Twitter
  /// </param>
  Future<ServerResponse> attachTwitterIdentity(
      String twitterId, String authenticationToken, String secret) async {
    return _attachIdentity(
        twitterId, "$authenticationToken:$secret", AuthenticationType.twitter);
  }

  /// <summary>
  /// Merge the profile associated with the provided Twitter credentials with the
  /// current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Merge
  /// </remarks>
  /// <param name="twitterId">
  /// String representation of a Twitter user ID
  /// </param>
  /// <param name="authenticationToken">
  /// The authentication token derived via the Twitter apis
  /// </param>
  /// <param name="secret">
  /// The secret given when attempting to link with Twitter
  /// </param>

  Future<ServerResponse> mergeTwitterIdentity(
      String twitterId, String authenticationToken, String secret) async {
    return _mergeIdentity(
        twitterId, "$authenticationToken:$secret", AuthenticationType.twitter);
  }

  /// <summary>
  /// Detach the Twitter identity from this profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Detach
  /// </remarks>
  /// <param name="twitterId">
  /// The Twitter id of the user
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachTwitterIdentity(
      String twitterId, bool continueAnon) async {
    return _detachIdentity(twitterId, AuthenticationType.twitter, continueAnon);
  }

  /// <summary>
  /// Attach the user's Parse credentials to the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Attach
  /// </remarks>
  /// <param name="parseId">
  /// The Parse id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from Parse
  ///   (that will be further validated when sent to the bC service)
  /// </param>

  Future<ServerResponse> attachParseIdentity(
      String parseId, String authenticationToken) async {
    return _attachIdentity(
        parseId, authenticationToken, AuthenticationType.parse);
  }

  /// <summary>
  /// Merge the profile associated with the provided Parse credentials with the
  /// current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Merge
  /// </remarks>
  /// <param name="parseId">
  /// The Parse id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from Parse
  /// (that will be further validated when sent to the bC service)
  /// </param>

  Future<ServerResponse> mergeParseIdentity(
      String parseId, String authenticationToken) async {
    return _mergeIdentity(
        parseId, authenticationToken, AuthenticationType.parse);
  }

  /// <summary>
  /// Detach the Parse identity from this profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Detach
  /// </remarks>
  /// <param name="parseId">
  /// The Parse id of the user
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachParseIdentity(
      String parseId, bool continueAnon) async {
    return _detachIdentity(parseId, AuthenticationType.parse, continueAnon);
  }

  /// <summary>
  /// Attach the user's Nintendo credentials to the current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Attach
  /// </remarks>
  /// <param name="nintendoAccountId">
  /// The Nintendo account id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the Nintendo SDK
  ///   (that will be further validated when sent to the bC service)
  /// </param>
  Future<ServerResponse> attachNintendoIdentity(
      String nintendoAccountId, String authenticationToken) {
    return _attachIdentity(
        nintendoAccountId, authenticationToken, AuthenticationType.nintendo);
  }

  /// <summary>
  /// Merge the profile associated with the provided Nintendo credentials with the
  /// current profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Merge
  /// </remarks>
  /// <param name="nintendoAccountId">
  /// The Nintendo account id of the user
  /// </param>
  /// <param name="authenticationToken">
  /// The validated token from the Nintendo SDK
  /// (that will be further validated when sent to the bC service)
  /// </param>

  Future<ServerResponse> mergeNintendoIdentity(
      String nintendoAccountId, String authenticationToken) {
    return _mergeIdentity(
        nintendoAccountId, authenticationToken, AuthenticationType.nintendo);
  }

  /// <summary>
  /// Detach the Nintendo identity from this profile.
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - Detach
  /// </remarks>
  /// <param name="nintendoAccountId">
  /// The Nintendo Account id of the user
  /// </param>
  /// <param name="continueAnon">
  /// Proceed even if the profile will revert to anonymous?
  /// </param>

  Future<ServerResponse> detachNintendoIdentity(
      String nintendoAccountId, bool continueAnon) async {
    return _detachIdentity(
        nintendoAccountId, AuthenticationType.nintendo, continueAnon);
  }

  /// <summary>
  /// Switch to a Child Profile
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - SWITCH_TO_CHILD_PROFILE
  /// </remarks>
  /// <param name="childProfileId">
  /// The profileId of the child profile to switch to
  /// If null and forceCreate is true a new profile will be created
  /// </param>
  /// <param name="childAppId">
  /// The appId of the child game to switch to
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created if it does not exist?
  /// </param>

  Future<ServerResponse> switchToChildProfile(
      String childProfileId, String childAppId, bool forceCreate) async {
    return _switchToChildProfile(
        childProfileId, childAppId, forceCreate, false);
  }

  /// <summary>
  /// Switches to the child profile of an app when only one profile exists
  /// If multiple profiles exist this returns an error
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - SWITCH_TO_CHILD_PROFILE
  /// </remarks>
  /// <param name="childAppId">
  /// The App ID of the child game to switch to
  /// </param>
  /// <param name="forceCreate">
  /// Should a new profile be created if one does not exist?
  /// </param>

  Future<ServerResponse> switchToSingletonChildProfile(
      String childAppId, bool forceCreate) async {
    return _switchToChildProfile(null, childAppId, forceCreate, true);
  }

  /// <summary>
  /// Attaches a univeral id to the current profile with no login capability.
  /// </summary>
  /// <param name="externalId">
  /// User ID
  /// </param>

  Future<ServerResponse> attachNonLoginUniversalId(String externalId) async {
    Map<String, dynamic> data = {};
    data[OperationParam.identityServiceExternalId.value] = externalId;

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.attachNonLoginUniversalId, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Updates univeral id of the current profile.
  /// </summary>
  /// <param name="externalId">
  /// User ID
  /// </param>
  Future<ServerResponse> updateUniversalIdLogin(String externalId) async {
    Map<String, dynamic> data = {};
    data[OperationParam.identityServiceExternalId.value] = externalId;

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.updateUniversalIdLogin, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Attach a new identity to a parent app
  /// </summary>
  /// <param name="externalId">
  /// User ID
  /// </param>
  /// <param name="authenticationToken">
  /// Password or client side token
  /// </param>
  /// <param name="authenticationType">
  /// Type of authentication
  /// </param>
  /// <param name="externalAuthName">
  /// Optional - if using AuthenticationType of external
  /// </param>
  /// <param name="forceCreate">
  /// If the profile does not exist, should it be created?
  /// </param>
  Future<ServerResponse> attachParentWithIdentity(
      String externalId,
      String authenticationToken,
      AuthenticationType authenticationType,
      String externalAuthName,
      bool forceCreate) async {
    Map<String, dynamic> data = {};

    data[OperationParam.identityServiceExternalId.value] = externalId;
    data[OperationParam.authenticateServiceAuthenticateAuthenticationToken
        .value] = authenticationToken;
    data[OperationParam.identityServiceAuthenticationType.value] =
        authenticationType.value;

    if (Util.isOptionalParameterValid(externalAuthName)) {
      data[OperationParam.authenticateServiceAuthenticateExternalAuthName
          .value] = externalAuthName;
    }

    data[OperationParam.authenticateServiceAuthenticateForceCreate.value] =
        forceCreate;

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.attachParentWithIdentity, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Switch to a Parent Profile
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - SWITCH_TO_PARENT_PROFILE
  /// </remarks>
  /// <param name="parentLevelName">
  /// The level of the parent to switch to
  /// </param>
  Future<ServerResponse> switchToParentProfile(String parentLevelName) async {
    Map<String, dynamic> data = {};
    data[OperationParam.authenticateServiceAuthenticateLevelName.value] =
        parentLevelName;

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.switchToParentProfile, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Detaches parent from this user's profile
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - DETACH_PARENT
  /// </remarks>
  Future<ServerResponse> detachParent() async {
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
        ServiceName.identity, ServiceOperation.detachParent, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Returns a list of all child profiles in child Apps
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - GET_CHILD_PROFILES
  /// </remarks>
  /// <param name="includeSummaryData">
  /// Whether to return the summary friend data along with this call
  /// </param>

  Future<ServerResponse> getChildProfiles(bool includeSummaryData) async {
    Map<String, dynamic> data = {};
    data[OperationParam.playerStateServiceIncludeSummaryData.value] =
        includeSummaryData;

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.getChildProfiles, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieve list of identities
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - GET_IDENTITIES
  /// </remarks>
  Future<ServerResponse> getIdentities() async {
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
        ServiceName.identity, ServiceOperation.getIdentities, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieve list of expired identities
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - GET_EXPIRED_IDENTITIES
  /// </remarks>

  Future<ServerResponse> getExpiredIdentities() async {
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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.getExpiredIdentities, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Refreshes an identity for this user
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - REFRESH_IDENTITY
  /// </remarks>
  /// <param name="externalId">
  /// User ID
  /// </param>
  /// <param name="authenticationToken">
  /// Password or client side token
  /// </param>
  /// <param name="authenticationType">
  /// Type of authentication
  /// </param>

  Future<ServerResponse> refreshIdentity(String externalId,
      String authenticationToken, AuthenticationType authenticationType) async {
    Map<String, dynamic> data = {};
    data[OperationParam.identityServiceExternalId.value] = externalId;
    data[OperationParam.authenticateServiceAuthenticateAuthenticationToken
        .value] = authenticationToken;
    data[OperationParam.identityServiceAuthenticationType.value] =
        authenticationType.value;

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
        ServiceName.identity, ServiceOperation.refreshIdentity, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Allows email identity email address to be changed
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - REFRESH_IDENTITY
  /// </remarks>
  /// <param name="oldEmailAddress">
  /// Old email address
  /// </param>
  /// <param name="password">
  /// Password for identity
  /// </param>
  /// <param name="newEmailAddress">
  /// New email address
  /// </param>
  /// <param name="updateContactEmail">
  /// Whether to update contact email in profile
  /// </param>

  Future<ServerResponse> changeEmailIdentity(String oldEmailAddress,
      String password, String newEmailAddress, bool updateContactEmail) async {
    Map<String, dynamic> data = {};
    data[OperationParam.identityServiceOldEmailAddress.value] = oldEmailAddress;
    data[OperationParam
        .authenticateServiceAuthenticateAuthenticationToken.value] = password;
    data[OperationParam.identityServiceNewEmailAddress.value] = newEmailAddress;
    data[OperationParam.identityServiceUpdateContactEmail.value] =
        updateContactEmail;

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.changeEmailIdentity, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Attaches a peer identity to this user's profile
  /// </summary>
  /// <param name="peer">
  /// Name of the peer to connect to
  /// </param>
  /// <param name="externalId">
  /// User ID
  /// </param>
  /// <param name="authenticationToken">
  /// Password or client side token
  /// </param>
  /// <param name="authenticationType">
  /// Type of authentication
  /// </param>
  /// <param name="externalAuthName">
  /// Optional - if using AuthenticationType of external
  /// </param>
  /// <param name="forceCreate">
  /// If the profile does not exist, should it be created?
  /// </param>

  Future<ServerResponse> attachPeerProfile(
      String peer,
      String externalId,
      String authenticationToken,
      AuthenticationType authenticationType,
      String externalAuthName,
      bool forceCreate) async {
    Map<String, dynamic> data = {};

    data[OperationParam.identityServiceExternalId.value] = externalId;
    data[OperationParam.authenticateServiceAuthenticateAuthenticationToken
        .value] = authenticationToken;
    data[OperationParam.identityServiceAuthenticationType.value] =
        authenticationType.value;

    if (Util.isOptionalParameterValid(externalAuthName)) {
      data[OperationParam.authenticateServiceAuthenticateExternalAuthName
          .value] = externalAuthName;
    }

    data[OperationParam.peer.value] = peer;
    data[OperationParam.authenticateServiceAuthenticateForceCreate.value] =
        forceCreate;

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.attachPeerProfile, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Detaches a peer identity from this user's profile
  /// </summary>
  /// <param name="peer">
  /// Name of the peer to connect to
  /// </param>
  Future<ServerResponse> detachPeer(String peer) async {
    Map<String, dynamic> data = {};

    data[OperationParam.peer.value] = peer;

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
        ServiceName.identity, ServiceOperation.detachPeer, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieves a list of attached peer profiles
  /// </summary>
  Future<ServerResponse> getPeerProfiles() async {
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
        ServiceName.identity, ServiceOperation.getPeerProfiles, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Attach blockchain
  /// </summary>
  /// <param name="blockchainConfig">
  ///
  /// </param>
  /// <param name="publicKey">
  ///
  /// </param>
  Future<ServerResponse> attachBlockChainIdentity(
      String blockchainConfig, String publicKey) async {
    Map<String, dynamic> data = {};
    data[OperationParam.blockChainConfig.value] = blockchainConfig;
    data[OperationParam.publicKey.value] = publicKey;

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.attachBlockChain, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// detach blockchain
  /// </summary>
  /// <param name="blockchainConfig">
  /// </param>
  Future<ServerResponse> detachBlockChainIdentity(
      String blockchainConfig) async {
    Map<String, dynamic> data = {};
    data[OperationParam.blockChainConfig.value] = blockchainConfig;

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.detachBlockChain, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  Future<ServerResponse> _attachIdentity(String externalId,
      String authenticationToken, AuthenticationType authenticationType) async {
    Map<String, dynamic> data = {};
    data[OperationParam.identityServiceExternalId.value] = externalId;
    data[OperationParam.identityServiceAuthenticationType.value] =
        authenticationType.value;
    data[OperationParam.authenticateServiceAuthenticateAuthenticationToken
        .value] = authenticationToken;

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
        ServiceName.identity, ServiceOperation.attach, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  Future<ServerResponse> _mergeIdentity(String externalId,
      String authenticationToken, AuthenticationType authenticationType) {
    Map<String, dynamic> data = {};
    data[OperationParam.identityServiceExternalId.value] = externalId;
    data[OperationParam.identityServiceAuthenticationType.value] =
        authenticationType.value;
    data[OperationParam.authenticateServiceAuthenticateAuthenticationToken
        .value] = authenticationToken;

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
        ServiceName.identity, ServiceOperation.merge, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  Future<ServerResponse> _detachIdentity(String externalId,
      AuthenticationType authenticationType, bool continueAnon) async {
    Map<String, dynamic> data = {};
    data[OperationParam.identityServiceExternalId.value] = externalId;
    data[OperationParam.identityServiceAuthenticationType.value] =
        authenticationType.value;
    data[OperationParam.identityServiceConfirmAnonymous.value] = continueAnon;

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
        ServiceName.identity, ServiceOperation.detach, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  Future<ServerResponse> _switchToChildProfile(String? childProfileId,
      String childAppd, bool forceCreate, bool forceSingleton) async {
    Map<String, dynamic> data = {};

    if (Util.isOptionalParameterValid(childProfileId)) {
      data[OperationParam.profileId.value] = childProfileId;
    }

    data[OperationParam.authenticateServiceAuthenticateGameId.value] =
        childAppd;
    data[OperationParam.authenticateServiceAuthenticateForceCreate.value] =
        forceCreate;
    data[OperationParam.identityServiceForceSingleton.value] = forceSingleton;

    data[OperationParam.authenticateServiceAuthenticateReleasePlatform.value] =
        _clientRef.releasePlatform.toString();
    data[OperationParam.authenticateServiceAuthenticateCountryCode.value] =
        Util.getCurrentCountryCode();
    data[OperationParam.authenticateServiceAuthenticateLanguageCode.value] =
        Util.getIsoCodeForCurrentLanguage();
    data[OperationParam.authenticateServiceAuthenticateTimeZoneOffset.value] =
        Util.getUTCOffsetForCurrentTimeZone();

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.switchToChildProfile, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
