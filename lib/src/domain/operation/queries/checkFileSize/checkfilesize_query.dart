import 'package:agile_front/infraestructure/operation.dart';
import 'package:agile_front/infraestructure/graphql/helpers.dart';

/// Query para verificar el tamaño de un archivo antes de subirlo
/// Retorna información sobre cuánto del archivo ya fue subido al servidor
class CheckFileSizeQuery implements Operation {
  final String _name = 'checkFileSize';
  Map<String, String>? declarativeArgs;
  final String? alias;
  Map<String, dynamic>? opArgs;
  List<Directive>? directives;

  @override
  get name => _name;

  CheckFileSizeQuery({
    this.declarativeArgs,
    this.alias,
    this.opArgs,
    this.directives,
  });

  @override
  String build({
    String? alias,
    Map<String, String>? declarativeArgs,
    Map<String, dynamic>? args,
    List<Directive>? directives,
  }) {
    // Campos que retorna la query - exactamente como lo espera el backend
    const fields = '''
      name
      size
      type
      folder
      sizeUploaded
      display
    ''';

    // Construir declaración de variables GraphQL
    final variableDecl = declarativeArgs ?? this.declarativeArgs ?? {};
    final variablesStr = variableDecl.isNotEmpty
        ? '(${variableDecl.entries.map((e) => '\$${e.key}:${e.value}').join(',')})'
        : '';

    final body = formatField(
      _name,
      alias: alias ?? this.alias,
      args: args ?? opArgs,
      directives: directives ?? this.directives,
      selection: fields,
    );

    return '''
      query $_name$variablesStr {
        $body
      }
    ''';
  }

  @override
  Map<String, dynamic> result(Map<String, dynamic> data) {
    String name = alias ?? _name;
    return data[name] as Map<String, dynamic>;
  }
}
