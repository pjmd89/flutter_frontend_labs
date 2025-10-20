import 'package:flutter/foundation.dart';
import '/src/infraestructure/auth/oauth_platform.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    bootstrap();
  }

  String? _accessToken;
  String? _refreshToken;
  bool _initializing = true;

  bool get initializing => _initializing;
  bool get isAuthenticated => !_initializing && _accessToken != null && _accessToken!.isNotEmpty;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  void bootstrap() {
    if (_initializing) {
      if (kIsWeb) {
        _accessToken = readStoredAccessToken();
        _refreshToken = readStoredRefreshToken();
      }
      _initializing = false;
      notifyListeners();
    }
  }

  Future<void> signIn({required String accessToken, String? refreshToken}) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    if (kIsWeb) {
      persistOAuthTokens(accessToken: accessToken, refreshToken: refreshToken);
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    _accessToken = null;
    _refreshToken = null;
    if (kIsWeb) {
      clearStoredTokens();
      clearOAuthState();
    }
    notifyListeners();
  }
}
