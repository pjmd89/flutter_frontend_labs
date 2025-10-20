import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '/src/infraestructure/auth/oauth_platform.dart';
import '/src/presentation/providers/auth_notifier.dart';

class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({super.key, required this.uri});

  final Uri uri;

  @override
  State<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  String? _status;
  bool _success = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleCallback());
  }

  Future<void> _handleCallback() async {
    final returnedState = widget.uri.queryParameters['state'];
    final storedState = retrieveOAuthState();

    if (storedState == null || storedState != returnedState) {
      setState(() {
        _status = 'No fue posible validar la sesión de OAuth (state inválido).';
        _success = false;
      });
      return;
    }

    clearOAuthState();

    final errorDescription = widget.uri.queryParameters['error_description'] ?? widget.uri.queryParameters['error'];
    if (errorDescription != null) {
      setState(() {
        _status = 'Google devolvió un error: $errorDescription';
        _success = false;
      });
      return;
    }

    final token = widget.uri.queryParameters['token'] ?? widget.uri.queryParameters['access_token'];
    final refresh = widget.uri.queryParameters['refresh_token'];

    if (token == null || token.isEmpty) {
      setState(() {
        _status = 'No se recibió ningún token en la redirección.';
        _success = false;
      });
      return;
    }

    persistOAuthTokens(accessToken: token, refreshToken: refresh);
    if (!mounted) return;

    await context.read<AuthNotifier>().signIn(accessToken: token, refreshToken: refresh);

    if (!mounted) {
      return;
    }

    setState(() {
      _status = 'Autenticación completada. Redirigiendo…';
      _success = true;
    });

    Future.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      context.go('/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                _status ?? 'Validando credenciales…',
                textAlign: TextAlign.center,
              ),
              if (!_success && _status != null) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Volver al inicio de sesión'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
