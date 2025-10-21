import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/src/domain/entities/types/user/user_model.dart';
import './view_model.dart';

class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({super.key, required this.uri});

  final Uri uri;

  @override
  State<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  String? _status;
  bool _success = false;
  bool _loading = true;
  late ViewModel viewModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleCallback());
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
  }

  Future<void> _handleCallback() async {
    final User? user = await viewModel.loggedUser();
    
    if(user == null){
      setState(() {
        _status = 'Error al validar las credenciales.';
        _success = false;
        _loading = false;
      });
    }

    if(user != null){

      setState(() {
        _status = 'Inicio de sesión exitoso. Redirigiendo…';
        _success = true;
        _loading = false;
      });
      _scheduleRedirect(user);
    }
  }

  void _scheduleRedirect(User user) {
    final router = GoRouter.of(context);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      viewModel.setLoginUser(user);
      router.go('/home');
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
              _loading ? const CircularProgressIndicator() : const SizedBox.shrink(),
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
