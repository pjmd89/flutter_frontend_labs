const String _unsupportedMessage = 'OAuth web helpers are only available on web builds.';

void persistOAuthState(String state) {
  throw UnsupportedError(_unsupportedMessage);
}

String? retrieveOAuthState() => null;

void clearOAuthState() {}

void redirectToOAuthProvider(Uri uri) {
  throw UnsupportedError(_unsupportedMessage);
}

void persistOAuthTokens({String? accessToken, String? refreshToken}) {}

String? readStoredAccessToken() => null;

String? readStoredRefreshToken() => null;

void clearStoredTokens() {}
