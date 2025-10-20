import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/src/infraestructure/auth/oauth_platform.dart';
import '/src/infraestructure/auth/oauth_state.dart';
import '/src/infraestructure/config/env.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isRedirecting = false;
  String? _errorMessage;

  void _startGoogleLogin() {
    if (!kIsWeb) {
      setState(() {
        _errorMessage = 'El flujo de inicio de sesión web solo está disponible en compilaciones web.';
        _isRedirecting = false;
      });
      return;
    }

    final authUrl = Environment.backendAuthUrl;
    if (authUrl.isEmpty || authUrl == 'Undefined Platform') {
      setState(() {
        _errorMessage = 'Debe configurarse la variable webAuthURL para apuntar al endpoint /auth/google del backend.';
      });
      return;
    }

    final state = generateOAuthState();
    persistOAuthState(state);

    final redirectUri = _buildRedirectUri();
    final uri = Uri.parse(authUrl);
    final params = Map<String, String>.from(uri.queryParameters);
    params['redirect_uri'] = redirectUri.toString();
    params['state'] = state;

    final loginUri = uri.replace(queryParameters: params);

    setState(() {
      _isRedirecting = true;
      _errorMessage = null;
    });

    redirectToOAuthProvider(loginUri);
  }

  Uri _buildRedirectUri() {
    final base = Uri.base;
    final callbackPath = Environment.webAuthCallbackPath;
    final origin = base.origin;

    if (base.fragment.startsWith('/')) {
      return Uri.parse('$origin/#$callbackPath');
    }

    var path = base.path;
    if (path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }

    return Uri.parse('$origin$path$callbackPath');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Inicia sesión con Google',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _isRedirecting ? null : _startGoogleLogin,
                  icon: const Icon(Icons.login),
                  label: Text(_isRedirecting ? 'Redirigiendo…' : 'Continuar con Google'),
                ),
                const SizedBox(height: 16),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                if (_isRedirecting) ...[
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}