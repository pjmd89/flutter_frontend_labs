import 'dart:html' as html;

const _stateKey = 'oauth_state';
const _accessTokenKey = 'oauth_access_token';
const _refreshTokenKey = 'oauth_refresh_token';

void persistOAuthState(String state) {
  html.window.sessionStorage[_stateKey] = state;
}

String? retrieveOAuthState() {
  return html.window.sessionStorage[_stateKey];
}

void clearOAuthState() {
  html.window.sessionStorage.remove(_stateKey);
}

void redirectToOAuthProvider(Uri uri) {
  html.window.location.href = uri.toString();
}

void persistOAuthTokens({String? accessToken, String? refreshToken}) {
  if (accessToken != null) {
    html.window.localStorage[_accessTokenKey] = accessToken;
  }
  if (refreshToken != null) {
    html.window.localStorage[_refreshTokenKey] = refreshToken;
  }
}

String? readStoredAccessToken() {
  return html.window.localStorage[_accessTokenKey];
}

String? readStoredRefreshToken() {
  return html.window.localStorage[_refreshTokenKey];
}

void clearStoredTokens() {
  html.window.localStorage.remove(_accessTokenKey);
  html.window.localStorage.remove(_refreshTokenKey);
}
