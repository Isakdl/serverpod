/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_auth_client/src/protocol/user_info.dart' as _i3;
import 'package:serverpod_auth_client/src/protocol/authentication_response.dart'
    as _i4;

/// Endpoint for handling admin functions.
/// {@category Endpoint}
class EndpointAdmin extends _i1.EndpointRef {
  EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.admin';

  /// Finds a user by its id.
  _i2.Future<_i3.UserInfo?> getUserInfo(int userId) =>
      caller.callServerEndpoint<_i3.UserInfo?>(
        'serverpod_auth.admin',
        'getUserInfo',
        {'userId': userId},
      );

  /// Marks a user as blocked so that they can't log in, and invalidates their
  /// auth key so that they can't keep calling endpoints through their current
  /// session.
  _i2.Future<void> blockUser(int userId) => caller.callServerEndpoint<void>(
        'serverpod_auth.admin',
        'blockUser',
        {'userId': userId},
      );

  /// Unblocks a user so that they can log in again.
  _i2.Future<void> unblockUser(int userId) => caller.callServerEndpoint<void>(
        'serverpod_auth.admin',
        'unblockUser',
        {'userId': userId},
      );
}

/// Endpoint for handling Sign in with Google.
/// {@category Endpoint}
class EndpointGoogle extends _i1.EndpointRef {
  EndpointGoogle(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.google';

  /// Authenticates a user with Google using the serverAuthCode.
  _i2.Future<_i4.AuthenticationResponse> authenticateWithServerAuthCode(
    String authenticationCode,
    String? redirectUri,
  ) =>
      caller.callServerEndpoint<_i4.AuthenticationResponse>(
        'serverpod_auth.google',
        'authenticateWithServerAuthCode',
        {
          'authenticationCode': authenticationCode,
          'redirectUri': redirectUri,
        },
      );

  /// Authenticates a user using an id token.
  _i2.Future<_i4.AuthenticationResponse> authenticateWithIdToken(
          String idToken) =>
      caller.callServerEndpoint<_i4.AuthenticationResponse>(
        'serverpod_auth.google',
        'authenticateWithIdToken',
        {'idToken': idToken},
      );
}

class Caller extends _i1.ModuleEndpointCaller {
  Caller(_i1.ServerpodClientShared client) : super(client) {
    admin = EndpointAdmin(this);
    google = EndpointGoogle(this);
  }

  late final EndpointAdmin admin;

  late final EndpointGoogle google;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'serverpod_auth.admin': admin,
        'serverpod_auth.google': google,
      };
}
