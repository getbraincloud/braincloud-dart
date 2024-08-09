import 'package:braincloud_dart/src/Common/authentication_ids.dart';
import 'package:braincloud_dart/src/Common/authentication_type.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/server_callback.dart';
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachFacebookIdentity(String facebookId, String authenticationToken,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _attachIdentity(facebookId, authenticationToken,
        AuthenticationType.facebook, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergeFacebookIdentity(String facebookId, String authenticationToken,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _mergeIdentity(facebookId, authenticationToken, AuthenticationType.facebook,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachFacebookIdentity(String facebookId, bool continueAnon,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _detachIdentity(facebookId, AuthenticationType.facebook, continueAnon,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachAdvancedIdentity(
      AuthenticationType authenticationType,
      AuthenticationIds ids,
      Map<String, dynamic>? extraJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.IdentityServiceExternalId.Value] = ids.externalId;
    data[OperationParam.IdentityServiceAuthenticationType.Value] =
        authenticationType.toString();
    data[OperationParam.AuthenticateServiceAuthenticateAuthenticationToken
        .Value] = ids.authenticationToken;

    if (Util.isOptionalParameterValid(ids.authenticationSubType)) {
      data[OperationParam.AuthenticateServiceAuthenticateExternalId.Value] =
          ids.authenticationSubType;
    }

    if (extraJson != null) {
      data[OperationParam.AuthenticateServiceAuthenticateExtraJson.Value] =
          extraJson;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.attach, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergeAdvancedIdentity(
      AuthenticationType authenticationType,
      AuthenticationIds ids,
      Map<String, dynamic>? extraJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.IdentityServiceExternalId.Value] = ids.externalId;
    data[OperationParam.IdentityServiceAuthenticationType.Value] =
        authenticationType.toString();
    data[OperationParam.AuthenticateServiceAuthenticateAuthenticationToken
        .Value] = ids.authenticationToken;

    if (Util.isOptionalParameterValid(ids.authenticationSubType)) {
      data[OperationParam.AuthenticateServiceAuthenticateExternalId.Value] =
          ids.authenticationSubType;
    }

    if (extraJson != null) {
      data[OperationParam.AuthenticateServiceAuthenticateExtraJson.Value] =
          extraJson;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.merge, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachAdvancedIdentity(
      AuthenticationType authenticationType,
      String externalId,
      bool continueAnon,
      Map<String, dynamic>? extraJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.IdentityServiceExternalId.Value] = externalId;
    data[OperationParam.IdentityServiceAuthenticationType.Value] =
        authenticationType.toString();
    data[OperationParam.IdentityServiceConfirmAnonymous.Value] = continueAnon;

    if (extraJson != null) {
      data[OperationParam.AuthenticateServiceAuthenticateExtraJson.Value] =
          extraJson;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.detach, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachUltraIdentity(String ultraUsername, String ultraIdToken,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _attachIdentity(ultraUsername, ultraIdToken, AuthenticationType.ultra,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergeUltraIdentity(String ultraUsername, String ultraIdToken,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _mergeIdentity(ultraUsername, ultraIdToken, AuthenticationType.ultra,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachUltraIdentity(String ultraUsername, bool continueAnon,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _detachIdentity(ultraUsername, AuthenticationType.ultra, continueAnon,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachOculusIdentity(String oculusId, String oculusNonce,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _attachIdentity(oculusId, oculusNonce, AuthenticationType.oculus, success,
        failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergeOculusIdentity(String oculusId, String oculusNonce,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _mergeIdentity(oculusId, oculusNonce, AuthenticationType.oculus, success,
        failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachOculusIdentity(String oculusId, bool continueAnon,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _detachIdentity(oculusId, AuthenticationType.oculus, continueAnon, success,
        failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachFacebookLimitedIdentity(
      String facebookLimitedId,
      String authenticationToken,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _attachIdentity(facebookLimitedId, authenticationToken,
        AuthenticationType.facebookLimited, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergeFacebookLimitedIdentity(
      String facebookLimitedId,
      String authenticationToken,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _mergeIdentity(facebookLimitedId, authenticationToken,
        AuthenticationType.facebookLimited, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachFacebookLimitedIdentity(
      String facebookLimitedId,
      bool continueAnon,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _detachIdentity(facebookLimitedId, AuthenticationType.facebookLimited,
        continueAnon, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachPlaystationNetworkIdentity(
      String psnAccountId,
      String authenticationToken,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _attachIdentity(psnAccountId, authenticationToken,
        AuthenticationType.playstationNetwork, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergePlaystationNetworkIdentity(
      String psnAccountId,
      String authenticationToken,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _mergeIdentity(psnAccountId, authenticationToken,
        AuthenticationType.playstationNetwork, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachPlaystationNetworkIdentity(String psnAccountId, bool continueAnon,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _detachIdentity(psnAccountId, AuthenticationType.playstationNetwork,
        continueAnon, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachPlaystation5Identity(
      String psnAccountId,
      String authenticationToken,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _attachIdentity(psnAccountId, authenticationToken,
        AuthenticationType.playstationNetwork5, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergePlaystation5Identity(
      String psnAccountId,
      String authenticationToken,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _mergeIdentity(psnAccountId, authenticationToken,
        AuthenticationType.playstationNetwork5, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachPlaystation5Identity(String psnAccountId, bool continueAnon,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _detachIdentity(psnAccountId, AuthenticationType.playstationNetwork5,
        continueAnon, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachGameCenterIdentity(String gameCenterId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    _attachIdentity(gameCenterId, "", AuthenticationType.gameCenter, success,
        failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergeGameCenterIdentity(String gameCenterId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    _mergeIdentity(gameCenterId, "", AuthenticationType.gameCenter, success,
        failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachGameCenterIdentity(String gameCenterId, bool continueAnon,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _detachIdentity(gameCenterId, AuthenticationType.gameCenter, continueAnon,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachEmailIdentity(String email, String password,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _attachIdentity(
        email, password, AuthenticationType.email, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergeEmailIdentity(String email, String password,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _mergeIdentity(
        email, password, AuthenticationType.email, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachEmailIdentity(String email, bool continueAnon,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _detachIdentity(email, AuthenticationType.email, continueAnon, success,
        failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachUniversalIdentity(String userId, String password,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _attachIdentity(userId, password, AuthenticationType.universal, success,
        failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergeUniversalIdentity(String userId, String password,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _mergeIdentity(userId, password, AuthenticationType.universal, success,
        failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachUniversalIdentity(String userId, bool continueAnon,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _detachIdentity(userId, AuthenticationType.universal, continueAnon, success,
        failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachSteamIdentity(String steamId, String sessionTicket,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _attachIdentity(steamId, sessionTicket, AuthenticationType.steam, success,
        failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergeSteamIdentity(String steamId, String sessionTicket,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _mergeIdentity(steamId, sessionTicket, AuthenticationType.steam, success,
        failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachSteamIdentity(String steamId, bool continueAnon,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _detachIdentity(steamId, AuthenticationType.steam, continueAnon, success,
        failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachGoogleIdentity(String googleUserId, String serverAuthCode,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _attachIdentity(googleUserId, serverAuthCode, AuthenticationType.google,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergeGoogleIdentity(String googleUserId, String serverAuthCode,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _mergeIdentity(googleUserId, serverAuthCode, AuthenticationType.google,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachGoogleIdentity(String googleUserId, bool continueAnon,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _detachIdentity(googleUserId, AuthenticationType.google, continueAnon,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachGoogleOpenIdIdentity(String googleUserAccountEmail, String idToken,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _attachIdentity(googleUserAccountEmail, idToken,
        AuthenticationType.googleOpenId, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergeGoogleOpenIdIdentity(String googleUserAccountEmail, String idToken,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _mergeIdentity(googleUserAccountEmail, idToken,
        AuthenticationType.googleOpenId, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachGoogleOpenIdIdentity(
      String googleUserAccountEmail,
      bool continueAnon,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _detachIdentity(googleUserAccountEmail, AuthenticationType.googleOpenId,
        continueAnon, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachAppleIdentity(String appleUserId, String identityToken,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _attachIdentity(appleUserId, identityToken, AuthenticationType.apple,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergeAppleIdentity(String appleUserId, String identityToken,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _mergeIdentity(appleUserId, identityToken, AuthenticationType.apple,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachAppleIdentity(String appleUserId, bool continueAnon,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _detachIdentity(appleUserId, AuthenticationType.apple, continueAnon,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachTwitterIdentity(
      String twitterId,
      String authenticationToken,
      String secret,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _attachIdentity(twitterId, "$authenticationToken:$secret",
        AuthenticationType.twitter, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergeTwitterIdentity(
      String twitterId,
      String authenticationToken,
      String secret,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _mergeIdentity(twitterId, "$authenticationToken:$secret",
        AuthenticationType.twitter, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachTwitterIdentity(String twitterId, bool continueAnon,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _detachIdentity(twitterId, AuthenticationType.twitter, continueAnon,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachParseIdentity(String parseId, String authenticationToken,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _attachIdentity(parseId, authenticationToken, AuthenticationType.parse,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergeParseIdentity(String parseId, String authenticationToken,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _mergeIdentity(parseId, authenticationToken, AuthenticationType.parse,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachParseIdentity(String parseId, bool continueAnon,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _detachIdentity(parseId, AuthenticationType.parse, continueAnon, success,
        failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachNintendoIdentity(
      String nintendoAccountId,
      String authenticationToken,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _attachIdentity(nintendoAccountId, authenticationToken,
        AuthenticationType.nintendo, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void mergeNintendoIdentity(
      String nintendoAccountId,
      String authenticationToken,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _mergeIdentity(nintendoAccountId, authenticationToken,
        AuthenticationType.nintendo, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachNintendoIdentity(String nintendoAccountId, bool continueAnon,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _detachIdentity(nintendoAccountId, AuthenticationType.nintendo,
        continueAnon, success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void switchToChildProfile(
      String childProfileId,
      String childAppId,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    _switchToChildProfile(childProfileId, childAppId, forceCreate, false,
        success, failure, cbObject);
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
  /// <param name="success">
  /// The method to call in event of successful login
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error during authentication
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void switchToSingletonChildProfile(String childAppId, bool forceCreate,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    _switchToChildProfile(
        null, childAppId, forceCreate, true, success, failure, cbObject);
  }

  /// <summary>
  /// Attaches a univeral id to the current profile with no login capability.
  /// </summary>
  /// <param name="externalId">
  /// User ID
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachNonLoginUniversalId(String externalId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.IdentityServiceExternalId.Value] = externalId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.attachNonLoginUniversalId, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Updates univeral id of the current profile.
  /// </summary>
  /// <param name="externalId">
  /// User ID
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void updateUniversalIdLogin(String externalId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.IdentityServiceExternalId.Value] = externalId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.updateUniversalIdLogin, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachParentWithIdentity(
      String externalId,
      String authenticationToken,
      AuthenticationType authenticationType,
      String externalAuthName,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.IdentityServiceExternalId.Value] = externalId;
    data[OperationParam.AuthenticateServiceAuthenticateAuthenticationToken
        .Value] = authenticationToken;
    data[OperationParam.IdentityServiceAuthenticationType.Value] =
        authenticationType.toString();

    if (Util.isOptionalParameterValid(externalAuthName)) {
      data[OperationParam.AuthenticateServiceAuthenticateExternalAuthName
          .Value] = externalAuthName;
    }

    data[OperationParam.AuthenticateServiceAuthenticateForceCreate.Value] =
        forceCreate;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.attachParentWithIdentity, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The method to call in event of successful switch
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error while switching
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void switchToParentProfile(String parentLevelName, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.AuthenticateServiceAuthenticateLevelName.Value] =
        parentLevelName;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.switchToParentProfile, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Detaches parent from this user's profile
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - DETACH_PARENT
  /// </remarks>
  /// <param name="success">
  /// The method to call in event of successful switch
  /// </param>
  /// <param name="failure">
  /// The method to call in the event of an error while switching
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachParent(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.detachParent, null, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void getChildProfiles(bool includeSummaryData, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStateServiceIncludeSummaryData.Value] =
        includeSummaryData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.getChildProfiles, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieve list of identities
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - GET_IDENTITIES
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void getIdentities(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.getIdentities, null, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieve list of expired identities
  /// </summary>
  /// <remarks>
  /// Service Name - identity
  /// Service Operation - GET_EXPIRED_IDENTITIES
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void getExpiredIdentities(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.getExpiredIdentities, null, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void refreshIdentity(
      String externalId,
      String authenticationToken,
      AuthenticationType authenticationType,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.IdentityServiceExternalId.Value] = externalId;
    data[OperationParam.AuthenticateServiceAuthenticateAuthenticationToken
        .Value] = authenticationToken;
    data[OperationParam.IdentityServiceAuthenticationType.Value] =
        authenticationType.toString();

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.refreshIdentity, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void changeEmailIdentity(
      String oldEmailAddress,
      String password,
      String newEmailAddress,
      bool updateContactEmail,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.IdentityServiceOldEmailAddress.Value] = oldEmailAddress;
    data[OperationParam
        .AuthenticateServiceAuthenticateAuthenticationToken.Value] = password;
    data[OperationParam.IdentityServiceNewEmailAddress.Value] = newEmailAddress;
    data[OperationParam.IdentityServiceUpdateContactEmail.Value] =
        updateContactEmail;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.changeEmailIdentity, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachPeerProfile(
      String peer,
      String externalId,
      String authenticationToken,
      AuthenticationType authenticationType,
      String externalAuthName,
      bool forceCreate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.IdentityServiceExternalId.Value] = externalId;
    data[OperationParam.AuthenticateServiceAuthenticateAuthenticationToken
        .Value] = authenticationToken;
    data[OperationParam.IdentityServiceAuthenticationType.Value] =
        authenticationType.toString();

    if (Util.isOptionalParameterValid(externalAuthName)) {
      data[OperationParam.AuthenticateServiceAuthenticateExternalAuthName
          .Value] = externalAuthName;
    }

    data[OperationParam.Peer.Value] = peer;
    data[OperationParam.AuthenticateServiceAuthenticateForceCreate.Value] =
        forceCreate;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.attachPeerProfile, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Detaches a peer identity from this user's profile
  /// </summary>
  /// <param name="peer">
  /// Name of the peer to connect to
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachPeer(String peer, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.Peer.Value] = peer;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.detachPeer, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieves a list of attached peer profiles
  /// </summary>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void getPeerProfiles(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.getPeerProfiles, null, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void attachBlockChainIdentity(String blockchainConfig, String publicKey,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.BlockChainConfig.Value] = blockchainConfig;
    data[OperationParam.PublicKey.Value] = publicKey;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.attachBlockChain, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// detach blockchain
  /// </summary>
  /// <param name="blockchainConfig">
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void detachBlockChainIdentity(String blockchainConfig,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.BlockChainConfig.Value] = blockchainConfig;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.detachBlockChain, data, callback);
    _clientRef.sendRequest(sc);
  }

  void _attachIdentity(
      String externalId,
      String authenticationToken,
      AuthenticationType authenticationType,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.IdentityServiceExternalId.Value] = externalId;
    data[OperationParam.IdentityServiceAuthenticationType.Value] =
        authenticationType.toString();
    data[OperationParam.AuthenticateServiceAuthenticateAuthenticationToken
        .Value] = authenticationToken;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.attach, data, callback);
    _clientRef.sendRequest(sc);
  }

  void _mergeIdentity(
      String externalId,
      String authenticationToken,
      AuthenticationType authenticationType,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.IdentityServiceExternalId.Value] = externalId;
    data[OperationParam.IdentityServiceAuthenticationType.Value] =
        authenticationType.toString();
    data[OperationParam.AuthenticateServiceAuthenticateAuthenticationToken
        .Value] = authenticationToken;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.merge, data, callback);
    _clientRef.sendRequest(sc);
  }

  void _detachIdentity(
      String externalId,
      AuthenticationType authenticationType,
      bool continueAnon,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.IdentityServiceExternalId.Value] = externalId;
    data[OperationParam.IdentityServiceAuthenticationType.Value] =
        authenticationType.toString();
    data[OperationParam.IdentityServiceConfirmAnonymous.Value] = continueAnon;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.identity, ServiceOperation.detach, data, callback);
    _clientRef.sendRequest(sc);
  }

  void _switchToChildProfile(
      String? childProfileId,
      String childAppd,
      bool forceCreate,
      bool forceSingleton,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};

    if (Util.isOptionalParameterValid(childProfileId)) {
      data[OperationParam.ProfileId.Value] = childProfileId;
    }

    data[OperationParam.AuthenticateServiceAuthenticateGameId.Value] =
        childAppd;
    data[OperationParam.AuthenticateServiceAuthenticateForceCreate.Value] =
        forceCreate;
    data[OperationParam.IdentityServiceForceSingleton.Value] = forceSingleton;

    data[OperationParam.AuthenticateServiceAuthenticateReleasePlatform.Value] =
        _clientRef.releasePlatform.toString();
    data[OperationParam.AuthenticateServiceAuthenticateCountryCode.Value] =
        Util.getCurrentCountryCode();
    data[OperationParam.AuthenticateServiceAuthenticateLanguageCode.Value] =
        Util.getIsoCodeForCurrentLanguage();
    data[OperationParam.AuthenticateServiceAuthenticateTimeZoneOffset.Value] =
        Util.getUTCOffsetForCurrentTimeZone();

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.identity,
        ServiceOperation.switchToChildProfile, data, callback);
    _clientRef.sendRequest(sc);
  }
}
