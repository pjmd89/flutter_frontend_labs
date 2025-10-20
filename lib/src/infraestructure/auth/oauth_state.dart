import 'dart:math';

const String _charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

String generateOAuthState([int length = 32]) {
  final random = Random();
  return List.generate(length, (_) => _charset[random.nextInt(_charset.length)]).join();
}
