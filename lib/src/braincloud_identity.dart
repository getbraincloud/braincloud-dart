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

class BrainCloudIdentity {
  final BrainCloudClient _clientRef;

  BrainCloudIdentity(this._clientRef);

  /// Attach the user's Facebook credentials to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// @param facebookId
  /// The facebook id of the user
  ///
  /// @param authenticationToken
  /// The validated token from the Facebook SDK
  ///   (that will be further validated when sent to the bC service)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachFacebookIdentity(
      {required String facebookId, required String authenticationToken}) async {
    return _attachIdentity(
        facebookId, authenticationToken, AuthenticationType.facebook);
  }

  /// Merge the profile associated with the provided Facebook credentials with the
  /// current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Merge
  ///
  /// @param facebookId
  /// The facebook id of the user
  ///
  /// @param authenticationToken
  /// The validated token from the Facebook SDK
  /// (that will be further validated when sent to the bC service)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergeFacebookIdentity(
      {required String facebookId, required String authenticationToken}) async {
    return _mergeIdentity(
        facebookId, authenticationToken, AuthenticationType.facebook);
  }

  /// Detach the Facebook identity from this profile.
  ///
  /// Service Name - identity
  /// Service Operation - Detach
  ///
  /// @param facebookId
  /// The facebook id of the user
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachFacebookIdentity(
      {required String facebookId, required continueAnon}) async {
    return _detachIdentity(
        facebookId, AuthenticationType.facebook, continueAnon);
  }

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
  ///
  /// @param authenticationType
  /// Universal, Email, Facebook, etc
  ///
  /// @param ids
  /// Authentication IDs structure
  ///
  /// @param extraJson
  /// Additional to piggyback along with the call, to be picked up by pre- or post- hooks. Leave an empty Map for no extraJson.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachAdvancedIdentity(
      {required AuthenticationType authenticationType,
      required AuthenticationIds ids,
      Map<String, dynamic>? extraJson}) async {
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
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.attach, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Merge the profile associated with the provided credentials with the current profile.
  ///
  /// @param authenticationType
  /// Universal, Email, Facebook, etc
  ///
  /// @param ids
  /// Authentication IDs structure
  ///
  /// @param extraJson
  /// Additional to piggyback along with the call, to be picked up by pre- or post- hooks. Leave an empty Map for no extraJson.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergeAdvancedIdentity(
      {required AuthenticationType authenticationType,
      required AuthenticationIds ids,
      Map<String, dynamic>? extraJson}) async {
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
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.merge, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Detach the identity from this profile.
  ///
  /// Watch for DOWNGRADING_TO_ANONYMOUS_ERROR - occurs if you set in_continueAnon to false, and
  /// disconnecting this identity would result in the profile being anonymous (which means that
  /// the profile wouldn't be retrievable if the user loses their device)
  ///
  /// @param authenticationType
  /// Universal, Email, Facebook, etc
  ///
  /// @param externalId
  /// User ID
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// @param extraJson
  /// Additional to piggyback along with the call, to be picked up by pre- or post- hooks. Leave an empty Map for no extraJson.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachAdvancedIdentity(
      {required AuthenticationType authenticationType,
      required String externalId,
      required bool continueAnon,
      Map<String, dynamic>? extraJson}) async {
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
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.detach, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

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
  ///
  /// @param ultraUsername
  /// it's what the user uses to log into the Ultra endpoint initially
  ///
  /// @param ultraIdToken
  /// The "id_token" taken from Ultra's JWT.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachUltraIdentity(
      {required String ultraUsername, required String ultraIdToken}) async {
    return _attachIdentity(
        ultraUsername, ultraIdToken, AuthenticationType.ultra);
  }

  /// Merge the profile associated with the provided Ultra credentials with the current profile
  ///
  /// Service Name - Identity
  /// Service Operation - Merge
  ///
  /// @param ultraUsername
  /// It's what the user uses to log into the Ultra endpoint initially
  ///
  /// @param ultraIdToken
  /// The "id_token" taken from Ultra's JWT.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergeUltraIdentity(
      {required String ultraUsername, required String ultraIdToken}) async {
    return _mergeIdentity(
        ultraUsername, ultraIdToken, AuthenticationType.ultra);
  }

  /// Detach the Ultra identity from this profile.
  ///
  /// Watch for DOWNGRADING_TO_ANONYMOUS_ERROR - occurs if you set in_continueAnon to false, and
  /// disconnecting this identity would result in the profile being anonymous (which means that
  /// the profile wouldn't be retrievable if the user loses their device)
  ///
  /// Service Name - Identity
  /// Service Operation - Detach
  ///
  /// @param ultraUsername
  /// It's what the user uses to log into the Ultra endpoint initially
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachUltraIdentity(
      {required String ultraUsername, required bool continueAnon}) async {
    return _detachIdentity(
        ultraUsername, AuthenticationType.ultra, continueAnon);
  }

  /// Attach the user's Oculus credentials to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// @param oculusId
  /// The oculus id of the user
  ///
  /// @param oculusNonce
  /// token from the Oculus SDK
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachOculusIdentity(
      {required String oculusId, required String oculusNonce}) async {
    return _attachIdentity(oculusId, oculusNonce, AuthenticationType.oculus);
  }

  /// Merge the profile associated with the provided Oculus credentials with the
  /// current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Merge
  ///
  /// @param oculusId
  /// The oculus id of the user
  ///
  /// @param oculusNonce
  /// token from the Oculus SDK
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergeOculusIdentity(
      {required String oculusId, required String oculusNonce}) async {
    return _mergeIdentity(oculusId, oculusNonce, AuthenticationType.oculus);
  }

  /// Detach the Facebook identity from this profile.
  ///
  /// Service Name - identity
  /// Service Operation - Detach
  ///
  /// @param oculusId
  /// The facebook id of the user
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachOculusIdentity(
      {required String oculusId, required bool continueAnon}) {
    return _detachIdentity(oculusId, AuthenticationType.oculus, continueAnon);
  }

  /// Attach the user's FacebookLimited credentials to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// @param facebookLimitedId
  /// The facebook Limited id of the user
  ///
  /// @param authenticationToken
  /// The validated token from the Facebook SDK
  ///   (that will be further validated when sent to the bC service)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachFacebookLimitedIdentity(
      {required String facebookLimitedId,
      required String authenticationToken}) async {
    return _attachIdentity(facebookLimitedId, authenticationToken,
        AuthenticationType.facebookLimited);
  }

  /// Merge the profile associated with the provided Facebook Limited credentials with the
  /// current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Merge
  ///
  /// @param facebookLimitedId
  /// The facebook Limited id of the user
  ///
  /// @param authenticationToken
  /// The validated token from the Facebook SDK
  /// (that will be further validated when sent to the bC service)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergeFacebookLimitedIdentity(
      {required String facebookLimitedId,
      required String authenticationToken}) async {
    return _mergeIdentity(facebookLimitedId, authenticationToken,
        AuthenticationType.facebookLimited);
  }

  /// Detach the FacebookLimited identity from this profile.
  ///
  /// Service Name - identity
  /// Service Operation - Detach
  ///
  /// @param facebookLimitedId
  /// The facebook Limited id of the user
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachFacebookLimitedIdentity(
      {required String facebookLimitedId, required bool continueAnon}) async {
    return _detachIdentity(
        facebookLimitedId, AuthenticationType.facebookLimited, continueAnon);
  }

  /// Attach the user's PSN credentials to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// @param psnAccountId
  /// The PSN account id of the user
  ///
  /// @param authenticationToken
  /// The validated token from the Playstation SDK
  ///   (that will be further validated when sent to the bC service)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachPlaystationNetworkIdentity(
      {required String psnAccountId,
      required String authenticationToken}) async {
    return _attachIdentity(psnAccountId, authenticationToken,
        AuthenticationType.playstationNetwork);
  }

  /// Merge the profile associated with the provided PSN credentials with the
  /// current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Merge
  ///
  /// @param psnAccountId
  /// The psn account id of the user
  /// @param authenticationToken
  /// The validated token from the Playstation SDK
  /// (that will be further validated when sent to the bC service)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergePlaystationNetworkIdentity(
      {required String psnAccountId,
      required String authenticationToken}) async {
    return _mergeIdentity(psnAccountId, authenticationToken,
        AuthenticationType.playstationNetwork);
  }

  /// Detach the PSN identity from this profile.
  ///
  /// Service Name - identity
  /// Service Operation - Detach
  ///
  /// @param psnAccountId
  /// The PSN Account id of the user
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachPlaystationNetworkIdentity(
      {required String psnAccountId, required bool continueAnon}) async {
    return _detachIdentity(
        psnAccountId, AuthenticationType.playstationNetwork, continueAnon);
  }

  /// Attach the user's PSN credentials to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// @param psnAccountId
  /// The PSN account id of the user
  ///
  /// @param authenticationToken
  /// The validated token from the Playstation SDK
  ///   (that will be further validated when sent to the bC service)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachPlaystation5Identity(
      {required String psnAccountId,
      required String authenticationToken}) async {
    return _attachIdentity(psnAccountId, authenticationToken,
        AuthenticationType.playstationNetwork5);
  }

  /// Merge the profile associated with the provided PSN credentials with the
  /// current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Merge
  ///
  /// @param psnAccountId
  /// The psn account id of the user
  ///
  /// @param authenticationToken
  /// The validated token from the Playstation SDK
  /// (that will be further validated when sent to the bC service)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergePlaystation5Identity(
      {required String psnAccountId,
      required String authenticationToken}) async {
    return _mergeIdentity(psnAccountId, authenticationToken,
        AuthenticationType.playstationNetwork5);
  }

  /// Detach the PSN identity from this profile.
  ///
  /// Service Name - identity
  /// Service Operation - Detach
  ///
  /// @param psnAccountId
  /// The PSN Account id of the user
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachPlaystation5Identity(
      {required String psnAccountId, required bool continueAnon}) async {
    return _detachIdentity(
        psnAccountId, AuthenticationType.playstationNetwork5, continueAnon);
  }

  /// Attach a Game Center identity to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// @param gameCenterId
  /// The user's game center id  (use the playerID property from the local GKPlayer dynamic)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachGameCenterIdentity(
      {required String gameCenterId}) async {
    return _attachIdentity(gameCenterId, "", AuthenticationType.gameCenter);
  }

  /// Merge the profile associated with the specified Game Center identity with the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Merge
  ///
  /// @param gameCenterId
  /// The user's game center id  (use the playerID property from the local GKPlayer dynamic)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergeGameCenterIdentity(
      {required String gameCenterId}) async {
    return _mergeIdentity(gameCenterId, "", AuthenticationType.gameCenter);
  }

  /// Detach the Game Center identity from the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Detach
  ///
  /// @param gameCenterId
  /// The user's game center id  (use the playerID property from the local GKPlayer dynamic)
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachGameCenterIdentity(
      {required String gameCenterId, required bool continueAnon}) async {
    return _detachIdentity(
        gameCenterId, AuthenticationType.gameCenter, continueAnon);
  }

  /// Attach a Email and Password identity to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// @param email
  /// The user's e-mail address
  ///
  /// @param password
  /// The user's password
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachEmailIdentity(
      {required String email, required String password}) async {
    return _attachIdentity(email, password, AuthenticationType.email);
  }

  /// Merge the profile associated with the provided e=mail with the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Merge
  ///
  /// @param email
  /// The user's e-mail address
  ///
  /// @param password
  /// The user's password
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergeEmailIdentity(
      {required String email, required String password}) async {
    return _mergeIdentity(email, password, AuthenticationType.email);
  }

  /// Detach the e-mail identity from the current profile
  ///
  /// Service Name - identity
  /// Service Operation - Detach
  ///
  /// @param email
  /// The user's e-mail address
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachEmailIdentity(
      {required String email, required bool continueAnon}) async {
    return _detachIdentity(email, AuthenticationType.email, continueAnon);
  }

  /// Attach a Universal (userId + password) identity to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// @param userId
  /// The user's userId
  ///
  /// @param password
  /// The user's password
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachUniversalIdentity(
      {required String userId, required String password}) async {
    return _attachIdentity(userId, password, AuthenticationType.universal);
  }

  /// Merge the profile associated with the provided e=mail with the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Merge
  ///
  /// @param userId
  /// The user's userId
  ///
  /// @param password
  /// The user's password
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergeUniversalIdentity(
      {required String userId, required String password}) {
    return _mergeIdentity(userId, password, AuthenticationType.universal);
  }

  /// Detach the universal identity from the current profile
  ///
  /// Service Name - identity
  /// Service Operation - Detach
  ///
  /// @param userId
  /// The user's userId
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachUniversalIdentity(
      {required String userId, required bool continueAnon}) async {
    return _detachIdentity(userId, AuthenticationType.universal, continueAnon);
  }

  /// Attach a Steam (userId + steamsessionticket) identity to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// @param steamId
  /// String representation of 64 bit steam id
  ///
  /// @param sessionTicket
  /// The user's session ticket (hex encoded)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachSteamIdentity(
      {required String steamId, required String sessionTicket}) {
    return _attachIdentity(steamId, sessionTicket, AuthenticationType.steam);
  }

  /// Merge the profile associated with the provided steam userId with the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Merge
  ///
  /// @param steamId
  /// String representation of 64 bit steam id
  ///
  /// @param sessionTicket
  /// The user's session ticket (hex encoded)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergeSteamIdentity(
      {required String steamId, required String sessionTicket}) async {
    return _mergeIdentity(steamId, sessionTicket, AuthenticationType.steam);
  }

  /// Detach the steam identity from the current profile
  ///
  /// Service Name - identity
  /// Service Operation - Detach
  ///
  /// @param steamId
  /// String representation of 64 bit steam id
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachSteamIdentity(
      {required String steamId, required bool continueAnon}) async {
    return _detachIdentity(steamId, AuthenticationType.steam, continueAnon);
  }

  /// Attach the user's Google credentials to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// @param googleUserId
  /// String representation of google+ userId. Gotten with calls like RequestUserId
  ///
  /// @param serverAuthCode
  /// The validated token from the Google SDK
  ///   (that will be further validated when sent to the bC service)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachGoogleIdentity(
      {required String googleUserId, required String serverAuthCode}) async {
    return _attachIdentity(
        googleUserId, serverAuthCode, AuthenticationType.google);
  }

  /// Merge the profile associated with the provided Google credentials with the
  /// current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Merge
  ///
  /// @param googleUserId
  /// String representation of google+ userId. Gotten with calls like RequestUserId
  ///
  /// @param serverAuthCode
  /// The validated token from the Google SDK
  /// (that will be further validated when sent to the bC service)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergeGoogleIdentity(
      {required String googleUserId, required String serverAuthCode}) async {
    return _mergeIdentity(
        googleUserId, serverAuthCode, AuthenticationType.google);
  }

  /// Detach the Google identity from this profile.
  ///
  /// Service Name - identity
  /// Service Operation - Detach
  ///
  /// @param googleUserId
  /// String representation of google+ userId. Gotten with calls like RequestUserId
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachGoogleIdentity(
      {required String googleUserId, required bool continueAnon}) async {
    return _detachIdentity(
        googleUserId, AuthenticationType.google, continueAnon);
  }

  /// Attach the user's Google credentials to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// @param googleUserAccountEmail
  /// The email associated with the google user
  ///
  /// @param IdToken
  /// The id token of the google account. Can get with calls like requestIdToken
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachGoogleOpenIdIdentity(
      {required String googleUserAccountEmail, required String idToken}) async {
    return _attachIdentity(
        googleUserAccountEmail, idToken, AuthenticationType.googleOpenId);
  }

  /// Merge the profile associated with the provided Google credentials with the
  /// current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Merge
  ///
  /// @param googleUserAccountEmail
  /// The email associated with the google user
  ///
  /// @param IdToken
  /// The id token of the google account. Can get with calls like requestIdToken
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergeGoogleOpenIdIdentity(
      {required String googleUserAccountEmail, required String idToken}) async {
    return _mergeIdentity(
        googleUserAccountEmail, idToken, AuthenticationType.googleOpenId);
  }

  /// Detach the Google identity from this profile.
  ///
  /// Service Name - identity
  /// Service Operation - Detach
  ///
  /// @param googleUserAccountEmail
  /// The email associated with the google user
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachGoogleOpenIdIdentity(
      {required String googleUserAccountEmail,
      required bool continueAnon}) async {
    return _detachIdentity(
        googleUserAccountEmail, AuthenticationType.googleOpenId, continueAnon);
  }

  /// Attach the user's Apple credentials to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// @param appleUserId
  /// This can be the user id OR the email of the user for the account
  ///
  /// @param identityToken
  /// The token confirming the user's identity
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachAppleIdentity(
      {required String appleUserId, required String identityToken}) async {
    return _attachIdentity(
        appleUserId, identityToken, AuthenticationType.apple);
  }

  /// Merge the profile associated with the provided Apple credentials with the
  /// current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Merge
  ///
  /// @param appleUserId
  /// This can be the user id OR the email of the user for the account
  ///
  /// @param identityToken
  /// The token confirming the user's identity
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergeAppleIdentity(
      {required String appleUserId, required String identityToken}) {
    return _mergeIdentity(appleUserId, identityToken, AuthenticationType.apple);
  }

  /// Detach the Apple identity from this profile.
  ///
  /// Service Name - identity
  /// Service Operation - Detach
  ///
  /// @param appleUserId
  /// This can be the user id OR the email of the user for the account
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachAppleIdentity(
      {required String appleUserId, required bool continueAnon}) async {
    return _detachIdentity(appleUserId, AuthenticationType.apple, continueAnon);
  }

  /// Attach the user's Twitter credentials to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// @param twitterId
  /// String representation of a Twitter user ID
  ///
  /// @param authenticationToken
  /// The authentication token derived via the Twitter apis
  ///
  /// @param secret
  /// The secret given when attempting to link with Twitter
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachTwitterIdentity(
      {required String twitterId,
      required String authenticationToken,
      required String secret}) async {
    return _attachIdentity(
        twitterId, "$authenticationToken:$secret", AuthenticationType.twitter);
  }

  /// Merge the profile associated with the provided Twitter credentials with the
  /// current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Merge
  ///
  /// @param twitterId
  /// String representation of a Twitter user ID
  ///
  /// @param authenticationToken
  /// The authentication token derived via the Twitter apis
  ///
  /// @param secret
  /// The secret given when attempting to link with Twitter
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergeTwitterIdentity(
      {required String twitterId,
      required String authenticationToken,
      required String secret}) async {
    return _mergeIdentity(
        twitterId, "$authenticationToken:$secret", AuthenticationType.twitter);
  }

  /// Detach the Twitter identity from this profile.
  ///
  /// Service Name - identity
  /// Service Operation - Detach
  ///
  /// @param twitterId
  /// The Twitter id of the user
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachTwitterIdentity(
      {required String twitterId, required bool continueAnon}) async {
    return _detachIdentity(twitterId, AuthenticationType.twitter, continueAnon);
  }

  /// Attach the user's Parse credentials to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// @param parseId
  /// The Parse id of the user
  ///
  /// @param authenticationToken
  /// The validated token from Parse
  ///   (that will be further validated when sent to the bC service)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachParseIdentity(
      {required String parseId, required String authenticationToken}) async {
    return _attachIdentity(
        parseId, authenticationToken, AuthenticationType.parse);
  }

  /// Merge the profile associated with the provided Parse credentials with the
  /// current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Merge
  ///
  /// @param parseId
  /// The Parse id of the user
  ///
  /// @param authenticationToken
  /// The validated token from Parse
  /// (that will be further validated when sent to the bC service)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergeParseIdentity(
      {required String parseId, required String authenticationToken}) async {
    return _mergeIdentity(
        parseId, authenticationToken, AuthenticationType.parse);
  }

  /// Detach the Parse identity from this profile.
  ///
  /// Service Name - identity
  /// Service Operation - Detach
  ///
  /// @param parseId
  /// The Parse id of the user
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachParseIdentity(
      {required String parseId, required bool continueAnon}) async {
    return _detachIdentity(parseId, AuthenticationType.parse, continueAnon);
  }

  /// Attach the user's Nintendo credentials to the current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Attach
  ///
  /// @param nintendoAccountId
  /// The Nintendo account id of the user
  ///
  /// @param authenticationToken
  /// The validated token from the Nintendo SDK
  ///   (that will be further validated when sent to the bC service)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachNintendoIdentity(
      {required String nintendoAccountId,
      required String authenticationToken}) {
    return _attachIdentity(
        nintendoAccountId, authenticationToken, AuthenticationType.nintendo);
  }

  /// Merge the profile associated with the provided Nintendo credentials with the
  /// current profile.
  ///
  /// Service Name - identity
  /// Service Operation - Merge
  ///
  /// @param nintendoAccountId
  /// The Nintendo account id of the user
  ///
  /// @param authenticationToken
  /// The validated token from the Nintendo SDK
  /// (that will be further validated when sent to the bC service)
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> mergeNintendoIdentity(
      {required String nintendoAccountId,
      required String authenticationToken}) {
    return _mergeIdentity(
        nintendoAccountId, authenticationToken, AuthenticationType.nintendo);
  }

  /// Detach the Nintendo identity from this profile.
  ///
  /// Service Name - identity
  /// Service Operation - Detach
  ///
  /// @param nintendoAccountId
  /// The Nintendo Account id of the user
  ///
  /// @param continueAnon
  /// Proceed even if the profile will revert to anonymous?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachNintendoIdentity(
      {required String nintendoAccountId, required bool continueAnon}) async {
    return _detachIdentity(
        nintendoAccountId, AuthenticationType.nintendo, continueAnon);
  }

  /// Switch to a Child Profile
  ///
  /// Service Name - identity
  /// Service Operation - SWITCH_TO_CHILD_PROFILE
  ///
  /// @param childProfileId
  /// The profileId of the child profile to switch to
  /// If null and forceCreate is true a new profile will be created
  ///
  /// @param childAppId
  /// The appId of the child game to switch to
  ///
  /// @param forceCreate
  /// Should a new profile be created if it does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> switchToChildProfile(
      {String? childProfileId,
      required String childAppId,
      required bool forceCreate}) async {
    return _switchToChildProfile(
        childProfileId, childAppId, forceCreate, false);
  }

  /// Switches to the child profile of an app when only one profile exists
  /// If multiple profiles exist this returns an error
  ///
  /// Service Name - identity
  /// Service Operation - SWITCH_TO_CHILD_PROFILE
  ///
  /// @param childAppId
  /// The App ID of the child game to switch to
  ///
  /// @param forceCreate
  /// Should a new profile be created if one does not exist?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> switchToSingletonChildProfile(
      {required String childAppId, required bool forceCreate}) async {
    return _switchToChildProfile(null, childAppId, forceCreate, true);
  }

  /// Attaches a univeral id to the current profile with no login capability.
  ///
  /// @param externalId
  /// User ID
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachNonLoginUniversalId(
      {required String externalId}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.identityServiceExternalId.value] = externalId;

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.attachNonLoginUniversalId, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Updates univeral id of the current profile.
  ///
  /// @param externalId
  /// User ID
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> updateUniversalIdLogin(
      {required String externalId}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.identityServiceExternalId.value] = externalId;

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.updateUniversalIdLogin, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Attach a new identity to a parent app
  ///
  /// @param externalId
  /// User ID
  ///
  /// @param authenticationToken
  /// Password or client side token
  ///
  /// @param authenticationType
  /// Type of authentication
  ///
  /// @param externalAuthName
  /// Optional - if using AuthenticationType of external
  ///
  /// @param forceCreate
  /// If the profile does not exist, should it be created?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachParentWithIdentity(
      {required String externalId,
      required String authenticationToken,
      required AuthenticationType authenticationType,
      String? externalAuthName,
      required bool forceCreate}) async {
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
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.attachParentWithIdentity, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Switch to a Parent Profile
  ///
  /// Service Name - identity
  /// Service Operation - SWITCH_TO_PARENT_PROFILE
  ///
  /// @param parentLevelName
  /// The level of the parent to switch to
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> switchToParentProfile(
      {required String parentLevelName}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.authenticateServiceAuthenticateLevelName.value] =
        parentLevelName;

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.switchToParentProfile, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Detaches parent from this user's profile
  ///
  /// Service Name - identity
  /// Service Operation - DETACH_PARENT
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachParent() async {
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
        ServiceName.identity, ServiceOperation.detachParent, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Returns a list of all child profiles in child Apps
  ///
  /// Service Name - identity
  /// Service Operation - GET_CHILD_PROFILES
  ///
  /// @param includeSummaryData
  /// Whether to return the summary friend data along with this call
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getChildProfiles(
      {required bool includeSummaryData}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.playerStateServiceIncludeSummaryData.value] =
        includeSummaryData;

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.getChildProfiles, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve list of identities
  ///
  /// Service Name - identity
  /// Service Operation - GET_IDENTITIES
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getIdentities() async {
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
        ServiceName.identity, ServiceOperation.getIdentities, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve list of expired identities
  ///
  /// Service Name - identity
  /// Service Operation - GET_EXPIRED_IDENTITIES
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getExpiredIdentities() async {
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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.getExpiredIdentities, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Refreshes an identity for this user
  ///
  /// Service Name - identity
  /// Service Operation - REFRESH_IDENTITY
  ///
  /// @param externalId
  /// User ID
  ///
  /// @param authenticationToken
  /// Password or client side token
  ///
  /// @param authenticationType
  /// Type of authentication
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> refreshIdentity(
      {required String externalId,
      required String authenticationToken,
      required AuthenticationType authenticationType}) async {
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
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.refreshIdentity, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Allows email identity email address to be changed
  ///
  /// Service Name - identity
  /// Service Operation - REFRESH_IDENTITY
  ///
  /// @param oldEmailAddress
  /// Old email address
  ///
  /// @param password
  /// Password for identity
  ///
  /// @param newEmailAddress
  /// New email address
  ///
  /// @param updateContactEmail
  /// Whether to update contact email in profile
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> changeEmailIdentity(
      {required String oldEmailAddress,
      required String password,
      required String newEmailAddress,
      required bool updateContactEmail}) async {
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
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.changeEmailIdentity, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Attaches a peer identity to this user's profile
  ///
  /// @param peer
  /// Name of the peer to connect to
  ///
  /// @param externalId
  /// User ID
  ///
  /// @param authenticationToken
  /// Password or client side token
  ///
  /// @param authenticationType
  /// Type of authentication

  /// @param externalAuthName
  /// Optional - if using AuthenticationType of external
  ///
  /// @param forceCreate
  /// If the profile does not exist, should it be created?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachPeerProfile(
      {required String peer,
      required String externalId,
      required String authenticationToken,
      required AuthenticationType authenticationType,
      String? externalAuthName,
      bool forceCreate = false}) async {
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
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.attachPeerProfile, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Detaches a peer identity from this user's profile
  ///
  /// @param peer
  /// Name of the peer to connect to
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachPeer({required String peer}) async {
    Map<String, dynamic> data = {};

    data[OperationParam.peer.value] = peer;

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
        ServiceName.identity, ServiceOperation.detachPeer, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves a list of attached peer profiles
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getPeerProfiles() async {
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
        ServiceName.identity, ServiceOperation.getPeerProfiles, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Attach blockchain
  ///
  /// @param blockchainConfig
  ///
  /// @param publicKey
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> attachBlockChainIdentity(
      {required String blockchainConfig, required String publicKey}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.blockChainConfig.value] = blockchainConfig;
    data[OperationParam.publicKey.value] = publicKey;

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.attachBlockChain, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// detach blockchain
  ///
  /// @param blockchainConfig
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> detachBlockChainIdentity(
      {required String blockchainConfig}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.blockChainConfig.value] = blockchainConfig;

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

    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.detachBlockChain, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// returns Future<ServerResponse>
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
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.attach, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// returns Future<ServerResponse>
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
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.merge, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// returns Future<ServerResponse>
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
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.detach, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// returns Future<ServerResponse>
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
      completer.complete(ServerResponse(
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
