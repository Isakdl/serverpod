import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/authentication/util.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Collects methods for authenticating users.
/// In most cases, it's more convenient to use the
/// serverpod_auth module for authentication.
class ServerpodAuth {
  /// Creates an identifier for a user. This is typically used to create a new
  /// user in the database. The [scopes] parameter can be used to specify what
  /// the user is allowed to do.
  static Future<AuthId> createAuthId(
    Session session, {
    Set<Scope> scopes = const {},
  }) async {
    var scopeNames = scopes.map((s) => s.name).whereType<String>().toList();
    var authId = AuthId(scopes: scopeNames);
    return await AuthId.db.insertRow(session, authId);
  }

  /// Deletes an identifier for a user. This will also revoke all refresh tokens
  /// associated with the user.
  static Future<void> deleteAuthId(Session session, int authId) async {
    await AuthId.db.deleteWhere(session, where: (t) => t.id.equals(authId));
  }

  /// Issues a refresh token for a user who is identified by an authId.
  /// The method [createAuthId] can be used to create an authId and is required
  /// before calling this method.
  /// The [provider] parameter is used to identify the authentication method
  /// used to sign in the user. The [expiresAt]
  /// parameter can be used to specify when the token should expire.
  static Future<RefreshToken> issueRefreshToken(
    Session session,
    int authId,
    String provider, {
    DateTime? expiresAt,
  }) async {
    var signInSalt = session.passwords['authKeySalt'] ?? defaultAuthKeySalt;

    var token = generateRandomString();
    var hash = hashString(signInSalt, token);

    var refreshToken = RefreshToken(
      authId: authId,
      token: token,
      tokenHash: hash,
      provider: provider,
      expiresAt: expiresAt,
    );

    var result = await RefreshToken.db.insertRow(session, refreshToken);
    return result.copyWith(token: token);
  }

  /// Revokes a refresh token.
  static Future<void> revokeRefreshToken(Session session, int tokenId) async {
    await RefreshToken.db
        .deleteWhere(session, where: (t) => t.id.equals(tokenId));
  }

  /// Revokes all refresh tokens for a user.
  static Future<void> revokeAllRefreshTokens(
      Session session, int authId) async {
    await RefreshToken.db
        .deleteWhere(session, where: (t) => t.authId.equals(authId));
  }

  static Future<String> issueAccessToken(
    Session session,
    int refreshTokenId, {
    DateTime? expireAt,
  }) async {
    return '';
  }

  /// Migrates all existing tokens linked to a userId to a new AuthId.
  static Future<AuthId> migrateTokenToAuthId(
    Session session,
    int userId,
    Set<Scope> scopes,
  ) async {
    return session.db.transaction((transaction) async {
      var tokens = await AuthKey.db.find(
        session,
        where: (t) => t.userId.equals(userId),
        transaction: transaction,
      );

      var authId = AuthId(
        scopes: scopes.map((s) => s.name).whereType<String>().toList(),
      );
      authId = await AuthId.db.insertRow(
        session,
        authId,
        transaction: transaction,
      );

      var id = authId.id;
      if (id == null) throw Error();

      var refreshTokens = tokens
          .map(
            (token) => RefreshToken(
              authId: id,
              token: '', // The token is not stored in the db
              tokenHash: token.hash,
              provider: token.method,
            ),
          )
          .toList();

      refreshTokens = await RefreshToken.db.insert(
        session,
        refreshTokens,
        transaction: transaction,
      );

      await AuthKey.db.delete(session, tokens, transaction: transaction);

      return authId.copyWith(refreshTokens: refreshTokens);
    });
  }
}
