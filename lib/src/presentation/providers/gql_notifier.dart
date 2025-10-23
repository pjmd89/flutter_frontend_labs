import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import '/src/infraestructure/error/error_manager.dart';
import '/src/infraestructure/config/env.dart';
import '/src/presentation/providers/auth_notifier.dart';

class GQLNotifier extends ChangeNotifier {
  final AuthNotifier authNotifier;
  late GqlConn gqlConn;

  GQLNotifier({required this.authNotifier}) {
    Map<String, ErrorHandler> errorHandlers = {'001': handleSessionError};
    gqlConn = GqlConn(
      apiURL: Environment.backendApiUrl,
      errorManager: ErrorManager(handlers: errorHandlers),
      wsURL: Environment.backendApiUrlWS,
      insecure: Environment.env == EnvEnum.dev,
    );
  }

  Future<void> handleSessionError(List<GraphQLError> errors) async {
    debugPrint(
      'Session error detected: ${errors.map((e) => e.message).join(', ')}',
    );

    // Hacer signOut - esto automáticamente redirigirá al login
    // porque Template está escuchando cambios en AuthNotifier
    await authNotifier.signOut();
  }
}
