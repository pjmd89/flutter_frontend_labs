import 'package:web/web.dart' as web;

const _stateKey = 'oauth_state';
const _accessTokenKey = 'oauth_access_token';
const _refreshTokenKey = 'oauth_refresh_token';

void persistOAuthState(String state) {
  web.window.sessionStorage.setItem(_stateKey, state);
}

String? retrieveOAuthState() {
  return web.window.sessionStorage.getItem(_stateKey);
}

void clearOAuthState() {
  web.window.sessionStorage.removeItem(_stateKey);
}

void redirectToOAuthProvider(Uri uri) {
  web.window.location.href = uri.toString();
}

void persistOAuthTokens({String? accessToken, String? refreshToken}) {
  if (accessToken != null) {
    web.window.localStorage.setItem(_accessTokenKey, accessToken);
  }
  if (refreshToken != null) {
    web.window.localStorage.setItem(_refreshTokenKey, refreshToken);
  }
}

String? readStoredAccessToken() {
  return web.window.localStorage.getItem(_accessTokenKey);
}

String? readStoredRefreshToken() {
  return web.window.localStorage.getItem(_refreshTokenKey);
}

void clearStoredTokens() {
  web.window.localStorage.removeItem(_accessTokenKey);
  web.window.localStorage.removeItem(_refreshTokenKey);
}
