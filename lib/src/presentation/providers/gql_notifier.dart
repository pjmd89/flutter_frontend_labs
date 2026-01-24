import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import '/src/infraestructure/error/error_manager.dart';
import '/src/infraestructure/config/env.dart';
import '/src/presentation/providers/auth_notifier.dart';
import '/src/infraestructure/services/error_service.dart';

class GQLNotifier extends ChangeNotifier {
  final AuthNotifier authNotifier;
  final ErrorService errorService;
  late GqlConn gqlConn;

  GQLNotifier({required this.authNotifier, required this.errorService}) {
    Map<String, ErrorHandler> errorHandlers = {
      '001': handleSessionError,
      '002': handleGenericError,
      '003': handleGenericError,
      '004': handleGenericError,
      '005': handleGenericError,
      '006': handleGenericError,
      '007': handleGenericError,
      '008': handleGenericError,
      '009': handleGenericError,
      '010': handleGenericError,
      '011': handleGenericError,
      '012': handleGenericError,
      '013': handleGenericError,
      '014': handleGenericError,
      '015': handleGenericError,
      '016': handleGenericError,
      '017': handleGenericError,
      '018': handleGenericError,
      '019': handleGenericError,
      '020': handleGenericError,
      '021': handleGenericError,
      '022': handleGenericError,
      '023': handleGenericError,
      '024': handleGenericError,
      '025': handleGenericError,
      '026': handleGenericError,
      '027': handleGenericError,
      '028': handleGenericError,
      '029': handleGenericError,
      '030': handleGenericError,
      '031': handleGenericError,
      '032': handleGenericError,
      '033': handleGenericError,
      '034': handleGenericError,
      '035': handleGenericError,
      '036': handleGenericError,
      '037': handleGenericError,
      '038': handleGenericError,
      '039': handleGenericError,
      '040': handleGenericError,
      '041': handleGenericError,
      '042': handleGenericError,
      '043': handleGenericError,
      '044': handleGenericError,
      '045': handleGenericError,
      '046': handleGenericError,
      '047': handleGenericError,
      '048': handleGenericError,
      '049': handleGenericError,
      '050': handleGenericError,
      '051': handleGenericError,
      '052': handleGenericError,
      '053': handleGenericError,
      '054': handleGenericError,
      '055': handleGenericError,
      '056': handleGenericError,
      '057': handleGenericError,
      '058': handleGenericError,
      '059': handleGenericError,
      '060': handleGenericError,
      '061': handleGenericError,
      '062': handleGenericError,
      '063': handleGenericError,
      '064': handleGenericError,
      '065': handleGenericError,
      '066': handleGenericError,
      '067': handleGenericError,
      '068': handleGenericError,
      '069': handleGenericError,
      '070': handleGenericError,
    };

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

    await authNotifier.signOut();
  }

  void handleGenericError(List<GraphQLError> errors) {
    for (var error in errors) {
      final code = error.extensions?['code'] as String?;
      final message = error.message;

      debugPrint('GraphQL Error [$code]: $message');

      // Mostrar error usando ErrorService
      if (code != null) {
        errorService.showBackendError(errorCode: code, errorMessage: message);
      }
    }
  }
}
