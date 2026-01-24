import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/entities/main.dart';
import 'package:agile_front/infraestructure/operation.dart';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
class ApproveEvaluationPackageMutation implements Operation{
  final EvaluationPackageFieldsBuilder builder;
  final String _name = 'approveEvaluationPackage';
  Map<String,String>? declarativeArgs;
  final String? alias;
  Map<String, dynamic>? opArgs;
  List<Directive>? directives;

  @override
  get name => _name;
  ApproveEvaluationPackageMutation({required this.builder, this.declarativeArgs, this.alias, this.opArgs, this.directives});
  @override
  String build({String? alias, Map<String, String>? declarativeArgs, Map<String, dynamic>? args, List<Directive>? directives}) {
    
    final fields = builder.build();
    // Construir declaración de variables GraphQL
    final variableDecl = declarativeArgs ?? this.declarativeArgs ?? {};
    final variablesStr = variableDecl.isNotEmpty ? '(${variableDecl.entries.map((e) => '\$${e.key}:${e.value}').join(',')})' : ''; 
    
    final body = formatField(
      _name,
      alias: alias ?? this.alias,
      args: args ?? opArgs,
      directives: directives ?? this.directives,
      selection: fields,
    );
    return '''
      mutation $_name$variablesStr {
        $body
      }
    ''';
  }
  @override
  EvaluationPackage result(Map<String, dynamic> data) {
    String name;
    name = alias ?? _name;
    final responseData = data[name];
    
    // Si ya es un EvaluationPackage, devolverlo directamente
    if (responseData is EvaluationPackage) {
      return responseData;
    }
    
    // Si es un Map, parsearlo
    return EvaluationPackage.fromJson(responseData);
  }

}
